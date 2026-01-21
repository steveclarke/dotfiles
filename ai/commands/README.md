# Commands

Prompt templates you can reuse across AI tools. Write a command once, use it in Cursor, Claude Code, and OpenCode.

> [!NOTE]
> For setup and architecture, see the [AI README](../README.md).

## Adding a Command

Create a markdown file in this folder:

```bash
vi ai/commands/my-command.md
```

The command works right away in all tools.

## Using Commands

Type the command name with a slash:

| Tool | How to Use |
|------|------------|
| Cursor | `/my-command` in chat |
| Claude Code | `/my-command` in chat |
| OpenCode | `/my-command` in chat |

## Available Commands

### Planning & Design

| Command | What It Does |
|---------|--------------|
| `plan.md` | Create implementation plans |
| `spec.md` | Write technical specs |
| `requirements.md` | Document requirements |
| `vision.md` | Define project goals |
| `implement-plan.md` | Execute plans step by step |

### Code Quality

| Command | What It Does |
|---------|--------------|
| `code-review.md` | Run code reviews |
| `code-review-prep.md` | Prep code for review |

### Documentation

| Command | What It Does |
|---------|--------------|
| `monthly-invoice-summary.md` | Summarize git commits for invoices |
| `handbook-writing.md` | Write docs and handbooks |
| `cheat-sheet-guide.md` | Make quick reference guides |

### Productivity

| Command | What It Does |
|---------|--------------|
| `todoist-daily-review.md` | Review and research Todoist tasks |
| `obsidian-vault-context.md` | Work with Obsidian vaults |

### Dev Tools

| Command | What It Does |
|---------|--------------|
| `bruno-endpoint-creation.md` | Create Bruno API endpoints |
| `write-bash-script.md` | Write bash scripts |
| `guided-config.md` | Interactive config helper |
| `create-command.md` | Create new commands |
