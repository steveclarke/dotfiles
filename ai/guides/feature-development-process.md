# Feature Development Process

This explains how we write documentation for features - what documents we create, how to name them, and the order we write them in.

## Preamble: Why We Work This Way

Our team operates in a unique moment in software history. Traditionally, teams faced a trade-off between **speed** (just start coding) and **certainty** (spend weeks writing detailed specs). Agile methodologies were designed to minimize up-front documentation because writing specs was slow, expensive, and often obsolete by the time development started.

Today, AI and LLM-assisted tooling have transformed this trade-off. With tools like Cursor and AI pair-programming assistants, we can:

* **Write detailed specs quickly** — what once took weeks can now be drafted in hours.
* **Iterate specs cheaply** — we can refine requirements and designs multiple times before writing code.
* **Generate implementation scaffolds directly from specs** — bridging the gap from design to code.
* **Use specs as the single source of truth** — LLMs can consume them to write code, generate tests, and even produce documentation.
* **Let AI read the docs for you** — traditionally, nobody wanted to read lengthy specification documents. Now, AI can read them instantly and answer questions like "What did the requirements say about X again?" without you having to search through pages of documentation.
* **Let AI maintain consistency across documents** — even "small" edits benefit from AI assistance. What seems like a one-word change often requires updates across multiple documents and sections. AI catches these cross-references and maintains consistency in ways that are mentally exhausting for humans. This is what makes comprehensive, multi-document specs actually maintainable.

This enables a **spec-first but agile** process:
we maintain the agility to change direction when needed, but we also benefit from highly structured, traceable documentation that improves communication, makes code generation more accurate, and reduces rework.

Our philosophy can be summarized as:

* **Stay Agile in Spirit:** Short feedback loops, rapid iteration, continuous improvement.
* **Be Spec-Driven in Practice:** Write detailed, LLM-ready documents that define success clearly before coding begins.
* **Build Once, Build Right:** Use documentation to align stakeholders and reduce wasted effort.
* **Keep Documentation Lean:** Add complexity only when necessary — single documents first, split documents as features scale.

By combining agile principles with modern AI-enabled workflows, we get the best of both worlds: speed, clarity, and alignment.

## Table of Contents

