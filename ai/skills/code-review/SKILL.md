---
name: code-review
description: Comprehensive code review process for conducting thorough, educational, and actionable code reviews. Use when reviewing pull requests, code changes, feature branches, conducting code quality assessments, or providing feedback on implementations.
---

# Code Review Process

Conduct thorough code reviews that provide constructive, actionable, and educational feedback.

## Review Workflow

### Phase 1: Initial Comprehensive Scan

Analyze all changes for:

**Security:**
- Input validation and sanitization
- Authentication and authorization
- Data exposure risks
- Injection vulnerabilities
- Sensitive data handling
- Access control patterns

**Performance & Efficiency:**
- Algorithm complexity
- Memory usage patterns
- Database/data store query optimization
- Caching strategies
- Unnecessary computations
- Resource management

**Code Quality & Patterns:**
- Readability and maintainability
- Naming conventions (functions, variables, classes)
- Function/class size and Single Responsibility
- Code duplication (DRY principle)
- Consistency with established patterns
- Magic numbers and hardcoded values

**Architecture & Design:**
- Design pattern usage and appropriateness
- Separation of concerns
- Dependency management
- Error handling strategy
- API/interface design
- Data modeling decisions
- Module organization and coupling

**Testing Coverage:**
- Test completeness and quality
- Test organization and naming
- Mock/stub usage patterns
- Edge case coverage
- Test maintainability
- Integration vs unit test balance

**Documentation:**
- API documentation (language-appropriate: YARD, TSDoc, JSDoc, docstrings, etc.)
- Code comments (what/why, not how)
- README updates if needed
- Breaking changes documented
- Migration/upgrade guides if needed

### Phase 2: Feature Documentation Verification

Ask the user: "Are there feature documents I should cross-check against? (spec, requirements, plan)"

If structured feature documentation exists:

**Check against Spec (Primary):**
- Verify all specified features are implemented
- Check data models match specifications
- Verify API contracts match spec
- Confirm UI components match spec (if applicable)
- Flag any deviations or incomplete items

**Check against Plan (Implementation):**
- Verify implementation approach matches planned approach
- Check that all planned phases/tasks are complete (for this PR)
- Identify any architectural deviations
- Note any planned features that are missing

**Check against Requirements (Context):**
- Ensure implementation satisfies stated requirements
- Verify edge cases from requirements are handled
- Check that acceptance criteria are met

### Phase 3: Test Pattern Analysis

Review test files specifically for:

**Test organization:**
- Logical grouping and nesting
- Clear test descriptions
- One assertion per test (when practical)
- Proper setup/teardown

**Testing guidelines conformance:**
- File organization (location, naming)
- Test data creation patterns
- Mock/stub usage
- Shared setup/context usage
- Test naming conventions

**Common anti-patterns:**
- Testing private methods/implementation details
- Over-specification (testing framework internals)
- Missing edge cases
- Brittle tests (fragile assertions, tight coupling)
- Test data pollution (outer contexts with excessive shared setup that bleeds into unrelated tests - use nested contexts to scope data appropriately)
- Global state mutation
- Time-dependent tests without proper mocking
- Flaky tests (non-deterministic behavior)

### Phase 4: Guided Walkthrough

**Step 1: Present Issue Summary**

Before diving into details, give the user a brief overview of all issues found:

```
I found 13 issues total across the PR:

🔴 Critical Issues (Must Fix):
1. SQL injection vulnerability - Unsanitized user input in query
2. Authentication bypass - Missing permission check in controller

⚠️ Required Changes (Must Fix):
3. N+1 query pattern - Missing eager loading for associations
4. Error handling missing - No try/catch for external API calls
5. Naming inconsistency - Mixed camelCase and snake_case in same module
6. Code duplication - Repeated logic across three files
7. Missing documentation - Public API methods lack doc comments

💡 Suggestions (Consider):
8. Extract magic numbers - Repeated constants should be named
9. Consider caching - Expensive computation called multiple times

📚 Testing Issues:
10. Missing edge case tests - Null/empty input scenarios not covered
11. Test data setup redundancy - Shared context too broad for nested tests

📝 Advisory:
12. Consider refactoring for future - Current approach doesn't scale well

I'll now walk through each issue with you one at a time to discuss what you'd like to do.
```

