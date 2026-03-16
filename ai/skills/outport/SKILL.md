---
name: outport
description: Manage dev ports with Outport. Use when setting up a new project, adding services, resolving port conflicts, configuring monorepo cross-service URLs, or working with worktrees and multiple instances. Triggers on "outport", "port conflict", "port allocation", "dev ports", ".outport.yml", "port management", "env var ports", "derived values", "cross-service URLs", "CORS origins from ports", ".test domains", "local DNS", "reverse proxy", "cookie isolation". Also use when the user mentions running multiple instances of a project, worktree port setup, or when services need to discover each other's URLs.
---

# Outport — Dev Port Manager

Outport allocates deterministic, non-conflicting ports for dev services,
assigns `.test` hostnames, and writes everything to `.env` files. Every
framework reads `.env` — Rails, Nuxt, Django, Docker Compose — so ports and
URLs just work without manual configuration.

## Quick Reference

```bash
# Core workflow
outport init              # Create .outport.yml (interactive)
outport apply             # Allocate ports, assign hostnames, write .env
outport a                 # Short alias for apply
outport apply --force     # Clear and re-allocate all ports from scratch
outport unapply           # Remove ports and clean .env files

# Inspect
outport ports             # Show ports for current project
outport ports --derived   # Show ports and derived values
outport ports --json      # Machine-readable output
outport open              # Open HTTP services in browser
outport open web          # Open a specific service
outport status            # Show all registered projects
outport status --check    # Show with health checks (up/down)
outport gc                # Remove stale registry entries

# .test domain routing (macOS, one-time setup)
outport setup             # Install DNS resolver and proxy daemon
outport teardown          # Remove DNS resolver and daemon
outport up                # Start the daemon manually
outport down              # Stop the daemon manually

# Instance management
outport rename <old> <new>  # Rename the current instance
outport promote             # Promote the current instance to main
```

All commands support `--json` for machine-readable output.

## Setting Up a New Project

### 1. Create `.outport.yml`

Run `outport init` for interactive setup, or create manually:

```yaml
name: my-project
services:
  web:
    env_var: PORT
    protocol: http
  postgres:
    env_var: DB_PORT
  redis:
    env_var: REDIS_PORT
```

### 2. Run `outport apply`

Allocates deterministic ports (hashed from project name + service name) and
writes them to `.env`. Same inputs always produce the same ports.

### 3. Wire up your project to read from `.env`

Most frameworks read `.env` natively or with minimal setup:

- **Docker Compose** — reads `.env` automatically. Use `${DB_PORT:-5432}` in
  `compose.yml`
- **Rails** — use `dotenv-rails` gem, or reference env vars in config:
  `port: ENV.fetch("DB_PORT", 5432)`
- **Nuxt** — reads `.env` natively. Runtime config values can be overridden
  via `NUXT_*` env vars
- **Foreman** — reads `.env` automatically
- **Overmind** — does NOT auto-load `.env`. Source it in your start script:
  ```bash
  if [ -f .env ]; then set -a; source .env; set +a; fi
  ```

### 4. Commit `.outport.yml`, gitignore `.env`

`.outport.yml` is project config — commit it so worktrees and teammates
inherit it. `.env` contains allocated ports — gitignore it. Each checkout
gets its own.

## .test Domains (DNS Proxying)

Running `outport setup` once enables friendly `.test` hostnames for your
services. After setup, `http://myapp.test` routes to your app instead of
`http://localhost:24920`.

### How it works

`outport setup` installs two components (macOS, requires sudo for DNS step):

1. **DNS resolver** — `/etc/resolver/test` points `*.test` queries to a
   local DNS server on port 15353, which resolves all `*.test` names to
   `127.0.0.1`.
2. **HTTP reverse proxy** — a LaunchAgent runs on port 80, routes requests
   by `Host` header to the correct service port, and auto-updates when you
   run `outport apply`. WebSocket connections are proxied transparently.

```bash
outport setup     # Install DNS + daemon (one-time, prompts for sudo)
outport teardown  # Remove everything — reverse of setup
outport up        # Start the daemon (if it was stopped)
outport down      # Stop the daemon
```

### Configuring .test hostnames

Add `hostname` and `protocol: http` to a service to assign it a `.test`
URL:

```yaml
name: myapp
services:
  web:
    env_var: PORT
    protocol: http
    hostname: myapp.test       # → http://myapp.test
  postgres:
    env_var: DB_PORT           # no hostname: port allocation only
```

