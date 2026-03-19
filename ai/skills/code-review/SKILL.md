---
name: code-review
description: "Pre-PR code review with multi-agent parallel analysis. Use when user says 'code review', 'review this code', 'review my changes', 'check for bugs', or before creating a PR."
disable-model-invocation: true
argument-hint: "[files/dirs] [--pr]"
---

# Code Review

Breadth-first pre-PR code review using 5 parallel review agents, each with a
different lens. Confidence-scored, false-positive-filtered, with auto-fix for
mechanical issues. Complements `/adversarial-review` (depth-first iterative
loop) — this skill catches what any single reviewer would miss across multiple
dimensions in one pass.

## Input Modes

Parse `$ARGUMENTS` to determine what to review:

- **No args:** review uncommitted changes — run `git diff` and `git diff --cached`
- **File/dir paths:** review specific files — read them directly
- **`--pr` flag:** review the full branch diff against the base branch

If the diff is empty, tell the user there's nothing to review and stop.

## Step 1: Detect Base Branch

Determine the base branch for diffing:

1. Try `gh pr view --json baseRefName -q .baseRefName` (if a PR already exists)
2. Try `git remote show origin | grep 'HEAD branch'` for the repo default
3. Fall back to `main`, then `master`

Store the result — you'll use it for the branch diff.

## Step 2: Gather Context

### The diff

Based on input mode:
- **No args:** `git diff` + `git diff --cached`
- **File paths:** read the files directly
- **`--pr`:** `git diff {base_branch}...HEAD`

Also generate a **change summary** — list of files changed, insertions/deletions,
and a one-line description of what the changeset does. Use a **haiku** Agent for
this:

```
Agent(model: "haiku", description: "Summarize changeset")
Prompt: "Here is a git diff. Return: (1) list of files changed with +/- line counts, (2) a one-sentence summary of what this changeset does. Be concise.\n\n{diff}"
```

### CLAUDE.md files

Use a **haiku** Agent to find relevant CLAUDE.md files:

```
Agent(model: "haiku", description: "Find CLAUDE.md files")
Prompt: "Find all CLAUDE.md files relevant to this review. Check: (1) the project root, (2) any directories containing modified files. Return the file paths and their contents. Modified files: {file_list}"
```

The agent should use `Read` and `Glob` to find and read the files.

## Step 3: Dispatch 5 Review Agents (Parallel)

Launch all 5 agents simultaneously using the **Agent tool** with `model: "sonnet"`.
Give each agent the diff, the change summary, and the CLAUDE.md contents.

Each agent returns a list of findings. Each finding must include:
- **File** and **line number/range**
- **Issue** description
- **Category** (which lens found it)
- **Severity** — one of: `mechanical` (auto-fixable) or `judgment` (needs user input)

### Agent 1: CLAUDE.md Compliance

```
Agent(model: "sonnet", description: "CLAUDE.md compliance review")
Prompt:
"Review this diff for compliance with the project's CLAUDE.md conventions.

CLAUDE.md contents:
{claude_md_contents}

Diff:
{diff}

Check:
- Naming conventions, file organization, architectural patterns
- Explicitly stated rules and preferences
- Style and formatting requirements

Only flag violations of rules that are EXPLICITLY stated in the CLAUDE.md.
Do not flag general best practices unless the CLAUDE.md specifically requires them.
For each finding, quote the specific CLAUDE.md rule being violated.

Return findings as a JSON array:
[{\"file\": \"path\", \"line\": N, \"issue\": \"description\", \"claude_md_rule\": \"quoted rule\", \"category\": \"claude-md\", \"severity\": \"mechanical|judgment\"}]

If no violations found, return an empty array: []"
```

### Agent 2: Bug Scan

