---
name: goal
description: Quick goal planning for technical tasks. Compressed vision-requirements-spec-plan into a single goal.md through a brief interview (3-6 questions). For tasks bigger than ad-hoc but not needing the full feature process.
---

# Goal Planning

## Overview
Compressed alternative to the full feature development process. Produces a single goal.md document through a quick conversational interview — typically 3-6 questions total.

One document instead of four. Plain language instead of formal requirement IDs. Quick interview instead of deep multi-phase discovery.

**When to use this:**
- Infrastructure work (deploy, configure, set up a service)
- Script or small tool development
- Technical configurations or migrations
- Anything bigger than a one-off task but not a full product feature

**When NOT to use this:**
- Full product features → use `/feature-vision`, `/feature-requirements`, `/feature-spec`, `/feature-plan`
- Simple one-off tasks → just do them or use plan mode

**IMPORTANT**: Start by creating a TODO list to track the 3 phases of goal creation. Mark the first phase as "in_progress" and others as "pending".

## Goal Document Structure

A goal.md is a single markdown file with four sections:

1. **Goal Statement** — One paragraph: what you're building, why, what success looks like
2. **Requirements** — Simple bullets in plain language (no REQ-X.X.X IDs, no user story format)
3. **Technical Approach** — Brief technical decisions: tools, languages, integration points, key choices
4. **Plan** — Ordered steps with checkboxes, ready to execute

**Target length:** 1-2 pages total. If it's getting longer, you're over-thinking it — use the full feature process instead.

## Process: Work Through These 3 Phases Sequentially

### Phase 1: Discovery (2-3 questions)

Understand what and why. Ask ONE question at a time:

- What are you trying to accomplish?
- Why does this need to be done? (What problem does it solve or what does it enable?)
- Any constraints or context I should know? (Existing systems, preferences, limitations)

**Keep it conversational.** Don't ask questions you can answer yourself from context — check the codebase, memory, and project docs first. If the goal is already clear from what the user said, skip straight to confirming your understanding rather than re-asking.

**Goal of this phase:** Enough understanding to write a clear goal statement and requirements bullets.

### Phase 2: Technical Approach (1-2 questions)

Understand how. Again, ONE question at a time:

- What tools, languages, or technologies should we use? (Or: here's what I'd suggest based on your stack — does that sound right?)
- Are there existing patterns or systems this needs to integrate with?

**Be opinionated.** If you know the user's stack and preferences, propose an approach and ask for confirmation rather than open-ended questions. Check the codebase for existing patterns before asking.

**Goal of this phase:** Key technical decisions made. Ready to write the document.

### Phase 3: Document Generation

Before generating, confirm the save location:
- **Default:** `goals/YYYY-MM-DD-brief-name/goal.md` relative to the current project root
- If the current project doesn't make sense, ask where to save it

Generate the goal.md with this structure:

```markdown
# Goal: [Brief Title]

## Goal Statement

[One paragraph — what you're building, why it's needed, what success looks like.]

## Requirements

- [Simple bullet — what the system must do]
- [Another capability]
- [Any constraints]
- [Keep these plain and practical]

## Technical Approach

[Brief — what tools, languages, frameworks. Key technical decisions and why.
Integration points with existing systems. 1-2 short paragraphs max.]

## Plan

- [ ] Step 1 — description
- [ ] Step 2 — description
- [ ] Step 3 — description
  - [ ] Sub-step if needed
- [ ] Step N — verify everything works
```

**After generating:** Mark all TODO phases complete. Ask if the user wants to start executing the plan or adjust anything first.

## Guidelines

- **Speed is the point.** Total interview: 3-6 questions. Don't fish for detail you don't need.
- **One question at a time.** Wait for the answer before asking the next.
- **Be opinionated.** Propose approaches based on what you know about the user's stack and preferences. Don't ask when you can suggest.
- **Plain language.** No corporate speak, no formal IDs, no jargon unless it's technical and necessary.
- **Check context first.** Read relevant files, memory, and project docs before asking questions the codebase can answer.
- **Single document.** No discussion-summary.md, no future.md, no cross-references. Just one goal.md.
- **Practical plans.** Steps should be concrete and executable. Include validation steps. No time estimates.
