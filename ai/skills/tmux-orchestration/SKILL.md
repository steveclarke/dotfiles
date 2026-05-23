---
name: tmux-orchestration
description: "Read, send input to, or spawn other tmux panes, windows, and sessions - including agents (Claude Code, Codex), REPLs, and TUIs running in them. Use when the user references another pane, window, or agent."
---

# tmux-orchestration

## Capabilities

- Read another pane — summarize an agent's progress, grab errors, check whether a long-running process finished.
- Drive another agent — send a handoff prompt, ask a follow-up, answer a confirmation, redirect it mid-task.
- Spawn new work — open another window or session with a fresh agent, REPL, watcher, or shell pre-seeded with a task.
- Coordinate long-running things — pipe output to a log, watch in the background, fan a command out across worktrees.
- Drive interactive TUIs — lazygit, k9s, htop, an editor — by sending keystrokes and reading the rendered frame.

## When to use

Whenever the user's request crosses a pane boundary. Common triggers:

- "Read / check / peek at / summarize what's happening in [pane|window|session]."
- "Send this to the agent in X." / "Tell the other Claude to…"
- "Answer the prompt in that pane." / "Type 'y' there."
- "Open a new window and start a Claude working on…"
- "Watch the build / deploy / test run and tell me when it finishes."
- "Run the same command in all my worktree shells."

Not for ordinary shell work that belongs in the current pane.

## Safety

The dangerous part isn't the tmux commands, it's the judgment.

### Confirm the target before acting

The user's wording ("the other one", "the apps worktree", "that Codex") is rarely unambiguous. List all panes with enough metadata to recognise them — session, window, pane, current command, working directory. If two or more candidates fit, name them and ask the user to pick. Don't guess. Confirm the target back to the user before anything substantive (send input, kill, spawn).

### Never write to the current pane

Targeting the pane the agent itself is running in is catastrophic — keystrokes hit the agent's own UI, cancelling work or sending garbage. Always know which pane is "self" and exclude it.

### Read before writing

Capture and inspect the pane before sending input. Two reasons:

- **It tells you what the pane is waiting for.** A shell prompt accepts commands; an agent's input box accepts prose; a confirmation prompt wants `y`/`n`. Sending the wrong shape of input causes real damage — e.g. a multi-line prompt pasted into bash tries to execute each line as a command.
- **It catches misidentified targets.** Expected a Codex session and saw a bash prompt in someone's home directory? Stop.

### Use buffer paste for non-trivial input

Single keys, short answers, and one-line commands can be sent directly. Anything multi-line, anything with backticks, quotes, dollar signs, or other shell-special characters, should be staged into a tmux buffer and pasted. Direct `send-keys` of complex text gets mangled by shell quoting.

Paste does not submit. Sending `Enter` is a separate, explicit step — and worth pausing on, because it's the point of no return.

### Substantive sends get a preview

For anything beyond a trivial answer (a handoff prompt, a multi-paragraph instruction, a destructive command), show the user the exact text and get a go-ahead before pressing Enter. Quick `y` / `n` / arrow-key style interactions don't need this.

### Verify after sending

Capture the target pane again. Confirm the receiving agent accepted the input and started working. If nothing visibly changed, something went wrong — wrong target, missing Enter, agent was busy and dropped the paste.

## Spawning

Prefer detached creation so the current pane keeps control. Seed the new agent by sending its opening prompt once its UI is ready — buffer paste, then Enter.

Avoid orphan windows. If something goes wrong (spawned the wrong command, picked the wrong cwd), close it before retrying.

## Background watching

For long-running processes in another pane:

- **Poll on demand.** When the user asks "is it done?", capture the pane and report.
- **Mirror to a file.** Pipe the pane's live output to a log file in the background, then tail or grep the file. Useful when scrollback might truncate, or when the user wants to walk away.

Stop mirroring when done — leaving pipes attached to inactive panes is sloppy.

## Broadcasting

Sending the same input to multiple panes at once is useful (run a command across worktree shells, restart several services) and dangerous (one typo, executed N times). Treat as destructive: confirm the pane set, confirm the input, turn synchronisation off again immediately. Never leave broadcast mode on across turns.

## What good looks like

**"What's the agent in the apps worktree doing?"**

1. List panes, identify the one in the apps worktree running an agent.
2. Capture its visible content (plus a bit of scrollback if useful).
3. Read it for *meaning* — what task is in flight, what was just completed, what is it waiting on — not just reciting the screen.
4. Report that summary, plus anything noteworthy (errors, pending prompts, idle for a long time).

**"Send a handoff to that pane."**

1. Confirm the target by name.
2. Draft the handoff prompt — concise, self-contained, points at the source of truth (a plan doc, a branch, a spec) rather than restating it.
3. Show the prompt to the user for approval.
4. Send via buffer paste, press Enter, capture the pane to confirm receipt.

## Failure modes to avoid

- Sending input to the wrong pane because the user said "the other one" and you guessed.
- Pasting a multi-line prompt into a shell instead of an agent UI, executing each line.
- Forgetting `Enter`, so the prompt sits in the input box and the user thinks the agent froze.
- Burying a destructive command in a broadcast and only realising after it ran in five panes.
- Leaving `synchronize-panes` on, so the next ordinary keystroke fans out unexpectedly.
- Spawning a new window in the wrong cwd or wrong session, then walking away from the orphan.

Cross-pane mistakes are usually unrecoverable — the receiving agent has already acted on whatever it got. When in doubt, stop and ask.
