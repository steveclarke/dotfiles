# Claude Agent Skills

Agent Skills extend Claude's capabilities by packaging specialized knowledge, workflows, and code into organized folders that Claude can discover and load dynamically. Instead of building custom agents for each use case, you can create composable "skills" that teach Claude how to perform specific tasks.

Think of a skill like an onboarding guide for a new hire - it contains instructions, examples, and tools needed to accomplish a specific type of work.

**Official Resources:**
- [Claude Code Skills Documentation](https://code.claude.com/docs/en/skills)
- [Engineering Blog Post](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills)
- [Example Skills Repository](https://github.com/anthropics/skills)

## Installation & Architecture

Skills in this repository use a three-layer architecture similar to the [prompts system](../prompts/README.md):

```
ai/skills/todoist-daily-review/
    ↓ (symlink via link-skills)
configs/claude/.claude/skills/todoist-daily-review/
    ↓ (symlink via stow)
~/.claude/skills/todoist-daily-review/
```

### Architecture Flow

1. **Source of truth**: `ai/skills/` - Actual skill directories with SKILL.md files
2. **Stow staging**: `configs/claude/.claude/skills/` - Symlinks created by `link-skills` command
3. **Deployed location**: `~/.claude/skills/` - Where Claude Code/Cursor discovers skills (via stow)

### Linking Skills

Use the `link-skills` CLI command to selectively link skills:

```bash
# List all available skills
link-skills list

# Link a specific skill
link-skills link todoist-daily-review

# Link all skills
link-skills link-all

# Unlink a skill
link-skills unlink todoist-daily-review

# List currently linked skills
link-skills linked
```

After linking, run stow to deploy:

```bash
dotfiles stow
# or
bash configs/stow.sh
```

This creates symlinks in `~/.claude/skills/` where Claude Code and Cursor automatically discover them.

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
├── examples.md         # Optional: examples and edge cases
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

**Description Best Practices:**
- Include both **what** the skill does and **when** to use it
- Use specific trigger terms users would mention
- Be clear and specific (vague descriptions make discovery difficult)

### Skills and Code Execution

Skills can include Python or JavaScript code that Claude can execute as tools. This is useful for:
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

Skills are **model-invoked**—Claude autonomously decides when to use them based on your request and the skill's description. You don't need to explicitly invoke them.

**Example:**
- You: "Can you help me review my Todoist tasks for today?"
- Claude: Automatically activates the `todoist-daily-review` skill if it matches the description

To see what skills are available, ask Claude:
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
Step-by-step guidance for Claude...

## Examples
Concrete examples of using this skill...
```

### 3. Link the Skill

```bash
link-skills link my-new-skill
dotfiles stow
```

### 4. Test the Skill

Ask Claude questions that should trigger your skill based on its description. Claude will automatically use the skill when relevant.

## Best Practices

- **Keep it focused:** One skill per workflow. Multiple focused skills compose better than one large skill
- **Write clear descriptions:** Claude uses the description to decide when to invoke the skill. Include both what it does and when to use it
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

**Files:**
- `SKILL.md` - Core skill definition with all patterns and examples

### code-review

Comprehensive code review process for conducting thorough, educational, and actionable code reviews:
- Initial comprehensive scan (security, performance, code quality, architecture, testing, documentation)
- Feature documentation verification (cross-checking against specs, plans, requirements)
- Test pattern analysis and anti-pattern identification
- Guided interactive walkthrough with issue prioritization
- Structured review document generation with checklists
- Review file organization and GitHub posting support

**Files:**
- `SKILL.md` - Complete review workflow and best practices

### todoist-daily-review

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

## Platform Support

Skills are supported on:
- **Claude Code** - Local code execution environment (recommended)
- **Cursor** - Integrated Claude Code environment
- **Claude.ai** - Web interface (requires ZIP upload)
- **Claude Agent SDK** - For building custom agents
- **Claude Developer Platform** - API integration (dependencies must be pre-installed)

For Claude Code and Cursor, skills are automatically discovered from `~/.claude/skills/` directory.

---

*Last Updated: January 2025*
