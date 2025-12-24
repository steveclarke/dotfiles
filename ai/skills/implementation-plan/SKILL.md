---
name: implementation-plan
description: Creates implementation plan documents by determining plan structure, sequencing development phases, and generating actionable tasks. Use when user wants to create an implementation plan, needs to sequence development work, determine when and in what order to build features, or create detailed task breakdowns with code examples. Follows established feature development process with clear phase sequencing, integrated development (code + validation + data), and selective detail strategy (full code for novel aspects, references for established patterns).
---

# Implementation Plan Creation

## Overview

Structured skill to help create implementation plan documents by determining plan structure, sequencing development phases, and generating actionable tasks following our established planning patterns.

## Required Context

You have comprehensive context available:

**Required Reading**:
- Feature development guide: `@~/.local/share/dotfiles/ai/guides/feature-development-process.md`
- Vision document: `@vision.md`
- Requirements document: `@requirements.md`
- Technical specification: `@spec.md`

Note: If the project has a local copy of the guide at `@project/guides/feature-development-process.md`, reference that instead for project-specific modifications.

**Additional Context Available**:
- **Full Codebase**: Examine existing implementation patterns and architecture
- **Implementation Guides**: Review backend/docs/guides/ and frontend/docs/guides/ for established approaches
- **Testing Guide**: Reference backend/docs/guides/testing/backend-testing-guide.md for testing strategy

**Approach**: Use all available context to create practical implementation plans with clear sequencing and integrated development phases.

**IMPORTANT**: Start by creating a TODO list to track the 3 phases of plan creation. Mark the first phase as "in_progress" and others as "pending".

## Implementation Plan Structure

