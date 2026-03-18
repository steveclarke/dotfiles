---
name: adversarial-review
description: Use when implementation is complete and you want rigorous code review before committing. Use for features, refactors, and changes touching critical paths. Not for trivial changes — this is expensive.
disable-model-invocation: true
argument-hint: "[files/dirs] [--pr]"
---

# Adversarial Review

Automated critique-fix loop using fresh-eyes reviewer subagents. Each round, a
new subagent reviews the code cold — no knowledge of why decisions were made, no
attachment to the implementation. The main agent fixes Critical and Suggestion
findings, then a fresh reviewer checks again. Loop stops when only Nitpicks
remain or after 3 rounds.

## When to Use

- After implementation, before committing — especially for features and refactors
- When changes touch critical paths, security-sensitive code, or complex logic
- When you want a review that's harder than what you'd give yourself
- Position in pipeline: `implement → /simplify → /adversarial-review → /finalize → commit`

## When NOT to Use

- Trivial changes, docs-only, config tweaks — use `/simplify` + `/finalize` instead
- Mid-implementation — finish building first, then review
- When you just want a quick sanity check — use `/code-review` instead

## Input Modes

Parse `$ARGUMENTS` to determine what to review:

- **No args:** review uncommitted changes — run `git diff` and `git diff --cached` to get staged + unstaged changes
- **File/dir paths:** review specific files — read them directly and present as the code to review
- **`--pr` flag:** review the full branch diff — run `git diff main...HEAD` (try `master` if `main` doesn't exist)

If the diff is empty, tell the user there's nothing to review and stop.

## Step 1: Gather Context

Before dispatching the reviewer, collect two things:

### The diff

Collect the diff based on the input mode above. This is what the reviewer will critique.

### Project conventions

Search the project for convention docs the reviewer should know about. Look for:

- CLAUDE.md files (project root and nested directories)
- Guide/convention docs in common locations: `project/guides/`, `docs/`, `.cursor/rules/`, `AGENTS.md`
- Lint and style config files (`.rubocop.yml`, `.eslintrc.*`, `.prettierrc`, `standardrb` config, etc.)

**Budget:** Keep convention context to ~5K tokens. Include CLAUDE.md files and lint configs. Do NOT include full implementation guides, feature docs, or READMEs — the reviewer is reviewing code quality, not feature completeness. If convention material exceeds the budget, prioritize CLAUDE.md files first, then lint configs.

## Step 2: Dispatch Reviewer Subagent

Use the **Agent tool** to spawn a reviewer:

- `subagent_type`: `general-purpose`
- `description`: `"Adversarial code review — round N"`
- `prompt`: the full reviewer prompt below, with `{conventions}` and `{diff}` replaced with the actual content

### Reviewer Prompt

```
You are a senior developer doing a cold code review. You have never seen this
code before. You have no context on why decisions were made. You did not write
any of this. Review with completely fresh eyes.

## Project Conventions

{conventions}

## Code to Review

{diff}

## Review Criteria

Be opinionated. Review for:

- **Correctness:** bugs, logic errors, edge cases, race conditions
- **Security:** injection, auth bypass, data exposure, OWASP top 10
- **DRY:** duplicated logic that should be extracted
- **Modularity:** classes/methods doing too much, unclear boundaries
- **Testability:** code that's hard to test, missing test coverage
- **Simplicity:** over-engineering, unnecessary abstractions, premature generalization
- **Architecture:** does it conform to the project's established patterns and conventions?
- **Naming:** unclear or misleading names
- **Error handling:** swallowed errors, missing edge cases

## Output Format

Return findings as a list. Each finding MUST have:

- **Severity:** Critical | Suggestion | Nitpick
- **Location:** file path and line range
- **Issue:** what's wrong
- **Fix:** specific, concrete recommendation

Severity definitions:
- **Critical** = bugs, security issues, data loss risk, broken functionality
- **Suggestion** = improvements that meaningfully affect quality, maintainability, or conformance
- **Nitpick** = style preferences, minor naming quibbles, cosmetic issues

Be thorough but honest about severity. Don't inflate Nitpicks to Suggestions.
If the code is solid, say so — an empty findings list is a valid result.
```

## Step 3: Process Findings

When the reviewer subagent returns:

1. Read through the findings
2. **Fix** all Critical and Suggestion items directly in the code
3. **Skip** any finding that conflicts with established project conventions or prior discussion in this session — note why you skipped it
4. **Log** Nitpick items without acting on them
5. Track what was found and fixed this round

Use your judgment. If a finding is wrong or would break something, skip it and note why. The reviewer has fresh eyes but lacks your conversation context — you know things it doesn't.

## Step 4: Loop

After applying fixes:

1. Collect the new diff — compare against the **original baseline** (not the previous round). The reviewer should see the full changeset each time, not just the fixes.
2. Spawn a **fresh** reviewer subagent with the updated diff. Do not reuse the previous subagent.
3. Repeat until one of these conditions is met:
   - **Only Nitpick findings remain** → stop, the code is clean
   - **3 rounds completed** → stop, report any remaining non-nitpick findings

## Step 5: Report

Present a summary when done:

```
## Adversarial Review Complete

**Rounds:** N of 3
**Result:** [Clean — only nitpicks remain | Capped — N issues remain after 3 rounds]

### Round 1
- [Critical] file.rb:12-15 — description (FIXED)
- [Suggestion] file.rb:30 — description (FIXED)
- [Nitpick] file.rb:45 — description

### Round 2
- [Nitpick] file.rb:32 — description

### Remaining Nitpicks
- file.rb:45 — description
- file.rb:32 — description
```

If the first round returns no findings at all, report that the code passed clean and stop.

## Common Mistakes

- **Reusing the same subagent** for round 2 — it remembers its own findings and loses the "fresh eyes" benefit. Always spawn a new one.
- **Diffing fixes only** instead of the full changeset — the round 2 reviewer should see everything, not just what changed since round 1.
- **Applying every finding blindly** — you have conversation context the reviewer lacks. Use judgment. Skip findings that conflict with project conventions or prior decisions, and note why.
- **Running this on trivial changes** — this is expensive. If you just renamed a variable, use `/simplify` + `/finalize` instead.
