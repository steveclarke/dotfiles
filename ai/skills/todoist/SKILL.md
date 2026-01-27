---
name: todoist
description: Interact with Todoist via MCP. Use when adding tasks, listing tasks, marking complete, or managing projects.
---

# Todoist MCP Integration

## Setup

There are two ways to configure the Todoist MCP server. The **NPX version with API token** is recommended for daily use.

### Option 1: NPX with API Token (Recommended)

This version uses a Todoist API token and doesn't require re-authentication. Best for regular use.

**1. Get your API token:**
- Go to [Todoist Settings → Integrations → Developer](https://app.todoist.com/app/settings/integrations/developer)
- Copy your API token (or generate a new one)

**2. Add to `~/.claude.json` at the top level:**

```json
{
  "mcpServers": {
    "todoist": {
      "command": "npx",
      "args": ["-y", "@doist/todoist-ai"],
      "env": {
        "TODOIST_API_KEY": "your-api-token-here"
      }
    }
  }
}
```

**Important:** The environment variable must be `TODOIST_API_KEY` (not `TODOIST_API_TOKEN`).

**3. Restart Claude Code** to pick up the new configuration.

### Option 2: HTTP with OAuth (Alternative)

This version uses OAuth and requires periodic re-authentication (session expires after ~1 hour). Useful if you don't want to store a token.

```bash
claude mcp add --transport http todoist https://ai.todoist.net/mcp
```

In Claude Code, run `/mcp` to open the MCP panel. Click on Todoist and complete the OAuth flow.

**Note:** The OAuth session times out frequently. If you get connection errors, re-authenticate via `/mcp`.

---

## Troubleshooting

**MCP shows "failed" or won't connect:**
1. Verify the env variable is `TODOIST_API_KEY` (not `TODOIST_API_TOKEN`)
2. Regenerate your API token at [Todoist Developer Settings](https://app.todoist.com/app/settings/integrations/developer) — old tokens may have expired
3. Restart Claude Code after config changes
4. Test with `mcp__todoist__user-info` to verify connection

---

## Available MCP Tools

All tools are prefixed with `mcp__todoist__`:

| Tool | Purpose |
|------|---------|
| `find-tasks` | Search tasks by text, project, section, labels, or assignee |
| `find-tasks-by-date` | Get tasks for a date range (use `startDate: "today"` for today + overdue) |
| `add-tasks` | Create one or more tasks with full options |
| `update-tasks` | Modify existing tasks (move, dates, priority, descriptions, assignments) |
| `complete-tasks` | Mark tasks as done |
| `find-projects` | List or search projects |
| `find-sections` | List sections within a project |
| `get-overview` | Markdown overview of all projects or a specific project |
| `add-projects` | Create new projects |
| `add-sections` | Create sections in projects |
| `add-comments` | Add comments to tasks or projects |
| `find-comments` | Get comments on tasks or projects |
| `search` | Full-text search across tasks and projects |
| `user-info` | Get user details, timezone, goals |

---

## Task Creation Best Practices

When creating tasks from verbal descriptions:

1. **Extract a clean, actionable title** — don't dump raw text verbatim
2. **Capture context in the description** — the "why", rationale, acceptance criteria
3. **Don't lose information** — everything said should be captured (title or description)
4. **Use imperative form** — "Contact Wade" not "Contacting Wade"

### MCP Task Options

```
content: "Task title" (required)
description: "Additional details"
dueString: "tomorrow at 5pm" (natural language)
priority: "p1" | "p2" | "p3" | "p4" (p1 = highest)
projectId: "<project-id>" or "inbox"
sectionId: "<section-id>"
labels: ["label1", "label2"]
duration: "2h" | "90m" | "2h30m"
responsibleUser: "<name>" (for shared projects)
```

---

## Common Operations

### List Today's Tasks
`find-tasks-by-date` with `startDate: "today"` — includes overdue items.

### List Tasks in a Project
`find-tasks` with `projectId`. Use `"inbox"` for inbox, or get project IDs from `find-projects`.

### Move a Task
`update-tasks` with `projectId` set to target project ID.

### Assign a Task (Shared Projects)
`update-tasks` with `responsibleUser`. Note: Can't assign while task is in Inbox — move first, then assign.

### Quick Overview
`get-overview` without parameters for all projects. Add `projectId` for specific project with tasks.

---

## Migration Notes

The previous CLI tool (`todoist` command via Homebrew) had reliability issues — moves didn't work and sync was unreliable. The official MCP server from Doist is the recommended approach.

If you still have the CLI installed:
```bash
brew uninstall todoist
```
