---
name: Implement a Plan
description: This skill should be used when the user asks to "implement this plan", "let's implement this plan", "I'm ready to implement this plan", "let's start working on this plan", "let's use this plan", "execute step 3.1", "resume working on this plan at section 4", "review this plan", "let's continue with the plan", or needs guidance on executing, resuming, or reviewing implementation plans with numbered sections and checkboxes.
version: 0.1.0
---

# Implement a Plan

Guidance for executing, resuming, and reviewing implementation plans in a controlled, incremental manner.

## Purpose

This skill ensures consistent, safe implementation of pre-defined plans by:

- Working in granular, committable steps
- Verifying plan accuracy before implementation
- Catching inconsistencies early
- Maintaining clear progress tracking
- Enabling easy rollback if needed

## When This Skill Applies

- **Starting a plan**: User wants to begin implementing a documented plan
- **Resuming a plan**: User returns with fresh context to continue at a specific section
- **Executing a step**: User wants to work on a specific numbered section
- **Reviewing a plan**: User wants to verify plan accuracy before or during implementation

## Core Principles

### 1. Granular Steps

Work step by step through numbered sections (1.1, then pause, review, then 1.2). Never combine multiple steps into one action. Each step should be:

- Small enough to review in isolation
- Independently committable/stageable
- Focused on a single concern

### 2. Sanity Checking Before Implementation

Before implementing any step:

1. Read the relevant code/files the step will modify
2. Look at adjacent patterns in the codebase (how similar things are done)
3. Verify the plan's assumptions match reality
4. Check that dependencies from previous steps are in place

### 3. Stop on Inconsistencies

If the plan contains errors, outdated assumptions, or conflicts with the codebase:

1. **Stop immediately** - do not attempt to implement
2. **Explain the inconsistency** clearly
3. **Suggest alternatives** with tradeoffs
4. **Wait for direction** before proceeding
5. **Update the plan first** before implementing

### 4. Never Jump Ahead

- Complete the current step fully before starting the next
- Wait for user verification after each step
- Do not anticipate or pre-implement future steps
- Respect step dependencies explicitly

### 5. Pattern Following

- Examine how similar features are implemented in the codebase
- Follow existing conventions and abstractions
- Prefer reusing existing patterns over creating new ones
- Note any deviations from patterns and explain why

### 6. Checkpoint Updates

After user verifies a step is complete:

1. Update the plan document to mark checkboxes complete
2. Update any status indicators (e.g., "🚧 In Progress" → "✅ Complete")
3. Report all changed files so user can manage their own Git workflow

## Workflow

### Starting a New Plan

1. **Read the entire plan** to understand scope and dependencies
2. **Identify the starting point** (usually Section 1 or first unchecked item)
3. **Perform sanity check** on the first step before implementing
4. **Confirm with user** the recommended starting point
5. **Wait for approval** before making any changes

### Resuming a Plan

When user says "resume at section X" or similar:

1. **Read the plan document** to understand context
2. **Review completed sections** (checked items) for context
3. **Read the target section** and its prerequisites
4. **Verify prerequisites are complete** by checking the codebase
5. **Perform sanity check** on the target step
6. **Summarize current state** before proceeding

### Executing a Step

For each numbered step or subsection:

1. **Read the step requirements** carefully
2. **Examine adjacent code** to understand patterns
3. **Identify all files** that will be created/modified
4. **Make the minimal changes** required for the step
5. **Run relevant tests** if applicable
6. **Report completion** and wait for user verification

### After User Verification

Once user confirms step is working:

1. **Update plan checkboxes** to mark step complete
2. **Report files changed** so user can review and manage Git themselves
3. **Await instruction** to proceed to next step

## Plan Document Expectations

Plans typically include:

- **Numbered sections** (1, 2, 3...) with subsections (1.1, 1.2...)
- **Task checkboxes** (`- [ ]` incomplete, `- [x]` complete)
- **Code examples** showing expected implementation
- **File paths** for new/modified files
- **Dependencies** between sections

## Common Scenarios

### Scenario: Plan Has Incorrect Code

```
User: "Let's implement section 3.1"
[Section 3.1 shows code that won't work with current codebase]

Response:
1. Explain the inconsistency
2. Show what the code should look like (based on adjacent patterns)
3. Offer to update the plan first
4. Wait for direction
```

### Scenario: Resuming After a Break

```
User: "Let's resume at section 4.2"

Response:
1. Read the plan and current codebase state
2. Summarize: "Sections 1-4.1 are complete. Section 4.2 requires..."
3. Verify prerequisites are in place
4. Perform sanity check on 4.2
5. Proceed or flag issues
```

### Scenario: Step Requires Multiple Files

```
[Step 3.1 creates a service, spec, and updates a model]

Response:
1. Create service file
2. Wait for review
3. Create spec file  
4. Wait for review
5. Update model
6. Wait for review
7. Mark step complete only after all parts verified
```

## Anti-Patterns to Avoid

❌ **Implementing multiple steps at once** - Always one step at a time

❌ **Skipping sanity checks** - Always verify before implementing

❌ **Ignoring inconsistencies** - Always stop and discuss

❌ **Guessing at patterns** - Always examine adjacent code first

❌ **Forgetting plan updates** - Always update checkboxes after verification

❌ **Any Git operations without explicit request** - See critical warning below

## Critical: No Git Operations

**NEVER perform any Git operations unless the user explicitly requests it.**

This includes:
- `git add` / staging files
- `git commit`
- `git push`
- `git checkout` / branch operations
- Any other git commands

The user manages their own Git workflow. After completing a step:

1. Report what files were created/modified
2. Wait for user to review and decide when/how to stage and commit
3. Only perform Git operations if user explicitly says "commit this" or similar

## Handling Large Steps

If a plan step is too large for atomic implementation:

1. **Propose sub-steps** to the user
2. **Get approval** for the breakdown
3. **Update the plan** to reflect sub-steps
4. **Execute sub-steps** individually
