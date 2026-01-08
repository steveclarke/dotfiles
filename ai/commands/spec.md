# Technical Specification

## Overview
Structured command to help create concise technical specification documents by guiding through architectural decisions, system contracts, and technical design without getting bogged down in implementation details.

You are helping create a technical specification document following our established feature development process. You have comprehensive context available:

**Required Reading**:
- Feature development guide: @~/.local/share/dotfiles/ai/guides/feature-development-process.md
- Vision document: @vision.md
- Requirements document: @requirements.md

Note: If the project has a local copy of the guide at @project/guides/feature-development-process.md, you may reference that instead for project-specific modifications.

**Additional Context Available**:
- **Full Codebase**: Examine existing patterns in backend/ and frontend/ directories
- **Implementation Guides**: Review backend/docs/guides/ and frontend/docs/guides/ for established patterns
- **Design Context**: Use available MCP connections for design system access where relevant

**Approach**: Use all available context to inform your technical decisions. Most implementation patterns and architectural decisions should be derived from existing codebase analysis rather than asking basic questions.

**IMPORTANT**: Start by creating a TODO list to track phases of specification creation (typically 3 phases; add optional Phase 4 for design brief if feature has UI/UX complexity). Mark the first phase as "in_progress" and others as "pending".

## Technical Specification Structure

**CRITICAL**: Specs define architecture and system contracts, NOT implementation
details. Keep specs concise (5-10 pages) focused on WHAT and WHY, not HOW
to code.

**Specs Include**:
- **Architecture Overview**: Core decisions and system structure
- **System Components**: What pieces exist and their roles/contracts
- **Data Contracts**: Type definitions (frontend/backend appropriate to your language),
  database schemas, API contracts
- **Configuration Architecture**: How the system is configured (not detailed
  examples)
- **Integration Patterns**: How it fits with existing systems
- **Quality Attributes**: Performance, reliability, maintainability
  requirements

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
**Goal**: Create a concise (5-10 pages), architectural specification focused
on system design and contracts.

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

---

**Key Sections to Include** (details for each section type):

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
- **System Components**: Define component roles and contracts using appropriate
  type definitions for your language
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

## Codebase Patterns to Reference

Always examine existing code before making technical decisions:

**Backend Patterns**:
- **API responses**: Check existing response templates/serializers for multi-field entity examples
- **Response wrappers**: Check how entities are wrapped (data and metadata patterns)
- **Search patterns**: Review how search functionality is implemented
- **Context separation**: Look for existing patterns where different contexts need different responses

**Frontend Patterns**:
- **Type organization**: Review existing type files for entity and response type patterns
- **Data mutations**: Review existing patterns for create/update operations
- **Context-specific types**: Review existing features that have context-specific vs shared types
- **Response structure**: See how frontend types mirror backend responses

**Authorization Patterns**:
- **Permission organization**: Review how permissions are organized by context
- **Context-specific permissions**: Same permission name may exist in different contexts with different scopes
- **Policy structure**: Check existing authorization policy patterns
- **Public API**: Note if public API uses different authentication (API keys vs sessions)

## Implementation Guides

If your project has implementation guides, reference them instead of including implementation code in specs. Specs should mention WHAT needs to be implemented and reference the appropriate guide for HOW to implement it.

**Common guide topics to consider**:
- Search functionality patterns
- File upload and attachment patterns
- Audit trail / change tracking
- Multi-tenancy approaches
- Role-based authorization
- State machine patterns
- Testing patterns and conventions
- Authentication strategies
- Database migration best practices

**How to Reference Guides in Specs** (if your project has them):
- ✅ "See implementation guide for search configuration details"
- ✅ "Follow established patterns for file attachment handling"
- ✅ "Reference authorization guide for permission structure"
- ❌ Don't include implementation code in specs
- ❌ Don't duplicate guide content in specifications

## Multi-Context Architecture Patterns

When features span multiple application contexts (internal, external, public), follow these patterns:

**Complete Separation Principle**:
- **Handlers/Controllers**: Separate request handlers for each context
- **Response Templates**: Separate response structures for each context, even if currently identical
- **Authorization**: Separate authorization policies for each context; Public API may use different auth
- **Permissions**: Define permissions for each context with appropriate scopes
- **Types**: Context-specific types when data structures differ
- **Routes**: Different route namespaces or prefixes for each context

**Why Complete Separation**:
- **Security**: Prevents accidental data leakage between contexts
- **Flexibility**: Each context can evolve independently
- **Clarity**: Clear boundaries make intent explicit
- **Maintenance**: Changes to one context don't affect others

**Common Context Patterns**:
- Internal/Admin context: Full CRUD, includes management and audit fields
- External/User context: Limited operations, excludes internal fields
- Public API: Often most restricted, may use different authentication (API keys vs sessions)

## Common Spec Pitfalls to Avoid

### Backend/API Section Pitfalls
❌ **Showing implementation code** - Show response structure, not how to build it  
❌ **Mixing layers** - Keep API sections pure backend, frontend types separate  
❌ **Over-engineering search** - Only add complex search when actually needed  
❌ **Unnecessary fields** - Ask whether audit/timestamp fields belong in API responses  
❌ **Spelling out standard patterns** - Reference standard patterns without repeating details  
❌ **Wrong location for parameters** - Document permitted attributes in authorization layer  
❌ **Reusing structures across contexts** - Always create separate structures for security  
❌ **Missing context authorization** - Define permissions for all contexts  
❌ **Generic "everything is sortable"** - List specific sortable columns  
❌ **Inconsistent authentication** - Document different auth approaches per context  

### Frontend/Type Section Pitfalls
❌ **Shared types for context-specific data** - Different contexts often need different type structures  
❌ **Centralizing request types** - Keep them colocated with usage  
❌ **Repetitive type definitions** - Don't duplicate types in API and Frontend sections  
❌ **Missing imports** - Type definitions need proper import statements  
❌ **Unused imports** - Only import types that are actually used  
❌ **Missing File Summary sections** - Start each context with quick reference cheat sheet  

### General Spec Pitfalls
❌ **Too much implementation code** - Specs define contracts, plans define implementation  
❌ **Repetitive examples** - Show pattern once, reference it elsewhere  
❌ **Missing architecture notes** - Explain WHY things are separate (security, isolation)  
❌ **Repeating permissions** - Reference Permission Definitions section, don't duplicate

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
