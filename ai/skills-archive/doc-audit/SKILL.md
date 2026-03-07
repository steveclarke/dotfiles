# Doc Audit

Audit documentation for accuracy against the current codebase. Finds stale
references, wrong examples, outdated counts, removed files, renamed APIs,
and drift between what the docs say and what the code actually does.

Use when: "audit the docs", "are the docs up to date?", "check documentation",
"docs drift check", "verify the docs", "is our documentation accurate?",
"doc audit", "documentation review", "do the docs match the code?",
"anything stale in the docs?", "doc health check".

## How it works

This skill reads the project's documentation files and cross-references them
against the actual source code. It reports only **inaccuracies** — things that
are wrong, stale, or misleading. It does not report things that are fine.

After reporting findings, fix the issues directly rather than just listing them.

## What to audit

### 1. Find all documentation

Locate documentation files in the project. Common locations:
- `README.md`, `CLAUDE.md`, `CONTRIBUTING.md`
- `docs/` directory
- `project/` or `doc/` directories
- Skill files (`.claude/skills/`)
- API docs, guides, architecture docs
- Inline code examples in markdown files

### 2. For each document, check against source code

**File paths and references:**
- Do referenced files still exist at the stated paths?
- Have files been moved, renamed, or deleted?
- Do directory listings match reality?

**Code examples:**
- Do the APIs shown (function names, parameters, return values) match the
  actual source code?
- Are default values correct?
- Do import paths resolve?
- Are class/module/component names current?

**Counts and lists:**
- Component counts, feature lists, supported versions — do they match?
- Are items listed as "TODO" or "planned" actually already done?
- Are items listed as "done" actually present in the code?

**Terminology:**
- Has naming changed? (e.g., `destructive` → `error`, `data-component` → `data-slot`)
- Are deprecated terms still used in docs?

**Configuration:**
- Do documented config options exist?
- Are version constraints accurate (gemspec, package.json)?
- Do documented commands still work?

### 3. Report format

Group findings by document. For each finding:
- State what the doc says
- State what the code actually does
- Severity: **Critical** (agents/developers would produce wrong code),
  **Medium** (inaccurate but unlikely to cause bugs), **Low** (cosmetic)

### 4. Fix issues

After the audit, fix all Critical and Medium issues directly. Note any Low
issues that aren't worth fixing.

## Tips

- Start with the most-referenced documents (README, CLAUDE.md, main guides)
  since drift there has the highest impact.
- Use Grep to verify claims — search for the actual function name, class name,
  or file path that the doc references.
- Pay special attention to code examples — they drift fastest because docs
  aren't covered by tests.
- Check if the project has a CLAUDE.md with a doc audit or finalize section
  that lists project-specific documentation locations.
