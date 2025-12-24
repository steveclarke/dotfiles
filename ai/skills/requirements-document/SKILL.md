---
name: requirements-document
description: Creates requirements documents through structured 3-phase discovery process. Guides through requirements discovery, practical scoping, and generates consolidated requirements document with clear, practical language. Use when user wants to create a requirements document, needs to define what the system must do and quality constraints, or is documenting business capabilities, user workflows, and system requirements. Follows established feature development process with single consolidated document covering user stories, business data, rules, quality attributes, and success criteria.
---

# Requirements Document Creation

## Overview

Structured skill to help create a requirements document by guiding through requirements discovery, practical scoping, and generating a single, consolidated requirements document with clear, practical language.

## Required Context

Before starting, read the feature development guide at `@~/.local/share/dotfiles/ai/guides/feature-development-process.md` and the vision document at `@vision.md` to understand the feature scope and our documentation approach.

Note: If the project has a local copy of the guide at `@project/guides/feature-development-process.md`, reference that instead for project-specific modifications.

**IMPORTANT**: Start by creating a TODO list to track the 3 phases of requirements creation. Mark the first phase as "in_progress" and others as "pending".

## Requirements Document Structure

**Single Consolidated Document** (requirements.md) includes:

**User Stories & Business Needs**:
- User stories structured by role
- Business capabilities and user workflows
- Core system capabilities the system must provide

**Business Data & Rules**:
- Business entities and data requirements (entities, relationships, business-level attributes and constraints)
- Business logic and rules that govern system behavior
- User experience requirements

**Quality Attributes & Constraints**:
- Performance, security, reliability, and scalability requirements
- Compliance and privacy controls
- Technical constraints and limitations

**Integration & Success**:
- Integration touchpoints with existing systems
- Development and testing approaches
- Success criteria and acceptance criteria
- Constraints and assumptions

## Existing System Patterns to Consider

When gathering requirements, check if existing system capabilities apply:
- **Search**: Full-text search capabilities
- **File Attachments**: Document/file upload and management
- **Audit Trail**: Change tracking and history
- **Multi-tenancy**: Data isolation per organization/tenant
- **Permissions**: Role-based access control
- **Tagging**: Classification and categorization systems
- **Custom Fields**: Extensible data fields

Ask early: "Which of these existing capabilities might apply to this feature?"

## Process: Work Through These 3 Phases Sequentially

### Phase 1: Requirements Discovery
Ask focused questions to gather ALL requirements (don't categorize yet):
- What specific capabilities does the system need to provide?
- What business entities does it need to manage (main concepts, relationships, business-level attributes)?
- What data does it need to store and what are the business constraints?
- What business rules need to be enforced?
- What are the different audiences (staff, members, public, admins)?
- How do requirements differ across these audiences?
- What should each audience be able to see and do?
- How do users interact with the system?
- What happens when there's no data? (Empty states for staff vs members)
- How is the data presented? (Feed-style, table, cards, etc.)
- What makes this feature usable for all technical skill levels?
- What are the security and permission requirements?
- What performance expectations exist?
- What integrations are needed with existing systems?
- What compliance or privacy requirements apply?

**ONE QUESTION AT A TIME** - Wait for answers before proceeding.

### Phase 2: Practical Focus & Future Planning
For each discovered requirement, ask:
- Is this immediately practical for the current scope?
- Should this go in current requirements or future.md for later phases?
- Can we state this in clear, simple language?
- Is this appropriately scoped for the current phase?
- Is this testable and measurable?

**Create future.md** for requirements that are:
- Great ideas but beyond current scope
- Complex features requiring Phase 2/3 implementation
- Ideas worth preserving for future consideration
- Advanced features that build on the initial foundation

**Keep in current requirements** only what is:
- Immediately practical and achievable
- Essential for core functionality
- Written in clear, simple language

### Phase 3: Document Generation
- Create a single consolidated requirements.md document with the following structure:
  1. **User Stories & Business Needs** - structured by role with clear business capabilities
  2. **Core System Capabilities** - what the system must provide to users
  3. **Business Data Requirements** - entities, relationships, business-level attributes
  4. **Business Rules & Logic** - rules and constraints that govern behavior
  5. **User Experience Requirements** - how the system should feel and behave
  6. **Quality Attributes & Constraints** - performance, security, reliability, scalability
  7. **Integration Touchpoints** - connections with existing systems
  8. **Development & Testing Approach** - how the system will be built and validated
  9. **Success Criteria** - clear acceptance criteria and definition of success
  10. **Constraints & Assumptions** - scope boundaries and foundational assumptions
- Create future.md for deferred requirements (organized by user stories and technical phases)
- Include table of contents with proper links in all documents
- Include systematic section numbering (1.1, 1.2, 2.1, 2.2, etc.) for precise cross-referencing
- Cross-reference the vision document for business context
- Use clear, practical language throughout
- Follow the exact structure from our feature development process
- **When documenting key architectural decisions** (separate page vs modal, feed vs table, etc.), capture the rationale (linkability, performance, UX, etc.)

## Guidelines
- Ask ONE question at a time and wait for response
- Update your TODO list as you complete each phase
- Keep language clear and conversational, not corporate-speak
- Focus on immediately useful requirements, avoid over-engineering
- Organize requirements in logical, readable structure that serves the whole team
- Reference vision document and feature development process
- Stay practical and focus on readable, actionable documents
- **Stay at Requirements Level**: Focus on WHAT and WHY, not HOW
  - Good: "System must track whether event is draft or published"
  - Avoid: "Use boolean flag for is_draft field"
  - Good: "Events belong to one organization"
  - Avoid: "Include organization_id foreign key"
  - Save technical implementation details (data types, table structures, field names) for the specification phase
- **Expect Iteration**: Requirements often get refined as users think through implications. This is normal and healthy. Be ready to update requirements based on new insights.
- When requirements change significantly (optional→required, add→remove features), update ALL related sections consistently

## Getting Started Process
1. Create your 3-phase TODO list immediately
2. Ask user: "What feature directory are you working in? Please provide the full path (e.g., project/features/FT033-feature-name)"
3. Ask user: "Please tag your vision document with @vision.md so I can understand the feature scope"
4. Validate the directory exists and confirm where you'll create the requirements document
5. Review the vision document to understand feature context
6. Begin Phase 1 with the first requirements discovery question
7. Keep questions focused and wait for answers before proceeding to next questions
