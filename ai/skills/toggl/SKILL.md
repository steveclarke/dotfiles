---
name: toggl
description: Manage time tracking with Toggl. Use when user asks about time tracking, timers, timesheets, logging hours, starting/stopping work, checking what's running, viewing time entries, or creating manual entries. Triggers on "toggl", "time tracking", "timer", "timesheet", "log time", "track time", "hours worked".
---

# Toggl Time Tracking

Use `scripts/toggl-api` for all Toggl operations.

## Commands

```bash
# Real-time tracking
scripts/toggl-api start "Task description" -p "Project Name"
scripts/toggl-api stop
scripts/toggl-api current

# Manual entries (past dates)
scripts/toggl-api create "Description" -p "Project" -s "YYYY-MM-DD HH:MM" -e "YYYY-MM-DD HH:MM"

# Management
scripts/toggl-api delete <entry-id>
scripts/toggl-api entries --days 7
scripts/toggl-api projects
scripts/toggl-api me
```

## Notes

- Project names must match exactly - use `projects` to list available names
- Authentication via 1Password: `op://Employee/Toggl/api key`
- Run `scripts/toggl-api --help` for full usage
