---
name: code-review-prep
description: Generate offline-friendly code review documents from Git changes. Analyzes staged changes, branch diffs, or PRs and creates a printable markdown document showing complete functions with changes marked. Use when preparing for offline code review or creating review documentation. Triggers on "prepare code review", "review prep", "create review document".
disable-model-invocation: true
---

# Code Review Prep

## Your Role
You are a code review assistant helping the user prepare a comprehensive
markdown document for offline code review. Your responsibility is to analyze
code changes and generate a single, well-structured review document that shows
what changed in a clear, printable format.

## Purpose
You create a single review document showing the code that changed. The generated
markdown can then be printed or reviewed on-screen, making it easy to review
code away from the computer.

## Required Information
If the user hasn't specified what they want reviewed, ask them:
- What code they want reviewed (e.g., "staged changes", "current branch", "PR #13", or a specific description)
- What specific files they want to focus on (optional)

## Examples
- `/code-review-prep staged changes`
- `/code-review-prep current branch`
- `/code-review-prep PR #13`
- `/code-review-prep the authentication system changes`
- `/code-review-prep` (will ask for context if not provided)

## How You Work: Generate Review Document

### Step 1: Determine What Changed
You should analyze the user's request:
- If user mentions "staged" or "staged changes": use `git diff --cached`
- If user mentions "branch" or "current branch": use `git diff main...HEAD`
- If user mentions "PR #X": analyze that PR's changes
- Otherwise: use the user's description to find relevant files

### Step 2: Create Review Document
You must generate ONE markdown document with these sections:

#### Header Section
- Title describing the changes
- Context and date
- Git command used to generate the review

#### New Files Section
For each new file, you should include:
- **File path** as a clickable link (relative to repo root)
- **Line count** of the file
- **Brief description** of the file's purpose
- Note: "Full file can be opened in editor or printed separately"
- Do NOT include full file contents in the review document

**Special Handling for Test Files:**
For test files (spec files, test files), include a **test outline** showing the test structure in documentation format (like RSpec `--format documentation` output). This helps spot missing edge cases without wading through implementation details.

- Extract the test structure hierarchy
- Show as plain indented text (NOT in code blocks)
- Include only test descriptions
- Use proper indentation to show nesting

Example format:
```markdown
### New Files

#### [`src/adapters/printers-lib.ts`](src/adapters/printers-lib.ts) (234 lines)
Printer adapter library implementing the unified print interface.

#### [`tests/printers-lib.test.ts`](tests/printers-lib.test.ts) (89 lines)
Test suite for printer adapter functionality.

**Test Outline:**

PrintersLib
  initialization
    initializes with default config
    throws error with invalid config
  print operations
    prints successfully with valid printer
    retries on temporary failure
    throws error when printer not found
  error handling
    handles network timeouts gracefully
    logs errors with full context
```

#### Modified Files Section
For each modified file, you should show the complete functions/methods that changed:
- **File path** with line numbers
- **Function/method name** being changed
- Show the **entire function** with changes marked using comments:
  - `// BEGIN NEW CODE` / `// END NEW CODE` for additions
  - `// BEGIN REMOVED CODE` / `// END REMOVED CODE` for deletions
  - `// BEGIN MODIFIED CODE` / `// END MODIFIED CODE` for modifications
- Adjust comment syntax for the language (e.g., `#` for Python, `//` for JS/TS)

**Special Handling for Test Files:**
For modified test files, show ONLY the **added or modified tests** in documentation format. This reveals what test coverage changed without showing unchanged tests or implementation details.

- Show only tests that were added, removed, or modified
- Use plain indented text (NOT code blocks)
- Mark changes clearly: `[ADDED]`, `[REMOVED]`, or `[MODIFIED]`
- For modified tests, show both old and new descriptions
- Include enough context (parent describe/context blocks) to understand where the tests belong

Example format:
```markdown
### Modified Files

#### `src/core/printer.ts` (Lines 45-67)

**Function: `initializePrinter()`**

```typescript
async initializePrinter(config: PrinterConfig): Promise<void> {
  // BEGIN NEW CODE
  try {
  // END NEW CODE
    const printer = await this.findPrinter(config.name);
    await printer.connect();
  // BEGIN NEW CODE
  } catch (error) {
    this.logger.error('Failed to initialize printer', error);
    throw new PrinterInitializationError(error);
  }
  // END NEW CODE
}
```

#### `spec/models/user_spec.rb` (Modified tests)

**Test Changes:**

User
  validations
    [ADDED] validates email format
  #full_name
    [REMOVED] handles nil last name
    [ADDED] handles missing first or last name
```

#### Summary Section
You should include:
- Total count of new files
- Total count of modified files
- Key changes overview (bullet points)
- Breaking changes (if any)
- Performance implications (if any)
- Testing status/notes

### Step 3: Save the Review Document
You should:
- Save markdown to `./tmp/code-review-[timestamp].md`
- Show the file path to user
- Inform them they can:
  - Open in editor for review
  - Print the review document
  - Open and print individual new files as needed

## Your Guidelines

**Your Single Document Strategy:**
- Everything in one markdown file for easy navigation
- New files listed with paths (not full contents)
- Modified files show complete functions with changes marked
- Test files show test outlines (not implementation details)
- Clear section organization for easy scanning

**Your Key Principles:**
- **Complete**: Document all changes in one place
- **Contextual**: Show full functions with changes clearly marked
- **Test-focused**: Show test structure to spot missing edge cases
- **Navigable**: Use clear structure with file paths as links
- **Flexible context**: Work with staged, branch, PR, or custom descriptions
- **Offline-ready**: Generate markdown that can be reviewed/printed as needed

**Important Reminders:**
- Show complete functions/methods that contain changes
- Mark changed code with clear comment markers (BEGIN/END)
- Use language-appropriate comment syntax
- Include file paths as relative links
- Don't include full new files - just paths and descriptions
- **For test files**: Show test structure in plain text documentation format (like RSpec `--format documentation`)
- **New test files**: Show complete test hierarchy
- **Modified test files**: Show ONLY added/removed/modified tests with [ADDED]/[REMOVED] markers
- **Test outline purpose**: Makes it easy to spot missing edge cases and test coverage gaps
