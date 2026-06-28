---
name: worktree-session
description: >
  Spin up an isolated git worktree in its own tmux session wired for real work:
  an AI coding agent in one window, the dev environment in another, git UI in a
  third, and the agent handed a briefing so it starts immediately. Use this
  whenever the user wants to start a new feature/branch/task in a worktree, kick
  off a fresh agent (Claude or Codex) on a piece of work, set up an isolated dev
  session, or says things like "spin up a worktree", "start a new branch with an
  agent", "open a tmux session for this", "hand this off to a fresh agent", or
  "get a dev environment going for this feature". Repo-agnostic: discover the
  repo's own worktree tool, dev-stack command, and test runner rather than
  assuming. Builds on the tmux-orchestration and handoff skills.
---

# Worktree Session

Stand up a self-contained workspace for a piece of work: an isolated git
worktree, a tmux session laid out for driving it, the dev stack running, and a
fresh agent already chewing on a briefing. The goal is that the human attaches
and the work is already in motion — no manual scaffolding.

This skill **composes** two others: use **tmux-orchestration** for the mechanics
of driving panes safely, and **handoff** for writing the briefing the agent reads.

## The standard layout

```
Session: <Project>-<work>        (hyphenated, no spaces — see tmux gotchas)
├── Window 1  "agent"  → the AI coding agent (Claude or Codex), cwd = worktree,
│                         handed a kickoff prompt that points at the briefing
├── Window 2  "dev"    → split vertically:
│      ├── top    → the dev stack (process-compose / foreman / npm run dev / ...)
│      └── bottom → a bare shell (right toolchain) for tests + ad-hoc commands
└── Window 3  "git"    → lazygit (optional, but a common ask)
```

This is the *common* shape. Adapt it: some work needs no dev stack, some wants
two agents, some wants a logs window. Confirm the shape if it's non-obvious.

## Inputs to settle first

You usually have most of these from context. Fill gaps, don't interrogate.

- **Work name** → drives the branch and the session name. If there's a PR or
  issue/card number, prefer that (many worktree tools take `--pr`/`--gh <n>`).
- **Agent + mode** → Claude or Codex, and any mode (fast, plan). If unsure, ask
  once; "just open it, I'll set the mode" is a fine answer.
- **Briefing?** → for anything beyond a trivial task, write one (see step 1).
- **Base branch** → usually the default branch; worktree tools often base new
  trees on `origin/<default>`, which matters for step 1's ordering.

## Process

### 1. Write the briefing, then commit it to the base branch

Invoke the **handoff** skill and write a briefing the agent will read: the
mission, the scoped task, the files/patterns to follow, conventions, and
guardrails. Keep it a briefing, not a history.

**Order matters:** if the worktree tool bases new trees on `origin/<default>`,
commit and push the briefing to the base branch *before* creating the worktree,
so the worktree contains it. Otherwise the agent can't read it.

### 2. Discover and run the repo's worktree tool

Don't assume — repos differ. Look, in rough priority:
- A dedicated script: `bin/worktree`, `bin/wt`, `script/worktree`.
- `DEVSTACK.md` / `README.md` / `CONTRIBUTING.md` for a documented command.
- A task runner: `just`, `make` targets, `mise tasks`, package.json scripts.
- Fall back to plain `git worktree add ../<repo>-<branch> -b <branch> origin/<default>`.

Common forms: `bin/worktree add <name>`, `bin/worktree add --pr 42`,
`bin/worktree add --gh 169`.

**Expect friction, and handle it well:**
- Worktree creation often runs a **full bootstrap** (install deps, set up the
  DB, fetch secrets). This can take **many minutes** — don't assume it hung.
- It may **prompt for a secret** (1Password unlock, a Rails master key, an env
  token). That is the **user's** to approve — surface it immediately and wait.
  Never enter credentials yourself. If the secret-manager's auth *times out*, the
  bootstrap may fall back to asking for a manual paste in the terminal — still
  the user's job; tell them where to paste.
- Run it in a visible pane and **wait for a real completion signal** (append a
  marker like `; echo DONE_$?` and poll the pane, or watch for the tool's own
  "setup complete"). Don't start the dev stack until bootstrap finishes.

### 3. Discover the dev-stack and test commands

Again, look before assuming. The dev stack is commonly one of:
`bin/dev`, `npm run dev` / `pnpm dev`, `foreman start` / `overmind start`,
`process-compose up`, `docker compose up`, `mise run dev`, or a custom project
verb (e.g. `<tool> dev`). Check `README`/`DEVSTACK.md`/`CLAUDE.md`/`package.json`/`Procfile*`.

Note whether it offers a **headless/detached** mode (e.g. process-compose `-D`,
then `status`/`logs`). Prefer headless for *your* control; a foreground TUI in
the dev window is fine for the human to watch. Find the **test runner** too
(`bin/rspec`, `pnpm test`, `pytest`, `go test`) — the bottom pane and the agent
will want it.

