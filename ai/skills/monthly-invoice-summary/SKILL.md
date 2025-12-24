---
name: monthly-invoice-summary
description: Creates professional monthly invoice summaries for clients by analyzing Git commits and time sheet notes. Combines technical development work with business activities into clear, value-focused bullet points suitable for client invoicing. Use when creating monthly billing summaries, preparing client invoices, summarizing development work for billing periods, translating technical Git commits into client-friendly descriptions, or combining Git activity with time sheet notes for complete project summaries.
---

# Monthly Invoice Summary

Generate professional, client-friendly monthly summaries of development work by analyzing Git commits and time sheet notes, then synthesizing them into clear, business-focused bullet points suitable for client invoicing.

## Overview

You act as an invoice summary assistant that translates technical development work into business communication. Your role is to analyze Git commits and time sheet notes, then synthesize them into concise, value-focused descriptions that clients can understand.

## Workflow

### Step 1: Gather Required Information

Collect the following before generating the summary:

1. **Project name** - What is the project called? (e.g., "Acme Project" or "Client Portal App")
2. **Time period** - For what month/period? (e.g., "August 2025", "Q3 2025")
3. **Previous month's summary** (optional but recommended) - Helps maintain consistency and include recurring items like meetings
4. **Time sheet notes** (optional) - Captures work beyond Git commits like meetings, planning, discussions, etc.
5. **Git repository location** - Confirm current directory or get the repository path

If the user provides all context upfront, proceed directly to Step 2. Otherwise, ask for missing information.

### Step 2: Collect Git Commit Data

Run git log for the specified timeframe to get all commits:

```bash
git log --since="2025-08-01" --until="2025-08-31" --format="%h %ai %s"
```

Analyze commit patterns to identify:
- Feature development work
- Bug fixes
- Dependency updates
- Documentation changes
- Testing improvements
- Configuration changes

Note the author if multiple developers worked on the project.

### Step 3: Review Additional Context

1. **Review time sheet notes** for work not captured in commits:
   - Client meetings and status calls
   - Planning and design sessions
   - Code reviews and pair programming
   - Research and investigation
   - Email correspondence and communication

2. **Reference previous month's summary** (if provided):
   - Identify recurring items (like "Status meetings & project management")
   - Match formatting style and tone
   - Note any ongoing multi-month work

### Step 4: Synthesize into Client-Friendly Summary

Combine all sources into cohesive categories. Group related work into logical categories:

- **Status meetings & project management** - Standard recurring monthly item
- **Version releases** - Highlight key improvements in each release
- **Infrastructure/dependency updates** - Group together, keep technical details minimal
- **Major feature work** - Business value and user-facing improvements
- **Bug fixes** - Only if significant; group minor fixes together
- **Security improvements** - Important to highlight
- **Performance optimizations** - Business impact (faster page loads, etc.)
- **Documentation updates** - User guides, API docs, setup instructions
- **Planning and design work** - Discovery, research, architectural planning

**Combination Strategy:**
- Merge multiple related commits into one bullet point
- Example: Instead of separate bullets for 20 dependency updates, write "Updated project dependencies and security patches"
- Example: Instead of listing 5 bug fix commits, write "Resolved reporting issues and fixed edge cases in user notifications"
- Include recurring items from previous month (especially meetings and project management)

### Step 5: Format and Present the Summary

Always provide the final output wrapped in triple backticks (```) as a code block for easy copy/paste:

```
Project Notes:
[Project Name] - [Time Period]:
- [Item 1]
- [Item 2]
- [Item 3]
```

This format allows the user to easily copy the plain text without any markdown rendering.

## Writing Guidelines

**Writing Style:**
- **Direct and action-oriented**: Avoid fluff words like "comprehensive", "enhanced", "robust"
- **Business-focused**: Emphasize outcomes and value, not technical implementation
- **Concise**: Combine related work into single bullet points
- **Minimal jargon**: Keep technical details light; clients don't need to know about dependencies
- **Sentence case**: Capitalize only the first word and proper nouns

**Language Examples:**

❌ **Avoid:**
- "Implemented comprehensive error handling system"
- "Enhanced database performance"  
- "Refactored legacy code"
- "Updated various dependencies"

✅ **Instead:**
- "Added error recovery for payment processing"
- "Improved report generation speed"
- "Modernized user authentication system"
- "Updated security patches and project dependencies"

**Output Quality:**
- Focus on value not implementation details
- Group related work to keep summary concise (aim for 5-10 bullets max)
- Use sentence case throughout
- Always wrap output in triple backticks for easy copy/paste

## Example Output

```
Project Notes:
Acme Client Portal - August 2025:
- Status meetings & project management
- Released version 2.3 with improved dashboard performance and new reporting features
- Resolved authentication issues and fixed edge cases in notification delivery
- Updated security patches and project dependencies
- Documented API endpoints for third-party integrations
```

## Usage Examples

- "Create a monthly invoice summary for Acme Project, August 2025"
- "I need to bill the client for last month's work"
- "Generate an invoice summary for this project covering July 2025"
- "Create a client-friendly summary of all the development work we did in Q3"