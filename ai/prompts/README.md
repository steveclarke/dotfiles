# Reusable Prompts

This directory contains reusable prompt templates for various development tasks.

## Purpose

This is the **source of truth** for all prompt templates. Prompts stored here are:
- Version controlled as regular files
- Tool-agnostic and reusable across different AI agents
- Selectively exposed to agents via symlinks

## Architecture

```
ai/prompts/                           ← Source of truth (actual files)
    └── code-review-prep.md
    └── plan.md
    └── ...

configs/cursor/.cursor/commands/      ← Symlinks to prompts (Cursor)
configs/claude/.claude/commands/      ← Symlinks to prompts (Claude)
    └── code-review-prep.md → ../../../../ai/prompts/code-review-prep.md
    └── plan.md → ../../../../ai/prompts/plan.md

~/.cursor/commands/                   ← Stow deploys Cursor symlinks here
~/.claude/commands/                   ← Stow deploys Claude symlinks here
```

## Usage

### For Cursor & Claude
Prompts symlinked in `configs/cursor/.cursor/commands/` and `configs/claude/.claude/commands/` are automatically available as commands after running stow.

### For Other Agents
Copy prompts to agent-specific directories or create symlinks as needed.

### Adding Commands

Use the `commands-link` CLI command:

```bash
# Link to both Cursor and Claude (default)
commands-link link your-prompt

# Link to Cursor only
commands-link --cursor link your-prompt

# Link to Claude only
commands-link --claude link your-prompt
```

## Available Prompts

### Development Workflow
- **plan.md** - Create detailed implementation plans for features
- **spec.md** - Generate technical specifications
- **requirements.md** - Document requirements and acceptance criteria
- **vision.md** - Define project vision and high-level goals

### Code Quality
- **code-review.md** - Conduct thorough code reviews
- **code-review-prep.md** - Prepare code for review

### Documentation & Summaries
- **monthly-invoice-summary.md** - Generate client-friendly invoice summaries from git commits
- **guided-config.md** - Interactive configuration guide

### Productivity
- **todoist-daily-review.md** - Interactive Todoist task research and triage assistant
- **toggl.md** - Toggl time tracking assistant for timesheet management
- **obsidian-vault-context.md** - Comprehensive Obsidian vault structure and interaction guide
- **browse-cursor.md** - Browse and explore Cursor features

## Benefits

- **Single source of truth**: Edit prompts here; changes reflect everywhere
- **Selective exposure**: Choose which prompts each agent sees
- **Reusability**: Same prompt can be used by multiple agents
- **Git tracking**: Prompts tracked as regular files, symlinks tracked as symlinks

## Migrated to Skills

Some prompts have been converted to Claude Agent Skills for better discoverability and automatic invocation:
- **bruno-endpoint-creation** → Now available as `bruno-endpoint-creation` skill
- **code-review** → Now available as `code-review` skill

## Related

- **[Claude Agent Skills](../skills/README.md)** - Similar architecture for Claude Agent Skills (model-invoked capabilities that extend Claude's functionality)
- Skills use the same three-layer architecture: source → staging → deployed via symlinks
