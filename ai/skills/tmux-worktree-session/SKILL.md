---
name: tmux-worktree-session
description: >
  Spin up an isolated git worktree in its own tmux session — coding agent in one
  window, dev stack in another, git UI in a third — with the agent briefed and
  already working. Use for spinning up a worktree, starting a feature/branch/task
  in isolation, handing work to a fresh agent (Claude/Codex), or setting up an
  isolated tmux dev session.
---

# tmux Worktree Session

Stand up a self-contained workspace: an isolated git worktree, a tmux session to
drive it, the dev stack running, and a fresh agent already working a briefing.
The human attaches and the work is already in motion.

**Composes** two skills: **tmux-orchestration** for safely driving panes, and
**handoff** for writing the briefing.

## Standard layout

```
Session: <Project>-<work>     (hyphenated, no spaces)
├── Window 1 "agent" → coding agent (Claude/Codex), cwd = worktree, given a
│                      kickoff prompt pointing at the briefing
├── Window 2 "dev"   → split: top = dev stack, bottom = bare shell for tests
└── Window 3 "git"   → lazygit (optional)
```

The common shape — adapt it (no dev stack, two agents, a logs window). Confirm
if non-obvious.

## Inputs

Fill from context, don't interrogate:
- **Work name** → branch + session name. Prefer a PR/issue number if one exists.
- **Agent + mode** → Claude or Codex, fast/plan. Ask once if unsure.
- **Base branch** → usually the default; worktree tools often base on
  `origin/<default>`, which matters for step 1.

## Process

### 1. Write the briefing, commit it to the base branch first

Use **handoff** to write what the agent reads: mission, scoped task,
files/patterns, conventions, guardrails. A briefing, not a history.

If the worktree tool bases new trees on `origin/<default>`, commit and push the
briefing to the base branch *before* creating the worktree — otherwise it won't
be there for the agent.

### 2. Discover and run the worktree tool

Look (see cheatsheet), don't assume. Common: `bin/worktree add <name>`,
`bin/worktree add --pr 42`. Fallback: `git worktree add ../<repo>-<branch> -b <branch> origin/<default>`.

Creation often triggers a **full bootstrap** (deps, DB, secrets) that takes
**minutes** — don't assume it hung. It may **prompt for a secret** (1Password,
master key, env token): that's the **user's** to approve — surface it and wait,
never type credentials yourself. Run it in a visible pane and wait for a real
completion signal (append `; echo DONE_$?` and poll) before starting the dev
stack.

### 3. Discover dev-stack and test commands

Look (see cheatsheet). Prefer a **headless/detached** mode for your control
(e.g. process-compose `-D` + `status`/`logs`); a foreground TUI is fine for the
human to watch. Note the test runner — the bottom pane and agent need it.

### 4. Build the session

Mechanics via **tmux-orchestration**. Specifics that bite:
- Create it **detached** so the user's current session is untouched.
- **Hyphenated name, no spaces.**
- Window 1 `agent`: `cd` to worktree, launch agent; when its UI is ready,
  **buffer-paste** the kickoff, then Enter as a separate step. Keep it short —
  point at the briefing.
- Window 2 `dev`: split; top = dev stack, bottom = shell. Both panes need the
  right toolchain (see version-manager gotcha).
- Window 3 `git`: `cd` to worktree, run `lazygit` (skip if absent).

### 5. Verify and report

- Dev stack actually **healthy** (poll `status`/health), not just "started";
  read process logs if anything failed.
- Agent actually **started** (capture its pane, don't assume the paste landed).
- Report: `tmux attach -t <session>`.

## Gotchas

**Version managers don't activate in spawned shells (the big one).** A shell you
spawn programmatically (`tmux new-session`, non-login) often lacks the user's
version manager (mise/asdf/rbenv/nvm), so `ruby`/`node`/`python` silently falls
back to the system version and bootstrap fails (e.g. *"Could not find bundler"*).
- Detect: compare `ruby -v` etc. in your pane vs the user's. Mismatch = the smell.
- Fix interactive panes: put shims on PATH, e.g. mise
  `export PATH="$HOME/.local/share/mise/shims:$PATH"`.
- Fix the dev stack's child processes too. For **mise**, plain `mise activate` is
  a **no-op in non-interactive `bash -lc`** — use `mise activate <shell> --shims`
  or `mise exec --`. If the dev-stack config uses plain `mise activate`, that's a
  real bug for agent/CI use — flag it.

**tmux targeting.**
- No spaces in session names — `session:window` targets mis-parse otherwise.
- Target panes by index (`MySess:1.1`), not name — name alone can mis-parse.
- Never write to your own pane. Get self first
  (`tmux display-message -p '#{session_name}:#{window_index}.#{pane_index}'`) and
  exclude it.

**Driving TUIs.** Wait for the agent UI before pasting; buffer-paste multi-line
prompts; Enter is a separate, deliberate step (preview substantive prompts to the
user first). Quit a dev TUI with its real key (process-compose `F10`), not a
guessed `Ctrl-C`.

## Discovery cheatsheet

| Need | Look for |
|------|----------|
| Worktree tool | `bin/worktree`, `script/worktree`, `DEVSTACK.md`, `just`/`make`, else `git worktree add` |
| Dev stack | `bin/dev`, `npm/pnpm dev`, `foreman`/`overmind`, `process-compose`, `docker compose`, `mise run dev`, project verbs |
| Test runner | `bin/rspec`, `pnpm test`, `pytest`, `go test`, `Makefile` |
| Toolchain | `.mise.toml`/`.tool-versions`/`.ruby-version`/`.nvmrc` — confirm the spawned shell uses it |
