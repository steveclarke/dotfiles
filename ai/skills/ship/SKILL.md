---
name: ship
description: "Run the full pre-merge pipeline and create a PR. Use when user says 'ship', 'ship it', 'ready to ship', 'let\\'s ship', 'prep for PR', 'create PR', or 'ready to merge'."
argument-hint: "[--adversarial] [--status]"
---

# Ship

Run the full pre-merge pipeline in one command: simplify → code review →
adversarial review → finalize → update docs → readiness dashboard → create PR.

No steps to remember. `/ship` handles everything.

## Parse Arguments

Check `$ARGUMENTS` for flags:
- `--status` — show the readiness dashboard only, don't run anything
- `--adversarial` — force adversarial review even on small changes

## Step 1: Detect Project Context

```bash
# Project name from git remote (or directory name as fallback)
PROJECT="$(basename "$(git remote get-url origin 2>/dev/null | sed 's/.*\///' | sed 's/\.git$//')" 2>/dev/null || basename "$PWD")"

# Current branch
BRANCH="$(git branch --show-current)"

# Base branch — try existing PR first, then repo default
BASE="$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null || gh repo view --json defaultBranchRef -q .defaultBranchRef.name 2>/dev/null || echo main)"

# Readiness script
READINESS="$HOME/.claude/skills/ship/scripts/readiness.sh"
```

**Abort if on the base branch.** Nothing to ship — tell the user to create a
feature branch first.

**Ensure readiness directory exists:**
```bash
"$READINESS" dir "$PROJECT"
```

## Step 2: Status-Only Mode

If `--status` was passed:

```bash
"$READINESS" dashboard "$PROJECT" "$BRANCH"
```

Print the dashboard and stop. Do not run any pipeline steps.

## Step 3: Run the Pipeline

For each step below, follow this pattern:

1. **Check readiness** — run `"$READINESS" check "$PROJECT" "$BRANCH" <skill>`
2. **If exit code 0** (clean within 2 hours) — the check outputs the relative
   time. Print: `"✓ <Step>: SKIPPED (done <time>)"` and move to the next step.
3. **If exit code 1** (not clean) — invoke the skill, then log the result.

### Step 3a: Simplify

Use the Skill tool to invoke `simplify`. This is a plugin skill that reviews
changed code for reuse, quality, and efficiency, then fixes issues directly.

After it completes, log the result:
```bash
"$READINESS" log "$PROJECT" "$BRANCH" simplify clean
```

If the skill reports issues it couldn't resolve, log `failed` instead of `clean`.

### Step 3b: Code Review

Use the Skill tool to invoke `code-review:code-review` (the plugin skill).
This dispatches 5 parallel review agents, scores findings by confidence,
auto-fixes mechanical issues, and asks for judgment on critical findings.

**Disambiguation:** If multiple code-review-style skills are available (e.g.
a project-local skill like `*-code-review`, `review`, or
`superpowers:requesting-code-review`), do **not** guess. Stop and ask the user
which one to run. The intended default is `code-review:code-review`, but
project-local review skills may be preferred in some codebases.

After it completes, log the result with metadata:
```bash
"$READINESS" log "$PROJECT" "$BRANCH" code-review clean \
  critical=0 suggestions=2 auto_fixed=2 coverage_ok=true
```

Replace the numbers with actual counts from the review output. If there are
unresolved critical findings, log `status: failed`.

**If code review fails** (unresolved critical findings), stop the pipeline.
Show the dashboard and report the failure.

### Step 3c: Adversarial Review (Optional)

Determine if adversarial review should run:

```bash
# Check diff size
DIFF_LINES="$(git diff --stat "$BASE"..."$BRANCH" | tail -1 | grep -o '[0-9]* insertion' | grep -o '[0-9]*')"
```

Run adversarial review if:
- `--adversarial` flag was passed, OR
- `DIFF_LINES` exceeds 500

If neither condition is met, skip this step (it's informational, not required).

If running, use the Skill tool to invoke `adversarial-review` with argument `--pr`.

After it completes, log the result:
```bash
"$READINESS" log "$PROJECT" "$BRANCH" adversarial-review clean \
  rounds=2 result=clean
```

Replace with actual values from the review output.

### Step 3d: Finalize

Use the Skill tool to invoke `finalize`. This runs lint, tests, code quality
sweep, documentation check, UI audit (if applicable), and git hygiene.

After it completes, log the result:
```bash
"$READINESS" log "$PROJECT" "$BRANCH" finalize clean \
  tests_passed=true lint_passed=true
```

If tests fail or lint fails, log the appropriate fields as `false` and
`status: failed`. **If finalize fails, stop the pipeline.** Show the dashboard
and report the failure.

### Step 3e: Update Docs (Project-Specific)

Check if the current project has an update-docs skill:

```bash
ls .claude/skills/update-docs/SKILL.md 2>/dev/null
```

If found, use the Skill tool to invoke `update-docs`.

After it completes, log the result:
```bash
"$READINESS" log "$PROJECT" "$BRANCH" update-docs clean
```

If not found, skip this step. It's informational — absence doesn't block shipping.

## Step 4: Show Readiness Dashboard

```bash
"$READINESS" dashboard "$PROJECT" "$BRANCH"
```

Print the full dashboard output.

**Large changeset advisory:** If the diff exceeds 500 lines and adversarial
review was not run, add a note:
> "Consider running `/adversarial-review` — this is a large changeset (N lines)"

## Step 5: Verdict and PR Creation

Read the dashboard verdict.

### If CLEARED

Proceed to create the PR:

1. **Push the branch:**
   ```bash
   git push -u origin "$BRANCH"
   ```

2. **Generate PR description:**
   - Read the commit log: `git log --oneline "$BASE".."$BRANCH"`
   - Read the readiness log for a summary of what was reviewed
   - Write a PR title (short, imperative, under 70 characters)
   - Write a PR body with:
     - Summary of changes (from commits)
     - Readiness summary (e.g., "Code review: clean, 2 auto-fixed. Finalize: tests pass, lint clean.")
     - Test plan

3. **Create the PR:**
   ```bash
   gh pr create --title "..." --body "$(cat <<'EOF'
   ## Summary
   ...

   ## Readiness
   ...

   ## Test Plan
   ...
   EOF
   )"
   ```

4. **Report:**
   - Print the PR URL
   - Check if the project has a release skill: `ls .claude/skills/release/SKILL.md 2>/dev/null`
   - If found: "When ready to deploy, run `/release`"

### If NOT CLEARED

Show what's missing or failed:
- List each required gate that isn't DONE
- Ask: "Ship anyway? (y/n)"
- If user confirms: proceed to PR creation
- If user declines: stop

## Error Handling

- **No git remote:** Run the full pipeline (steps 3a-3e). At step 5, report:
  "No git remote configured. Run `git remote add origin <url>` or `gh repo create`,
  then run `/ship` again — all steps are cached and will be skipped."

- **`gh` not authenticated:** Report: "GitHub CLI not authenticated. Run `gh auth login`."

- **Step failure:** Log `status: failed`, show dashboard with failure visible,
  stop the pipeline. Report what failed and why. User fixes the issue and
  runs `/ship` again — passed steps are skipped via smart skip.

- **Ctrl+C / cancel:** Readiness file only has entries for completed steps.
  Next `/ship` run picks up naturally.
