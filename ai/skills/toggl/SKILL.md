---
name: toggl
description: Manage time tracking with Toggl via CLI. Use when user asks about time tracking, timers, timesheets, logging hours, starting/stopping work, checking what's running, or viewing time entries. Triggers on "toggl", "time tracking", "timer", "timesheet", "log time", "track time", "hours worked".
---

# Toggl Time Tracking Assistant

Manage time tracking using the `toggl` CLI (Rust-based, uses Toggl API v9).

## Setup

**Installation** (if `toggl` not found):
```bash
cargo install toggl
```

**Authentication** - API token stored in 1Password:
```bash
toggl auth "$(op read 'op://Employee/Toggl/api key')"
```

## Core Commands

```bash
toggl start "Task description"  # Start a new time entry
toggl stop                      # Stop the current timer
toggl current                   # Show what's currently running
toggl list time-entry           # List recent time entries
toggl list project              # List available projects
toggl continue                  # Resume the most recent entry
toggl smart "Task"              # Smart start/stop (figures out what to do)
toggl rename "New name"         # Rename the current entry
```

For full command details and additional options, run `toggl --help` or `toggl <command> --help`.

## Workflow Patterns

**Before starting work:** Check what's running with `toggl current`

**Starting a task:** Use descriptive names that will make sense later when reviewing timesheets (e.g., "Feature 123 - API endpoints" not just "coding")

**Switching tasks:** Stop the current timer before starting a new one, or use `toggl smart` which handles this automatically

**Reviewing time:** Use `toggl list time-entry` to verify hours are logged correctly

## Tips

- The `--fzf` flag enables fuzzy selection for interactive commands
- `toggl continue` resumes your most recent entry - useful for recurring tasks
- `toggl start 3` can resume entry #3 from your recent list
