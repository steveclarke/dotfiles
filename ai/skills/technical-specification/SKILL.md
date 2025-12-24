---
name: technical-specification
description: Creates concise technical specification documents through 3-4 phase process. Guides through architectural decisions, system contracts, and technical design without getting bogged down in implementation details. Use when user wants to create a technical specification, needs to define how the system will be implemented technically, or is documenting architecture, data contracts, API specifications, and system components. Follows established feature development process with concise (5-10 page) specs focused on WHAT and WHY, not HOW to code. Optionally creates design brief for features with UI/UX complexity.
---

# Technical Specification Creation

## Overview

Structured skill to help create concise technical specification documents by guiding through architectural decisions, system contracts, and technical design without getting bogged down in implementation details.

## Required Context

You have comprehensive context available:

**Required Reading**:
- Feature development guide: `@~/.local/share/dotfiles/ai/guides/feature-development-process.md`
- Vision document: `@vision.md`
- Requirements document: `@requirements.md`

Note: If the project has a local copy of the guide at `@project/guides/feature-development-process.md`, reference that instead for project-specific modifications.

**Additional Context Available**:
- **Full Codebase**: Examine existing patterns in backend/ and frontend/ directories
- **Implementation Guides**: Review backend/docs/guides/ and frontend/docs/guides/ for established patterns
- **Design Context**: Use available MCP connections for design system access where relevant

**Approach**: Use all available context to inform your technical decisions. Most implementation patterns and architectural decisions should be derived from existing codebase analysis rather than asking basic questions.

**IMPORTANT**: Start by creating a TODO list to track phases of specification creation (typically 3 phases; add optional Phase 4 for design brief if feature has UI/UX complexity). Mark the first phase as "in_progress" and others as "pending".

## Technical Specification Structure

**CRITICAL**: Specs define architecture and system contracts, NOT implementation details. Keep specs concise (5-10 pages) focused on WHAT and WHY, not HOW to code.

**Specs Include**:
- **Architecture Overview**: Core decisions and system structure
- **System Components**: What pieces exist and their roles/contracts
- **Data Contracts**: Type definitions (frontend/backend appropriate to your language), database schemas, API contracts
- **Configuration Architecture**: How the system is configured (not detailed examples)
- **Integration Patterns**: How it fits with existing systems
- **Quality Attributes**: Performance, reliability, maintainability requirements

**Specs DO NOT Include**:
- ❌ Implementation code examples (those go in plans)
- ❌ Step-by-step implementation details
- ❌ Repetitive explanations of the same concepts

## Process: Work Through These 3 Phases Sequentially

### Phase 1: Context Analysis & Scope Confirmation
First, analyze the available context to understand the feature scope:

**Context Analysis**:
1. Review the vision and requirements documents to understand the feature scope
2. Examine the codebase to identify existing patterns and architectural approaches
3. Check implementation guides in backend/docs/guides/ and frontend/docs/guides/ for relevant patterns
4. Identify similar existing features to follow established patterns

**Scope Confirmation** - Ask clarifying questions only as needed:
- Based on the requirements, this appears to be [full-stack/backend-only/frontend-only/background processing] - is this correct?
- Are there any specific implementation constraints or preferences not covered in the requirements?
- Is this a complete feature implementation or a specific phase (e.g., "Phase 1: Backend foundation")?
- Any existing systems integration requirements beyond what's documented?

**Goal**: Confirm technical scope and identify relevant existing patterns to follow.

**ONE QUESTION AT A TIME** - Wait for answers before proceeding.

### Phase 2: Implementation Design Using Existing Patterns
Based on codebase analysis and scope confirmation, design implementation following established patterns:

**Design Approach**:
1. **Follow Existing Patterns**: Use similar features in the codebase as templates
2. **Apply Established Conventions**: Follow patterns found in implementation guides
3. **Leverage Existing Systems**: Integrate with established RBAC, multi-tenancy, etc.
4. **Ask Specific Questions**: Only ask about unique aspects not covered by existing patterns

**For Backend/Database work:**
- Model data following existing entity patterns and relationships
- Define service contracts using appropriate type definitions for your language
- Design API endpoints following established REST conventions and response formats
- Use type definitions to document API request/response contracts and data structures
- Apply standard authorization permissions and validation patterns
- **Search Integration**: Determine search scope and indexing strategy
  - Does search need own entity fields only, or related entity data?
  - Document search configuration approach
- **Sort Parameters**: Document sortable columns and default sort behavior
  - List specific sortable columns
  - Specify default sort order
- **Multi-Context Considerations**: For features spanning multiple application contexts (internal/external, admin/user, etc.)
  - Create separate response structures when contexts need different data
  - Example: External-facing may exclude internal fields that admin context needs
  - Always create explicit separation for security isolation, even if currently identical
- **Permitted Parameters**: Document allowed parameters for each context
  - List fields that can be created/updated
  - Note any fields excluded (generated, computed, or restricted)
