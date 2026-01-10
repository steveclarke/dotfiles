# Requirements

## Overview
Structured command to help create a requirements document by guiding through requirements discovery, practical scoping, and generating a single, consolidated requirements document with clear, practical language.

You are helping create a requirements document following our established feature development process. First, read our feature development guide at @~/.local/share/dotfiles/ai/guides/feature-development-process.md and the vision document at @vision.md to understand the feature scope and our documentation approach.

Note: If the project has a local copy of the guide at @project/guides/feature-development-process.md, you may reference that instead for project-specific modifications.

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

## Requirement Identification Format

All requirements must use systematic ID prefixes for easy cross-referencing in
specs, plans, and discussions.

| Prefix | Usage | Numbering |
|--------|-------|-----------|
| `US-X.X.X` | User Stories | Section.Subsection.Item |
| `REQ-X.X.X` | Requirements | Section.Subsection.Item |
| `SC-X` | Success Criteria | Sequential number |

**Format Examples**:
```markdown
**US-1.1.1**: As a staff member, I want to view custom field data...

**REQ-2.1.1**: The system must render form controls dynamically based on...

**SC-1**: Staff can view custom field values on detail pages.
```

**Numbering Rules**:
- Numbers follow document section hierarchy (section 2.1 → REQ-2.1.x)
- User stories in section 1.1 use US-1.1.1, US-1.1.2, etc.
- Requirements in section 3.2 use REQ-3.2.1, REQ-3.2.2, etc.
- Success criteria use simple sequential numbers (SC-1 through SC-N)

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
- Apply ID prefixes to all user stories (US-), requirements (REQ-), and success
  criteria (SC-) following the Requirement Identification Format above
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
- **Update or create discussion-summary.md**:
  - Check if discussion-summary.md exists in the feature directory
  - If exists: Add a "Requirements Phase" section with:
    - Technical discussions and research from requirements phase
    - "Resolved Questions from Vision" subsection (table showing what was open and how resolved)
    - Update Key Decisions Log with new decisions (continuing numbering from vision)
    - Update Technical Context with newly referenced files
  - If not exists: Create it with full structure including Vision Phase placeholder
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