```
Agent(model: "sonnet", description: "Bug and security scan")
Prompt:
"Do a shallow bug scan of this diff. Focus on the CHANGES ONLY — not pre-existing code.

Diff:
{diff}

Scan for:
- Security issues: injection, auth bypass, data exposure, XSS, CSRF (OWASP top 10)
- Correctness: logic errors, off-by-one, null/nil handling, type mismatches
- Race conditions: concurrent access, shared mutable state, missing locks
- Data safety: destructive operations without confirmation, missing validations
- Missing LLM output validation (if applicable)

Ignore:
- Issues a linter/typechecker/compiler would catch
- Pre-existing issues on lines not modified in this diff
- Style preferences and nitpicks

Return findings as a JSON array:
[{\"file\": \"path\", \"line\": N, \"issue\": \"description\", \"category\": \"bug\", \"severity\": \"mechanical|judgment\"}]

If no bugs found, return an empty array: []"
```

### Agent 3: Git Blame / History Context

```
Agent(model: "sonnet", description: "Git history context review")
Prompt:
"Review this diff in the context of git history. For each modified file, run
git blame and git log to understand what changed recently and why.

Diff:
{diff}

Changed files: {file_list}

Check for:
- Reverting recent intentional changes without explanation
- Modifying code that has a comment explaining why it's written that way
- Breaking patterns established by recent commits
- Removing code that was added recently for a specific reason (check commit messages)

Use Bash to run: git blame {file}, git log --oneline -10 {file}, git log -1 --format='%s%n%b' {commit_sha}

Return findings as a JSON array:
[{\"file\": \"path\", \"line\": N, \"issue\": \"description\", \"history_context\": \"what the history shows\", \"category\": \"history\", \"severity\": \"mechanical|judgment\"}]

If no issues found, return an empty array: []"
```

### Agent 4: Previous PR Comments

```
Agent(model: "sonnet", description: "Check previous PR comments on modified files")
Prompt:
"Check if there are previous PR comments on the files modified in this diff
that might be relevant to the current changes.

Changed files: {file_list}

Steps:
1. Use gh to find recent merged PRs that touched these files:
   gh pr list --state merged --limit 10 --json number,title
2. For each relevant PR, check for review comments:
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments
3. Look for comments about the same code areas being modified now

Flag any previous review feedback that:
- Applies to the current changes (same patterns, same concerns)
- Was explicitly requested but not implemented
- Warned about issues that this diff might reintroduce

Return findings as a JSON array:
[{\"file\": \"path\", \"line\": N, \"issue\": \"description\", \"pr_reference\": \"PR #N: comment\", \"category\": \"pr-history\", \"severity\": \"mechanical|judgment\"}]

If no relevant comments found, return an empty array: []"
```

### Agent 5: Code Comment Compliance

```
Agent(model: "sonnet", description: "Code comment compliance check")
Prompt:
"Check that the changes in this diff comply with existing code comments,
TODOs, and inline documentation.

Diff:
{diff}

For each modified file, read the FULL file (not just the diff) and check:
- Do the changes contradict any inline comments near the modified code?
- Are there TODO/FIXME/HACK/NOTE comments that the changes should address?
- Did the changes make any existing comments stale or incorrect?
- Are there 'do not modify' or 'keep in sync' warnings being violated?

Return findings as a JSON array:
[{\"file\": \"path\", \"line\": N, \"issue\": \"description\", \"comment_text\": \"the relevant comment\", \"category\": \"comments\", \"severity\": \"mechanical|judgment\"}]

If no issues found, return an empty array: []"
```

## Step 4: Confidence Scoring

For each finding from all 5 agents, dispatch a **haiku** Agent to score confidence.
Run these in parallel — one agent per finding.