- **Multi-Context Authorization**: For features with multiple contexts, define permissions for each
  - Internal context: Full CRUD permissions
  - External context: Limited permissions (often read-only)
  - Public API: May use different authentication (API keys vs session auth)
  - Same permission name may exist in multiple contexts with different scopes
- Ask: Any unique business logic, constraints, or data relationships not seen in similar features?

**For Frontend/UI work:**
- Follow existing UI component architecture and data contract patterns
- Use established responsive and navigation integration approaches
- Apply standard design system and component library usage
- **Type Organization**: Determine if types should be context-specific or shared
  - Context-specific types: When different parts of the application need different data structures
  - Shared/core types: Only for truly shared types across all contexts
  - Request payload types: Colocate with the code that uses them
- Ask: Do different contexts need the same data structure, or different subsets?
- Ask: Any unique UI interactions or integration requirements?

**For Background Processing:**
- Follow existing job processing and scheduling patterns
- Apply standard error handling and monitoring approaches
- Ask: Any unique processing requirements or timing constraints?

**Goal**: Leverage existing codebase patterns and ask only about unique implementation aspects.

### Phase 3: Specification Document Creation
**Goal**: Create a concise (5-10 pages), architectural specification focused on system design and contracts.

**Recommended Section Flow**:

Organize sections to flow naturally from foundational data through backend to frontend, allowing each discipline to read contiguously:

1. **Overview** - Universal context (everyone reads)
2. **Architecture Overview** - Core design decisions (everyone reads)
3. **Data Architecture** - Database schema, models, validation (backend starts here)
4. **API Architecture** - Endpoints, request/response contracts (backend continues)
5. **Authorization Architecture** - Permissions, policies (backend continues)
6. **Integration Architecture** - Search, audit, documents, external systems (backend continues)
7. **Frontend Architecture** - Types, components, pages (frontend reads, referencing API section as needed)
8. **Design & UX Requirements** - Design brief reference and dev summary (designers + frontend)
9. **Configuration Architecture** - Settings, feature flags (supporting concerns)
10. **File Organization** - Where files live (supporting concerns)
11. **Quality Attributes** - Performance, security, reliability (supporting concerns)

**Why This Flow Works**:
- **Contiguous reading**: Backend devs read sections 1-6, frontend devs read 1-2 + 7-8
- **Natural progression**: Data layer → Backend → Presentation → Supporting concerns
- **No jumping around**: Each discipline gets their content in one block
- **Shared foundation**: Everyone starts with overview and architecture context

**Flexibility**: Omit sections not relevant to your feature (e.g., backend-only features skip Frontend/Design sections).

**Key Sections to Include**:

- **API Architecture** (if backend/API work):
  - Endpoint definitions (routes, parameters, query params, sortable columns)
  - Request/Response Contracts (BACKEND ONLY - structure and format)
    - List response template/serializer files (architecture)
    - Show entity structure per context (contract)
    - Show response wrappers (collection/single entity patterns)
    - Show request payload examples
    - Document permitted attributes
    - NO implementation code - that's for the plan
    - Keep backend contracts separate from frontend types

