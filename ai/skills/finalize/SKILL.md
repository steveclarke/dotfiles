---
name: finalize
description: Post-implementation checklist for documentation, code quality, convention alignment, visual verification, and issue hygiene. Run after core work is done, before committing or merging. Use when user says "finalize", "ready to merge", "preflight check", "wrap this up", "did we miss anything", or "final review".
---

# Finalize

## How it works

This skill runs a universal checklist, then checks the project's CLAUDE.md
for any project-specific finalization requirements (look for a "Finalize
Checklist" section or similar). The project knows what it needs — this skill
just makes sure nothing gets skipped.

## Universal Checklist

Work through each section. Report what passes and what needs fixing.
Fix issues directly rather than just listing them — the user wants the
work done, not a report.

### 1. Lint & Format

Run whatever lint/format tools the project uses. Check CLAUDE.md or
package.json/Gemfile for the commands. Common ones:

- Ruby: `standardrb`, `rubocop`
- JS/TS: `eslint`, `oxlint`, `prettier`, `oxfmt`
- CSS: `stylelint`
- Python: `ruff`, `black`

### 2. Tests

Run the project's test suite. Check for:
- All tests pass
- No skipped tests that shouldn't be skipped
- New code has test coverage (or note if it doesn't)

### 3. Code Quality Sweep

Scan changed files for common issues:
- Raw/hardcoded values that should use project utilities or constants
- Inconsistent patterns with existing code (naming, structure, style)
- Dead code, redundant logic, TODO/FIXME comments left behind
- Debug statements (console.log, binding.pry, debugger, puts)
- Security: hardcoded secrets, unsafe patterns

### 4. Documentation

Check that new/changed code has corresponding documentation:
- README or docs pages updated if user-facing behavior changed
- Inline docs (JSDoc, YARD, docstrings) on public APIs
- Any project-specific docs (check CLAUDE.md for the list)

### 5. Visual Verification

If the project has a visual component (UI library, web app):
- Verify changes render correctly
- Check in dev server, Storybook, Lookbook, or equivalent
- Light mode and dark mode if applicable
- Mobile/responsive if applicable

### 6. Git & Issue Hygiene

- PR description reflects the actual scope of changes
- `Closes #N` or equivalent issue linking in PR body
- Parent issues/epics updated if this is part of a larger effort
- Follow-on issues created for deferred or discovered work
- Issues added to project board with correct status

### 7. Project-Specific Checks

Read the project's CLAUDE.md for a "Finalize Checklist" section (or similar).
If it exists, work through those items too. These are project-specific
requirements that the universal checklist can't know about.

### 8. Memory

If this is a Claude Code session with persistent memory:
- Update memory files with key learnings, decisions, or patterns discovered
- Update status tracking (component counts, phase progress, etc.)
