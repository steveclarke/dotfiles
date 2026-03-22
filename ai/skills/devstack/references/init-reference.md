# Init Reference — Setting Up Devstack for a Project

Follow these steps to initialize devstack for a project that doesn't have it yet.

## 1. Check Prerequisites

Verify process-compose is installed:

```bash
command -v process-compose >/dev/null && process-compose version || echo "Not installed"
```

If not installed: `brew install f1bonacc1/tap/process-compose`

Also verify: Docker Desktop running, outport CLI available (if project uses it).

## 2. Audit the Project

Look for these files and note what exists:

| File | What it tells you |
|------|-------------------|
| `Procfile.dev` | Processes to convert (web, css, js, etc.) |
| `compose.yml` or `docker-compose.yml` | Docker services (Postgres, Redis, Mailpit, etc.) |
| `outport.yml` | Port management is in place |
| `bin/dev` | Existing dev starter (likely Foreman) |
| `bin/services` | Existing Docker service wrapper |
| `bin/setup` | One-time initialization script |
| `bin/worktree` | Existing worktree tooling |
| `.env` or `.env.example` | Environment variable patterns |
| `CLAUDE.md` / `AGENTS.md` | Agent instructions that may need updating |

## 3. Handle Docker Compose File Naming

process-compose auto-discovers files in this order: `compose.yml`, `compose.yaml`,
`process-compose.yml`, `process-compose.yaml`. If the project has `compose.yml`
**in the same directory** as `process-compose.yml`, it will conflict.

**Action:** If `compose.yml` exists in the project root, rename it to `docker-compose.yml`:
```bash
git mv compose.yml docker-compose.yml
```
Docker Compose supports both names natively. No other changes needed.

If `compose.yml` is in a subdirectory (e.g., `backend/compose.yml`), no conflict
exists — process-compose only auto-discovers in its own directory.

## 4. Author process-compose.yml

Create `process-compose.yml` in the project root. Key rules:

### Shell Configuration (CRITICAL)
Always use a login shell so Docker, mise, and Homebrew are on PATH:
```yaml
version: "0.5"

log_level: info

shell:
  shell_command: "bash"
  shell_argument: "-lc"
```

**TUI Theme:** The default theme is washed out on dark terminals. Themes are a
**user setting**, not a project config. On macOS, the settings file is at
`~/Library/Application Support/process-compose/settings.yaml` (NOT `~/.config/`):
```yaml
theme: Catppuccin Mocha
sort:
    by: RESTARTS
    isReversed: false
disable_exit_confirmation: false
```
Built-in options: `Catppuccin Mocha`, `One Dark`, `Monokai`, `Cobalt`, `Material`.
Do NOT put `theme:` in `process-compose.yml` — it will be silently ignored.

### mise Activation (CRITICAL)

The login shell (`bash -lc`) is not always sufficient to load mise-managed tool
versions. Any process that uses a mise-managed tool (Ruby, Node, pnpm) MUST
include `eval "$(mise activate bash)"` in its command:

```yaml
  rails:
    command: eval "$(mise activate bash)" && bin/rails server -p $PORT
```

Without this, processes may pick up the macOS system Ruby (2.6) or other system
tool versions instead of the mise-managed versions. Always add the activation
prefix — it's harmless if mise is already active and critical when it isn't.

### Docker Services
For each service in docker-compose.yml, create a process entry with a readiness
probe and shutdown command:
```yaml
processes:
  postgres:
    command: docker compose up postgres
    readiness_probe:
      exec:
        command: "docker compose exec postgres pg_isready -U postgres"
      initial_delay_seconds: 2
      period_seconds: 3
      failure_threshold: 10
    shutdown:
      command: docker compose stop postgres

  mailpit:
    command: docker compose up mailpit
    shutdown:
      command: docker compose stop mailpit
```

If the Docker Compose file is in a subdirectory (e.g., `backend/compose.yml`),
prefix commands with `cd backend &&`:
```yaml
  postgres:
    command: cd backend && docker compose up postgres
    readiness_probe:
      exec:
        command: "cd backend && docker compose exec postgres pg_isready -U postgres"
      ...
    shutdown:
      command: cd backend && docker compose stop postgres
```

### Rails Server
Use an exec probe with curl for health checks. Do NOT use http_get — the
outport reverse proxy redirects port 80 to HTTPS, breaking the built-in
HTTP probe when it falls back to no port:
```yaml
  rails:
    command: eval "$(mise activate bash)" && bin/rails server -p $PORT
    depends_on:
      postgres:
        condition: process_healthy
    readiness_probe:
      exec:
        command: "curl -sf http://127.0.0.1:${PORT}/up"
      initial_delay_seconds: 3
      period_seconds: 5
      failure_threshold: 10
```

**Rails host authorization:** If the project uses outport's `.test` domain
routing, Rails 8+ will block requests with "Blocked host" errors. Add this
to `config/environments/development.rb`:
```ruby
config.hosts << ".projectname.test"
```
The leading dot is a wildcard covering all subdomains.

