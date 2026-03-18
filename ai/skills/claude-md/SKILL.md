---
name: claude-md
description: >-
  Use when creating, editing, auditing, trimming, or optimizing any CLAUDE.md
  file. Also triggers on 'init claude.md', 'update claude.md', 'audit my
  claude config', 'what should be in CLAUDE.md', or any task involving
  CLAUDE.md content.
---

# CLAUDE.md Authoring

## The Core Rule

Apply this litmus test to every line: **"Would removing this cause Claude to make mistakes?"**

If Claude can infer it from code, README, or standard conventions — cut it. CLAUDE.md is expensive context loaded every session. Treat every line as costing money.

## What Belongs in CLAUDE.md

Only include what Claude would get wrong without explicit instruction:

- **Build/test/lint commands** Claude can't guess (`make test-integration`, custom scripts)
- **Code style rules that differ** from language defaults or formatter configs
- **Non-obvious gotchas** and footguns specific to this codebase
- **Testing instructions** — preferred runners, required setup, test DB conventions
- **Repo etiquette** — branch naming, PR conventions, commit message format
- **Architectural decisions** not self-evident from code structure
- **Dev environment quirks** — required env vars, version pinning, local setup traps
- **Pointers to docs** (`@path/to/file`), not copies of docs

## What Does NOT Belong

Stop adding these — they waste context every session:

- **Project overviews / elevator pitches** — that's the README
- **Directory trees / file descriptions** — Claude can read the filesystem
- **Standard language conventions** — Claude already knows them
- **Code snippets** — they go stale; use `@file:line` references instead
- **API documentation** — link to it, don't paste it
- **Generic best practices** — "write clean code" teaches nothing
- **Anything already in README or docs** — don't duplicate committed files
- **Frequently changing information** — it will drift and mislead

## Structural Rules

- **Target under 300 lines.** Well under is better. Audit anything approaching 300.
- **Use routing** — `@path/to/detailed-doc.md` for anything longer than a few lines.
- **Anchor critical rules at top and bottom** — primacy and recency bias means the middle gets lost.
- **Prefer positive instructions** — "Use named exports" over "Don't use default exports."
- **Use hooks for hard rules** — if a rule must never be broken, enforce it with a pre-commit hook, not prose.

## Creating a New CLAUDE.md

1. Read the existing README, docs, and codebase structure first.
2. Identify only what Claude would trip on — not what it can infer.
3. Check for parent/sibling CLAUDE.md files to avoid duplication.
4. Write a lean file, then self-audit against these rules before presenting.
5. For subdirectory CLAUDE.md files: scope tightly to that directory's concerns.

**Output:** Present the draft with a line count. Let the user review before writing.

## Editing an Existing CLAUDE.md

1. Read the current file.
2. Apply these rules to the changes — don't add bloat.
3. Verify new content passes the litmus test.
4. Flag if the file exceeds 300 lines with suggestions to cut or route.

**Output:** Make the edit. Flag if over 300 lines.

## Auditing an Existing CLAUDE.md

1. Read the file alongside the README and docs it might duplicate.
2. Apply the litmus test line by line.
3. Report verdicts: **keep** / **cut** / **extract to separate file** (with reasoning).
4. Suggest routing patterns for content that belongs but is too detailed.
5. Check line count.

**Output:** Structured report with verdicts, current and projected line counts. Ask which changes to apply.

## Assistant Config Detection

If the CLAUDE.md defines a persona or role ("You are...", personality, coaching instructions, communication style), it is an **assistant config file** — a different use case entirely. Flag this: "This looks like an AI assistant config, not a project conventions file. The standard CLAUDE.md rules don't apply here." Do not silently skip this check.

## Out of Scope

- **Not a linter** — this skill guides your thinking, it does not auto-fix files.
- **Not a template** — enforce principles, not rigid structure. CLAUDE.md format is intentionally flexible.
- **Does not modify non-CLAUDE.md files** — if content should move to a README or docs file, recommend the move but don't make it.

## Edge Cases

- **File doesn't exist + user says "audit":** Tell them. Offer to create one.
- **Multiple CLAUDE.md files:** Operate on the most contextually relevant one. Ask if ambiguous. When auditing, offer to audit all.
- **User explicitly wants an anti-pattern:** Comply, but note it's typically README content that consumes context every session. User instructions always win.
- **Monorepo:** Check parent CLAUDE.md files to avoid duplicating inherited instructions.

## Reference

- [Best Practices](https://code.claude.com/docs/en/best-practices) — official include/exclude table
- [CLAUDE.md docs](https://code.claude.com/docs/en/memory) — how CLAUDE.md files work
