---
name: gog-cli
description: Interact with Google Workspace services via command line using gog-cli. Use when user wants to work with Gmail (search, send, labels, filters), Calendar (events, scheduling, availability), Drive (upload, download, share), Sheets (read, write, format), Docs/Slides (create, export), Contacts, Tasks, Chat, or Classroom. Triggers on "Google", "Gmail", "Calendar", "Drive", "Sheets", "Docs", "Slides", "Contacts", "Tasks", "Google Chat", "Classroom", or any gog command.
---

# gog-cli - Google Workspace CLI

Command-line tool for interacting with Google Workspace services.

## Service References

Load only the reference file for the service you need:

- **Email operations** - See [references/gmail.md](references/gmail.md)
- **Calendar & scheduling** - See [references/calendar.md](references/calendar.md)
- **File storage** - See [references/drive.md](references/drive.md)
- **Spreadsheets** - See [references/sheets.md](references/sheets.md)
- **Documents & presentations** - See [references/docs-slides.md](references/docs-slides.md)
- **Contact management** - See [references/contacts.md](references/contacts.md)
- **Task lists** - See [references/tasks.md](references/tasks.md)
- **Team messaging** - See [references/chat.md](references/chat.md)
- **Education/courses** - See [references/classroom.md](references/classroom.md)

## Global Options

Apply to any command:

| Option | Description |
|--------|-------------|
| `--account <email\|alias>` | Specify account to use |
| `--json` | Machine-readable JSON output |
| `--plain` | Tab-separated plaintext |
| `--force` | Skip confirmation prompts |
| `--no-input` | Fail rather than prompt (CI-friendly) |
| `--verbose` | Show API requests/responses |

## Quick Examples

```bash
# Gmail: search recent emails
gog gmail search 'newer_than:7d' --max 10

# Calendar: today's events
gog calendar events primary --today

# Drive: list files
gog drive ls --max 20

# Sheets: read cells
gog sheets get <spreadsheetId> 'Sheet1!A1:B10'

# Tasks: list task lists
gog tasks lists
```

## Utility Commands

```bash
# Current time
gog time now
gog time now --timezone America/New_York

# Auth status
gog auth list --check
gog auth status
```

## Tips

- Use `--json` for scripting and piping to jq
- Most IDs can be found in Google URLs (e.g., spreadsheet ID in sheets URL)
- Gmail search uses Google's search syntax (from:, to:, subject:, newer_than:, etc.)
- Calendar accepts "primary" as calendarId for main calendar
