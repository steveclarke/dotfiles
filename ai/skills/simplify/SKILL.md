---
name: simplify
description: "Reviews the current diff for duplication, dead code, needless abstraction and inconsistency with surrounding code, then applies the high-confidence fixes. Quality cleanup only, not a bug hunt. Use on 'simplify', 'clean this up' or 'simplify this diff', and from ship."
---

# Simplify

A lightweight cleanup pass on the current diff. `ship` runs it when a repo
documents no review path of its own. It exists for harnesses without a
built-in `/simplify`, such as Codex.

**Contract:** the current diff introduces no avoidable complexity.

## What to do

Review the diff (see scope below) and remove, with high-confidence edits
only:

- Duplication
- Dead code
- Needless indirection
- Unnecessary abstraction
- Premature generalization
- Patterns inconsistent with the surrounding code
- Test noise

Do **not** churn design or public APIs unless the diff itself created the
problem. If a change needs judgment rather than being clearly correct,
report it instead of "fixing" it.

Fix issues directly and report what changed, briefly. This is quality
cleanup only — it does not hunt for bugs. For correctness/security review,
use a code-review skill/command instead.

## Determining scope

Default to the diff between the current branch and its fork point from the
base branch:

```bash
BASE="$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null || gh repo view --json defaultBranchRef -q .defaultBranchRef.name 2>/dev/null || echo main)"
BASE_REF="$(git rev-parse --verify --quiet "$BASE" >/dev/null 2>&1 && echo "$BASE" || echo "origin/$BASE")"
FORK="$(git merge-base "$BASE_REF" HEAD 2>/dev/null)"
git diff "$FORK"...HEAD
```

If there's no branch/PR context yet (uncommitted work-in-progress), review
`git diff HEAD` instead — staged and unstaged changes against the last
commit.

If the user names a specific file, scope, or commit range, use that instead
of the default.
