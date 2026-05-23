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

Skills are synced globally via `bin/skills-install`, which uses
[`npx skills`](https://github.com/vercel-labs/skills) to install or refresh from
multiple sources into `~/.agents/skills/` and symlink to each agent's skill
directory. Run the same command on fresh and existing machines; it is
idempotent and also prunes known deprecated skills.

```
bin/skills-install
├── My custom skills    ← from this repo (ai/skills/)
├── My own-repo skills  ← from steveclarke/kiso, outport, etc.
└── External skills     ← from pbakaus/impeccable, antfu/skills, etc.
```

Each agent gets individual per-skill symlinks:

```
~/.agents/skills/
├── 1password/        ← installed skill
├── adapt/
└── ...

~/.claude/skills/
├── 1password → ../../.agents/skills/1password
├── adapt → ../../.agents/skills/adapt
└── ...
```

### Commands

| Task | Command |
|------|---------|
| Sync all skills | `skills-install` |
| List without installing | `skills-install --list` |

See `bin/skills-install` for the full list of sources and `ai/SKILLS-AUDIT.md`
for the classification of each skill.

## Quick Start

### Add a Custom Skill

Create a folder with a `SKILL.md` file in `ai/skills/`:

```bash
mkdir ai/skills/my-skill
touch ai/skills/my-skill/SKILL.md
```

See `ai/skills/README.md` for the full skill format.

Then run `skills-install` to deploy it globally.

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
| `bin/skills-install` | Syncs all skills from configured sources. |
| `ai/SKILLS-AUDIT.md` | Classification of all skills by source. |