### CSS/JS Watchers
Depend on rails being started (not healthy — just started):
```yaml
  css:
    command: eval "$(mise activate bash)" && bin/rails 'tailwindcss:watch[always]'
    depends_on:
      rails:
        condition: process_started

  js:
    command: eval "$(mise activate bash)" && pnpm build --watch
    depends_on:
      rails:
        condition: process_started
```

**CRITICAL — Tailwind CSS v4 `always` flag:** The `[always]` argument is required.
Tailwind v4's watch mode (`-w`) exits when stdin is closed. Process-compose doesn't
provide stdin to processes, so without `always` the CSS watcher does an initial build
then silently dies. The process shows as "Completed" in status — easy to miss because
it looks like a successful one-shot build. The `always` flag maps to `--watch=always`
which keeps the watcher alive regardless of stdin.

### One-Shot Processes
Some tasks need to run once before other processes start (e.g., building shared
frontend layers). Use `availability` to prevent restarts and `exit_on_end: false`
so process-compose doesn't shut down when it exits:
```yaml
  prepare_layers:
    command: eval "$(mise activate bash)" && pnpm prepare:layers
    availability:
      restart: "no"
      exit_on_end: false
```

Other processes can depend on it completing:
```yaml
  frontend:
    command: eval "$(mise activate bash)" && pnpm dev
    depends_on:
      prepare_layers:
        condition: process_completed
```

### Environment Variables
process-compose auto-loads `.env` from the working directory. Variables like
`$PORT`, `$DB_PORT` from outport are available to all processes and probes.

**Monorepo note:** If the `.env` file is in a subdirectory (e.g., `backend/.env`),
`bin/dev` should source it before launching process-compose. See the bin/dev
section below.

### Nuxt/Node Frontend
For projects with frontend apps:
```yaml
  frontend:
    command: eval "$(mise activate bash)" && pnpm dev
    depends_on:
      rails:
        condition: process_healthy
```

### Redis
```yaml
  redis:
    command: docker compose up redis
    readiness_probe:
      exec:
        command: "docker compose exec redis redis-cli ping"
      initial_delay_seconds: 1
      period_seconds: 3
      failure_threshold: 10
    shutdown:
      command: docker compose stop redis
```

### Dev URLs (outport projects)
For projects using outport, add a `urls` process that displays all allocated
URLs and ports after the app is healthy. Create `bin/dev-urls`:

```sh
#!/usr/bin/env sh
# Print dev URLs and ports. Runs after rails is healthy.

if command -v outport > /dev/null 2>&1; then
  outport ports
  echo ""
fi

# Stay alive so process-compose keeps this process running
exec tail -f /dev/null
```

```yaml
  urls:
    command: bin/dev-urls
    depends_on:
      rails:
        condition: process_healthy
```

This gives immediate visibility into what's running and where — useful in both
the TUI and when agents check logs.

## 5. Create bin/dev

Replace the existing `bin/dev` (if any) with a process-compose wrapper.

### UDS-Only Server (CRITICAL for worktree isolation)

process-compose runs an HTTP API server that client commands (`status`,
`restart`, `logs`, `down`) connect to. By default this listens on TCP port
8080. Multiple worktrees running simultaneously would all collide on that port.

The solution is UDS (unix domain sockets) mode — two flags:

- **`-U`** — use a unix socket instead of TCP. No port at all.
- **`-u /path/to/sock`** — set a deterministic socket path. Without this,
  the default path includes the PID and changes every run, so client
  commands can't find the server.

