# Agent Skills

Agent Skills extend AI agent capabilities by packaging specialized knowledge, workflows, and code into organized folders that agents can discover and load dynamically. Instead of building custom agents for each use case, you can create composable "skills" that teach agents how to perform specific tasks.

Think of a skill like an onboarding guide for a new hire - it contains instructions, examples, and tools needed to accomplish a specific type of work.

**Official Resources:**
- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
- [Engineering Blog Post](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Example Skills Repository](https://github.com/anthropics/skills)

## Installation & Architecture

Skills are shared across all AI tools via directory symlinks:

```
ai/skills/                              ← Source of truth
    └── todoist-daily-review/
    └── code-review/
    └── ...

~/.claude/skills      → dotfiles/ai/skills   (Claude Code)
~/.cursor/skills      → dotfiles/ai/skills   (Cursor)
~/.config/opencode/skill → dotfiles/ai/skills   (OpenCode)
```

### Adding a New Skill

Simply create a skill directory in `ai/skills/`:

```bash
mkdir ai/skills/my-new-skill
# Create SKILL.md (see format below)
```

The skill is immediately available to Claude Code, Cursor, and OpenCode - no linking required.

### Deploying Skills

Run stow to deploy (if not already set up):

```bash
dotfiles stow
# or
bash configs/stow.sh
```

## How Skills Work

### Progressive Disclosure

Skills use a three-level progressive disclosure system:

1. **Level 1 - Metadata** (always loaded): Agents pre-load the `name` and `description` of all installed skills into their system prompt at startup
2. **Level 2 - Core Instructions**: If the agent thinks a skill is relevant, it reads the full `SKILL.md` file into context
3. **Level 3+ - Additional Resources**: Skills can bundle extra files (reference docs, scripts) that agents load only when needed

This design keeps context windows lean while making virtually unlimited context available on-demand.

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
---

# My Skill

## Overview
Detailed instructions for the agent...

## When to Use
Apply this skill when...

## Instructions
Step-by-step workflow...
```

**Important Naming Rules:**
- `name` field must contain **only lowercase letters, numbers, and hyphens**
- Bad: `My Skill`, `My_Skill`, `MySkill`
- Good: `my-skill`, `my-skill-v2`, `skill-123`

**Description Best Practices:**
- Include both **what** the skill does and **when** to use it
- Use specific trigger terms users would mention
- Be clear and specific (vague descriptions make discovery difficult)

### Skills and Code Execution

Skills can include Python or JavaScript code that agents can execute as tools. This is useful for:
- Operations better suited to code than token generation (sorting, parsing, etc.)
- Tasks requiring deterministic reliability
- Interacting with APIs or filesystems

```markdown
---
name: pdf-form-filler
description: Fill out PDF forms programmatically. Use when working with PDF files or forms.
---

# PDF Form Filler

## Scripts

Use `scripts/extract_fields.py` to get all form fields from a PDF.
```

## Usage

Skills are **model-invoked**—agents autonomously decide when to use them based on your request and the skill's description. You don't need to explicitly invoke them.

**Example:**
- You: "Can you help me review my Todoist tasks for today?"
- Agent: Automatically activates the `todoist-daily-review` skill if it matches the description

To see what skills are available, ask the agent:
- "What skills are available?"
- "List all available skills"

## Creating New Skills

### 1. Create the Skill Directory

```bash
mkdir ai/skills/my-new-skill
cd ai/skills/my-new-skill
```

### 2. Write SKILL.md

Create `SKILL.md` with YAML frontmatter and instructions:

```markdown
---
name: my-new-skill
description: Brief description of what this skill does and when to use it. Include trigger terms users would mention.
---

# My New Skill

## Instructions
Step-by-step guidance for the agent...

## Examples
Concrete examples of using this skill...
```

### 3. Test the Skill

Ask the agent questions that should trigger your skill based on its description. The agent will automatically use the skill when relevant.

## Best Practices

- **Keep it focused:** One skill per workflow. Multiple focused skills compose better than one large skill
- **Write clear descriptions:** Agents use the description to decide when to invoke the skill. Include both what it does and when to use it
- **Start simple:** Begin with basic markdown instructions before adding complex scripts
- **Use examples:** Include example inputs/outputs to show what success looks like
- **Version your skills:** Track versions as you iterate (helps with troubleshooting)
- **Test incrementally:** Test after each change rather than building everything at once
- **Let skills compose:** Agents can use multiple skills together automatically

## Security Considerations

**Only install skills from trusted sources**

- Skills can execute code in your environment
- Don't hardcode sensitive info (API keys, passwords)
- Review any downloaded skills before enabling
- Audit bundled scripts and dependencies
- Be cautious of skills that connect to external networks

## Skills in This Directory

### 1password

Secure secret management using 1Password CLI. Teaches the agent to:
- Ask for 1Password secret references instead of raw secrets
- Use `op read "op://Vault/Item/field"` to fetch secrets
- Keep credentials out of chat history, shell history, and config files

### bruno-endpoint-creation

Comprehensive guide for creating REST API endpoints in Bruno. Provides patterns and best practices for:
- Environment configuration (development vs production)
- RESTful endpoint structure and CRUD patterns
- Authentication (collection-level and individual)
- Request configuration and body formatting
- Response handling with pre/post-request scripts
- Error handling and validation
- Documentation standards
- Collection organization and folder structure
- Advanced patterns (pagination, filtering, bulk operations)
- Testing strategies and security considerations

### code-review

Comprehensive code review process for conducting thorough, educational, and actionable code reviews:
- Initial comprehensive scan (security, performance, code quality, architecture, testing, documentation)
- Feature documentation verification (cross-checking against specs, plans, requirements)
- Test pattern analysis and anti-pattern identification
- Guided interactive walkthrough with issue prioritization
- Structured review document generation with checklists
- Review file organization and GitHub posting support

### toggl

Time tracking assistant using the Toggl CLI. Automatically invoked when discussing:
- Time tracking, timers, timesheets
- Starting/stopping work timers
- Logging hours or checking time entries
- Viewing what's currently running

Uses the Rust-based toggl CLI (watercooler-labs/toggl-cli) with Toggl API v9.

### todoist-daily-review

Automates the workflow for reviewing and documenting Todoist investigation tasks:
1. Fetches today's tasks from Todoist
2. Identifies investigation items (tools, articles, resources)
3. Researches each via web search
4. Generates structured markdown summaries
5. Appends to Obsidian daily notes
6. Marks tasks complete in Todoist

## Platform Support

Skills are supported on:
- **Claude Code** - Local code execution environment
- **Cursor** - Integrated Claude Code environment (nightly)
- **OpenCode** - Terminal-based AI coding agent
- **Claude.ai** - Web interface (requires ZIP upload)
- **Claude Agent SDK** - For building custom agents

For Claude Code, Cursor, and OpenCode, skills are automatically discovered from their respective skills directories.

## Related

- **[Commands](../commands/README.md)** - Reusable command/prompt templates
- **[Agents](../agents/README.md)** - Agent definitions with model/tool configurations
