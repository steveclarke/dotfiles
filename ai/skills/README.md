# Claude Agent Skills

> ⚠️ **WORK IN PROGRESS**
>
> This is an experimental area for testing Claude's new Agent Skills feature (announced Oct 16, 2025).
> **Current Status:** Not fully working yet - needs iteration and debugging.
> This directory contains early attempts that may not function as intended.

## What are Agent Skills?

Agent Skills are a new way to extend Claude's capabilities by packaging specialized knowledge, workflows, and code into organized folders that Claude can discover and load dynamically. Instead of building custom agents for each use case, you can create composable "skills" that teach Claude how to perform specific tasks.

Think of a skill like an onboarding guide for a new hire - it contains instructions, examples, and tools needed to accomplish a specific type of work.

**Announced:** October 16, 2025  
**Official Resources:**
- [Engineering Blog Post](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Skills Documentation](https://docs.anthropic.com/en/docs/agents/skills)
- [How to Create Skills Guide](https://support.claude.com/en/articles/12512198-how-to-create-custom-skills)
- [Example Skills Repository](https://github.com/anthropics/skills)

## How Skills Work

### Progressive Disclosure

Skills use a three-level progressive disclosure system:

1. **Level 1 - Metadata** (always loaded): Claude pre-loads the `name` and `description` of all installed skills into its system prompt at startup
2. **Level 2 - Core Instructions**: If Claude thinks a skill is relevant, it reads the full `SKILL.md` file into context
3. **Level 3+ - Additional Resources**: Skills can bundle extra files (reference docs, scripts) that Claude loads only when needed

This design keeps Claude's context window lean while making virtually unlimited context available on-demand.

### Anatomy of a Skill

A skill is a directory containing at minimum a `SKILL.md` file:

```
my-skill/
├── SKILL.md           # Required: core skill definition
├── reference.md       # Optional: additional context
├── examples.md        # Optional: examples and edge cases
└── scripts/           # Optional: executable code
    └── helper.py
```

### SKILL.md Format

Every `SKILL.md` must start with YAML frontmatter containing required metadata:

```markdown
---
name: my-skill-name
description: Clear description of what this skill does and when to use it
version: 1.0.0
---

# My Skill

## Overview
Detailed instructions for Claude...

## When to Use
Apply this skill when...

## Instructions
Step-by-step workflow...
```

**Important Naming Rules:**
- `name` field must contain **only lowercase letters, numbers, and hyphens**
- Bad: `My Skill`, `My_Skill`, `MySkill`
- Good: `my-skill`, `my-skill-v2`, `skill-123`

### Skills and Code Execution

Skills can include Python or JavaScript code that Claude can execute as tools. This is useful for:
- Operations better suited to code than token generation (sorting, parsing, etc.)
- Tasks requiring deterministic reliability
- Interacting with APIs or filesystems

```markdown
---
name: pdf-form-filler
description: Fill out PDF forms programmatically
dependencies: python>=3.8, pypdf>=3.0.0
---

# PDF Form Filler

## Scripts

Use `scripts/extract_fields.py` to get all form fields from a PDF.
```

## Creating and Installing Skills

### 1. Create the Skill Directory

```bash
mkdir my-skill
cd my-skill
```

### 2. Write SKILL.md

Start with YAML frontmatter, then add instructions in markdown.

### 3. Package as ZIP

```bash
cd ..
zip -r my-skill.zip my-skill/
```

**Important:** The ZIP must contain the skill folder as its root, not files directly:

```
✅ Correct:
my-skill.zip
└── my-skill/
    └── SKILL.md

❌ Incorrect:
my-skill.zip
└── SKILL.md (directly in root)
```

### 4. Upload to Claude

1. Go to Claude.ai Settings > Capabilities
2. Upload your skill ZIP file
3. Enable the skill
4. Test with prompts that should trigger it

## Best Practices

- **Keep it focused:** One skill per workflow. Multiple focused skills compose better than one large skill
- **Write clear descriptions:** Claude uses the description to decide when to invoke the skill
- **Start simple:** Begin with basic markdown instructions before adding complex scripts
- **Use examples:** Include example inputs/outputs to show what success looks like
- **Version your skills:** Track versions as you iterate (helps with troubleshooting)
- **Test incrementally:** Test after each change rather than building everything at once
- **Let skills compose:** Claude can use multiple skills together automatically

## Security Considerations

⚠️ **Only install skills from trusted sources**

- Skills can execute code in your environment
- Don't hardcode sensitive info (API keys, passwords)
- Review any downloaded skills before enabling
- Audit bundled scripts and dependencies
- Be cautious of skills that connect to external networks

## Skills in This Directory

### todoist-daily-review

**Status:** ⚠️ Work in Progress - Not fully functional

Automates the workflow for reviewing and documenting Todoist investigation tasks:
1. Fetches today's tasks from Todoist
2. Identifies investigation items (tools, articles, resources)
3. Researches each via web search
4. Generates structured markdown summaries
5. Appends to Obsidian daily notes
6. Marks tasks complete in Todoist

**Files:**
- `SKILL.md` - Core skill definition and workflow
- `examples.md` - Example outputs and edge cases

## Future Plans

As the Skills feature matures, this directory will contain:
- Production-ready skills for my workflows
- Templates and examples for creating new skills
- Integration guides for different contexts (Claude.ai, Claude Code, API)

## Platform Support

Skills are currently supported on:
- **Claude.ai** - Web interface with skill management
- **Claude Code** - Local code execution environment
- **Claude Agent SDK** - For building custom agents
- **Claude Developer Platform** - API integration (dependencies must be pre-installed)

---

*Last Updated: October 18, 2025*

