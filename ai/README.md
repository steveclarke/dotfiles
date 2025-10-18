# AI/LLM Resources

This directory contains AI and LLM-related resources for development workflows, including guides and prompts.

## Directory Structure

- **[guides/](guides/)** - Development process documentation and guides
- **[prompts/](prompts/)** - Reusable prompt templates for various tasks
- **[skills/](skills/)** - ⚠️ Claude Agent Skills (experimental/WIP)

## Prompts and Agent Integration

**All prompts are stored in `ai/prompts/` as the source of truth.** Agent-specific configurations (like Cursor commands) use symlinks to selectively expose prompts to different agents.

For detailed information on the symlink architecture and how to integrate prompts with agents like Cursor, see **[ai/prompts/README.md](prompts/README.md)**.

This `ai/` directory also contains:
- Process guides that agents reference (like feature-development-process.md)
- Notes and learnings about working with AI tools
- **Experimental:** Claude Agent Skills (brand new feature from Oct 2025, currently WIP)

## Quick Start

1. **Using Guides**: Check `guides/` for process documentation
2. **Using Prompts**: Browse `prompts/` for reusable templates
3. **Using Skills**: See `skills/README.md` for info on Claude Agent Skills (experimental)

## Contributing

When adding new resources:
- Guides go in `guides/` - process documentation
- Prompts go in `prompts/` - reusable templates
- Skills go in `skills/` - Claude Agent Skills (see skills/README.md for format)
- Keep content generic and shareable (no project-specific details)

