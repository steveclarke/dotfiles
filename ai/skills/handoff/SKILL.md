---
name: handoff
description: "Brief another agent session so it can continue this work — directly to a running session or pane, or as a temp file when neither is reachable. Use on 'handoff', 'hand off', 'fresh context', 'new session', 'pick this up later', or proactively when context is full and work remains."
---

# Handoff — Brief the Next Session

Pass the state of this session to the session that continues the work. A handoff is a briefing, not a record: it is delivered straight to the next session wherever possible, and it is never committed to the repo.

## 1. Gather State

Collect only what the next session needs:

**Done:**
- Tasks or phases completed
- Files created or modified (high level)
- Commits made and pushed (branch, remote status)

**Not done:**
- Remaining tasks or phases
- Bugs hit and fixed, so the next session doesn't repeat them
- Anything partially started

**Decisions:**
- Choices the user approved that constrain future work
- Patterns established
- Approaches tried that didn't work

**Practical details:**
- Repo path, branch, remote
- Dev environment state (running, or how to start it)
- Test credentials if relevant
- Key file paths (specs, plans, docs) — 2-4 at most

If the next task isn't obvious, ask: **"What should the next session focus on?"**

## 2. Write the Brief

Keep it under a minute to read. Self-contained — no "see above".

```markdown
# [Topic] — Handoff (YYYY-MM-DD)

[1-2 sentence summary of where things stand]

## Done
- ...

## Not Done
- ...

## Decisions
- ...

## Bugs Fixed (Don't Repeat)
- ...

## Practical
- Repo: [path] (branch: [branch])
- Dev stack: [state]

## Next
[What to do first]

## Read First
- [path] — [why]
```

## 3. Deliver It

Use the first route that works:

1. **Another Claude Code session is running.** Find it with `ListAgents` and send the brief with `SendMessage`. Confirm which session it is before sending.
2. **The target runs in Herdr or tmux.** Send the brief to the target pane with the `herdr` skill (inside Herdr) or the `tmux-orchestration` skill (plain tmux). Confirm the pane before sending.
3. **No live target.** Write the brief to `${TMPDIR:-/tmp}/handoff-YYYY-MM-DD-<topic>.md`, copy a one-line resume prompt that points at it to the clipboard (`pbcopy` on macOS, `wl-copy` or `xclip -selection clipboard` on Linux), and give the user the path. The file is disposable; losing it on reboot is fine.

Never write the brief into the project or commit it.

## What NOT to Include

- Conversation play-by-play
- Raw error logs (summarize the fix)
- File contents or implementation details readable from disk
- Anything derivable from `git log` or the code
