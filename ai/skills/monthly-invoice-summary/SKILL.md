---
name: monthly-invoice-summary
description: "Generate client-friendly monthly invoice summaries from Git commits and timesheet notes. Use when preparing monthly billing or project status reports."
disable-model-invocation: true
---

# Monthly Invoice Summary

## Purpose

Combine technical Git commits with time sheet notes (meetings, planning, etc.)
into concise, value-focused descriptions a client can understand. The job is
translation between technical work and business communication.

## Required Information

1. **Project name** — e.g. "Acme Project" or "Client Portal App"
2. **Time period** — e.g. "August 2025", "Q3 2025"
3. **Previous month's summary** (optional) — keeps wording consistent and carries recurring items forward
4. **Time sheet notes** (optional) — work beyond Git commits: meetings, planning, discussions
5. **Git repository location** — or confirm the current directory

Ask for whatever is missing. If it all arrives upfront, go straight to Step 2.

## Examples

- `/monthly-invoice-summary for Acme Project, August 2025`
- `/monthly-invoice-summary I need to bill the client for last month`
- `/monthly-invoice-summary` (will ask for required information)

## Step 1: Gather Information

Collect the items listed above.

## Step 2: Collect Git Commit Data

Run `git log` for the timeframe: `git log --since="2025-08-01" --until="2025-08-31"`.
Include commit messages and dates; note the author if multiple developers.

Analyze commit patterns to identify feature development, bug fixes, dependency
updates, documentation changes, testing improvements, and configuration changes.

## Step 3: Review Additional Context

Review time sheet notes for work not captured in commits — client meetings and
status calls, planning and design sessions, code reviews and pair programming,
research and investigation, email correspondence.

Reference the previous month's summary to identify recurring items, match
formatting and tone, and note ongoing multi-month work.

## Step 4: Synthesize

Group related work into logical categories. Common ones:

- **Status meetings & project management** — standard recurring monthly item
- **Version releases** — highlight key improvements in each release
- **Infrastructure/dependency updates** — group together, keep technical details minimal
- **Major feature work** — business value and user-facing improvements
- **Bug fixes** — only if significant; group minor fixes together
- **Security improvements**
- **Performance optimizations** — business impact (faster page loads, etc.)
- **Documentation updates** — user guides, API docs, setup instructions
- **Planning and design work** — discovery, research, architectural planning

Merge related commits into single bullets. Twenty dependency commits become
"Updated project dependencies and security patches"; five bug fixes become
"Resolved reporting issues and fixed edge cases in user notifications". Aim for
5–10 bullets total.

## Step 5: Present

Output as a fenced code block so the plain text can be copied without markdown
rendering:

```
Project Notes:
Acme Client Portal - August 2025:
- Status meetings & project management
- Released version 2.3 with improved dashboard performance and new reporting features
- Resolved authentication issues and fixed edge cases in notification delivery
- Updated security patches and project dependencies
- Documented API endpoints for third-party integrations
```

## Writing Style

- **Direct and action-oriented** — avoid "comprehensive", "enhanced", "robust"
- **Business-focused** — outcomes and value, not technical implementation
- **Minimal jargon** — clients don't need to know about dependencies
- **Sentence case** — capitalize only the first word and proper nouns

❌ "Implemented comprehensive error handling system" → ✅ "Added error recovery for payment processing"
❌ "Enhanced database performance" → ✅ "Improved report generation speed"
❌ "Refactored legacy code" → ✅ "Modernized user authentication system"
❌ "Updated various dependencies" → ✅ "Updated security patches and project dependencies"
