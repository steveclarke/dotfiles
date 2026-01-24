---
name: todoist
description: Interact with Todoist via CLI. Use when adding tasks, listing tasks, marking complete, or doing daily task review/triage.
---

# Todoist CLI

## Installation

```bash
# Stable (when v0.24.0+ released)
brew install todoist

# HEAD build (includes shared labels fix from PR #273)
brew install --HEAD todoist
```

## Command Syntax

**Important:** Flags must come BEFORE the task content.

```bash
# Add task (correct)
todoist add --date "2026-01-31" --priority 2 "Task description here"

# Add task (WRONG - will fail)
todoist add "Task description" --date "2026-01-31"

# Quick add with natural language date
todoist quick "Buy milk tomorrow"

# List tasks
todoist list
todoist list --filter "today"
todoist list --filter "#ProjectName"
todoist list --filter "overdue"

# Modify existing task (e.g., set date)
todoist modify <task-id> --date "2026-01-31"

# Complete task
todoist close <task-id>

# Sync with server
todoist sync

# List projects
todoist projects
```

## Add Command Options

```bash
todoist add [options] "Task content"
  --date, -d       Due date ("today", "tomorrow", "2026-01-31", "next monday")
  --priority, -p   Priority 1-4 (1=highest, 4=lowest/default)
  --project-name, -N  Project name
  --label-names, -L   Labels (comma-separated)
```

## Filter Syntax

Based on [Todoist filter syntax](https://todoist.com/help/articles/introduction-to-filters):

```bash
todoist list --filter "today"
todoist list --filter "#Inbox"
todoist list --filter "#Inbox | #Work"      # OR
todoist list --filter "#Inbox & p1"         # AND
todoist list --filter "7 days"
todoist list --filter "overdue"
```

## Config & Cache

- Config: `~/.config/todoist/config.json`
- Cache: `~/.cache/todoist/cache.json`

To reset: delete both files and run `todoist sync` (will prompt for token).

---

## Triage Workflow

For processing investigation items (articles, tools, repos) dumped into Todoist from mobile.

**Run from hugo repo** (`~/src/hugo`) to access the bookmark skill.

### Process

1. **List tasks**: `todoist list --filter "#Inbox"` or `todoist list`
2. **Pick one** — usually a URL or "check out X"
3. **Research** — if it's a URL, fetch it; otherwise web search
4. **Decide:**
   - Worth keeping → save with bookmark skill (see below)
   - Not useful → just close
   - Action item → leave in Todoist or move to appropriate project
5. **Complete**: `todoist close <task-id>`
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
