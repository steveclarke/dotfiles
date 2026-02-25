---
name: overmind-dev
description: Set up Overmind as an agentic-friendly process manager for dev servers. Use when setting up a new project's dev environment, adding services to a Procfile, or when the user mentions Overmind, Procfile, dev server orchestration, or wants to manage multiple services (web server, CSS watcher, docs site, background workers) from a single command.
---

# Overmind for Development

Overmind is a tmux-based process manager. Key advantage over Foreman: daemonized
mode lets agents start/stop/restart services without blocking the terminal.

Requires **tmux** (installed automatically by `brew install overmind` on macOS).

## Setup Checklist

1. **`Procfile.dev`** at project root — one service per line (`name: command`)
2. **`bin/dev`** — bash wrapper with subcommands (start, stop, restart, status, logs, help)
3. **`bin/setup`** — Ruby script (Rails convention) installing deps + overmind
4. **`.overmind.env`** — sets `OVERMIND_SOCKET=tmp/overmind.sock`
5. **`tmp/.keep`** — tracked by git; `.gitignore` has `/tmp/*` + `!/tmp/.keep`

## Key Design Decisions

- **Foreground by default** — `bin/dev` runs in foreground so crashes are visible.
  `-d` flag to daemonize. Never daemonize by default — silent crash + vanishing
  socket is undebuggable.
- **Socket in `tmp/`** — keeps project root clean (Rails convention).
  `.overmind.env` ensures bare `overmind` commands also use the right path.
- **Stale socket handling** — `bin/dev` cleans up stale sockets before starting
  (prevents "already running" errors). `bin/dev stop` falls back to removing the
  socket if `overmind quit` fails (connection refused).
- **Own arg parser** — `bin/dev` parses its own flags (`-d`, subcommands) and
  only passes through to overmind after `--`.

## bin/dev Commands

| Command | What it does |
|---------|-------------|
| `bin/dev` | Start foreground (default) |
| `bin/dev -d` | Start daemonized |
| `bin/dev stop` | Stop running instance |
| `bin/dev restart web` | Restart a specific service |
| `bin/dev status` | Show process statuses |
| `bin/dev logs` | Tail all logs |
| `bin/dev -- -l web,css` | Pass flags directly to overmind |

## Procfile Patterns

```procfile
# Standard Rails
web: bin/rails server -p 3000
css: bin/rails tailwindcss:watch

# With workers
worker: bundle exec sidekiq

# Subdirectories (engines, monorepos)
web: cd test/dummy && bin/rails server -p 4001
docs: cd docs && bin/bridgetown start

# Mixed stack
api: cd backend && bin/rails server -p 3000
web: cd frontend && npm run dev
```

## Agent Workflow

1. Check status: `bin/dev status 2>/dev/null && echo "running" || echo "not running"`
2. Start daemonized: `bin/dev -d` (never foreground — blocks terminal)
3. After server-affecting edits: `bin/dev restart web`
4. Read logs non-interactively via tmux capture-pane:
   ```bash
   SOCK=$(ls /private/tmp/tmux-$(id -u)/overmind-* 2>/dev/null || ls /tmp/tmux-$(id -u)/overmind-* 2>/dev/null)
   SESSION=$(tmux -S "$SOCK" list-sessions -F '#{session_name}' | head -1)
   tmux -S "$SOCK" capture-pane -t "$SESSION":web -p -S -100
   ```
5. Leave running at session end — user runs `bin/dev stop` when done.

## Useful Overmind Flags

| Flag | Purpose |
|------|---------|
| `-D` | Daemonize |
| `-f FILE` | Specify Procfile path |
| `-r PROCESS` | Auto-restart on crash (`-r all` for everything) |
| `-l PROCESS` | Only start specific processes (`-l web,css`) |