**IMPORTANT:** Do NOT use `--no-server`. Despite the name, it disables ALL
servers — including UDS. In process-compose, UDS is HTTP-over-unix-socket, so
"no server" kills UDS too. This is confirmed by the maintainer (GitHub #358).

### Template

```bash
#!/usr/bin/env bash
set -euo pipefail

# Source .env if it's not in the project root (monorepo pattern)
# if [[ -f backend/.env ]]; then
#   set -a
#   source backend/.env
#   set +a
# fi

# UDS-only server: no TCP port, deterministic socket path.
# Uses project name for worktree isolation. If using outport,
# COMPOSE_PROJECT_NAME is unique per worktree (e.g., "myapp-1").
pc_sock="${TMPDIR:-/tmp}process-compose-${COMPOSE_PROJECT_NAME:-myproject}.sock"
pc_flags=(-U -u "$pc_sock")

case "${1:-}" in
  -D)        shift; process-compose up -D "${pc_flags[@]}" "$@" ;;
  stop)      process-compose "${pc_flags[@]}" down ;;
  status)
    fmt="--output wide"; [[ "${2:-}" == "--json" ]] && fmt="--output json"
    process-compose "${pc_flags[@]}" process list $fmt 2>/dev/null || { echo "Dev environment is not running. Start it with: bin/dev"; exit 1; }
    ;;
  logs)      process-compose "${pc_flags[@]}" process logs "${2:?specify a service}" ;;
  restart)   process-compose "${pc_flags[@]}" process restart "${2:?specify a service}" ;;
  *)         process-compose up "${pc_flags[@]}" "$@" ;;
esac
```

**Adapt for your project:**
- Uncomment the `.env` sourcing if port variables aren't in the project root
- Replace `myproject` with your project name (or use `COMPOSE_PROJECT_NAME`
  if outport is managing it)

Make it executable: `chmod +x bin/dev`

## 6. Create bin/worktree

Git worktrees let you run multiple isolated instances of the project simultaneously —
each with its own ports, database, and dev stack. The `bin/worktree` script wraps
`git worktree` with GitHub integration and outport port allocation.

Use the template from `templates/bin-worktree`. Adapt these lines:

- **`WORKTREE_ROOT`** — set to `$HOME/src/<projectname>-worktrees`
- **`DEFAULT_BRANCH`** — set to `master` or `main` (whatever the project uses)

```bash
cp templates/bin-worktree bin/worktree
chmod +x bin/worktree
```

**Features:**
- **Create from name:** `bin/worktree create refactor-auth` — creates branch + worktree
- **Create from GitHub issue:** `bin/worktree create 169` — fetches issue title, slugifies
  it, creates branch `169-slugified-title`
- **Create from PR:** `bin/worktree create --pr 42` — fetches the PR's branch name
- **List:** `bin/worktree list` — shows all worktrees with paths and ports
- **Remove:** `bin/worktree remove <name>` — stops services, removes worktree, optionally
  deletes the branch
- **Navigate:** `cd $(bin/worktree go 169)` — fuzzy-finds worktree by name/number

On create, the script automatically runs `outport up` to allocate unique ports for
the new instance. Each worktree gets its own `.env`, its own Docker containers
(via `COMPOSE_PROJECT_NAME`), and its own `.test` hostname — zero conflicts.

After creating a worktree, the user opens a new terminal tab and runs:
```bash
cd <worktree-path>
bin/setup    # install deps, prepare DB
bin/dev      # start everything
```

The script copies next-step instructions to the clipboard for convenience.

**Requires:** `gh` CLI (for issue/PR lookups), `outport` (for port allocation).

## 7. Clean Up Old Files

- Remove `bin/services` if it exists (Docker is now managed by process-compose)
- Remove `Procfile.dev` (replaced by `process-compose.yml`)
- Add `.pc/` to `.gitignore` (process-compose runtime state directory)

## 8. Update CLAUDE.md

Find and update these sections:

- **Services section:** Replace `bin/services` references. Docker services are now
  managed by process-compose via `docker-compose.yml` and `process-compose.yml`.
- **Running the App section:** Replace with bin/dev commands:
  - `bin/dev` — TUI for humans
  - `bin/dev -D` — headless for agents
  - `bin/dev stop` — stop all
  - `bin/dev restart rails` — restart after code changes
- **Remove:** "Do NOT run `bin/dev` from Claude" — agents SHOULD use `bin/dev -D`
- **Remove:** "touch tmp/restart.txt" — use `bin/dev restart rails` instead
- **Update:** Any stale references to `compose.yml` → `docker-compose.yml`
- **Update:** "Foreman" → "process-compose" in any port loading references
- **Add:** A pointer to `DEVSTACK.md` for full dev environment documentation

## 9. Generate DEVSTACK.md

Use the template from `templates/DEVSTACK.md`, filling in project-specific details
by reading bin/setup, process-compose.yml, and any worktree tooling.

## 10. Verify

Run through this checklist before committing:

1. Dry-run: `process-compose up --dry-run` (validates config)
2. Start: `bin/dev -D` (headless)
3. Wait: `sleep 15` (give services time to start)
4. Status: `bin/dev status` (JSON — all services running/healthy)
5. Health: `curl -sf http://127.0.0.1:$PORT/up` (200 OK)
6. Logs: `bin/dev logs rails` (shows recent output)
7. Restart: `bin/dev restart rails` (restarts and comes back healthy)
8. Stop: `bin/dev stop` (clean shutdown)

**If client commands fail** (connection refused, socket not found), check:
- Is the server actually running? (`pgrep -f process-compose`)
- Does the socket file exist? (`ls ${TMPDIR}process-compose-*.sock`)
- Are you running `bin/dev` from the project root? (socket path is relative)
- Did you accidentally use `--no-server`? (removes ALL servers including UDS)

## 11. Commit

Stage all changes and commit:
```bash
git add process-compose.yml bin/dev bin/worktree DEVSTACK.md .gitignore
git rm bin/services Procfile.dev  # if they existed
git add CLAUDE.md  # if updated
git commit -m "Initialize devstack: process-compose, bin/dev, bin/worktree, DEVSTACK.md"
```