Our implementation plans include:
- Development phases and sequencing (the WHEN and ORDER)
- Detailed code blocks for unique/novel aspects (with full documentation using your language's standards)
- Pattern references for established code (noting only what's different)
- Granular checkbox tasks within each phase
- Cross-references to vision, requirements, and spec documents

**IMPORTANT**: 
- Do NOT include any effort sizing estimates, hours, or time estimates in the plan documents
- The checklist tasks themselves serve as the completion criteria - no separate success criteria sections needed
- **Code Detail Strategy**:
  - **Unique/Novel/Complex code**: Spell out FULLY with complete documentation using your language's conventions - developers should be able to review, understand, and iterate at the plan level
  - **Established patterns**: Just reference existing implementations and note what's different - no boilerplate code
  - When you DO include code, make it thorough and detailed with full documentation
  - Goal: Enable plan-level iteration for novel code, skip redundant boilerplate entirely

## Process: Work Through These 3 Phases Sequentially

### Phase 1: Determine Plan Structure
First, analyze the technical specification and determine how to organize the planning documents:

**Complexity Analysis**:
1. Review the technical spec to understand implementation scope
2. Examine existing similar features in the codebase for patterns
3. Assess team involvement (backend-only, frontend-only, full-stack, design work)
4. Determine optimal plan structure

**Structure Recommendation** - Suggest approach with rationale:
- **Single plan.md**: For focused features or single-domain work (backend-only, frontend-only, etc.) (estimated <500 lines)
- **Split by domain**: plan-backend.md + plan-frontend.md + plan-design.md for complex full-stack features
- **Separate tasks.md**: Only for complex coordination (multiple developers, handoff scenarios)

Ask: "Based on your spec analysis, I recommend [structure]. Does this match your preferences?"

### Phase 2: Design Implementation Approach
Determine implementation approach and phase structure:

**Planning Activities**:
- **Analyze implementation scope** and determine high-level phase breakdown
- **Identify what's unique vs established patterns** - differentiate novel aspects from boilerplate
- **Identify phase dependencies** and sequencing requirements
- **Determine code placement approach** (which files, directory structure, following existing patterns)
- **Assess complexity factors** and technical challenges requiring detailed explanation
- **Reference existing patterns** to minimize boilerplate in plan - note existing implementations developers can follow

**Information Gathering**:
- **Ask specific questions about**:
  - Unique implementation approaches not covered by existing patterns
  - Testing depth preferences for this feature
  - Any specific implementation constraints or preferences

**Sequencing Validation**:
- **Present proposed implementation sequence** with high-level phase breakdown and rationale
- **Ask for sequencing confirmation**: "Does this order make sense? Are there dependencies I missed?"
- **Validate phase dependencies and prerequisites** before proceeding to document generation
- **Get explicit approval** of the implementation approach and sequencing

### Phase 3: Generate Plan Documents
Create the actual plan documents based on Phase 2 planning:

- **Generate plan.md or plan-[domain].md files** as determined in Phase 1
- **Write implementation phases** using the approach and structure designed in Phase 2
- **Include table of contents** with systematic section numbering (1.1, 1.2, 2.1, 2.2, etc.)
- **Add actionable checkbox tasks** within each implementation phase (these tasks ARE the completion criteria)
- **Apply selective detail approach**:
  - For **unique/novel code**: Include FULL, detailed implementations with complete documentation using your language's standards
  - For **established patterns**: Reference existing implementations and note only what's different
  - When code IS included, make it complete enough for plan-level review and iteration
- **Include justification and cross-references** for each phase explaining which spec sections it implements (use precise section references like spec.md#1.2, spec.md#3.1)
- **Use clear, practical language** focused on implementation sequencing

## Guidelines
- **Context First**: Always analyze existing plans and implementation patterns before planning
- **Selective Detail Strategy**:
  - **Novel/Complex Code**: Include FULL, detailed code with complete documentation using your framework's conventions - enable plan-level review and iteration
  - **Established Patterns**: Reference existing implementations, note differences only - no boilerplate repetition
  - When code IS included, make it thorough enough for developers to understand and refactor in the plan itself
- **Pattern References**: When similar code exists, say "Follow pattern from X, but adjust Y" instead of repeating boilerplate
- **Plan Overview Required**: Start documents with concise overview (what we're building, key components, sequencing logic as bullets)
- **Prerequisites as Phase 1**: Include external setup, manual configurations, and environment requirements as the first implementation phase - even if they're confirmatory steps
- **Actionable Tasks**: Use checkboxes for actionable tasks and implementation steps
- **Integrated Development**: Each phase includes code implementation with appropriate validation and data (not separate activities)
- **Code + Validation Approach**:
  - Implementation phases focus on novel/complex code with full details; reference existing patterns for standard code
  - When code IS included: make it thorough with complete documentation using your framework's standards for plan-level review
  - Include tests: full details for novel logic, references for standard patterns appropriate to your testing framework
  - Include smoke tests, throwaway scripts, or manual validation when formal testing patterns don't exist
  - Phases creating new data models should include realistic sample data for developer use
- **Test Structure Pattern**: Selective detail based on novelty
  - **Standard CRUD/simple patterns**: Just reference existing test patterns ("Follow test pattern from X")
  - **Novel/complex testing logic**: Include FULL test structure with complete test blocks and implementation details appropriate to your testing framework
  - When tests ARE included, make them detailed enough to review and iterate at the plan level
  - Goal: Enable thorough test review for unique testing scenarios, skip boilerplate for standard patterns
- **Code Documentation**: Full documentation for novel code, skip for standard patterns
  - **Standard CRUD/simple patterns**: Developers can follow existing examples - no need to include
  - **Novel/complex code**: Include COMPLETE documentation with all parameters, return values, examples, type information, and detailed descriptions using your language's documentation standards
  - When documentation IS included, make it thorough and complete - enable full understanding at the plan level
  - Use your language's documentation format (e.g., JSDoc, docstrings, YARD, etc.)
  - Goal: Full documentation for unique code, zero boilerplate for standard patterns
- **Incremental Validation**: Include validation steps for complex integrations and end-to-end workflows where manual testing would be tedious
- **Early Sample Data**: Include realistic sample data for new backend database models early in development phases, unless model interdependencies prevent it
- **Justification Required**: Every implementation phase must be traceable to spec sections
- **Pattern Following**: Base implementation approach on established codebase patterns
- **Documentation Required**: Include documentation/guide generation as the final phase of every implementation plan
- **Focus on Implementation Only**: Do NOT include development philosophy, risk mitigation strategy, or quality assurance strategy sections - developers have vision, requirements, spec, and guides for context
- Update your TODO list as you complete each phase
- Focus on WHEN and ORDER of implementation phases
- Reference implementation guides and similar features
- Cross-reference all previous documents for business and technical context

## Getting Started Process
1. Create your 3-phase TODO list immediately
2. Ask user: "What feature directory are you working in? Please provide the full path (e.g., project/features/FT033-feature-name)"
3. Ask user: "Please tag your vision, requirements, and spec documents with @vision.md @requirements.md @spec.md"
4. Validate the directory exists and confirm where you'll create the plan documents
5. Review all previous documents to understand complete feature context
6. Begin Phase 1 with plan structure analysis and recommendation
7. Keep recommendations focused and wait for confirmation before proceeding
