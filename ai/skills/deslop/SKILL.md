---
name: deslop
description: Use for deep-clean cleanup of AI-generated code across a whole codebase — dedupe, dead code, circular deps, weak types, defensive try/catch, legacy paths, and AI-slop comments. Supports JavaScript/TypeScript, Ruby/Rails, and Go. Run after heavy AI-coding sessions, before merging long-running branches, or when the codebase smells like vibe-coded slop. Distinct from `/simplify` (scoped to recent edits); `/deslop` attacks the whole codebase.
argument-hint: "[path] [--dry-run] [--passes 1,2,...] [--stack js|ruby|go]"
---

# Deslop

Aggressive whole-codebase cleanup for AI-generated code. Eight specialized
passes, each a fresh-eyes subagent with a narrow mandate. Based on the pattern
from Shaw (@shawmakesmagic). The framing: "the quality of your vibecoded slop
is horrible… fortunately, there is a fix."

## What It Does (the 8 passes)

1. **DRY / dedupe** — consolidate duplicated code where it reduces complexity
2. **Consolidate shared types** — unify type definitions that should be shared
3. **Remove dead code** — find unreferenced code with stack-appropriate tools
4. **Untangle circular dependencies** — surface and break cycles
5. **Remove weak types** — replace `any`/`unknown`/`T.untyped`/`interface{}` with real types
6. **Remove defensive try/catch** — delete error handlers that swallow or hide errors without a real purpose
7. **Remove legacy/deprecated/fallback code** — consolidate to a single current code path
8. **Remove AI-slop comments** — strip in-motion commentary, stubs, larp, and obvious-code comments

## When to Use

