---
name: commit
description: Create well-structured commit messages following Conventional Commits format. Use when committing code changes, writing commit messages, or formatting git history.
---

# Commit Messages

Follow these conventions when creating commits.

## Prerequisites

Before committing, ensure you're working on a feature branch, not the master branch.

```bash
# Check current branch
git branch --show-current
```

If you're on `master`, create a new branch first:

```bash
# Create and switch to a new branch
git checkout -b <type>/<brief-description>
```

## Branch Naming

Branch names follow the pattern:

```
{type}/{brief-description}
```

For work tied to a feature epic, include the feature ID:

```
{type}/{feature-id}-{brief-description}
```

**Examples:**
- `feat/add-user-auth` - Adding authentication
- `feat/FT050-workflow-automation` - Feature epic work
- `fix/resolve-link-validation` - Bug fix
- `docs/workflow-guide` - Documentation
- `chore/update-ruby-version` - Dependencies

## Commit Format

```
<type>: <summary>

<body>

<footer>
```

The summary is required. Body and footer are optional but helpful when context is needed.

## Commit Types

| Type       | Purpose                              |
| ---------- | ------------------------------------ |
| `feat`     | New feature                          |
| `fix`      | Bug fix                              |
| `docs`     | Documentation only                   |
| `style`    | Code formatting (no logic change)    |
| `refactor` | Code restructuring (no behavior change) |
| `test`     | Adding or modifying tests            |
| `chore`    | Build tools, dependencies, configs   |

## Summary Rules

- **Under 50 characters** - Get to the point
- **Imperative mood** - "Add feature" not "Added feature"
- **Capitalize first word** - "Add feature" not "add feature"
- **No period at end** - Save the character

## Body Guidelines

Use the body to explain **why**, not how. The code shows how; the commit explains why.

- Use imperative mood and present tense
- Wrap lines at 72 characters
- Include motivation for the change
- Contrast with previous behavior when relevant

## Examples

### Simple change (no body needed)

```
docs: fix typo in workflow guide
```

### Feature with context

```
feat: add link archival endpoint

Implement POST /api/v1/links/:id/archive endpoint to allow
marking links as archived without deletion. Includes validation
and database migration.
```

### Bug fix

```
fix: resolve popup not opening on Firefox

The popup.html failed to load on Firefox due to CSP issues.
Updated manifest.json with proper permissions.
```

### Dependency update

```
chore: update Docker base image to Ruby 3.4.2

Bump base image for security patches and performance improvements.
```

### Refactor

```
refactor: extract link validation to service

Move duplicate validation code from three endpoints into a shared
validator class. No behavior change.
```

### Test addition

```
test: add archival endpoint tests
```

## Commit Frequency

Commit after completing logical chunks of work. Each commit should be a checkpoint—a coherent piece of work that makes sense on its own.

```bash
git commit -m "feat: add archival endpoint skeleton"
git commit -m "feat: add archival validation logic"
git commit -m "test: add archival endpoint tests"
git commit -m "docs: document archival API endpoint"
```

Small, focused commits are easier to review and easier to revert if needed.

## Squash Merge Note

We use squash merges for all PRs. Your individual commits get combined into a single, clean commit when merged to master. This means:

- Don't stress over "fix typo" commits during development
- The final squash commit message gets polished at merge time
- Master history shows one commit per PR

## Issue References

If your project uses issue tracking (GitHub Issues, Jira, Linear, etc.), reference issue IDs in **PR titles or branch names**, not commit messages. This enables automatic linking and status updates.

**Branch:** `feat/GH-128-add-user-auth`
**PR title:** `feat: add user authentication #128`

## Principles

- Each commit should be a single, coherent change
- Commits should be independently understandable
- Focus on why the change was made, not what changed

## References

- [Conventional Commits](https://www.conventionalcommits.org/)
- [How to Write a Git Commit Message](https://cbea.ms/git-commit/)