**Key points for the summary:**
- List each issue with a brief description (5-10 words)
- Include the file/location when helpful for context
- Group by priority level
- Keep it scannable - user should understand scope in 30 seconds
- Total count at the top

**Step 2: Interactive Walkthrough Process**

Don't dump all details at once. Use this interactive process:

1. **Present issues in priority order:**
   - Critical Issues (must fix before merge)
   - Required Changes (must fix)
   - Suggestions (should consider)
   - Testing Issues (test pattern improvements)
   - Advisory Notes (future considerations)

2. **For each issue, ask the user:**
   - Present the problem
   - Show current code
   - Propose solution(s)
   - Explain rationale
   - Wait for user decision

3. **Track all decisions:**
   - Keep a running list of what the user decided for each issue
   - Note any items deferred or skipped
   - Document any custom solutions the user suggests

4. **Remember context:**
   - User may correct your understanding
   - User may provide additional context
   - Adjust subsequent recommendations based on decisions

### Phase 5: Generate Structured Review Document

Create a markdown document with this structure:

```markdown
# PR Review: [Feature Name] ([branch-name])

**Date:** [Current Date]
**Reviewer:** [Name]
**Branch:** [branch-name]
**Base:** [base-branch]
**Changes:** [file count, insertions, deletions]

## Summary
[Brief overview of what the PR implements]

**Overall Assessment:** ⭐⭐⭐⭐⭐ (X/5) - [One-line assessment]

---

## 📋 Quick Reference Checklist

### 🔴 Critical Issues (Must Fix Before Merge)
- [ ] **Issue #1:** [Short description]
  - **File:** [path] (line X)
  - **Details:** See §1 below

### ⚠️ Required Changes (Must Fix Before Merge)
- [ ] **Issue #X:** [Short description]
  - **File:** [path] (lines X-Y)
  - **Details:** See §X below

### 💡 Suggestions (Consider)
- [ ] **Issue #X:** [Short description]
  - **File:** [path]
  - **Details:** See §X below

### 📚 Testing Issues (If Applicable)
- [ ] **Issue #X:** [Short description with specific line numbers]
  - **File:** [path]
  - **Lines to fix:** [specific lines]
  - **Details:** See Appendix A below

### 📝 Advisory Notes (Future Considerations)
- [ ] **Issue #X:** [Short description]
  - **Details:** See §X below (not blocking)

---

## 🔴 Critical Issues (Must Fix)

### 1. [Issue Title]

**Files:**
- `[full/path/to/file]` (lines X-Y)

**Issue:**
[Clear description of the problem]

**Current code:**
```language
[Exact problematic code]
```

**Solution:**
[Recommended fix]

```language
[Example corrected code]
```

**Rationale:** [Why this matters and why this solution is better]

---

[Repeat for all issues with detailed sections]

---

## ✅ Excellent Work

**What's Done Well:**
1. [Specific praise]
2. [Good patterns observed]
3. [Quality aspects]

---

## Summary of Required Changes

See **Quick Reference Checklist** at the top for the complete trackable list.

**At a Glance:**
- 🔴 **X Critical Issues** - [Brief description]
- ⚠️ **X Required Changes** - [Brief description]
- 💡 **X Suggestions** - [Brief description]

**Implementation Approach:**
Items can be addressed individually, in batches, or split into task tracking system as needed.

---

## Testing Notes

Before merge, verify:
- [ ] [Test item 1]
- [ ] [Test item 2]

**Ready for re-review after changes are applied.**

---

# Appendix A: [Educational Topic] (If Applicable)

## 🎓 Learning Opportunity: [Topic]

[Educational content explaining patterns, best practices, or common pitfalls]

### Key Concepts
[Explanation of the underlying concepts]

### Resources for Learning
- [Link to documentation]
- [Link to examples]
- [Link to guides]

### Issue: [Specific Problem]
[Detailed explanation with examples]

### Why This Matters
[Educational conclusion]
```

