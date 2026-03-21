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
| `outport.yml` or `.outport.yml` | Port management is in place |
| `bin/dev` | Existing dev starter (likely Foreman) |
| `bin/services` | Existing Docker service wrapper |
| `bin/setup` | One-time initialization script |
| `bin/worktree` | Existing worktree tooling |
| `.env` or `.env.example` | Environment variable patterns |
| `CLAUDE.md` / `AGENTS.md` | Agent instructions that may need updating |

## 3. Handle Docker Compose File Naming

process-compose auto-discovers files in this order: `compose.yml`, `compose.yaml`,
`process-compose.yml`, `process-compose.yaml`. If the project has `compose.yml`,
it will conflict.

**Action:** If `compose.yml` exists, rename it to `docker-compose.yml`:
```bash
git mv compose.yml docker-compose.yml
```
Docker Compose supports both names natively. No other changes needed.

If the project already uses `docker-compose.yml`, no action needed.

## 4. Author process-compose.yml

Create `process-compose.yml` in the project root. Key rules:

### Shell Configuration (CRITICAL)
Always use a login shell so Docker, mise, and Homebrew are on PATH:
```yaml
version: "0.5"

log_level: info
theme: "Catppuccin Mocha"

shell:
  shell_command: "bash"
  shell_argument: "-lc"
```

Note: `theme` is optional but recommended for readability. Built-in options include
`Catppuccin Mocha`, `One Dark`, `Monokai`, `Cobalt`, `Material`. The default theme
is washed out and hard to read on dark terminals.

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

### CSS/JS Watchers
Depend on rails being started (not healthy — just started):
```yaml
  css:
    command: eval "$(mise activate bash)" && bin/rails tailwindcss:watch
    depends_on:
      rails:
        condition: process_started

  js:
    command: pnpm build --watch
    depends_on:
      rails:
        condition: process_started
```

Note: Check if commands need `eval "$(mise activate bash)"` prefix. The global
`bash -lc` login shell usually puts mise shims on PATH, but if a command uses a
tool managed by mise (Ruby, Node, pnpm), test with `bash -lc "which <tool>"` first.

### Environment Variables
process-compose auto-loads `.env` from the working directory. Variables like
`$PORT`, `$DB_PORT` from outport are available to all processes and probes.
No additional env configuration needed.

### Nuxt/Node Frontend
For projects with frontend apps:
```yaml
  frontend:
    command: pnpm dev
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

## 5. Replace bin/dev

Replace the existing `bin/dev` (typically a Foreman wrapper) with a process-compose wrapper:

```bash
#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  -D)        shift; exec process-compose up -D --no-server "$@" ;;
  stop)      exec process-compose down ;;
  status)    exec process-compose process list --output json ;;
  logs)      exec process-compose process logs "${2:?specify a service}" ;;
  restart)   exec process-compose process restart "${2:?specify a service}" ;;
  *)         exec process-compose up --no-server "$@" ;;
esac
```

**IMPORTANT:** The `--no-server` flag disables process-compose's HTTP server (port 8080).
Without this, multiple worktrees running simultaneously will conflict on port 8080.
The CLI commands (status, logs, restart) use unix sockets, not HTTP, so `--no-server` is safe.

Make it executable: `chmod +x bin/dev`

## 6. Clean Up Old Files

- Remove `bin/services` if it exists (Docker is now managed by process-compose)
- Remove `Procfile.dev` (replaced by `process-compose.yml`)
- Add `.pc/` to `.gitignore` (process-compose runtime state directory)

## 7. Update CLAUDE.md

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

## 8. Generate DEVSTACK.md

Use the template from `templates/DEVSTACK.md`, filling in project-specific details
by reading bin/setup, process-compose.yml, and any worktree tooling.

## 9. Verify

Run through this checklist before committing:

1. Dry-run: `process-compose up --dry-run` (validates config)
2. Start: `bin/dev -D` (headless)
3. Wait: `process-compose project is-ready --wait`
4. Status: `bin/dev status` (JSON — all services running/healthy)
5. Health: `curl -sf http://127.0.0.1:$PORT/up` (200 OK)
6. Logs: `bin/dev logs rails` (shows recent output)
7. Restart: `bin/dev restart rails` (restarts and comes back healthy)
8. Stop: `bin/dev stop` (clean shutdown, all ports freed)

## 10. Commit

Stage all changes and commit:
```bash
git add process-compose.yml bin/dev DEVSTACK.md .gitignore
git rm bin/services Procfile.dev  # if they existed
git add CLAUDE.md  # if updated
git commit -m "Initialize devstack: process-compose, bin/dev wrapper, DEVSTACK.md"
```
