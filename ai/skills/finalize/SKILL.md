---
name: finalize
description: "Post-implementation checklist — docs, code quality, conventions, visual verification, issue hygiene. Triggers on 'finalize', 'ready to merge', 'preflight check', 'wrap this up', 'final review'."
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

### 5. UI & Design Quality

Skip this section if the changeset has no view/template/component files.

**Run Impeccable skills on changed view files:**
- `/polish` — spacing, interaction states, typography, transitions, details
- `/audit` — accessibility, performance, responsive, theming
- `/normalize` — component library usage, design system compliance, tokens

Report which skills were run and what they found. Fix issues directly.

**Consistency with existing pages** (not covered by Impeccable):
- New pages match the structure of similar existing pages
- Headers, content wrappers, and action placement follow established patterns
- If the page deviates from the dominant pattern, the deviation is intentional
  and justified

**Visual verification:**
- Changes render correctly in dev server, Storybook, or Lookbook
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