- After a heavy AI-coding session (you've generated a lot of code quickly)
- Before merging a long-running feature branch
- On a codebase inherited from another AI session or another developer
- As a periodic deep-clean (quarterly, per-release)
- Position in pipeline: `heavy AI coding → /deslop → /simplify → /adversarial-review → /finalize → commit`

## When NOT to Use

- Trivial changes or recent edits — use `/simplify` instead
- A codebase you don't have time to review carefully — this will move files and kill code
- Mid-feature — finish the feature first
- Without a clean git tree (see Safety below)

## Safety — Non-Negotiable

This skill deletes code. Before running anything:

1. **Verify clean git tree** — `git status` must be clean. Refuse to proceed otherwise. If uncommitted changes exist, tell the user to stash or commit.
2. **Create a dedicated branch** — `git checkout -b deslop/YYYY-MM-DD` before any pass writes. Never run on main/master.
3. **Commit between passes** — each pass gets its own commit so individual passes can be reverted without redoing the rest.
4. **High-confidence only** — each subagent implements only changes it is confident about. Borderline calls go in its report for human review, not in the code.
5. **No pass is blocking** — if a required tool isn't installed, the pass reports "skipped: missing <tool>" and moves on.

## Input Parsing

Parse `$ARGUMENTS`:

- **No args** → run all 8 passes on the repo root
- **Path** (e.g. `app/services` or `src/`) → scope all passes to that path
- **`--dry-run`** → run the research phase for each pass, print a critical assessment, but make zero code changes
- **`--passes 1,3,8`** → run only the listed pass numbers (comma-separated)
- **`--stack js`|`ruby`|`go`** → force the stack (skip auto-detection)

## Step 1: Detect the Stack

Look for lockfiles in the target path (or repo root if no path given):

| File | Stack |
|------|-------|
| `package.json` + `tsconfig.json` | `typescript` |
| `package.json` (no TS config) | `javascript` |
| `Gemfile` | `ruby` (check for `rails` gem → `rails`) |
| `go.mod` | `go` |

A repo may have multiple stacks (e.g. Rails app with a Vue frontend). Record all stacks found. When dispatching each pass, tell the subagent which stacks are in scope for the files it will touch. For a nested frontend (e.g. `app/frontend/`), pass 3 and 4 dispatch a JS/TS-aware subagent for that subtree and a Ruby-aware one for the rest.

If `--stack` is given, skip detection and use the forced stack.

For stack-specific tooling details (commands, install, quirks), read the relevant reference file only when a pass that uses that tool is about to run:

- `references/javascript.md` — knip, madge, ts-prune, TypeScript type checking
- `references/ruby.md` — debride, packwerk, Sorbet notes
- `references/go.md` — staticcheck, `go mod graph`, deadcode

## Step 2: Research Phase (parallel, read-only)

For each pass that is in scope (not skipped by `--passes`), dispatch a subagent **in the same turn** so all 8 research tasks run in parallel.

Use the **Agent tool** with `subagent_type: general-purpose`. Each research subagent:

- Reads code only — makes no edits
- Runs read-only analysis tools (linters, `knip --dry-run`, `madge --circular`, etc.)
- Produces a critical assessment: what's wrong, where, how confident, how to fix
- Categorizes each finding as **high-confidence** (safe to auto-apply) or **needs-review**
- Returns a structured report

Research subagent prompt template (fill in `{pass_name}`, `{pass_instructions}`, `{stack_info}`, `{scope_path}`):

```
You are a senior engineer performing a cold read of this codebase. You are
scoped to a single concern: {pass_name}.

## Stack Info
{stack_info}

## Scope
Target path: {scope_path}

## Your Mandate
{pass_instructions}

## Output Format

Return two sections:

### Critical Assessment
A prose summary of the state of the code for your concern. What patterns do
you see? How pervasive is the problem? Any notable surprises?

### Findings
A list of concrete, actionable findings. For each finding, provide:

- **Location:** file path(s) and line range(s)
- **Issue:** what's wrong
- **Fix:** specific, concrete change
- **Confidence:** high | needs-review
- **Rationale:** why this is safe (for high-confidence) or what the risk is (for needs-review)

Be honest about confidence. If you can't verify a symbol is unused across the
whole codebase, it's needs-review. If removing a try/catch might swallow a real
error condition, it's needs-review. When in doubt, err toward needs-review.

## Do Not
- Make any file edits
- Run stateful commands (git commits, migrations, package installs)
- Go beyond your concern's scope
```

See `references/passes.md` for the full per-pass instructions, stack-aware tool invocations, and what counts as high-confidence vs needs-review for each pass.

## Step 3: Apply Phase (sequential, one commit per pass)

If `--dry-run`, skip this step and jump to the report.

For each pass with high-confidence findings, in this order:

1. **Dead code (pass 3) first** — removing unused code shrinks the surface area for later passes
2. **AI slop comments (pass 8)** — comments are low-risk
3. **Legacy/deprecated (pass 7)**
4. **Defensive try/catch (pass 6)**
5. **Weak types (pass 5)**
6. **Consolidate shared types (pass 2)**
7. **DRY / dedupe (pass 1)** — most invasive, runs after others have cleaned the field
8. **Circular deps (pass 4)** — structural changes, run last

For each pass:

1. Dispatch an apply subagent. Give it the findings from its research pass and instruct it to implement only the **high-confidence** items. Provide file contents fresh (don't rely on research-phase cached state).
2. After the subagent returns, run the project's type checker / linter / test suite if available — record pass/fail
3. Commit with message `deslop: <pass_name>` (e.g. `deslop: remove dead code`)
4. If tests or type-check fail, **do not proceed** to the next pass. Report the failure and hand back to the user.

Apply subagent prompt template:

```
You are implementing a single cleanup pass: {pass_name}.

## Stack Info
{stack_info}

## Findings to Apply
{high_confidence_findings}

## Rules
- Implement ONLY the findings above. Do not expand scope.
- If a finding looks wrong on closer inspection, skip it and note why in your
  report. Safety over completeness.
- Make minimal edits. Don't reformat, rename, or touch surrounding code.
- If a finding would break a public API, skip it and flag it.

## Output
Return a summary:
- Applied: N findings
- Skipped: N findings (with brief reason for each)
- Files touched: list
```

## Step 4: Report

After all passes (or after `--dry-run` research), produce a single report:

```
## Deslop Report

**Stack:** <detected stacks>
**Scope:** <path>
**Mode:** <full | dry-run | --passes 1,3,8>
**Branch:** deslop/YYYY-MM-DD (or "no changes — dry-run")

### Pass Summary
| Pass | Findings | High-Conf | Applied | Needs-Review | Skipped |
|------|----------|-----------|---------|--------------|---------|
| 1. DRY/dedupe | ... | ... | ... | ... | ... |
| 2. Shared types | ... | ... | ... | ... | ... |
| 3. Dead code | ... | ... | ... | ... | ... |
| 4. Circular deps | ... | ... | ... | ... | ... |
| 5. Weak types | ... | ... | ... | ... | ... |
| 6. Defensive try/catch | ... | ... | ... | ... | ... |
| 7. Legacy code | ... | ... | ... | ... | ... |
| 8. AI slop comments | ... | ... | ... | ... | ... |

### Needs-Review Items
Grouped by pass. Each item includes location, issue, suggested fix, and why
it was deferred. Review these manually.

### Commits
List of commits created on the branch.

### Next Steps
- Review needs-review items
- Run the full test suite
- Run `/simplify` + `/adversarial-review` before merging
```

## Common Mistakes

- **Running on a dirty tree.** The whole point of commits between passes is clean reverts. If you skip the clean-tree check, a bad pass can mix with the user's in-flight work and become a nightmare to untangle.
- **Skipping the research phase.** Going straight to edits produces the cargo-cult behavior Shaw was railing against. Research first, commit to findings, then apply.
- **Applying needs-review items.** If the subagent wasn't confident, neither should the apply phase be. Surface them in the report and let the user decide.
- **Running pass 1 (DRY) before pass 3 (dead code).** You'd waste effort deduping code that's about to be deleted.
- **Running all passes in parallel during apply.** The passes can conflict (e.g. type consolidation moves a type the dead-code pass wants to remove). Research in parallel, apply sequentially.
- **Treating missing tools as blocking.** If `knip` isn't installed, the JS/TS dead-code pass reports "skipped — install `knip`" and the rest of the run continues. Never halt the whole flow because one tool is missing.

## References

- Shaw's original prompt: https://x.com/shawmakesmagic/status/2044269097647779990
- `references/passes.md` — full per-pass instructions
- `references/javascript.md` — JS/TS tooling (knip, madge, ts-prune)
- `references/ruby.md` — Ruby/Rails tooling (debride, packwerk)
- `references/go.md` — Go tooling (staticcheck, `go mod graph`)
