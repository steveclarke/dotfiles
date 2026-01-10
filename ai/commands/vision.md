# Vision Document

## Overview
Structured command to help create vision documents by guiding through focused discovery phases and building each section systematically following our established feature development process.

You are helping create a vision document following our established feature development process. First, read our feature development guide at @~/.local/share/dotfiles/ai/guides/feature-development-process.md to understand our vision document structure and approach.

Note: If the project has a local copy of the guide at @project/guides/feature-development-process.md, you may reference that instead for project-specific modifications.

**IMPORTANT**: Start by creating a TODO list to track the 5 phases of vision document creation. Mark the first phase as "in_progress" and others as "pending".

## Vision Document Structure
Our vision documents are **lean and focused** - typically 100-150 lines, never more than 200. They flow from general to specific:

**Required sections:**
- Clear vision statement (one sentence)
- Table of contents (with links to all major sections)
- Problem (what's broken, who it affects, why it matters)
- Solution (how we'll solve it, core philosophy, key capabilities)
- User Needs (simple bullets by role - what they need to accomplish)
- Future Possibilities (brief overview with reference to separate future.md)
- Scope (concrete list of what v1 delivers and what's not included)

**What does NOT belong in vision:**
- Detailed business justifications or ROI calculations
- Deployment details (where/how it runs - that's spec territory)
- Technical implementation details (APIs, schemas, architecture - that's spec territory)
- Detailed user stories or acceptance criteria (that's requirements territory)
- Step-by-step workflows or process flows (that's requirements territory)
- Repetitive sections that restate the same information

## Process: Work Through These 5 Phases Sequentially

### Phase 1: Problem Discovery
Ask focused questions to understand:
- What specific problem are we solving?
- Who experiences this problem and how?
- What's the current painful/manual process?
- What are the consequences of not solving this?

**ONE QUESTION AT A TIME** - Wait for answers before proceeding.
**NO CORPORATE SPEAK** - Keep language conversational and direct.

### Phase 2: Solution Exploration
Ask about:
- How do we envision solving this at a high level?
- What's our core philosophy or approach?
- What are the 3-5 key capabilities we need?
- What makes this solution different/better?

### Phase 3: User Needs Analysis
**Use consolidated user roles at vision level:**
- End Users (all user types)
- Admin Staff (consolidate all staff types - Staff, Administrators, Organization Admins)
- Product Team (if relevant)

**Avoid fine-grained role distinctions** - detailed role breakdown goes in requirements document.

For each consolidated role, ask ONLY:
- What do they need to accomplish with this feature?

**STOP THERE.** Don't ask about "current pain points" or "how success looks different" - that creates redundancy with the Problem section and belongs in requirements.

### Phase 4: Future & Scope Discovery
Ask about:
- What nice-to-have features should we consider for future phases?
- What scope are we explicitly INCLUDING in v1? (get concrete details)
- What scope are we explicitly NOT including in v1?

**Key**: Get detailed, concrete information about what v1 will actually deliver - this becomes the bridge to requirements.

### Phase 5: Document Generation
**Before generating, ruthlessly eliminate redundancy:**
- Does this section repeat information from another section?
- Is this section justifying something already obvious from the problem?
- Is this spec-level detail (deployment, technical architecture)?
- Is this requirements-level detail (detailed workflows, acceptance criteria)?

**Then generate three documents:**

**1. vision.md** - The lean, focused vision document:
- Create a clear one-sentence vision statement
- Generate a table of contents with links to all major sections
- Compile vision document with concrete scope section
- Flow from general (problems, solution) to specific (detailed scope)
- Follow "no corporate speak" principle throughout
- Reference future.md in the brief future possibilities section
- **Keep total length under 150 lines** - be ruthless about brevity

**2. future.md** - Detailed future enhancements:
- Create separate detailed future.md document with all future features
- Organize by phases (Phase 2, Phase 3, etc.)
- Include strategic future vision (if applicable)

**3. discussion-summary.md** - Living discussion summary document:
- Create a unified discussion summary that will accumulate across all phases
- Include "Vision Phase" section with all vision-related discussions
- Include placeholder sections for Requirements, Spec, and Plan phases
- Document architectural decisions made and their rationale in Key Decisions Log
- Capture technical feasibility discussions and implementation ideas
- Note any technical constraints or challenges identified
- Include open questions that should be addressed in requirements/spec
- Add Technical Context section with files referenced and related features
- Organize with clear sections and table of contents
- This document serves as institutional memory across the entire feature lifecycle

## Key Principles

**Flow from General to Specific:**
Start with high-level problems and solutions, end with concrete scope details that bridge naturally to requirements.

**Scope Section is Critical:**
This should be a concrete LIST of what v1 delivers. Think: bullet points of capabilities/tools/features. This bridges vision to requirements.

**BUT don't include:**
- How it will be deployed (staging vs production) - that's spec territory
- Technical architecture details - that's spec territory  
- Justifications for why things are excluded - just list what's out, no explanations needed

**Separate Future Content:**
Create detailed future.md document for all future features. Vision should only have brief future overview.

**No Corporate Speak:**
Write for humans first. Use clear, simple language. Avoid jargon and unnecessarily complex terminology.

**User Role Consolidation:**
Keep user roles consolidated at vision level. Detailed role breakdowns belong in requirements.

**Eliminate Redundancy (CRITICAL):**
We're a small team that values lean, readable documents. Every section must add NEW information. Before including a section, ask: "Does this repeat something already said?" If yes, DELETE IT.

Common redundant patterns to AVOID:
- "Business Case" that just restates the problem in corporate language
- "Consequences" section that repeats pain points already in Problem
- "Who This Affects" section when it's obvious from Problem
- Multiple sections listing benefits/value in different ways
- Detailed "current pain points" AND "how success looks different" in user needs (Problem section already covers this)

**Keep It Short:**
Vision documents should be 100-150 lines MAX. If you're over 200 lines, you're repeating yourself or including spec/requirements-level detail.

## Guidelines
- Ask ONE question at a time and wait for response
- Update your TODO list as you complete each phase
- Keep questions conversational, not corporate-speak
- Focus on immediately useful information, avoid fluff
- Reference any existing notes or context provided
- Stay practical - we're a small team that values readable, actionable documents
- During discovery, it's normal to discuss technical feasibility and architecture - capture all of this
- Always create three documents at the end: vision.md, future.md, and discussion-summary.md

## Getting Started Process
1. Create your 5-phase TODO list immediately
2. Ask user: "What feature directory are you working in? Please provide the full path (e.g., project/features/FT033-feature-name)"
3. Ask user: "If you have existing notes, please tag them with @notes.md or @[filename].md so I can review them"
4. Validate the directory exists and confirm that's where you'll create vision.md, future.md, and discussion-summary.md
5. Review any tagged notes files
6. Begin Phase 1 with the first problem discovery question
7. Keep questions focused and wait for answers before proceeding to next questions
8. During conversations, capture technical/architectural discussions even if they don't directly go into vision.md

## What to Capture in discussion-summary.md

This document should be structured to accumulate context across all feature
development phases. For vision phase, create the full document structure:

**Document Structure:**
```markdown
# Feature Name: Discussion Summary

Living document capturing technical discussions, research, decisions, and
context from all phases of feature development.

## Table of Contents
- [Vision Phase](#vision-phase)
- [Requirements Phase](#requirements-phase)
- [Spec Phase](#spec-phase)
- [Plan Phase](#plan-phase)
- [Key Decisions Log](#key-decisions-log)
- [Technical Context](#technical-context)

## Vision Phase
[Vision phase content goes here]

## Requirements Phase
*To be added during requirements phase.*

## Spec Phase
*To be added during spec phase.*

## Plan Phase
*To be added during plan phase.*

## Key Decisions Log
| # | Decision | Rationale | Phase |
|---|----------|-----------|-------|
[Decisions from vision phase]

## Technical Context
### Files Referenced
[Backend and frontend files referenced]

### Related Features
[Related feature references]
```

**Vision Phase Content to Include:**
- Core problem identified and all nuances discussed
- Solution approach and how it evolved during discussion
- Technical feasibility discussions
- Architectural decisions made and their rationale
- Implementation ideas explored (even if not chosen)
- Technology choices and why (SDKs, frameworks, protocols)
- Technical constraints identified
- Integration points with existing systems
- Open questions for requirements/spec phases

**Key Decisions Log:**
- Number decisions starting from 1
- Include decision, rationale, and "Vision" as the phase
- Later phases will continue the numbering

**Technical Context:**
- List files referenced during discussions (backend and frontend paths)
- Note related features that may be affected

**Purpose:** This document serves as institutional memory across the entire
feature lifecycle. Each phase adds its section, and the Key Decisions Log and
Technical Context accumulate across all phases.
