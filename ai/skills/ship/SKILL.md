---
name: ship
description: "Run the full pre-merge pipeline and create a PR. Triggers on 'ship', 'ship it', 'ready to ship', 'prep for PR', 'create PR', 'ready to merge'."
argument-hint: "[--adversarial] [--no-adversarial] [--status]"
---

# Ship

The final pass on a PR. `/ship` **orchestrates** the whole pre-merge process:
it runs the review gates in order, gates on their results, and opens the PR.

It's an orchestrator, not a monolith. Two gates it does itself, because no
portable version exists (they're Claude-native): **Simplify** and **Code
Review**. Two gates it **delegates** to standalone skills that both harnesses
have: **Adversarial** → the `adversarial-review` skill, **Finalize** → the
`finalize` skill. Ship owns the *policy* (order, when adversarial triggers, what
blocks the ship); the delegated skills own their *mechanism*.

Eight gates, run in order:

1. **Context** — figure out where we are, abort if unsafe
2. **Change Inventory** — map what changed and where the risk is
3. **Simplify** *(inline)* — remove complexity the diff introduced
4. **Code Review** *(inline)* — find bugs, block on unresolved criticals
5. **Adversarial** *(opt-in → `adversarial-review` skill)* — red-team high-risk changes
6. **Finalize** *(→ `finalize` skill)* — lint, tests, quality, docs, hygiene
7. **Readiness** — dashboard keyed to the current diff
8. **PR** — push, write the PR, report the URL

## Execution Model — Read This First

The inline gates below (Simplify, Code Review) define a **contract: the outcome
it must produce**, not the mechanism. How you satisfy it depends on the harness.
The delegated gates (Adversarial, Finalize) push this same principle down into
their own skills — those skills carry their own per-harness notes.

- **Claude Code** — you have real parallel subagents (Task/Agent) and a
  Workflow engine. For Code Review, fan out N independent reviewers with distinct
  lenses and adversarially verify their findings. This is your edge — use it on
  non-trivial diffs.
- **Codex** — default to a single thorough pass grounded in the actual repo:
  `git`, `rg`, targeted reads, `apply_patch` for narrow edits, and the
  sandbox/approval model for verification. You can parallelize read-only shell
  inspection freely, but not as a correctness dependency. Subagents are optional
  acceleration when explicitly available — **never required for correctness**.
  The single-agent path must be complete on its own.
- **Any harness** — if you have neither subagents nor special tooling, run the
  gate contracts sequentially yourself. Nothing here needs more than a shell,
  git, and the ability to read and edit files.

**Portability rules (they keep this working everywhere):**

- **Restate each gate's inputs.** Don't rely on hidden context carried between
  gates. Every gate names what it looked at: base, head, files changed,
  commands run, findings. A fresh agent picking up at gate 6 should be able to.
- **Serialize writes, parallelize reads.** Reviewing and inspecting in parallel
  is fine. Edits go through the main agent one at a time — never fan out write
  operations.
- **Don't assume tooling exists.** MCP servers, plugins, a browser, a GitHub
  connector, a specific approval mode — none are guaranteed. Degrade to shell +
  git and say what you couldn't do.
- **Be explicit about sandbox needs.** If a command needs network, writes
  outside the workspace, or wants elevated access, say exactly what it needs and
  why before running it — don't let an approval turn into a mystery failure.
- **Don't repeat broad verification.** Once the Finalize gate passes, don't
  re-run tests/lint unless a later loop round changed files. Re-running wastes
  time and reads as process for its own sake.

## Parse Arguments

Check `$ARGUMENTS` for flags:

- `--status` — show the readiness dashboard only, run nothing
- `--adversarial` — run the Adversarial gate even if it wouldn't trigger
- `--no-adversarial` — skip the Adversarial gate AND suppress its advisory line

## Gate 1: Context

Establish the ground truth before judging anything.

```bash
# Project name from git remote (or directory name as fallback)
PROJECT="$(basename "$(git remote get-url origin 2>/dev/null | sed 's/.*\///' | sed 's/\.git$//')" 2>/dev/null || basename "$PWD")"

# Current branch and HEAD. Full SHA — this is the readiness cache identity, not
# a display string, so a short SHA isn't safe here.
BRANCH="$(git branch --show-current)"
HEAD_SHA="$(git rev-parse HEAD)"

# Base branch — try existing PR first, then repo default
BASE="$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null || gh repo view --json defaultBranchRef -q .defaultBranchRef.name 2>/dev/null || echo main)"

# Resolve BASE to a ref that actually exists locally, so merge-base can't fall
# back to an unresolved name and make every diff fail. Prefer a local branch,
# then the remote-tracking ref.
if git rev-parse --verify --quiet "$BASE" >/dev/null; then
  BASE_REF="$BASE"
elif git rev-parse --verify --quiet "origin/$BASE" >/dev/null; then
  BASE_REF="origin/$BASE"
else
  BASE_REF=""   # abort below with a fetch hint
fi

# Merge base — the real fork point, so the diff is only this branch's work
FORK="$(git merge-base "$BASE_REF" HEAD 2>/dev/null || echo "")"

# Resolve the readiness script from the shared skill location (portable across
# harnesses — Claude symlinks into ~/.agents, Codex reads it directly). The
# dotfiles source is listed last so a normal run uses the installed copy, but
# in-place testing of the source still resolves. Never hardcode one harness path.
READINESS=""
for c in "$HOME/.agents/skills/ship/scripts/readiness.sh" \
         "$HOME/.claude/skills/ship/scripts/readiness.sh" \
         "$HOME/.config/opencode/skill/ship/scripts/readiness.sh" \
         "$HOME/.local/share/dotfiles/ai/skills/ship/scripts/readiness.sh"; do
  [ -f "$c" ] && READINESS="$c" && break
done
```

**Abort if `READINESS` is empty** — the pipeline can't track state. Tell the user
the ship skill isn't installed where expected (`skills-install`).

**Abort if `BASE_REF` is empty** — the base branch has no local or remote ref.
Tell the user to `git fetch origin "$BASE"` and re-run.

**Abort if on the base branch** (`BRANCH` == `BASE`). Nothing to ship — tell the
user to create a feature branch first.

**Abort if the worktree isn't clean** (`git status --porcelain` is non-empty).
Ship's later gates edit code and then commit those edits as a "review fixes"
commit — if the tree already has unrelated changes, that commit would sweep them
up too. Tell the user to commit or stash first. Starting clean also means any
dirtiness mid-run is unambiguously ship's own work.

**Ensure the readiness directory exists:**
```bash
"$READINESS" dir "$PROJECT"
```

Report: project, branch, base, fork point, HEAD. That's this gate's output.

### Status-Only Mode

If `--status` was passed:
```bash
"$READINESS" dashboard "$PROJECT" "$BRANCH" --head="$HEAD_SHA"
```
Print the dashboard (keyed to the current HEAD, so entries logged against older
commits show as stale) and stop. Run no gates.

## Gate 2: Change Inventory

Understand the shape of the change before critiquing it. This is a read-only
gate — cheap, and it tells every later gate where to focus.

```bash
git diff --name-status "$FORK"...HEAD     # what files, how they changed
git diff --shortstat "$FORK"...HEAD       # added + deleted line counts
git diff --check "$FORK"...HEAD           # whitespace/conflict-marker errors
git log --oneline "$FORK"..HEAD           # the commits being shipped
```

Compute total churn from **added + deleted** lines (not insertions alone — a
pure-deletion diff still matters). Use `awk`, not `bc`: `bc` exits 0 on empty
input, so an empty diff would yield an empty string, not `0`, and later
`[ "$CHURN" -gt 500 ]` would break:

```bash
CHURN="$(git diff --numstat "$FORK"...HEAD | awk '{a+=$1; d+=$2} END {print a+d+0}')"
```

Produce a short inventory: which files/domains changed, and which touch
**risk areas** — auth/permissions, money/billing, data migrations, multi-tenant
boundaries, destructive operations, background jobs/concurrency, public APIs,
dependency upgrades, or cross-cutting refactors. This risk read drives the
Adversarial gate's advisory.

## The Review Loop (Gates 3–6)

Gates 3–6 all review and edit (Simplify, Code Review, Adversarial, and Finalize
each fix what they find). **An edit by a later gate invalidates the earlier gates
for this diff** — Simplify's pass on tree A is not a pass on the tree Code Review
then edited. So run these gates as a loop, not a single top-to-bottom pass:

1. Run Gates 3–6 in order. Each may edit files.
2. **If any gate edited files this pass**, seal and loop:
   ```bash
   git add -A && git commit -m "ship: apply review fixes (round N)"
   HEAD_SHA="$(git rev-parse HEAD)"
   ```
   Then go back to step 1. The re-run validates the newly committed tree, so the
   gates that ran against the old tree get genuinely re-checked against the final
   diff.
3. **If a full pass makes no edits**, stop — every gate just validated the exact
   committed tree. That's the honest pass.

**Cap at 2 rounds.** If gates are still editing after that, stop and report; the
change may be oscillating and needs a human. **Never re-stamp** an old pass onto a
new HEAD — a gate's pass only counts for the tree it actually reviewed. Because
the worktree started clean (Context gate), every `git add -A` here captures only
ship's own edits.

### Smart skip within the loop

At the start of each gate, check whether it's already clean for the **current**
HEAD:

```bash
"$READINESS" check "$PROJECT" "$BRANCH" <gate> --head="$HEAD_SHA"
```

- **Exit 0** — clean for this exact tree; print `"✓ <Gate>: SKIPPED (done <time>)"`.
- **Exit 1** — never run, failed, or the tree changed since (a commit moved HEAD)
  → run the gate.

Readiness is keyed to HEAD, so a commit inside the loop **automatically**
invalidates the prior round's logs and forces the affected gates to re-run — no
manual bookkeeping. After running a gate, log it against the current HEAD:

```bash
"$READINESS" log "$PROJECT" "$BRANCH" <gate> <clean|skipped|failed> head="$HEAD_SHA" [key=value ...]
```

Smart skip also carries across separate `/ship` invocations: if you re-run ship
and HEAD hasn't moved, already-clean gates skip and only the unfinished work runs.

## Gate 3: Simplify

**Contract:** the diff introduces no avoidable complexity.

Review the diff against the fork point and remove, with high-confidence edits
only: duplication, dead code, needless indirection, unnecessary abstraction,
premature generalization, patterns inconsistent with the surrounding code, and
test noise. Do **not** churn design or public APIs unless the diff itself created
the problem. If a change needs judgment rather than being clearly correct,
report it instead of "fixing" it.

Log `clean` only when no unresolved simplification issues remain; otherwise log
`failed` with a note.

## Gate 4: Code Review

**Contract:** the diff is reviewed for defects; unresolved criticals block the
ship.

Review the diff for correctness bugs, regressions, missing edge cases, race
conditions, unsafe assumptions, security issues (injection, auth bypass, data
exposure), error handling, and test gaps. Fix mechanical/high-confidence issues
directly. For anything that needs a judgment call, surface it to the user.

**Also check scope — "did we build the right thing?"** Does the diff actually
satisfy the stated issue/spec/PR intent, and does it avoid unrelated work that
shouldn't be in this PR? The other gates cover quality; this is the one place
that checks the change is the *correct* one. Flag scope drift or missed intent.

- **Claude Code:** dispatch several `general-purpose` reviewers in parallel,
  each with a distinct lens (correctness, security, tests, conventions), then
  adversarially verify findings before acting. Score by confidence.
- **Codex / other:** one thorough inline review over the full diff, grounded in
  the actual files and the project's conventions (`CLAUDE.md`/`AGENTS.md`, lint
  configs).

