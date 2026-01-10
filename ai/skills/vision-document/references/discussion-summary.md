# What to Capture in discussion-summary.md

This document should be structured to accumulate context across all feature
development phases. For vision phase, create the full document structure.

## Document Structure

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
[Decisions accumulated across all phases]

## Technical Context
### Files Referenced
[Backend and frontend files referenced]

### Related Features
[Related feature references]
```

## Vision Phase Content to Include

- Core problem identified and all nuances discussed
- Solution approach and how it evolved during discussion
- Technical feasibility discussions
- Architectural decisions made and their rationale
- Implementation ideas explored (even if not chosen)
- Technology choices and why (SDKs, frameworks, protocols)
- Technical constraints identified
- Integration points with existing systems
- Open questions for requirements/spec phases

## Requirements Phase Content to Include

- Technical discussions and research from requirements phase
- "Resolved Questions from Vision" subsection (table showing what was open and
  how resolved)
- Data type decisions and business rule discussions
- Integration pattern research

## Spec Phase Content to Include

- Architectural decisions and their rationale
- Technology choices explored and selected
- Technical research conducted during spec phase
- Pattern decisions and trade-offs considered

## Plan Phase Content to Include

- Implementation approach discussions
- Sequencing decisions and rationale
- Any pivots made during planning
- Dependency and risk discussions

## Key Decisions Log

- Number decisions starting from 1 in vision phase
- Continue numbering across all phases
- Include decision, rationale, and phase for each entry
- This becomes a consolidated record of all major decisions

## Technical Context

- List files referenced during discussions (backend and frontend paths)
- Note related features that may be affected
- Update as new files are discovered in each phase

## Purpose

This document serves as institutional memory across the entire feature
lifecycle. Each phase adds its section, and the Key Decisions Log and Technical
Context accumulate across all phases.

When creating requirements, spec, or plan documents, this summary provides all
the context from previous phases without having to re-discuss everything. It
bridges the gap between phase conversations and helps new developers understand
the technical journey.
