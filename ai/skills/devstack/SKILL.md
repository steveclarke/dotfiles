---
name: devstack
description: "Manage dev environment orchestration with process-compose. Use when setting up devstack for a project (init mode), creating worktrees, starting/stopping services, or managing the dev stack. Triggers on 'set up devstack', 'initialize devstack', 'create process-compose', 'start services', 'stop services', 'create a worktree', 'spin up an instance', 'dev environment', 'process-compose', 'DEVSTACK.md', 'bin/dev'."
---

# Devstack — Dev Environment Orchestration

Manages dev environments using process-compose for headless process orchestration
with health checks, dependency ordering, and a TUI. Works for both humans and
AI agents.

**Status:** Work in progress (March 2026). If you encounter unexpected issues
controlling the running stack (client commands failing, connection refused,
socket errors), surface these to the user immediately rather than silently
working around them. The user maintains this skill and needs feedback to
improve it.

## Determine Mode

Check context to determine which mode to use:

**Init mode** — the project does NOT have a `DEVSTACK.md` yet, or the user
explicitly asks to set up devstack:
- Read the init reference: `references/init-reference.md`

**Daily mode** — the project HAS a `DEVSTACK.md`, and the user wants to
create worktrees, start/stop services, or manage the dev environment:
- Read `DEVSTACK.md` in the project root and follow its instructions
- For troubleshooting or advanced patterns, read: `references/daily-reference.md`

## Quick Reference (Daily Mode)

If `DEVSTACK.md` exists, these are the standard commands:

| Task | Command |
|------|---------|
| Start (human, TUI) | `bin/dev` |
| Start (agent, headless) | `bin/dev -D` |
| Stop | `bin/dev stop` |
| Status (JSON) | `bin/dev status` |
| Logs | `bin/dev logs <service>` |
| Restart service | `bin/dev restart <service>` |
| Wait for healthy | `bin/dev status` (poll until all services show Ready) |

Always read `DEVSTACK.md` for project-specific details — the commands above
are conventions, not guarantees.