Log with counts, e.g.:
```bash
"$READINESS" log "$PROJECT" "$BRANCH" code-review clean head="$HEAD_SHA" \
  critical=0 suggestions=2 fixed=2
```

**If there are unresolved critical findings, log `failed`, stop the pipeline,**
show the dashboard, and report what's blocking.

## Gate 5: Adversarial (Opt-In → `adversarial-review` skill)

**Contract:** high-risk changes get red-teamed; the human owns escalation. Ship
owns *when* this runs; the `adversarial-review` skill owns *how*.

**This gate is skipped by default.** It does not auto-run, even on
dangerous-looking diffs — the final pass stays predictable and low-friction.

Decide, based on the args and Gate 2's risk read:

- **`--no-adversarial` passed** → skip silently.
- **`--adversarial` passed** → run it.
- **Neither, and Gate 2 found risk areas** → skip, but print one advisory line
  and record it in readiness:
  > High-risk changes detected: auth, migration. Run `/ship --adversarial` to
  > red-team before merging.
  Make the advisory precise (name the categories) and hard to miss. **Do not
  block PR creation.**
- **Neither, and no risk areas** → skip silently.

**When it runs, invoke the `adversarial-review` skill**, passing ship's resolved
fork so it reviews the exact diff ship inventoried — don't let the delegated skill
re-guess the base:

```
adversarial-review --fork="$FORK"
```

That skill runs the fresh-eyes critique→fix loop and adapts to the harness itself
(subagents on Claude, single-agent on Codex). Apply its fixes; **block only on
concrete, plausible failures with evidence** — speculation becomes PR notes, not
gates. Log `clean`/`failed` under `adversarial-review` with `rounds=N`.

If the skill isn't installed, fall back inline: a cold, fresh-eyes pass over the
diff that tries to *disprove* the PR's safety claims (production failure, abuse,
data loss, rollback), fixing Critical/Suggestion findings.

## Gate 6: Finalize (→ `finalize` skill)

**Contract:** the project's own checks pass on the tree being shipped, and no
doc is left stale.

**Invoke the `finalize` skill.** It runs the universal checklist — lint/format,
tests, code-quality sweep (debug statements, secrets, dead code), documentation,
UI/design quality on view changes, git/issue hygiene — plus any project-specific
"Finalize Checklist" in the project's CLAUDE.md. This is why the separate Docs
step folded in here: `finalize` already covers docs.

Ship's responsibility is the **gate decision**: if `finalize` reports failing
tests or lint, log `failed`, stop the pipeline, show the dashboard, and report
what's blocking. Because `finalize` runs the broad checks, don't re-run them
elsewhere; on the stable final loop round it validates the shipped tree.