### Phase 6: Organize Review Files

Suggest organizing review artifacts based on project structure. Common patterns:

**Option A: Feature-based organization**
```
project/features/[FEATURE]/
  └── reviews/
      └── pr-[number]-[description]/
          ├── review.md
          ├── post-review.sh (optional)
          └── README.md
```

**Option B: Centralized reviews**
```
docs/reviews/
  └── pr-[number]-[description]/
      └── review.md
```

**Option C: Alongside code**
```
.github/reviews/
  └── pr-[number]-[description]/
      └── review.md
```

Ask the user where they'd like review documents stored.

### Phase 7: GitHub Posting (Optional)

Ask the user: "Would you like help posting this review to GitHub?"

If yes, create/update a posting script:

```bash
#!/bin/bash
# Post PR Review to GitHub
set -e

PR_NUMBER=[number]
REVIEW_FILE="[filename].md"

echo "📋 Posting PR #${PR_NUMBER} review to GitHub..."
echo "Review: [Feature Name]"
echo "File: ${REVIEW_FILE}"
echo ""

# Safety checks: gh CLI installed, authenticated, file exists
# Show preview
# Ask for confirmation

gh pr review "$PR_NUMBER" --request-changes \
  --body-file "$REVIEW_FILE"

echo "✅ Review posted successfully!"
```

Make it executable: `chmod +x post-review.sh`

Note: Use `--request-changes` for reviews with critical/required issues, `--comment` for advisory-only reviews.

## Output Format Requirements

### For Each Issue:

**Specific references:**
- Exact file paths
- Exact line numbers or ranges
- Use absolute line numbers from the actual files

**Clear structure:**
- Problem statement
- Current code (with context)
- Recommended solution (with example)
- Rationale (why it matters)
- Impact assessment

**Code examples:**
- Show actual problematic code
- Show corrected code
- Include enough context to understand
- Use proper syntax highlighting for the language

**Priorities:**
- 🔴 Critical: Security, bugs, data loss, architecture problems
- ⚠️ Required: Code quality, performance, patterns, maintainability
- 💡 Suggestions: Improvements, optimizations, refactoring opportunities
- 📚 Testing: Test patterns, coverage, organization
- 📝 Advisory: Future considerations, technical debt notes

### Educational Opportunities

When you identify common anti-patterns or learning opportunities:

1. **Create an appendix section** with:
   - Explanation of the concept
   - Why it matters
   - Links to documentation/guides (if project has them)
   - Clear examples of correct vs incorrect patterns
   - Resources for deeper learning

2. **Use teaching moments** without being condescending:
   - "This is a common pattern when..."
   - "Understanding X helps with..."
   - "The framework provides Y to handle..."

## Best Practices

1. **Be constructive and educational** - Help developers learn, don't just criticize
2. **Provide context** - Explain why something matters
3. **Show examples** - Code speaks louder than descriptions
4. **Be specific** - Exact files and lines, not vague references
5. **Prioritize correctly** - Not everything is critical
6. **Acknowledge good work** - Point out what's done well
7. **Make it trackable** - Checklists and clear action items
8. **Remember context** - Previous decisions inform future recommendations
9. **Be consistent** - Follow established patterns in the codebase
10. **Stay professional** - Constructive, respectful, supportive tone

## Interactive Elements

Throughout the review process:

- **Ask questions** when you need clarification
- **Confirm understanding** of user decisions
- **Suggest alternatives** when appropriate
- **Acknowledge corrections** and adjust accordingly
- **Track all decisions** for the final document