Hostname rules:
- Must include the project name (e.g., `myapp.test`, `app.myapp.test`)
- Requires `protocol: http` or `https`
- Non-main instances get the instance code appended automatically (see
  [Multiple Instances](#multiple-instances))

### Cookie isolation

Each instance gets its own `.test` hostname, so browser cookies and
sessions are isolated automatically — no incognito windows needed:

```text
myapp [main]   web → 24920   http://myapp.test
myapp [bkrm]   web → 28104   http://myapp-bkrm.test
```

## Config Reference

### Service Fields

| Field | Required | Description |
|-------|----------|-------------|
| `env_var` | yes | Environment variable name written to `.env` |
| `protocol` | no | `http`, `https`, `smtp`, `postgres`, `redis`, etc. HTTP/HTTPS services show URLs in output and work with `outport open` |
| `hostname` | no | `.test` hostname for this service (e.g., `myapp.test`). Requires `protocol: http` or `https`. Non-main instances get the instance code appended. |
| `preferred_port` | no | Port to try first. Falls back to hash-based allocation if already in use |
| `env_file` | no | Where to write. String or array. Defaults to `.env` in project root |

### Writing to Multiple `.env` Files

For monorepos, a port often needs to appear in multiple `.env` files. Use an
array for `env_file`:

```yaml
services:
  rails:
    env_var: RAILS_PORT
    protocol: http
    env_file:
      - backend/.env
      - frontend/.env          # Frontend needs this to construct API URLs
```

## Derived Values

Applications don't just need port numbers — they need URLs. Derived values
compute environment variables from your service map and write finished values
to `.env`.

### Basic syntax

```yaml
derived:
  API_URL:
    value: "${rails.url:direct}/api/v1"   # http://localhost:24920/api/v1
    env_file: frontend/.env
  CORS_ORIGINS:
    value: "${web.url}"                   # http://myapp.test (or localhost:PORT)
    env_file: backend/.env
```

- `${service_name.field}` references service fields
- `env_file` is required (no default — you must be explicit)
- Derived names must not collide with service `env_var` names

### Template Fields

| Template | Resolves to | Use case |
|----------|------------|----------|
| `${rails.port}` | `24920` | Raw port number |
| `${rails.hostname}` | `myapp.test` (or `localhost` if no hostname set) | Hostname only |
| `${rails.url}` | `http://myapp.test` | Browser-facing URLs (CORS, asset hosts), routed via proxy |
| `${rails.url:direct}` | `http://localhost:24920` | Server-to-server calls that bypass the proxy |

**When to use `url` vs `url:direct`:**
- `${service.url}` — for values the browser sends (CORS origins, asset
  hosts, OAuth redirect URIs). Uses the `.test` hostname when configured.
- `${service.url:direct}` — for server-to-server calls (API base URLs a
  backend fetches, WebSocket connections from a Node server). Always uses
  `localhost` — no proxy hop.

### Per-file value overrides

When the same env var needs different values in different files (common in
monorepos where multiple apps share a framework convention), use the object
syntax for `env_file` entries:

```yaml
derived:
  NUXT_API_BASE_URL:
    env_file:
      - file: frontend/apps/main/.env
        value: "${rails.url:direct}/api/v1"
      - file: frontend/apps/portal/.env
        value: "${rails.url:direct}/portal/api/v1"
```

You can mix plain string entries (which use the top-level `value`) with
object entries in the same list.

### Real-world monorepo example

Rails backend with two Nuxt frontends. Backend needs CORS origins from
frontend `.test` URLs. Frontends need the Rails API URL for server-side
fetches:

```yaml
name: myapp
services:
  rails:
    env_var: RAILS_PORT
    protocol: http
    hostname: myapp.test
    env_file: backend/.env
  frontend_main:
    env_var: MAIN_PORT
    protocol: http
    hostname: app.myapp.test
    env_file:
      - frontend/apps/main/.env
      - backend/.env               # Backend needs this for CORS
  frontend_portal:
    env_var: PORTAL_PORT
    protocol: http
    hostname: portal.myapp.test
    env_file:
      - frontend/apps/portal/.env
      - backend/.env               # Backend needs this for CORS

derived:
  # Server-to-server API URLs (bypass proxy — use direct localhost)
  NUXT_API_BASE_URL:
    env_file:
      - file: frontend/apps/main/.env
        value: "${rails.url:direct}/api/v1"
      - file: frontend/apps/portal/.env
        value: "${rails.url:direct}/portal/api/v1"

  # Backend CORS (browser-facing — use .test hostnames)
  CORE_CORS_ORIGINS:
    value: "${frontend_main.url},${frontend_portal.url}"
    env_file: backend/.env

  # Backend asset host (browser-facing)
  SHRINE_ASSET_HOST:
    value: "${rails.url}"
    env_file: backend/.env
```

After `outport apply`, every service has the right ports AND the right URLs.
No hardcoded values survive.

## Framework Env Var Conventions

When setting up derived values, knowing how frameworks map env vars to
config is essential:

| Framework | Convention | Example |
|-----------|-----------|---------|
| **Nuxt** | `NUXT_` prefix maps to `runtimeConfig` | `NUXT_API_BASE_URL` overrides `runtimeConfig.apiBaseUrl` |
| **Rails (AnyWayConfig)** | `PREFIX_ATTR` maps to config class | `CORE_CORS_ORIGINS` overrides `CoreConfig.cors_origins` |
| **Rails (Shrine)** | Same AnyWayConfig pattern | `SHRINE_ASSET_HOST` overrides `ShrineConfig.asset_host` |
| **Django** | Typically reads `os.environ` directly | Name vars however your `settings.py` expects |
| **Docker Compose** | Reads `.env` automatically | `${DB_PORT:-5432}` in `compose.yml` |

The derived values feature is most powerful when it writes env vars that
match these framework conventions — the framework reads the value natively
and no config code changes are needed.

## .env File Format

Outport writes managed variables in a fenced block at the bottom of each
`.env` file:

```env
# Your own variables — Outport never touches these
SECRET_KEY=abc123
RAILS_ENV=development

# --- begin outport.dev ---
DB_PORT=21536
RAILS_PORT=24920
NUXT_API_BASE_URL=http://localhost:24920/api/v1
# --- end outport.dev ---
```

On each `outport apply`, the fenced block is replaced with current values.
Variables removed from `.outport.yml` disappear from the block. Everything
outside the block is preserved.

## Multiple Instances

Outport detects git worktrees automatically. Each worktree gets unique ports
and its own `.test` hostname — no configuration needed:

```bash
# Main checkout
$ outport apply
my-app [main]
  rails  RAILS_PORT → 24920  http://my-app.test
  web    MAIN_PORT  → 21349

# Worktree — different ports, different hostname, zero conflicts
$ cd ../my-app-feature && outport apply
  Registered as my-app-bkrm. Use 'outport rename bkrm <name>' to rename.
my-app [bkrm]
  rails  RAILS_PORT → 20192  http://my-app-bkrm.test
  web    MAIN_PORT  → 21133
```

Derived values are recomputed per instance — CORS origins, API URLs, and
all other derived values automatically use that instance's ports and
hostnames. Two full instances run simultaneously with no port collisions,
no hostname collisions, and no manual configuration.

Manage instances with:

```bash
outport rename bkrm my-feature   # Rename an instance
outport promote                   # Promote current instance to main
```

## Integrating with Setup Scripts

Run `outport apply` early in your project's setup flow — after `.env` file
creation but before services start. Make it optional so developers without
Outport aren't blocked:

```bash
# In bin/setup or similar
if command -v outport > /dev/null 2>&1; then
  outport apply
else
  echo "Outport not found — using default ports"
  echo "Install: brew install steveclarke/tap/outport"
fi
```

## Common Tasks

### Port conflict with another project
Run `outport apply` in both projects. Outport's registry ensures no
collisions across all registered projects.

### Ports are stale from an old allocation
Run `outport apply --force` to clear and re-allocate.

### Freeing ports from a project you're done with
Run `outport unapply` to remove from registry and free all ports.

### Adding a new service to an existing project
Add it to `.outport.yml` and run `outport apply`. Existing allocations
are preserved — only the new service gets a port.

### Agent needs to know the project's URLs
Run `outport ports --json` for structured output with ports, protocols,
and URLs.

### Services moved to different ports than expected
Check `outport status` to see all allocations. If another project holds
the ports you want, unapply it first, then `outport apply --force`.

### .test domain not resolving
Run `outport status` to verify the daemon is configured. If `outport setup`
was never run, run it now. If the daemon is stopped, run `outport up`.
