---
name: simplify
description: "Review recently changed code for reuse, simplification, efficiency, and consistency cleanups, then apply the fixes. Quality only — doesn't hunt for bugs. Triggers on 'simplify', 'clean this up', 'simplify this diff'."
---

# Simplify

Standalone version of the Simplify gate `ship` runs inline. Use this
directly for a lightweight cleanup pass on whatever you're currently
working on, without running the rest of ship's pre-merge pipeline (clean
working tree requirement, Code Review, PR creation, etc.).

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
