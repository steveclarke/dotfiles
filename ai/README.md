# AI/LLM Resources

This directory contains AI and LLM-related resources for development workflows, shared across Cursor, Claude Code, and OpenCode.

## Directory Structure

- **[agents/](agents/)** - Agent definitions (Claude Code, OpenCode)
- **[commands/](commands/)** - Reusable command/prompt templates
- **[guides/](guides/)** - Development process documentation and guides
- **[skills/](skills/)** - Agent skills for extending capabilities

## Architecture

All AI tools (Cursor, Claude Code, OpenCode) share the same resources via directory symlinks:

```
ai/
├── agents/       ← Agent definitions
├── commands/     ← Command/prompt templates  
├── guides/       ← Process documentation
└── skills/       ← Agent skills

configs/cursor/.cursor/
├── commands → ../../../../ai/commands
└── skills → ../../../../ai/skills

configs/claude/.claude/
├── agents → ../../../../ai/agents
├── commands → ../../../../ai/commands
└── skills → ../../../../ai/skills

configs/opencode/.config/opencode/
├── agent → ../../../../ai/agents
├── command → ../../../../ai/commands
└── skill → ../../../../ai/skills
```

After running `stow`, these are deployed to `~/.cursor/`, `~/.claude/`, and `~/.config/opencode/`.

## Quick Start

1. **Add a command**: Create a markdown file in `ai/commands/` - automatically available to all tools
2. **Add a skill**: Create a skill directory in `ai/skills/` - available to Claude and OpenCode
3. **Add an agent**: Create a markdown file in `ai/agents/` - available to Claude and OpenCode
4. **Deploy changes**: Run `bash configs/stow.sh` or `dotfiles stow`

## Contributing

When adding new resources:
- Commands go in `commands/` - reusable prompt templates
- Skills go in `skills/` - agent skills (see skills/README.md for format)
- Agents go in `agents/` - agent definitions with model/tool configs
- Guides go in `guides/` - process documentation
- Keep content generic and shareable (no project-specific details)

