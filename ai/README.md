# AI Resources

Shared resources for AI coding tools. Custom skills, agents, and guides maintained in this dotfiles repo.

## What's Inside

| Folder | What It Does |
|--------|--------------|
| `agents/` | Agent definitions (model, tools, behavior) |
| `guides/` | Process docs and how-to guides |
| `skills/` | Custom skills authored in this repo |
| `skills-archive/` | Retired skills kept for reference |

## How Skills Are Installed

Outport installs and updates every skill. Steve's Skills page lists each source:
this repo's `ai/skills` folder, his own repos (kiso, ucmix, outport and others)
and outside authors (pbakaus/impeccable, antfu/skills and others). Team skills
come from `myunio/skills`.

At the start of each Claude Code or Codex session, `out skills sync` installs
the latest pushed version of every source into `~/.agents/skills/`.
`~/.claude/skills` is a link to that folder.

| Task | Command |
|------|---------|
| Set up a machine (once) | `out login`, then `out skills setup` |
| See what is installed | `out skills status` |
| List personal sources | `out skills github list` |
| Add a source | `out skills github add <owner>/<repo>[/<path>]` |

## Quick Start

### Add a Custom Skill

Create a folder with a `SKILL.md` file in `ai/skills/`:

```bash
mkdir ai/skills/my-skill
touch ai/skills/my-skill/SKILL.md
```

See `ai/skills/README.md` for the full skill format.

Then commit and push; the next agent session installs it.

### Add an Agent

Create a markdown file in `ai/agents/`:

```bash
touch ai/agents/my-agent.md
```

## Directory Guide

| Path | Purpose |
|------|---------|
| `ai/skills/*/SKILL.md` | Custom skills. Folders with instructions agents can learn. |
| `ai/agents/*.md` | Agent configs. Model and tool settings. |
| `ai/guides/*.md` | Process docs. Workflows and best practices. |
