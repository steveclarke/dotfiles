---
name: handoff
description: "Prepare a clean handoff for continuing complex work in a fresh Claude Code session. Use on 'handoff', 'hand off', 'fresh context', 'new session', 'pick this up later', or proactively when context is full and work remains."
---

# Handoff — Context-to-Context Continuation

Write durable continuation notes to the project, generate a resume prompt, and copy it to the clipboard so a fresh Claude Code session can pick up exactly where this one left off.

## Why This Matters

Claude Code sessions have finite context. Complex multi-session work (migrations, large features, multi-phase plans) needs a way to pass state between sessions without losing momentum. The handoff captures what a fresh session needs to know — not everything that happened, but everything that matters going forward.

## Process

### 1. Gather State

Before writing anything, collect this information from the current session:

**What's done:**
- Tasks/phases completed
- Files created or modified (high-level, not every file)
- Commits made and pushed (branch name, remote status)

**What's not done:**
- Remaining tasks or phases
- Known issues, bugs encountered and fixed (so the next session doesn't repeat them)
- Anything partially started

**Key decisions made:**
- Architectural choices the user approved
- Patterns established that future work should follow
- Things that were tried and didn't work

**Practical details:**
- Repo location, branch, remote
- Dev environment state (running? needs setup?)
- Test credentials if relevant
- Relevant file paths (specs, plans, docs)

If the next task isn't obvious from context, ask: **"What should the next session focus on?"**

### 2. Write Continuation File

Write a continuation notes file to the project. Location preference:
1. `docs/superpowers/plans/` if it exists (superpowers convention)
2. `docs/` if it exists
3. Project root as `CONTINUATION.md`

**Filename:** `YYYY-MM-DD-<topic>-continuation.md`

Structure:

```markdown
# [Topic] — Continuation Notes

## Current State (YYYY-MM-DD)

[1-2 sentence summary of where things stand]

### What's Working
- [bullet list of completed work]

### What's NOT Working Yet
- [bullet list of remaining work, known gaps]

### Key Decisions
- [decisions the user approved that constrain future work]

### Bugs Fixed (Don't Repeat These)
- [gotchas encountered — saves the next session from re-discovering them]

### Practical Details
- Repo: [path] (GitHub: [org/repo], branch: [branch])
- Dev stack: [running? how to start?]
- Credentials: [if needed for testing]

## Next: [What To Do]

[Brief description of what the next session should do first]

### Key Files to Read
- [file path] — [what it contains and why it matters]

### Pattern to Follow
[If a pattern was established, show a brief example so the next session
doesn't have to rediscover it]
```

Keep it concise — this is a briefing, not a history. The next session should be able to read this in under a minute and know exactly what to do.

### 3. Commit and Push

```bash
git add <continuation-file>
git commit -m "docs: add continuation notes for handoff"
git push
```

### 4. Generate Resume Prompt

Craft a resume prompt — the exact text the user will paste into a fresh session. It should:
- Be self-contained (no "see above" references)
- Point to 2-4 files max (the continuation notes + key docs)
- State the next task clearly
- Be under 10 lines

**Template:**

```
I'm [brief context]. [Phase/step] is complete. Read these files to get up to speed, then [next action]:

1. [continuation file path] (where we left off)
2. [spec or plan path] (full context)
3. [CLAUDE.md or other key doc] (conventions)

[One sentence about what to do next.]
```

### 5. Copy to Clipboard

```bash
echo "<resume prompt>" | pbcopy   # macOS
# or: echo "<resume prompt>" | xclip -selection clipboard   # Linux
```

Tell the user: **"Resume prompt copied to clipboard. Start a fresh session in `[repo path]` and paste it."**

## What NOT to Include

- Full conversation history or play-by-play
- Raw error logs (summarize the fix, not the stack trace)
- File contents that can be read from disk
- Implementation details that are in the code
- Anything the fresh session can derive by reading the codebase

The continuation file supplements `git log` and the code itself — it captures context that isn't in either place.
