---
name: overmind-dev
description: Set up Overmind as an agentic-friendly process manager for dev servers. Use when setting up a new project's dev environment, adding services to a Procfile, or when the user mentions Overmind, Procfile, dev server orchestration, or wants to manage multiple services (web server, CSS watcher, docs site, background workers) from a single command.
---

# Overmind for Development

Overmind is a tmux-based process manager. Key advantage over Foreman: daemon
mode, individual process restart, and interactive debugging via `overmind connect`.

Requires **tmux** (installed automatically by `brew install overmind` on macOS).

## Setup Checklist

1. **`Procfile.dev`** at project root — one service per line (`name: command`)
2. **`bin/dev`** — bash wrapper with subcommands (start, stop, restart, status, logs, help)
3. **`.overmind.env`** — socket path + recommended settings
4. **`tmp/.keep`** — tracked by git; `.gitignore` has `/tmp/*` + `!/tmp/.keep`

## `.overmind.env` — Recommended Settings

```env
OVERMIND_SOCKET=tmp/overmind.sock
OVERMIND_NO_PORT=1
OVERMIND_CAN_DIE=css
```

| Setting | Why |
|---------|-----|
| `OVERMIND_SOCKET=tmp/overmind.sock` | Keeps project root clean, avoids macOS 104-char socket path limit |
| `OVERMIND_NO_PORT=1` | Prevents Overmind from injecting PORT=5000/5100/5200 which shadows explicit port vars in Procfile |
| `OVERMIND_CAN_DIE=css` | Tailwind watcher crash doesn't tear down the whole stack |

Optional: `OVERMIND_AUTO_RESTART=css` to auto-restart watchers on crash.

## Key Design Decisions

- **Daemon by default for engine/library projects** — `bin/dev` daemonizes
  so agents and developers can keep working. `-f` flag for foreground when
  debugging. For app projects, foreground by default may be better (crashes
  are immediately visible).
- **Explicit `-s "$SOCKET"` on every overmind command** — don't rely on
  `.overmind.env` alone. The socket flag works regardless of CWD, which
  matters for scripts that `cd` into subdirectories.
- **Socket in `tmp/`** — keeps project root clean (Rails convention).
- **Stale socket handling** — `bin/dev` cleans up stale sockets before
  starting (prevents "already running" errors). `bin/dev stop` falls back
  to removing the socket if `overmind quit` fails.

## bin/dev Commands

| Command | What it does |
|---------|-------------|
| `bin/dev` | Start daemonized (default) |
| `bin/dev -f` | Start in foreground |
| `bin/dev stop` | Stop running instance |
| `bin/dev restart web` | Restart a specific service |
| `bin/dev status` | Show process statuses and URLs |
| `bin/dev logs` | Tail all logs |
| `bin/dev logs web` | Tail logs from a specific service |
| `bin/dev -- -l web,css` | Pass flags directly to overmind |

## Procfile Patterns

```procfile
# Standard Rails
web: bin/rails server -p ${PORT:-3000}
css: bin/rails tailwindcss:watch

# With explicit port vars (use with OVERMIND_NO_PORT=1)
web: cd lookbook && bin/rails server -p ${LOOKBOOK_PORT:-4001}
docs: cd docs && bin/bridgetown start -P ${DOCS_PORT:-4000}

# With workers
worker: bundle exec sidekiq
```

## Agent Workflow

1. Check status: `bin/dev status 2>/dev/null && echo "running" || echo "not running"`
2. Start daemonized: `bin/dev` (never foreground — blocks terminal)
3. After lib/ changes: `bin/dev restart web` (app/ changes autoload)
4. Read logs: `bin/dev logs web` (single process) or `bin/dev logs` (all)
5. Leave running at session end — user runs `bin/dev stop` when done.

## Useful Overmind Flags

| Flag | Purpose |
|------|---------|
| `-D` | Daemonize |
| `-f FILE` | Specify Procfile path |
| `-s SOCKET` | Specify socket path |
| `-r PROCESS` | Auto-restart on crash (`-r all` for everything) |
| `-l PROCESS` | Only start specific processes (`-l web,css`) |
| `-N` | Disable automatic PORT assignment (same as `OVERMIND_NO_PORT=1`) |

## Common Pitfalls

- **Stale sockets** — after crash/reboot, `overmind start` says "already
  running". Fix: `rm tmp/overmind.sock` (or let `bin/dev` handle it).
- **Port shadows** — without `OVERMIND_NO_PORT=1`, Overmind injects
  PORT=5000/5100/5200 per process, overriding explicit port vars.
- **Socket path length** — macOS limits Unix socket paths to 104 chars.
  `tmp/overmind.sock` (relative) avoids this. Never use `$TMPDIR`.
- **Nested tmux** — if inside tmux, `overmind connect` nests sessions.
  Detach with `Ctrl-b Ctrl-b d` (double prefix).