- **Codex:** `finalize`'s checks lean on the sandbox/approval model; if a command
  needs network or elevated access, say so before running.

Log under the readiness key `finalize` (the dashboard reads its
`tests_passed`/`coverage_ok` fields from that entry):
```bash
"$READINESS" log "$PROJECT" "$BRANCH" finalize clean head="$HEAD_SHA" \
  tests_passed=true lint_passed=true
```

If the skill isn't installed, fall back inline: run the project's real
lint/test/build commands, update any docs the diff made stale, and log the same.

## After the Loop

When the review loop stabilizes (a full pass of Gates 3–6 made no edits), the
worktree is clean, all fixes are committed, and every gate's readiness log is
keyed to the final `HEAD_SHA`. Nothing left to fold in — the PR will contain the
fixes because they're already commits. Proceed to the dashboard.

## Gate 7: Readiness

```bash
"$READINESS" dashboard "$PROJECT" "$BRANCH" --head="$HEAD_SHA"
```

Print the full dashboard. Each gate shows passed / skipped / failed with its
evidence, keyed to the current HEAD — entries logged against an older HEAD show
as STALE. Read the verdict from it.

**Large-changeset note:** if `CHURN` > 500 and the Adversarial gate was skipped,
add: "Large changeset (N lines) — consider `/ship --adversarial`."

## Gate 8: PR

Act on the verdict.

### If CLEARED

1. **Push** (the review loop already committed every fix):
   ```bash
   git push -u origin "$BRANCH"
   ```

2. **Build the PR body in a temp file** — never via shell command substitution
   (backticks or `$()` in a commit summary will mangle the body). Clean it up
   with a `trap` so a failure mid-way doesn't leak the temp file:
   ```bash
   BODY="$(mktemp)"; trap 'rm -f "$BODY"' EXIT
   cat > "$BODY" <<'EOF'
   ## Summary
   <what changed, from the commits>

   ## Readiness
   <e.g. Code review: clean, 2 fixed. Verification: tests + lint pass. Adversarial: skipped (low-risk).>

   ## Test Plan
   <how it was verified>
   EOF
   ```
   Fill it from `git log --oneline "$FORK"..HEAD` and the readiness log. Title:
   short, imperative, under 70 chars.

3. **Create or update the PR — branch on whether one already exists.** Don't use
   `gh pr create || gh pr edit`; that fallback masks a real create failure
   (auth, network) as "edit the existing PR."
   ```bash
   if gh pr view >/dev/null 2>&1; then
     gh pr edit --title "..." --body-file "$BODY"
   else
     gh pr create --title "..." --body-file "$BODY"
   fi
   ```

4. **Report:** print the PR URL and any remaining human decision points (e.g. an
   adversarial advisory that was surfaced but not acted on). If the project has a
   release skill (`ls .claude/skills/release/SKILL.md`), note: "When ready to
   deploy, run `/release`."

### If NOT CLEARED

List each required gate that isn't DONE and why. Ask: **"Ship anyway? (y/n)"** —
if yes, proceed to PR creation; if no, stop.

## Error Handling

- **No git remote / no base ref:** the review gates don't need a remote, but they
  do need a base to diff against. If `BASE_REF` resolved (a local base branch
  exists), run Gates 1–7 normally and at Gate 8 report: "No git remote. Run
  `git remote add origin <url>` or `gh repo create`, then `/ship` again — passed
  gates are cached to this HEAD and will be skipped." If `BASE_REF` is empty too
  (single-branch repo, no base anywhere), there's nothing to diff against —
  that's the `BASE_REF` abort in the Context gate; tell the user to
  `git fetch origin "$BASE"` or point ship at the right base branch.
- **`gh` not authenticated:** "GitHub CLI not authenticated. Run `gh auth login`."
- **Gate failure:** log `failed`, show the dashboard with the failure visible,
  stop. The user fixes it and runs `/ship` again — because readiness is keyed to
  HEAD, unchanged gates skip and only the affected work re-runs.
- **Cancel mid-run:** readiness only has entries for completed gates; the next
  `/ship` picks up naturally.