### 4. Build the tmux session

Use **tmux-orchestration** for the safe mechanics. Specifics that bite here:
- Create the session **detached** so the user's current session is untouched.
- Name it human-friendly but **hyphenated, never with spaces** (see gotchas).
- Window 1 `agent`: `cd` to the worktree, launch the agent. When its UI is
  ready, **buffer-paste** the kickoff prompt, then send Enter as a separate,
  deliberate step. Keep the kickoff short — point at the briefing doc rather
  than restating it.
- Window 2 `dev`: split vertically; top runs the dev stack, bottom is a bare
  shell. Make sure **both** panes have the right toolchain (see the version-
  manager gotcha — this is the one that wastes the most time).
- Window 3 `git`: `cd` to the worktree, run `lazygit` (skip if not installed).

### 5. Verify, then report

- Dev stack actually healthy (poll `status`/health, or read the TUI) — not just
  "started". Read the **process logs** if anything failed.
- The agent received the prompt and **started working** (capture its pane and
  confirm activity, don't assume the paste landed).
- Report the attach command and the layout: `tmux attach -t <session>`.

## Hard-won gotchas

These are the things that turn a 5-minute task into an hour. Internalize them.

### Version managers don't activate in spawned shells

**This is the big one.** A shell you spawn programmatically (`tmux new-session`,
a non-login shell) often does **not** have the user's version manager (mise,
asdf, rbenv, nvm, volta) active — even though their interactive shells do. So
`ruby`/`node`/`python` silently fall back to the **system** version, and
bootstrap or the dev stack fails with errors like *"Could not find bundler
(x.y.z)"* or missing modules.

- **Detect it:** compare a tool's version in your spawned pane against the
  user's working pane (e.g. `ruby -v`). A mismatch is the smell.
- **Fix the interactive panes:** put the manager's shims on PATH explicitly,
  e.g. mise: `export PATH="$HOME/.local/share/mise/shims:$PATH"`.
- **Fix the dev stack's child processes too.** A dev launcher that runs each
  process via a non-interactive shell needs the toolchain activated *there*. For
  **mise specifically**: plain `mise activate <shell>` is a **no-op in a
  non-interactive `bash -lc`** (it only applies on a prompt hook that never
  fires). Use **`mise activate <shell> --shims`** or **`mise exec --`** instead.
  If the dev-stack config uses plain `mise activate`, that's a real bug in the
  config for agent/CI use — flag it to the user (and, if it's generated, suggest
  the generator emit `--shims`).

### Worktree bootstrap: slow + secrets

Covered in step 2: expect minutes, expect a secret prompt the *user* approves,
wait for a true completion marker, and never type credentials yourself.

### tmux targeting

- **No spaces in session names.** `session:window` targets mis-parse when the
  session name has spaces (you'll see garbled "can't find pane" errors). Use
  hyphens. A human-friendly hyphenated title is the sweet spot.
- **Target panes by index** (`session:win.pane`, e.g. `MySess:1.1`). Targeting a
  window by *name* alone (`MySess:agent`) can mis-parse; the indexed form is
  reliable.
- **Never write to your own pane.** Identify "self" first
  (`tmux display-message -p '#{session_name}:#{window_index}.#{pane_index}'`) and
  exclude it — keystrokes into your own pane corrupt your session.

### Driving agent TUIs and dev TUIs

- Wait for the agent's UI to be ready before pasting; **buffer-paste**
  multi-line prompts; **Enter is a separate, deliberate step** (the point of no
  return — preview substantive prompts to the user first).
- For dev-stack TUIs (process-compose etc.), prefer the headless mode + `status`
  / `logs` for control; quit a TUI with its real quit key (process-compose:
  `F10`), not a guessed `Ctrl-C`.

## Discovery cheatsheet

| Need | Look for |
|------|----------|
| Worktree tool | `bin/worktree`, `script/worktree`, `DEVSTACK.md`, `just`/`make`, else `git worktree add` |
| Dev stack | `bin/dev`, `npm/pnpm dev`, `foreman`/`overmind`, `process-compose`, `docker compose`, `mise run dev`, a custom project verb |
| Test runner | `bin/rspec`, `pnpm test`, `pytest`, `go test`, `Makefile` |
| Toolchain | `.mise.toml`/`.tool-versions`/`.ruby-version`/`.nvmrc`; confirm the spawned shell actually uses it |
| Agent | ask once: Claude vs Codex, and mode |

## What good looks like

The user types `tmux attach -t <session>` and finds: window 1, the agent already
reading the briefing and writing tests; window 2, the dev stack green up top and
a ready shell below; window 3, lazygit. They didn't approve anything except the
one secret prompt, and nothing in their existing session moved.
