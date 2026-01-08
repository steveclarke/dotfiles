# Reusable Commands

This directory contains reusable command/prompt templates for AI agents.

## Purpose

This is the **source of truth** for all command templates. Commands stored here are:
- Version controlled as regular files
- Tool-agnostic and reusable across Cursor, Claude Code, and OpenCode
- Automatically available to all agents via directory symlinks

## Architecture

```
ai/commands/                              ← Source of truth (actual files)
    └── code-review.md
    └── plan.md
    └── ...

configs/cursor/.cursor/commands           ← Symlink to ai/commands
configs/claude/.claude/commands           ← Symlink to ai/commands
configs/opencode/.config/opencode/command ← Symlink to ai/commands

~/.cursor/commands/                       ← Stow deploys here
~/.claude/commands/                       ← Stow deploys here
~/.config/opencode/command/               ← Stow deploys here
```

## Usage

### Adding a New Command

Simply create a markdown file in this directory:

```bash
# Create a new command
vi ai/commands/my-new-command.md

# Deploy (if not already stowed)
dotfiles stow
```

The command is immediately available to all AI tools.

### Using Commands

| Tool | Invocation |
|------|------------|
| **Cursor** | `/my-new-command` in chat |
| **Claude Code** | `/my-new-command` in chat |
| **OpenCode** | `/my-new-command` in chat |

## Available Commands

### Development Workflow
- **plan.md** - Create detailed implementation plans for features
- **spec.md** - Generate technical specifications
- **requirements.md** - Document requirements and acceptance criteria
- **vision.md** - Define project vision and high-level goals
- **implement-plan.md** - Execute implementation plans step by step

### Code Quality
- **code-review.md** - Conduct thorough code reviews
- **code-review-prep.md** - Prepare code for review

### Documentation & Summaries
- **monthly-invoice-summary.md** - Generate client-friendly invoice summaries from git commits
- **handbook-writing.md** - Create documentation and handbooks
- **cheat-sheet-guide.md** - Generate quick reference guides

### Productivity
- **todoist-daily-review.md** - Interactive Todoist task research and triage
- **toggl.md** - Toggl time tracking assistant
- **obsidian-vault-context.md** - Obsidian vault structure and interaction guide

### Development Tools
- **bruno-endpoint-creation.md** - Create Bruno API endpoints
- **write-bash-script.md** - Write bash scripts following best practices
- **guided-config.md** - Interactive configuration guide
- **create-command.md** - Create new AI commands

## Benefits

- **Single source of truth**: Edit commands here; changes reflect everywhere
- **Zero configuration**: All commands automatically available to all tools
- **Consistent experience**: Same commands work across Cursor, Claude, and OpenCode
- **Git tracking**: All commands version controlled as regular files

## Related

- **[Skills](../skills/README.md)** - Agent skills for extending AI capabilities
- **[Agents](../agents/README.md)** - Agent definitions with model/tool configurations
