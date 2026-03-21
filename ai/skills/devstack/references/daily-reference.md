# Daily Reference — Operating a Devstack Environment

Use this reference when a project already has `DEVSTACK.md`. Always read
that file first — it has project-specific details. This document covers
common patterns and troubleshooting.

## Starting the Stack

**As an agent (headless):**
```bash
bin/dev -D
process-compose project is-ready --wait
bin/dev status  # verify all services healthy
```

**As a human (TUI):**
```bash
bin/dev
```

## Stopping the Stack

```bash
bin/dev stop
```

## Common Operations

| Task | Command |
|------|---------|
| Check status | `bin/dev status` |
| Tail logs | `bin/dev logs <service>` |
| Restart one service | `bin/dev restart <service>` |
| REST API (JSON) | `curl -s http://localhost:8080/processes` (only if `--no-server` is not used) |
| Wait for healthy | `process-compose project is-ready --wait` |

## Creating Worktrees

Three entry points — check `DEVSTACK.md` for the project's worktree command:

```bash
# By name
bin/worktree create refactor-auth

# By GitHub issue number (auto-looks up title)
bin/worktree create 169

# By PR number
bin/worktree create --pr 42
```

After creating, open a new terminal tab:
```bash
cd <path printed by create>
bin/setup       # one-time: gems, secrets, db
bin/dev         # start everything
```

## Returning to an Existing Worktree

If services are stopped (e.g., after a reboot):
```bash
cd <worktree-path>
bin/dev         # or bin/dev -D for agents
```

No need to re-run bin/setup unless dependencies changed.

## Troubleshooting

### Rails health check fails
**Symptom:** Rails shows "Completed" or "Not Ready" in status.
**Check:** `bin/dev logs rails` — look for the error.
**Common causes:**
- Pending migrations: `bin/rails db:migrate`
- Stale PID file: `rm -f tmp/pids/server.pid`
- Port in use: `lsof -i :$PORT`

### Docker services won't start
**Check:** Is Docker Desktop running? `docker info`
**Check:** Port conflict? `bin/dev logs postgres`

### "command not found" in process logs
**Cause:** PATH not set up. Verify `process-compose.yml` uses `bash -lc` (login shell).

### Process-compose not running
**Check:** `process-compose process list` — if it errors, the daemon isn't running.
**Fix:** `bin/dev -D` to start it.

### Worktree removal fails with "contains modified or untracked files"
**Cause:** The worktree has uncommitted changes.
**Fix:** Use `bin/worktree remove -f <name>` to force removal.

## Verifying the Stack Before Telling the User It's Ready

Agents MUST verify before claiming services are up:

1. Run `bin/dev status` and check JSON output
2. Every process with `has_ready_probe: true` should show `is_ready: "Ready"`
3. Every process should show `is_running: true` — if CSS shows "Completed" instead of "Running", the Tailwind watcher exited (see init-reference.md for the `always` flag fix)
4. Hit the app's health endpoint: `curl -sf http://127.0.0.1:${PORT}/up`

Do NOT tell the user "it's running" based solely on "I started it." Verify.
