# Devstack — <PROJECT_NAME>

## Prerequisites

<!-- List tools that must be installed -->
- Ruby <VERSION> (via mise)
- Docker Desktop
- outport CLI (`brew install steveclarke/tap/outport`)
- process-compose (`brew install f1bonacc1/tap/process-compose`)

## Setup (first time)

<!-- Steps to run once after cloning or creating a worktree -->
```bash
bin/setup    # Install deps, fetch secrets, prepare databases
```

## Start

```bash
bin/dev      # TUI — interactive dashboard (for humans)
bin/dev -D   # Headless daemon (for agents)
```

**Services managed by process-compose:**

| Service | Description |
|---------|-------------|
<!-- List each process from process-compose.yml -->
| postgres | PostgreSQL database |
| mailpit | Email testing |
| rails | Rails application server |
| css | Tailwind CSS watcher |

## Stop

```bash
bin/dev stop
```

## Health Check

```bash
bin/dev status    # JSON status of all processes
```

<!-- Describe expected output -->
Processes with `has_ready_probe: true` should show `is_ready: "Ready"`.
One-shot processes (css, js) show as "Completed" — this is normal.

## Logs

```bash
bin/dev logs <service>    # e.g., bin/dev logs rails
```

## Restart

```bash
bin/dev restart <service>    # e.g., bin/dev restart rails
```

<!-- Note which services auto-reload vs need manual restart -->

## Worktrees

<!-- Document the project's worktree tooling -->
```bash
bin/worktree create <name>     # Create isolated instance
cd <path>                      # Open new terminal tab
bin/setup                      # One-time setup
bin/dev                        # Start everything
```

<!-- Worktree directory, input types (name, issue, PR) -->

## Notes

<!-- Project-specific gotchas and things agents should know -->
- Docker Compose file is `docker-compose.yml` (not `compose.yml`)
- process-compose uses login shell (`bash -lc`) for PATH resolution
- Rails health check uses exec probe with curl
- process-compose auto-loads `.env` for port variables from outport
