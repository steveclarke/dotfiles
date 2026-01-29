---
name: time-tracking
description: Manage time tracking with Toggl or Clockify. Use when user asks about time tracking, timers, timesheets, logging hours, starting/stopping work, checking what's running, viewing time entries, or creating manual entries. Triggers on "toggl", "clockify", "time tracking", "timer", "timesheet", "log time", "track time", "hours worked".
---

# Time Tracking

Use `scripts/track` for all time tracking operations. Supports both Toggl (default) and Clockify.

## Commands

```bash
# Real-time tracking (default: Toggl)
scripts/track start "Task description" -p "Project Name"
scripts/track stop
scripts/track current

# Use Clockify instead
scripts/track start "Task description" -p "Project Name" -P clockify
scripts/track current -P clockify

# Manual entries (past dates)
scripts/track create "Description" -p "Project" -s "YYYY-MM-DD HH:MM" -e "YYYY-MM-DD HH:MM"
scripts/track create "Description" -p "Project" -s "..." -e "..." -t "tag1,tag2"  # with tags

# Management
scripts/track delete <entry-id>
scripts/track entries --days 7
scripts/track projects
scripts/track me

# Projects and tags (Toggl only)
scripts/track project:create "Project Name"
scripts/track project:create "Project Name" -b        # billable
scripts/track project:create "Project Name" --private # private project
scripts/track tags
```

## Provider Selection

- `-P toggl` (default) - Use Toggl Track
- `-P clockify` - Use Clockify

## Notes

- Project names must match exactly - use `projects` to list available names
- Authentication via 1Password:
  - Toggl: `op://Employee/Toggl/api key`
  - Clockify: `op://Employee/Clockify/Saved on app.clockify.me/apikey`
- **Token caching**: API tokens are cached in `~/.local/state/steveos/time-tracking/` for 24 hours to avoid repeated 1Password prompts
- Run `scripts/track --help` for full usage

## Cache Management

```bash
scripts/track cache:clear      # Clear token for current provider
scripts/track cache:clear:all  # Clear all cached tokens
```

Use these if you rotate your API key in 1Password or need to re-authenticate.