- **Authorization Architecture** (if authorization required):
  - Permission Definitions (separate by context)
    - Internal context permissions (full access category)
    - External context permissions (limited access category)
    - Note if public API uses different authentication
  - Authorization Policy Contracts (type definitions for each context)
    - Name policies by context: "Internal Policy", "External Policy"
    - Public API: May use API key authentication instead of role-based
    - Add Authorization Notes referencing permissions section (don't repeat permissions)

- **Frontend Architecture** (if UI work):
  - Type Definitions (using your frontend language's type system)
    - Entity interfaces (one per context if different)
    - Response wrapper types
    - Request payload types (colocated with usage)
    - Context-specific vs shared type decisions
  - Components, modules, pages (organized by context)
    - Start each context section with "File Summary" (routes, pages, modules, types, components)
    - Follow with "Detailed Breakdown" for implementation details
    - File Summary gives developers quick reference cheat sheet

**Spec Content Guidelines**:
- **Include table of contents** with systematic section numbering (1.1, 1.2, 2.1, 2.2, etc.) following markdown standards
- **Architecture Overview**: Core decisions, technology choices, system structure
- **System Components**: Define component roles and contracts using appropriate type definitions for your language
- **Data Architecture**: Database schemas, API contracts, event structures - show the shape/contract, not implementation
- **Configuration Architecture**: How components are configured (environment variables, config files) - not detailed examples
- **File Organization**: Where components live and why
- **Quality Attributes**: Performance, reliability, maintainability considerations
- **Integration Patterns**: How it connects to existing systems

**Backend API Response Design** (Request/Response Contracts):
- ✅ **Focus on response structure**: Show what the response should look like, not how to build it
- ✅ **File architecture**: List response template/serializer files to show where logic lives
- ✅ **Response examples**: Provide concrete examples for each context
- ✅ **Pure backend focus**: Keep frontend types separate from backend contracts
- ✅ **Context-specific separation**: For multi-context features, show separate contracts
  - Example: Internal API entity (full data with internal fields)
  - Example: External API entity (limited data, public fields only)
  - Example: Public API entity (if different from external)
- ✅ **Wrapper patterns**: Show how entities are wrapped (e.g., data and metadata keys)
- ✅ **Standard patterns**: Reference standard pagination/filtering patterns without spelling out every field
- ❌ **No implementation code**: Save implementation details for the plan
- ❌ **No repetitive examples**: Reference earlier contracts instead of duplicating

**Frontend Type Definitions**:
- ✅ **Context-specific types**: Types should be organized by context when they have different data structures
  - Internal context may need full entity with all fields
  - External context may need simplified entity with limited fields
- ✅ **Shared types**: Only use shared/core types for truly universal types across all contexts
- ✅ **Request payload types**: Colocate with the code that uses them, not in separate type files
  - Follow naming pattern appropriate to your framework
- ✅ **Match backend structure**: Frontend types should mirror backend responses exactly
- ✅ **Include imports**: Show proper import statements for shared types

**Writing Guidelines**:
- ✅ **Keep it concise**: Each concept explained once, no repetition
- ✅ **Focus on contracts**: Type definitions, database schemas, API structures
- ✅ **Architectural decisions**: WHAT you're building and WHY, not HOW to code it
- ✅ **Clear structure**: Logical flow from overview → components → integration
- ✅ **Backend/Frontend separation**: Keep API sections pure backend (response structure), Frontend sections pure frontend (types)
- ❌ **No implementation code**: No detailed code examples (save for implementation plans)
- ❌ **No repetitive examples**: If you show a pattern once, don't show it again
- ❌ **Keep layers separate**: API contracts separate from frontend types

### Phase 4: Design Brief Creation (Optional)
**When to Create**: Features with UI/UX components that require designer collaboration.

**When to Skip**: 
- Backend-only features
- Simple UI updates following established patterns
- Features where requirements already contain sufficient design detail

**Goal**: Extract design-relevant information into standalone document so designer doesn't need to dig through requirements and spec.

**Design Brief Content** (`design-brief.md`):
- **Page Inventory**: What pages/screens need to be designed
- **Component Requirements**: What components are needed and what data they display (plain language, no code)
- **Interaction Patterns**: User flows for key interactions
- **Form Fields**: What fields, labels, validation rules, help text
- **Responsive Considerations**: Mobile-first, breakpoints, accessibility
- **Design Deliverables**: What designer should provide to developers

**Writing Guidelines**:
- ✅ **Plain language**: No code or technical jargon
- ✅ **Data needs**: "Component displays: title, date, location" not implementation
- ✅ **Standalone**: Designer shouldn't need to refer back to requirements
- ✅ **Actionable**: Every section helps designer make decisions
- ❌ **Don't prescribe colors**: Let designer make visual choices
- ❌ **Don't include backend details**: Focus on what user sees/does

**Spec Integration**: Add lightweight section in spec.md that references the full design brief and provides quick summary for developers.

## Reference Materials

When working on specifications, refer to these detailed guides as needed:

- **Codebase Patterns**: See [references/patterns.md](references/patterns.md) for backend, frontend, and authorization patterns to examine in existing code
- **Implementation Guides**: See [references/implementation-guides.md](references/implementation-guides.md) for how to reference project implementation guides in specs
- **Multi-Context Patterns**: See [references/multi-context-patterns.md](references/multi-context-patterns.md) for architecture patterns when features span multiple application contexts
- **Common Pitfalls**: See [references/pitfalls.md](references/pitfalls.md) for a checklist of common mistakes to avoid in backend/API, frontend/type, and general spec sections

## Guidelines
- **Context First**: Always analyze existing codebase patterns and implementation guides before asking questions
- **Smart Questions**: Ask only about unique aspects not covered by existing patterns
- **Pattern Following**: Base technical decisions on established codebase conventions
- **Architectural Focus**: Define system structure and contracts, not implementation steps
- **Concise Communication**: Explain each concept once clearly, avoid repetition
- **Minimal Interaction**: Leverage comprehensive context to reduce back-and-forth questions
- **Update TODO list** as you complete each phase
- **Phase 1**: Analyze context and confirm scope rather than basic discovery
- **Phase 2**: Design using existing patterns, ask only about unique aspects
- **Phase 3**: Create architectural specification showing system contracts and decisions
- **Phase 4 (Optional)**: Create design brief for features with UI/UX complexity to give designer standalone document
- **Business Context**: Reference vision and requirements for understanding, not for traceability
- **Practical Focus**: Design immediately buildable solutions using proven patterns
- **Backend/Frontend Separation**: Keep backend contracts separate from frontend types

## Getting Started Process
1. Create your TODO list immediately (3 phases, or 4 if design brief needed)
2. Ask user: "What feature directory are you working in? Please provide the full path (e.g., project/features/FT033-feature-name)"
3. Ask user: "Please tag your vision document with @vision.md and requirements document with @requirements.md"
4. Validate the directory exists and confirm where you'll create spec.md
5. Review the vision and requirements document to understand feature context
6. Begin Phase 1 with the first technical discovery question
7. Keep questions focused and wait for answers before proceeding to next questions
