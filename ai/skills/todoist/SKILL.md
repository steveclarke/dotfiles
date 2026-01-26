---
name: todoist
description: Interact with Todoist via MCP. Use when adding tasks, listing tasks, marking complete, or doing daily task review/triage.
---

# Todoist MCP Integration

## Setup

The official Todoist MCP server from Doist provides reliable, full-featured access to Todoist.

### 1. Add the MCP Server

```bash
claude mcp add --transport http todoist https://ai.todoist.net/mcp
```

### 2. Authenticate

In Claude Code, run `/mcp` to open the MCP panel. Click on Todoist and complete the OAuth flow to authenticate your account.

That's it. The MCP tools are now available.

---

## Available MCP Tools

All tools are prefixed with `mcp__todoist__`:

| Tool | Purpose |
|------|---------|
| `find-tasks` | Search tasks by text, project, section, labels, or assignee |
| `find-tasks-by-date` | Get tasks for a date range (use `startDate: "today"` for today + overdue) |
| `add-tasks` | Create one or more tasks with full options |
| `update-tasks` | Modify existing tasks (dates, priority, labels, etc.) |
| `complete-tasks` | Mark tasks as done |
| `find-projects` | List or search projects |
| `find-sections` | List sections within a project |
| `get-overview` | Get a markdown overview of all projects or a specific project |
| `add-projects` | Create new projects |
| `add-sections` | Create sections in projects |
| `add-comments` | Add comments to tasks or projects |
| `find-comments` | Get comments on tasks or projects |
| `search` | Full-text search across tasks and projects |
| `user-info` | Get user details, timezone, goals |

---

## Task Creation Best Practices

When creating tasks from the user's verbal descriptions:

1. **Extract a clean, actionable title** — don't dump raw text verbatim
2. **Capture context in the description** — the "why", rationale, acceptance criteria
3. **Don't lose information** — everything the user says should be captured (title or description)

Example:
- User says: "Configure staging so we can CC emails for preview, so developers and clients can review what gets sent"
- **Title:** "Add email CC option to staging paperless emails"
- **Description:** "Allow CCing multiple email addresses so developers and clients can preview what emails get generated and review the content."

### MCP Task Options

When using `add-tasks`:

```
content: "Task title" (required)
description: "Additional details"
dueString: "tomorrow at 5pm" (natural language)
priority: "p1" | "p2" | "p3" | "p4" (p1 = highest)
projectId: "<project-id>" or "inbox"
sectionId: "<section-id>"
labels: ["label1", "label2"]
duration: "2h" | "90m" | "2h30m"
```

---

## Common Operations

### List Today's Tasks

Use `find-tasks-by-date` with `startDate: "today"` — this includes overdue items by default.

### List Tasks in a Project

Use `find-tasks` with `projectId` parameter. Get project IDs from `find-projects` or `get-overview`.

### Quick Overview

Use `get-overview` without parameters to see all projects with their sections. Add `projectId` to see tasks within a specific project.

### Search Tasks

Use `search` for full-text search, or `find-tasks` with `searchText` for filtered searching.

---

## Triage Workflow

For processing investigation items (articles, tools, repos) dumped into Todoist from mobile.

**Run from hugo repo** (`~/src/hugo`) to access the bookmark skill.

### Process

1. **Get inbox tasks**: Use `find-tasks` with `projectId: "inbox"`
2. **Pick one** — usually a URL or "check out X"
3. **Research** — if it's a URL, fetch it; otherwise web search
4. **Decide:**
   - Worth keeping as reference -> save with bookmark skill (see below)
   - Not useful -> just close
   - Action item -> leave in Todoist or move to appropriate project
5. **Complete**: Use `complete-tasks` with the task ID
6. **Repeat**

### Saving to Knowledge Base

Use the bookmark skill in hugo repo:

```bash
# Quick capture (metadata only)
node .claude/skills/bookmark/scripts/bookmark-add.mjs "<url>" --tags "tag1,tag2"

# Full extraction (includes readable content)
node .claude/skills/bookmark/scripts/bookmark-add.mjs "<url>" --tags "tag1,tag2" --scrape
```

Or just say "bookmark this" and provide the URL — Hugo will handle it.

### Principles

- One task at a time
- Confirm before completing
- Confirm before saving
- Don't batch — stay interactive

---

## Migration Notes

The previous CLI tool (`todoist` command via Homebrew) had reliability issues — moves didn't work and sync was unreliable. The official MCP server from Doist is the recommended approach.

If you still have the CLI installed:
```bash
brew uninstall todoist
```