```
Agent(model: "haiku", description: "Score finding confidence: {brief_description}")
Prompt:
"Score this code review finding on a scale of 0-100 for confidence that it is
a real, actionable issue (not a false positive).

Finding:
{finding_json}

CLAUDE.md rules (if relevant):
{claude_md_contents}

Diff context:
{relevant_diff_section}

Scoring rubric:
- 0: False positive. Doesn't stand up to scrutiny, or is a pre-existing issue.
- 25: Might be real, might be false positive. Stylistic issue not in CLAUDE.md.
- 50: Verified real but may be a nitpick or rare in practice.
- 75: Confirmed real, will be hit in practice, important.
- 100: Absolutely certain, frequent in practice, evidence confirms.

False positive examples (score 0-25):
- Pre-existing issues on unmodified lines
- Issues a linter/typechecker would catch
- Pedantic nitpicks a senior engineer wouldn't flag
- General quality issues not required by CLAUDE.md
- Changes in functionality that are likely intentional
- Issues silenced by lint-ignore comments

Return ONLY a JSON object: {\"score\": N, \"reasoning\": \"brief explanation\"}"
```

**Filter:** Drop any finding with score below 80.

## Step 5: Auto-Fix vs. Ask

Classify each surviving finding:

### Mechanical — fix silently:
- Dead code, unused variables/imports
- Stale comments that contradict the code
- Magic numbers → named constants
- Debug statements left behind (console.log, puts, binding.pry, debugger)
- N+1 queries (obvious cases)
- Missing LLM output validation (straightforward additions)

For each mechanical fix:
1. Apply the fix using `Edit`
2. Record what was fixed for the report

### Judgment — ask the user with a recommendation:
- Security findings (auth, injection, XSS)
- Race conditions
- Design decisions, architectural concerns
- Fixes requiring >20 lines changed
- Removing functionality
- Anything changing user-visible behavior

Present these to the user with a specific recommendation for each.

## Step 6: Test Coverage Check

Analyze the diff for new code that needs tests. Use a **haiku** Agent:

```
Agent(model: "haiku", description: "Test coverage assessment")
Prompt:
"Analyze this diff and determine if new tests are needed.

Diff:
{diff}

REQUIRES tests (flag as critical finding if missing):
- New public methods or functions
- New API endpoints or routes
- New business logic or algorithms
- New data transformations or calculations
- New error handling paths

DOES NOT require tests:
- Config file changes
- Documentation changes
- View-only / template changes
- One-line fixes to existing tested code
- Dependency updates

Check if the diff includes corresponding test files. Look for test files in
common locations: test/, spec/, __tests__/, *.test.*, *_test.*, *_spec.*

Return a JSON object:
{\"status\": \"ok|gaps\", \"details\": \"explanation\", \"missing_tests\": [\"list of what needs tests\"]}"
```

If `status` is `"gaps"`, add each missing test as a critical finding in the report.

## Step 7: Report

Present the final report. Do NOT log to any readiness file — the `/ship`
orchestrator handles that. Terminal output only.

```
## Code Review Complete

**Findings:** N total (X critical, Y informational)

### AUTO-FIXED:
- `file.rb:42` — removed unused variable `oldPort`
- `registry.go:118` — magic number 30 → `defaultTimeoutSec`

### NEEDS INPUT:
- `allocator.go:67` — concurrent map access without mutex (confidence: 92)
  **Recommendation:** wrap in sync.RWMutex

### Test Coverage:
- [OK] All new logic has corresponding tests
  OR
- [GAPS] Missing tests for: new `calculate_dues` method in `member.rb`

**Status:** CLEAR — no issues need input
  OR
**Status:** N issues need input
```

If zero findings survived filtering, report:

```
## Code Review Complete

**Findings:** 0

No issues found. Checked for bugs, CLAUDE.md compliance, historical context,
previous PR comments, and code comment consistency.

### Test Coverage:
- [OK|GAPS] — description

**Status:** CLEAR
```

## Common Mistakes

- **Flagging pre-existing issues** — only flag problems introduced or worsened by THIS diff
- **Inflating severity** — if it's a nitpick, score it honestly. The 80% filter exists for a reason
- **Missing the auto-fix** — if a finding is mechanical, fix it. Don't just report it
- **Requiring tests for everything** — config changes, docs, and view-only changes don't need tests
- **Posting to GitHub** — this is a pre-PR terminal review. No `gh pr comment`
- **Logging to readiness file** — the `/ship` orchestrator handles that, not this skill