- [Feature Development Process](#feature-development-process)
  - [Preamble: Why We Work This Way](#preamble-why-we-work-this-way)
  - [Table of Contents](#table-of-contents)
  - [1. Overview](#1-overview)
    - [AI-Assisted Document Creation](#ai-assisted-document-creation)
    - [Quick Reference: Document Types by Purpose](#quick-reference-document-types-by-purpose)
  - [2. Document Hierarchy](#2-document-hierarchy)
  - [3. Document Types and Purposes](#3-document-types-and-purposes)
    - [3.1. Vision Document](#31-vision-document)
    - [3.2. Requirements Document](#32-requirements-document)
    - [3.3. Technical Specification](#33-technical-specification)
    - [3.4. Design Brief (Optional)](#34-design-brief-optional)
    - [3.5. Implementation Plans](#35-implementation-plans)
    - [3.6. Task Lists (When Needed)](#36-task-lists-when-needed)
    - [3.7. Future Ideas Document (Optional)](#37-future-ideas-document-optional)
  - [4. Naming Conventions](#4-naming-conventions)
    - [4.1. Single Document Approach](#41-single-document-approach)
    - [4.2. Multi-Document Breakdown](#42-multi-document-breakdown)
  - [5. Template Structure](#5-template-structure)
  - [6. Document Flow and Workflow](#6-document-flow-and-workflow)
    - [6.1. Development Sequence](#61-development-sequence)
  - [7. Living Documents](#7-living-documents)
  - [8. Best Practices](#8-best-practices)

## 1. Overview

We write different types of documents for different people. Business documents focus on what we're building and why. Technical documents focus on how we're building it. This keeps things clear and lets each document serve its specific purpose.

**Core Philosophy**: Start simple, add complexity only when needed. Each document is written for specific people and serves a clear purpose.

**LLM-Ready Principle**: All documents should be written clearly and precisely enough that an AI tool could consume them and produce scaffolding code, tests, or additional design documentation. This means:

* Avoiding ambiguous language
* Including enough detail (data shapes, edge cases, acceptance criteria)
* Using consistent naming across documents

### AI-Assisted Document Creation

We provide Cursor commands to streamline document creation with guided, structured processes:

**Available Commands**:
* **`/vision`** - Creates vision documents through structured discovery
* **`/requirements`** - Creates functional and system requirements through structured discovery
* **`/spec`** - Creates technical specifications through architecture and design process
* **`/plan`** - Creates implementation plans through sequencing and task planning process

**Benefits**:
* **Guided Discovery**: Step-by-step questions ensure nothing gets missed
* **Educational**: Learn document structures and best practices through use
* **Consistent Output**: All documents follow our established templates and standards
* **Quality Focus**: Built-in checks for clear language and practical scope

**How to Use**: Simply type the command in any Cursor chat and follow the guided prompts. Commands automatically reference this process guide and your existing feature-related documents for context.

> 🚫 **No Corporate Speak**
> 
> **Write for humans first.** Use clear, simple, understandable language that people can grasp on the first read. Avoid corporate speak, jargon, and unnecessarily complex terminology.
> 
> **These documents are meant to be read and understood**, not to impress anyone with fancy vocabulary. If a team member, stakeholder, or new developer can't understand what you're saying immediately, the document has failed its primary purpose.
> 
> **Examples**:
> - ✅ "Users can see their award history" 
> - ❌ "The system shall facilitate user visibility into their comprehensive recognition lifecycle"
> - ✅ "Staff need to know what awards to distribute"
> - ❌ "Personnel require visibility into pending distribution requirements for recognition artifacts"

### Quick Reference: Document Types by Purpose

| Question | Document Name | File Name | Purpose |
|----------|---------------|-----------|---------|
| **WHY?** | Vision Document | `vision.md` | Strategic context, business case, high-level goals |
| **WHAT & CONSTRAINTS?** | Requirements | `requirements.md` | Business capabilities, user workflows, quality attributes, and system constraints |
| **HOW?** | Technical Specification | `spec.md` | Technical implementation, architecture, how it will be built |
| **WHAT TO DESIGN?** | Design Brief (Optional) | `design-brief.md` | UI/UX guidance for designer - pages, components, interactions (only for features with UI complexity) |
| **WHEN?** | Implementation Plan | `plan.md` | Implementation sequence, phases, when and in what order |
| **TASKS?** | Task Breakdown | `tasks.md` | Granular checklist items (only when plans need to be split from the plan) |
| **LATER?** | Future Ideas | `future.md` | Deferred requirements and ideas for future development phases |

## 2. Document Hierarchy

The standard document progression follows this hierarchy:

```
Vision → Requirements → Technical Specification → Implementation Plans
                              ↓ (optional)
                         Design Brief
```

**Design Brief** is optional - create it for features with UI/UX complexity to give the design team a standalone document. It bridges requirements/spec to actual design work.

Each document builds upon the previous while serving distinct purposes and audiences.

## 3. Document Types and Purposes

### 3.1. Vision Document

**Filename**: `vision.md`
**Audience**: All stakeholders - Product Managers, Business Analysts, Developers, Leadership
**Purpose**: High-level business vision and strategic context

> 💡 In practice, our "Vision Document" does more than just vision. It includes business requirements, user needs, and solution overview - stuff that's usually split across multiple documents. We combine them because it's simpler for our small team and AI tools can work with the combined information better.

**Content Includes**:

* Clear vision statement (the actual "vision" in one sentence)
* Table of contents (with links to all major sections)
* Problem definition and business case
* Solution overview (how we'll solve the problem at a high level)
* Key user needs structured by role (what each user type needs to accomplish)
  - *Example roles to consider (adapt to your context):*
    - Staff Users (daily operations)
    - Admin Users (elevated operations and management)
    - End Users (customer/client-facing features)
    - Organization Admins (org settings and account management)
    - Internal Team (internal tooling and management)
* Core business concepts (domain terminology and key ideas)
* User experience vision (how it should feel to use)
* Future possibilities (nice-to-have features and future enhancements)
* Team decisions (key choices made during planning)

### 3.2. Requirements Document

**Filename**: `requirements.md`
**Audience**: All stakeholders - Product Managers, Developers, Architects, QA, Operations
**Purpose**: Define **what** the system must do and the **quality constraints** it must meet

> 💡 **Consolidated Approach**: We combine business capabilities and system quality attributes in one document because our small team benefits from having all requirements in a single, readable document rather than artificial boundaries that create duplication and confusion.

**Content Includes**:

* **User Stories & Business Needs**: User stories structured by role, business capabilities and workflows
* **Functional Capabilities**: Core system capabilities and user workflows the system must provide
* **Business Data Requirements**: Entities, relationships, business-level attributes and constraints
* **Business Rules & Logic**: Rules and constraints that govern system behavior
* **User Experience Requirements**: How the system should feel and behave for users
* **Quality Attributes & Constraints**: Performance, security, reliability, scalability requirements
* **Integration Touchpoints**: How the system connects with existing systems
* **Development & Testing Approach**: How the system will be built and validated
* **Success Criteria**: Clear acceptance criteria and definition of success
* **Constraints & Assumptions**: Scope boundaries and foundational assumptions

**Excludes**: Technical implementation details, specific technologies, database schemas, API specifications (these belong in technical specifications)

### 3.3. Technical Specification

**Filename**: `spec.md` (start simple) or `spec-[area].md` (when complexity demands)
**Audience**: Developers, Architects, DevOps (how to build it)
**Purpose**: Define **how** the system will be implemented technically

**Content Includes**:

* Data models, schemas, and database design
* API specifications and endpoint definitions
* Technical architecture and design patterns
* Class hierarchies and module organization
* Performance considerations and constraints
* Security implementation details
* Framework-specific patterns and approaches
* JSON structures and validation schemas
* Application type definitions (using your language's type system)
* Cross-references to requirements with precise section numbering (requirements.md#1.2)

**Code Snippets vs Implementation Code**: Technical specifications should include code snippets for illustration purposes (type definitions, data structures, schemas, example API payloads) but should NOT contain complete implementation code. Full working code belongs in implementation plans, not technical specifications.

### 3.4. Design Brief (Optional)

**Filename**: `design-brief.md`
**Audience**: Designer/UI/UX team, Product Manager
**Purpose**: Provide standalone design guidance so designer doesn't need to constantly dig through requirements and technical specs

> 💡 **Optional Document**: Only create for features with UI/UX components requiring designer collaboration. Skip for backend-only features, simple UI updates following established patterns, or when requirements already contain sufficient design detail.

**Content Includes**:

* **Page Inventory**: What pages/screens need to be designed
* **Component Requirements**: What components are needed and what data they display (plain language, no code)
* **Interaction Patterns**: User flows for key interactions (creating, editing, viewing)
* **Form Fields**: What fields, labels, validation rules, help text, character limits
* **Responsive Considerations**: Mobile-first approach, breakpoints, accessibility requirements
* **Design-to-Development Handoff**: What designer should deliver (mockups, component specs, interaction states)

**Writing Principles**:
* ✅ **Plain language** - No code or technical jargon
* ✅ **Data requirements** - "Component displays: title, date, location" not implementation details
* ✅ **Standalone** - Designer shouldn't need to refer back to requirements constantly
* ✅ **Actionable** - Every section helps designer make decisions
* ❌ **Don't prescribe colors/styling** - Let designer make visual design choices
* ❌ **Don't include backend details** - Focus on what user sees and does

**Integration**: Technical spec should include lightweight section that references the design brief and provides quick summary for developers.

### 3.5. Implementation Plans

**Filename**: `plan.md` (simple) or `plan-[area].md` (when complexity demands)
**Audience**: Development teams
**Purpose**: Define **when** and **in what order** implementation occurs

> 💡 Implementation plans typically contain both high-level sequencing and granular task lists in a single document. Separate task documents (Section 3.7) are only created when there's a specific need to split them out (e.g., very long plans, multiple developers needing separate task lists, or requiring more granular tracking).

**Content Includes**:

* Development phases and sequencing
* Granular tasks within each phase with integrated validation and data
* Team-specific implementation approaches
* Dependencies and prerequisites
* T-shirt sizing for effort estimation (Small, Medium, Large) - **do not include time estimates**
* Risk mitigation strategies
* Testing and validation approaches
* Cross-references to technical specifications with precise section numbering (spec.md#1.2)

**Code + Validation Integration**: Each implementation phase includes code with appropriate validation:
* **Testing**: Follow established patterns appropriate to your testing framework when available, or include smoke tests/throwaway scripts when formal patterns don't exist
* **Sample Data**: Phases creating new data models should include realistic sample data for developer use
* **Validation Emphasis**: Developers should always validate their work through testing, scripts, or manual verification

> 🔄 **Iterative Validation Principle**: Finish each phase completely (with code, validation, and sample data when applicable) before starting the next one. This prevents writing lots of code before finding out it doesn't work. Validate your work early and often to catch problems quickly instead of after you've built everything.

### 3.6. Task Lists (When Needed)

**Filename**: `tasks.md` (simple) or `tasks-[area].md` (when complexity demands)
**Audience**: Individual contributors working on implementation
**Purpose**: Break down implementation into discrete, trackable tasks

**When to Use**:

* Multiple developers working on the same area need separate task lists
* Complex features requiring detailed progress tracking
* AI-assisted development workflows needing specific instructions
* Handoff scenarios where tasks move between team members

**Content Includes**:

* Granular, actionable checklist items
* Task dependencies and sequencing
* Completion status tracking
* Specific implementation instructions
* Related test and validation requirements

### 3.7. Future Ideas Document (Optional)

**Filename**: `future.md`
**Audience**: Product team, future developers
**Purpose**: Capture valuable ideas and requirements that are beyond current scope

**When to Capture Future Ideas**:

Future ideas emerge throughout the entire development process, not just during initial planning. Capture them immediately whenever they arise:

* **During Vision & Requirements**: "That's brilliant, but it's too much for Phase 1"
* **During Technical Specification**: "This technical approach enables X in the future"
* **During Implementation**: "We could extend this to support Y later"
* **Any Time**: When discussing features and someone says "that's a great idea, but not now"

The key is to **capture ideas when they emerge** rather than losing them. Writing to the future document is encouraged at any phase - it prevents scope creep while preserving innovation.

**What to Capture**:

* Great ideas that exceed current team capacity or timeline
* Complex features requiring Phase 2/3/4 implementation
* Requirements that are over-engineered for current maturity but valuable later
* User stories and technical enhancements worth preserving

**Content Includes**:

* User stories organized by role ("As a Financial Auditor, I want to...")
* Technical enhancement phases (Phase 2, Phase 3, Phase 4)
* Complex features deferred from current requirements
* Integration possibilities for future consideration
* Advanced functionality that builds on MVP foundation

**Benefits**:

* **Preserves Innovation**: Capture great ideas without cluttering current scope
* **Future Planning**: Organized backlog for subsequent development phases
* **Team Alignment**: Clear separation between "now" and "later" features
* **Stakeholder Communication**: Shows awareness of broader possibilities while maintaining focus

## 4. Naming Conventions

### 4.1. Single Document Approach

**Default Starting Point**: Begin with single documents and split only when complexity demands it.

```
FT### - Feature Name/
├── vision.md
├── requirements.md
├── spec.md
└── plan.md
```

### 4.2. Multi-Document Breakdown

**When Complexity Demands**: Split into specialized documents only when a single document becomes unwieldy.

**Technical Specifications**:

* `spec-architecture.md` - Overall system design and architecture
* `spec-frontend.md` - Frontend-specific technical decisions
* `spec-backend.md` - Backend-specific technical decisions
* `spec-api.md` - API contract specifications
* `spec-database.md` - Database schema and optimization
* `spec-security.md` - Security implementation details

**Implementation Plans**:

* `plan-frontend.md` - Frontend implementation sequencing
* `plan-backend.md` - Backend implementation sequencing
* `plan-design.md` - Visual design and UX implementation
* `plan-operations.md` - Infrastructure and deployment approach

**Task Lists** (when needed):

* `tasks-frontend.md` - Frontend-specific task breakdown
* `tasks-backend.md` - Backend-specific task breakdown
* `tasks-design.md` - Design-specific task breakdown

## 5. Template Structure

Each feature directory should be structured to support this documentation flow:

```
[FT### - Feature Name]/
├── vision.md          # Strategic context and goals
├── requirements.md    # Business capabilities, workflows, and quality constraints
├── spec.md           # Technical implementation (start here)
├── design-brief.md   # UI/UX guidance for designer (optional - only if UI complexity)
└── plan.md           # Implementation sequencing (start here)
```

**Evolution path** as complexity grows:

```
[FT### - Feature Name]/
├── vision.md
├── requirements.md
├── spec-architecture.md         # Split when needed
├── spec-frontend.md            # Split when needed  
├── spec-backend.md             # Split when needed
├── design-brief.md             # Optional - for UI/UX complexity
├── plan-frontend.md            # Split when needed
├── plan-backend.md             # Split when needed
├── plan-design.md              # Split when needed
├── tasks-frontend.md           # When multiple developers on same area
└── tasks-backend.md            # When multiple developers on same area
```

## 6. Document Flow and Workflow

### 6.1. Development Sequence

| Phase | Document | Purpose | Who's Involved |
|-------|----------|---------|----------------|
| 1 | **Vision Document** | Define strategic context and high-level goals | **Entire team** |
| 2 | **Requirements Document** | Specify business capabilities, user workflows, and quality constraints | **Entire team** |
| 3 | **Technical Specification** | Design implementation approach and architecture | Developers, Architects, DevOps |
| 4 | **Design Brief** (optional) | Extract UI/UX guidance for designer when feature has UI complexity | Designers, Product Manager |
| 5 | **Implementation Plans** | Sequence development and allocate resources (includes granular tasks) | Development team OR individual developers working on specific areas |
| 6 | **Task Lists** (optional) | Break down plans into discrete trackable items when needed | Individual developers working on specific areas |

## 7. Living Documents

* **All documents are revisable**: Discovery during development can lead to revisions of any document in the hierarchy
* **Upstream revision freedom**: Technical discoveries may warrant updates to functional requirements or even vision documents
* **AI-enabled agility**: Modern tooling allows us to maintain detailed specs while preserving the ability to iterate quickly
* **Exception awareness**: Customer commitments or contractual obligations may require formal change processes
* **Default assumption**: Unless explicitly locked down, all documents should be treated as living and evolving

> 💡 **The Living Documents Advantage**: Unlike old-school development where changing early decisions was expensive and painful, AI tools let us quickly update our documents when we find better solutions. We can keep detailed specs but still be flexible when we learn something new.

## 8. Best Practices

> 💡 **Always Start with Vision & Involve the Whole Team**
> 
> While not every feature requires all document types, we **highly recommend always having a vision document**. There's nothing like taking the time to envision what we want so that everybody agrees on the direction.
> 
> **Team Involvement in Early Phases**:
> * **Vision**: Ideally, the **entire team should be involved in vision** whenever possible. It's surprising how much better outcomes are when the whole team participates in envisioning the future. If in doubt, include the full team.
> * **Requirements**: Similarly, the **full team is valuable during requirements** - this is where the most discussion, visioning, workshopping, and dreaming happens. This is where we hash out technical possibilities, time availability, and constraints together.
> * **Later Phases**: As you move into technical specifications and implementation plans, team involvement can become more specialized (frontend devs, backend devs, designers working on their respective areas).
> 
> **When in doubt, involve the whole team in vision and requirements.**

> 💡 **Let AI Handle All Edits, Even Small Ones**
> 
> You might think "I can just change this one word myself" — but you'd be surprised how often that "small" change needs to ripple through multiple documents. The AI will catch that a term change in requirements needs to update the technical spec, the implementation plan, and three cross-references you forgot about.
> 
> **This capability is what makes our comprehensive documentation approach viable.** Without AI maintaining consistency, the cognitive load of keeping multiple detailed documents in sync would force us back to minimal documentation. Let the AI do the work — it's faster and more thorough than manual updates.

1. **Start with the simplest structure** that serves your feature's needs
2. **Use consistent naming** across all features for easy navigation (document-type first: `plan-frontend.md`, `tasks-backend.md`)
3. **Reference other documents** rather than duplicating technical implementation details in requirements
4. **Write for your audience** - avoid technical jargon in business documents
5. **Keep documents focused** - each document should serve a clear, distinct purpose
6. **Update cross-references** when splitting or renaming documents
7. **Keep tasks in plans by default** - Most features need both sequencing and tasks in one document. Only split into separate task documents when multiple people need different task lists for the same area
8. **Include complete work items** - Each task section should include related code, tests, and sample data requirements
9. **Specify test structure, not test code** - Plans should include test outlines (describe/context blocks and test case descriptions) that define *what* to test, but not the actual test implementation code. Example: `describe User { it "validates email format" }` not the full test body with expectations and assertions
10. **LLM Readiness** - Write documents clearly enough that they can be consumed by AI tools for code, test, and plan generation

---

By combining detailed, AI-enabled documentation with agile principles, we get the best of both worlds: the clarity and alignment that specs provide, with the flexibility and speed that modern development demands. These practices aren't about creating bureaucracy—they're about creating shared understanding that makes building software faster, better, and more enjoyable for everyone involved.
