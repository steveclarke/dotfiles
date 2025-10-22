# Move Files Command

## Overview
A two-phase approach for moving files that preserves git history and makes changes trackable in diffs.

## The Problem
When moving files, if you copy content and write new files, git treats them as deletions + additions rather than moves. This makes it impossible to track what actually changed versus what just moved.

## The Solution: Two-Phase Move

### Phase 1: Move Files with `mv` Commands

**CRITICAL RULE:** Use terminal `mv` commands ONLY. Never copy content and write files.

```bash
mv source/path destination/path
```

**After moving files, STOP.**

Tell the user:
> "Phase 1 complete. Files have been moved using `mv` commands. Please stage these moves in git, then let me know when ready for Phase 2."

### Phase 2: Make Content Changes (Only After User Stages)

Only proceed after user explicitly confirms moves are staged.

Now make any necessary content changes to the moved files:
- Update path references
- Fix import statements
- Update documentation links
- Adjust configuration values
- Modify file content as needed

## Why This Works

**Git tracking:** When you use `mv` and stage the move, git recognizes it as a rename/move operation. This preserves file history.

**Clean diffs:** 
- Phase 1 diff shows: file moved from A to B (no content changes)
- Phase 2 diff shows: only the actual content modifications

**Easy review:** The user can verify moves are correct before any content changes happen. This makes it clear what moved versus what actually changed.

## When to Use This

Use this pattern whenever:
- Moving files between directories
- Reorganizing documentation
- Refactoring code structure
- Consolidating scattered files
- Any scenario where files need to move AND have content updated

## Example Usage

User says: "Move all the guides from backend/docs/ to project/guides/backend/"

Your response:
1. Use `mv backend/docs/guides project/guides/backend`
2. Verify the move succeeded
3. Tell user to stage the moves
4. **WAIT** for user confirmation
5. Only then make content changes to the moved files

## Key Principles

- **Use `mv` commands only** - Never copy and write
- **Stop after moves** - Wait for staging
- **Make content changes separately** - Only after user confirms staging
- **One phase at a time** - Never combine moves with content changes

