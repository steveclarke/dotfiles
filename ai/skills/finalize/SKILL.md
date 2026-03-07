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

### 5. UI & Design Quality

Skip this section if the changeset has no view/template/component files.
Otherwise, scan all changed view files against these checks.

**Component usage:**
- Every UI element should use the project's component library (Kiso `kui()`,
  Nuxt UI, etc.) — not hand-rolled HTML for something the library provides
- Check for raw `<button>`, `<input>`, `<table>`, `<dialog>` that should use
  library components instead

**Spacing & layout:**
- All spacing values from the standard scale (1, 1.5, 2, 3, 4, 6, 8, 12, 16)
- Flag non-standard values like `p-7`, `mt-11`, `gap-3.5` — these suggest
  eyeballing instead of using the system
- Content areas use consistent padding and max-width within the project
- Page structure matches the project's established layout pattern (check
  existing pages for the dominant pattern)

**Typography:**
- Same structural role uses same text size everywhere (page titles, section
  titles, card titles, body, captions should each be one consistent size)
- Font weights match the project's hierarchy (typically semibold for headings,
  medium for labels, normal for body)

**Color:**
- Semantic tokens only (primary, secondary, muted, destructive, etc.)
- No raw color classes (blue-500, zinc-700) in view files
- Same semantic meaning for same colors (if "active" is green on one page,
  it should be green everywhere)

**Interaction states:**
- Interactive elements have hover, focus, active, and disabled states
- Focus indicators are visible (never `outline-none` without a replacement)
- Loading states exist for async actions
- Destructive actions have appropriate confirmation

**Empty states:**
- Pages that can have no data handle it with a proper empty state
- Empty states include: description of what will appear, clear action to
  create first item
- Pattern matches the project's existing empty state approach

**Consistency with existing pages:**
- New pages match the structure of similar existing pages
- Headers, content wrappers, and action placement follow established patterns
- If the page deviates from the dominant pattern, the deviation is intentional
  and justified

**Accessibility basics:**
- Text contrast meets WCAG AA (4.5:1 for normal text, 3:1 for large text)
- All images have alt text
- Form inputs have associated labels
- Heading hierarchy is logical (no skipping levels)

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
