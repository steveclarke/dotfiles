---
name: overmind-dev
description: Set up Overmind as an agentic-friendly process manager for dev servers. Use when setting up a new project's dev environment, adding services to a Procfile, or when the user mentions Overmind, Procfile, dev server orchestration, or wants to manage multiple services (web server, CSS watcher, docs site, background workers) from a single command.
---

# Overmind for Agentic Development

Overmind is a process manager built on tmux that solves the biggest pain point
in agentic coding: dev servers that block the agent's terminal. With Overmind
running daemonized, the agent can start services, restart them after changes,
and read logs — all without hanging.

## Why Overmind over Foreman

- **Daemonized mode (`-D`)** — starts in background, returns control immediately
- **Per-process control** — restart, stop, or connect to any single service
- **Log access via tmux** — agent can read any service's output without attaching
- **No terminal blocking** — the classic agent problem of `bin/dev` hanging is gone

## Prerequisites

Overmind requires **tmux**. Both must be installed.

**macOS (Homebrew):**

```bash
brew install overmind
```

Homebrew installs tmux automatically as a dependency.

**Linux (Debian/Ubuntu):**

```bash
sudo apt install tmux
# Download overmind binary from https://github.com/DarthSim/overmind/releases
```

**Linux (Arch):**

```bash
sudo pacman -S tmux overmind
```

**Go install:**

```bash
sudo apt install tmux   # or your distro's package manager
go install github.com/DarthSim/overmind/v2@latest
```

**Verify both are available:**

```bash
command -v tmux > /dev/null 2>&1 || echo "tmux is not installed"
command -v overmind > /dev/null 2>&1 || echo "overmind is not installed"
```

## Setup Pattern

### 1. Create a root Procfile.dev

Put a `Procfile.dev` at the project root listing all services:

```procfile
web: bin/rails server -p 3000
css: bin/rails tailwindcss:watch
worker: bundle exec sidekiq
```

Each line: `name: command`. Use `cd` prefixes when services run from
subdirectories:

```procfile
web: cd some/subdir && bin/rails server -p 3000
docs: cd docs && npm run dev
```

### 2. Create bin/dev

```sh
#!/usr/bin/env sh
set -e

if ! command -v overmind > /dev/null 2>&1; then
  echo "Error: overmind is not installed."
  echo "Install with: brew install overmind (macOS) or see https://github.com/DarthSim/overmind"
  exit 1
fi

exec overmind start -f Procfile.dev -D "$@"
```

`chmod +x bin/dev`. The `-D` flag daemonizes by default. `"$@"` passes through
any extra overmind flags.

### 3. Add .overmind.sock to .gitignore

```
.overmind.sock
```

## Commands Reference

All commands must run from the directory containing `.overmind.sock` (where
`bin/dev` was started — typically the project root).

### Starting and stopping

| Command | What it does |
|---------|-------------|
| `bin/dev` | Start all services daemonized |
| `overmind stop` | Stop all services and clean up |
| `overmind stop web` | Stop just one service |
| `overmind restart web` | Restart one service (e.g. after config changes) |

### Reading logs

| Command | What it does |
|---------|-------------|
| `overmind echo` | Tail all logs interleaved (streaming — use with timeout) |
| `tmux -S ... capture-pane -t session:process -p` | Capture recent output (see below) |

### Reading logs non-interactively (for agents)

`overmind echo` streams forever, so for non-interactive log reading, capture
the tmux pane directly:

```bash
# Find the tmux socket
# macOS:
SOCK=$(ls /private/tmp/tmux-$(id -u)/overmind-* 2>/dev/null | head -1)
# Linux:
SOCK=$(ls /tmp/tmux-$(id -u)/overmind-* 2>/dev/null | head -1)

# Capture recent output from a specific service (last screenful)
tmux -S "$SOCK" capture-pane -t SESSION:PROCESS -p

# Capture with history (last 500 lines)
tmux -S "$SOCK" capture-pane -t SESSION:PROCESS -p -S -500
```

The session name is typically the project directory name. Process names match
the Procfile labels (web, css, docs, etc.).

To find the session name:

```bash
tmux -S "$SOCK" list-sessions
```

### Interactive (for humans)

| Command | What it does |
|---------|-------------|
| `overmind connect web` | Attach to web process (Ctrl+B, then D to detach) |
| `overmind echo` | Tail all logs interleaved |

## Agent Workflow

When working as an agent on a project that uses Overmind:

1. **At session start** — check if overmind is already running:
   ```bash
   ls .overmind.sock 2>/dev/null && echo "running" || echo "not running"
   ```

2. **Start if needed** — run `bin/dev` (returns immediately due to `-D`)

3. **After editing server-affecting files** (routes, config, initializers,
   theme modules, templates) — restart the relevant service:
   ```bash
   overmind restart web
   ```

4. **After editing CSS/Tailwind config** — the css watcher usually picks it up
   automatically. If not:
   ```bash
   overmind restart css
   ```

5. **To debug issues** — read the logs:
   ```bash
   SOCK=$(ls /private/tmp/tmux-$(id -u)/overmind-* 2>/dev/null || ls /tmp/tmux-$(id -u)/overmind-* 2>/dev/null)
   SESSION=$(tmux -S "$SOCK" list-sessions -F '#{session_name}' | head -1)
   tmux -S "$SOCK" capture-pane -t "$SESSION":web -p -S -100
   ```

6. **At session end** — leave it running. The user can `overmind stop` when done.

## Common Procfile Patterns

### Standard Rails app

```procfile
web: bin/rails server -p 3000
css: bin/rails tailwindcss:watch
```

### Rails with background workers

```procfile
web: bin/rails server -p 3000
css: bin/rails tailwindcss:watch
worker: bundle exec sidekiq
jobs: bin/jobs
```

### Rails engine with test app + docs site

```procfile
web: cd test/dummy && bin/rails server -p 4001
css: cd test/dummy && bin/rails tailwindcss:watch
docs: cd docs && bin/bridgetown start
```

### Node.js / Next.js

```procfile
web: npm run dev
worker: npm run worker
```

### Mixed stack

```procfile
api: cd backend && bin/rails server -p 3000
web: cd frontend && npm run dev
worker: cd backend && bundle exec sidekiq
```

## Overmind Flags

| Flag | Purpose |
|------|---------|
| `-D` | Daemonize (run in background) |
| `-f FILE` | Specify Procfile path |
| `-r PROCESS` | Auto-restart process if it dies (`-r all` for everything) |
| `-l PROCESS` | Only start specific processes (`-l web,css`) |
| `-N` | Don't colorize output |

## Existing Project Migration

If a project already has a `Procfile.dev` in a subdirectory (e.g. Rails'
default at `Procfile.dev`), create a root-level one that wraps those services
with `cd` prefixes if needed. Keep the original so standalone usage still works.
