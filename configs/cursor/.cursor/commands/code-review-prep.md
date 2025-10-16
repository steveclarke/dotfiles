# Code Review Prep

## Overview
Structured command to generate a markdown review document for offline code review, including code snippets of changes and file paths to new files.

## Purpose
Creates a single review document showing the code that changed. The generated markdown can then be printed or reviewed on-screen.

## Required Information
If the user hasn't specified what they want reviewed, ask them:
- What code they want printed (e.g., "staged changes", "current branch", "PR #13", or a specific description)
- What specific files they want to focus on (optional)

## Examples
- `/code-review-prep staged changes`
- `/code-review-prep current branch`
- `/code-review-prep PR #13`
- `/code-review-prep the authentication system changes`
- `/code-review-prep` (will ask for context if not provided)

## Process: Generate Review Document

### Step 1: Determine What Changed
- If user mentions "staged" or "staged changes": use `git diff --cached`
- If user mentions "branch" or "current branch": use `git diff main...HEAD`
- If user mentions "PR #X": analyze that PR's changes
- Otherwise: use the user's description to find relevant files

### Step 2: Create Review Document
Generate ONE markdown document with these sections:

#### Header Section
- Title describing the changes
- Context and date
- Git command used to generate the review

#### New Files Section
For each new file:
- **File path** as a clickable link (relative to repo root)
- **Line count** of the file
- **Brief description** of the file's purpose
- Note: "Full file can be opened in editor or printed separately"
- Do NOT include full file contents in the review document

Example format:
```markdown
### New Files

#### [`src/adapters/printers-lib.ts`](src/adapters/printers-lib.ts) (234 lines)
Printer adapter library implementing the unified print interface.

#### [`tests/printers-lib.test.ts`](tests/printers-lib.test.ts) (89 lines)
Test suite for printer adapter functionality.
```

#### Modified Files Section
For each modified file, show the complete functions/methods that changed:
- **File path** with line numbers
- **Function/method name** being changed
- Show the **entire function** with changes marked using comments:
  - `// BEGIN NEW CODE` / `// END NEW CODE` for additions
  - `// BEGIN REMOVED CODE` / `// END REMOVED CODE` for deletions
  - `// BEGIN MODIFIED CODE` / `// END MODIFIED CODE` for modifications
- Adjust comment syntax for the language (e.g., `#` for Python, `//` for JS/TS)

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
```

#### Summary Section
- Total count of new files
- Total count of modified files
- Key changes overview (bullet points)
- Breaking changes (if any)
- Performance implications (if any)
- Testing status/notes

### Step 3: Save the Review Document
- Save markdown to `./tmp/code-review-[timestamp].md`
- Show the file path to user
- User can then:
  - Open in editor for review
  - Print the review document
  - Open and print individual new files as needed

## Guidelines

**Single Document Strategy:**
- Everything in one markdown file for easy navigation
- New files listed with paths (not full contents)
- Modified files show complete functions with changes marked
- Clear section organization for easy scanning

**Key Principles:**
- **Complete**: All changes documented in one place
- **Contextual**: Full functions shown with changes clearly marked
- **Navigable**: Clear structure with file paths as links
- **Flexible context**: Works with staged, branch, PR, or custom descriptions
- **Offline-ready**: Generated markdown can be reviewed/printed as needed

**Important:**
- Show complete functions/methods that contain changes
- Mark changed code with clear comment markers (BEGIN/END)
- Use language-appropriate comment syntax
- Include file paths as relative links
- Don't include full new files - just paths and descriptions
