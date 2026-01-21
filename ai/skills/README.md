# Agent Skills

Skills teach AI agents how to do specific tasks. Instead of building custom agents, you create skills that any agent can learn and use.

Think of a skill like a how-to guide for a new hire. It has instructions, examples, and tools for a specific type of work.

> [!NOTE]
> For setup and architecture, see the [AI README](../README.md).

## Quick Links

- [Claude Code Skills Docs](https://code.claude.com/docs/en/skills)
- [Engineering Blog Post](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Example Skills Repo](https://github.com/anthropics/skills)

## How Skills Work

Skills use three levels of detail:

| Level | What Loads | When |
|-------|-----------|------|
| 1. Metadata | Name and description | Always (at startup) |
| 2. Instructions | Full `SKILL.md` file | When the agent thinks it's relevant |
| 3. Resources | Extra files, scripts | Only when needed |

This keeps context small while making lots of info available on demand.

## Creating a Skill

### 1. Create the Folder

```bash
mkdir ai/skills/my-skill
```

### 2. Write SKILL.md

Every skill needs a `SKILL.md` file with YAML frontmatter:

```markdown
---
name: my-skill
description: What this skill does and when to use it. Include trigger words.
---

# My Skill

## Instructions
Step-by-step guidance for the agent...

## Examples
Show what success looks like...
```

> [!IMPORTANT]
> The `name` field must use only lowercase letters, numbers, and hyphens.
> Good: `my-skill`, `code-review-v2`
> Bad: `My Skill`, `My_Skill`

### 3. Add Extra Files (Optional)

```
my-skill/
├── SKILL.md           # Required
├── reference.md       # Optional: extra context
├── examples.md        # Optional: more examples
└── scripts/           # Optional: code the agent can run
    └── helper.py
```

### 4. Test It

Ask the agent questions that match your skill's description. The agent will use the skill when it seems relevant.

## Using Skills

Skills are **automatic**. Agents decide when to use them based on your request and the skill's description.

**Example:**
- You: "Help me review my Todoist tasks"
- Agent: Loads the `todoist-daily-review` skill (if the description matches)

To see what skills exist:
- Ask: "What skills are available?"

## Writing Good Skills

**Keep it focused.** One skill per task. Small skills combine better than big ones.

**Write clear descriptions.** Agents use the description to decide when to load the skill. Say what it does AND when to use it.

**Start simple.** Begin with markdown instructions. Add scripts later if needed.

**Use examples.** Show inputs and outputs so the agent knows what success looks like.

## Scripts in Skills

Skills can include code that agents run as tools. This helps with:
- Tasks better done in code (sorting, parsing)
- Work that needs exact results
- Calls to APIs or file systems

```markdown
---
name: pdf-form-filler
description: Fill out PDF forms. Use when working with PDFs.
---

# PDF Form Filler

## Scripts

Use `scripts/extract_fields.py` to get form fields from a PDF.
```

## Security

> [!CAUTION]
> Only install skills from sources you trust.

- Skills can run code on your machine
- Don't hardcode secrets (API keys, passwords)
- Review downloaded skills before you enable them
- Check any bundled scripts

## Skills in This Repo

### 1password
Fetch secrets with 1Password CLI. Keeps credentials out of chat and shell history.

### bruno-endpoint-creation
Create REST API endpoints in Bruno. Covers auth, request setup, and testing.

### code-review
Run thorough code reviews. Checks security, performance, and code quality.

### toggl
Track time with the Toggl CLI. Start/stop timers, log hours, view entries.

### todoist-daily-review
Review and document Todoist tasks. Researches items, writes summaries, marks complete.
