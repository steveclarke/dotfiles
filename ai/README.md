# AI Resources

Shared resources for AI coding tools. One place to manage prompts, skills, and agents that work across Cursor, Claude Code, and OpenCode.

## Why Use This?

Most AI tools store settings in their own folders. This creates a problem: you end up copying the same prompts and skills between tools.

This setup fixes that. You write a skill once, and all your AI tools can use it.

## What's Inside

| Folder | What It Does |
|--------|--------------|
| `agents/` | Agent settings (model, tools, behavior) |
| `commands/` | Prompt templates you can reuse |
| `guides/` | Process docs and how-to guides |
| `skills/` | Skills that teach agents new tasks |

## How It Works

All AI tools share the same files through symlinks:

```
ai/
├── agents/       ← Agent settings
├── commands/     ← Prompt templates
├── guides/       ← Process docs
└── skills/       ← Agent skills

~/.cursor/
├── commands → ai/commands
└── skills → ai/skills

~/.claude/
├── agents → ai/agents
├── commands → ai/commands
└── skills → ai/skills

~/.config/opencode/
├── agent → ai/agents
├── command → ai/commands
└── skill → ai/skills
```

After you run `stow`, all tools see the same files.

## Quick Start

### Add a Command

Create a markdown file in `ai/commands/`:

```bash
touch ai/commands/my-prompt.md
```

All tools can now use this prompt template.

### Add a Skill

Create a folder with a `SKILL.md` file in `ai/skills/`:

```bash
mkdir ai/skills/my-skill
touch ai/skills/my-skill/SKILL.md
```

See `ai/skills/README.md` for the full skill format.

### Add an Agent

Create a markdown file in `ai/agents/`:

```bash
touch ai/agents/my-agent.md
```

### Deploy Changes

Run stow to create the symlinks:

```bash
dotfiles stow
# or
bash configs/stow.sh
```

## Directory Guide

| Path | Purpose |
|------|---------|
| `ai/commands/*.md` | Prompt templates. Markdown files with reusable prompts. |
| `ai/skills/*/SKILL.md` | Agent skills. Folders with instructions agents can learn. |
| `ai/agents/*.md` | Agent configs. Model and tool settings. |
| `ai/guides/*.md` | Process docs. Workflows and best practices. |

## Adding New Resources

> [!TIP]
> Keep content generic. Don't add project-specific details that won't work elsewhere.

**Commands**: Add prompt templates to `commands/`. Use them for tasks you repeat often.

**Skills**: Add skill folders to `skills/`. Each skill needs a `SKILL.md` file with YAML frontmatter. Skills can include scripts and reference docs.

**Agents**: Add agent definitions to `agents/`. These control which model and tools an agent uses.

**Guides**: Add process docs to `guides/`. These are for human readers, not agents.

## Supported Tools

| Tool | Commands | Skills | Agents |
|------|----------|--------|--------|
| Cursor | Yes | Yes | No |
| Claude Code | Yes | Yes | Yes |
| OpenCode | Yes | Yes | Yes |
