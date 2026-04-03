---
name: outport
description: Manage dev ports with Outport. Use when setting up a new project, adding services, resolving port conflicts, configuring monorepo cross-service URLs, or working with worktrees and multiple instances. Triggers on "outport", "port conflict", "port allocation", "dev ports", "outport.yml", "port management", "env var ports", "computed values", "cross-service URLs", "CORS origins from ports", ".test domains", "local DNS", "reverse proxy", "cookie isolation", "tunnel", "share localhost", "public URL", "cloudflare tunnel", "outport doctor", "health check", "diagnose outport", "QR code", "mobile access", "phone testing", "LAN IP", "hostname aliases", "multiple hostnames", "subdomain routing". Also use when the user mentions running multiple instances of a project, worktree port setup, or when services need to discover each other's URLs.
---

# Outport — Dev Port Manager

Outport allocates deterministic, non-conflicting ports for dev services,
assigns `.test` hostnames, and writes everything to `.env` files. Every
framework reads `.env` — Rails, Nuxt, Django, Docker Compose — so ports and
URLs just work without manual configuration.

## Quick Reference

```bash
# Project commands
outport init              # Create outport.yml (interactive)
outport up                # Allocate ports, assign hostnames, write .env
outport up --force        # Clear and re-allocate all ports from scratch
outport down              # Remove ports and clean .env files

# Inspect & diagnose
outport status            # Show project status (ports, health, URLs)
outport status --computed # Include computed values
outport ports             # Show ports with live process info (PID, memory, uptime)
outport ports --all       # Full machine scan (Outport + non-Outport ports)
outport ports --down      # Include ports with no running process
outport ports kill <svc>  # Kill process by service name or port number
outport ports kill --orphans  # Kill all orphaned dev processes
outport open              # Open HTTP services in browser
outport open web          # Open a specific service
outport share             # Tunnel HTTP services to public URLs
outport share web         # Tunnel a specific service
outport qr                # Show QR codes for mobile device access
outport qr --tunnel       # Show QR codes with tunnel URLs
outport doctor            # Check system health and project config

# System commands (machine-wide)
outport system start      # Install DNS, CA, and start the daemon
outport system stop       # Stop the daemon
outport system restart    # Re-write plist and restart the daemon
outport system status     # Show all registered projects
outport system status --check  # Show with health checks (up/down)
outport system prune      # Remove stale registry entries
outport system uninstall  # Remove DNS resolver, daemon, and CA

# Instance management
outport rename <old> <new>  # Rename the current instance
outport promote             # Promote the current instance to main
```

All commands support `--json` for machine-readable output.

## Setting Up a New Project

### 1. Create `outport.yml`

Run `outport init` for interactive setup, or create manually:

```yaml
name: my-project
services:
  web:
    env_var: PORT
  postgres:
    env_var: DB_PORT
  redis:
    env_var: REDIS_PORT
```

### 2. Run `outport up`

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

### 4. Commit `outport.yml`, gitignore `.env`

`outport.yml` is project config — commit it so worktrees and teammates
inherit it. `.env` contains allocated ports — gitignore it. Each checkout
gets its own.

## .test Domains (DNS Proxying)

Running `outport system start` once enables friendly `.test` hostnames for
your services. After setup, `https://myapp.test` routes to your app instead
of `http://localhost:24920`.

### How it works

`outport system start` installs three components (requires sudo for DNS and CA trust):

1. **DNS resolver** — configures your OS to send `*.test` queries to a
   local DNS server on port 15353, which resolves all `*.test` names to
   `127.0.0.1`. On macOS this is `/etc/resolver/test`; on Linux it's a
   systemd-resolved drop-in config.
2. **Reverse proxy** — a daemon runs on ports 80 and 443, routes
   requests by `Host` header to the correct service port, and auto-updates
   when you run `outport up`. WebSocket connections are proxied transparently.
   Managed by launchd on macOS, systemd on Linux.
3. **Local CA** — generates a Certificate Authority for HTTPS. HTTP requests
   on port 80 are redirected to HTTPS via 307.

```bash
outport system start      # Install DNS + CA + daemon (one-time, prompts for sudo)
outport system stop       # Stop the daemon
outport system restart    # Re-write plist and restart the daemon
outport system uninstall  # Remove everything — reverse of start
```

### Configuring .test hostnames

Add `hostname` to a service to assign it a `.test` URL:

```yaml
name: myapp
services:
  web:
    env_var: PORT
    hostname: myapp.test       # → https://myapp.test
  postgres:
    env_var: DB_PORT           # no hostname: port allocation only
```

Hostname rules:
- Must include the project name (e.g., `myapp.test`, `app.myapp.test`)
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

### Project-Level Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | yes | Project identifier. Used for port allocation and hostname generation. |
| `open` | no | List of service names that `outport open` opens by default. When omitted, opens all services with a hostname. |

### Service Fields

| Field | Required | Description |
|-------|----------|-------------|
| `env_var` | yes | Environment variable name written to `.env` |
| `hostname` | no | `.test` hostname for this service (e.g., `myapp.test`). Implies HTTP. Non-main instances get the instance code appended. |
| `aliases` | no | Named alternative hostnames (map of label → hostname). Each alias routes to the same port. Requires `hostname`. |
| `preferred_port` | no | Port to try first. Falls back to hash-based allocation if already in use |
| `env_file` | no | Where to write. String or array. Defaults to `.env` in project root |

### Writing to Multiple `.env` Files

For monorepos, a port often needs to appear in multiple `.env` files. Use an
array for `env_file`:

```yaml
services:
  rails:
    env_var: RAILS_PORT
    env_file:
      - backend/.env
      - frontend/.env          # Frontend needs this to construct API URLs
```

## Computed Values

Applications don't just need port numbers — they need URLs. Computed values
compute environment variables from your service map and write finished values
to `.env`.

### Basic syntax

```yaml
computed:
  API_URL:
    value: "${rails.url:direct}/api/v1"   # http://localhost:24920/api/v1
    env_file: frontend/.env
  CORS_ORIGINS:
    value: "${web.url}"                   # http://myapp.test (or localhost:PORT)
    env_file: backend/.env
```

- `${service_name.field}` references service fields
- `env_file` is required (no default — you must be explicit)
- Computed names must not collide with service `env_var` names

### Template Fields

| Template | Resolves to | Use case |
|----------|------------|----------|
| `${rails.port}` | `24920` | Raw port number |
| `${rails.hostname}` | `myapp.test` (or `localhost` if no hostname set) | Hostname only |
| `${rails.url}` | `http://myapp.test` | Browser-facing URLs (CORS, asset hosts), routed via proxy |
| `${rails.url:direct}` | `http://localhost:24920` | Server-to-server calls that bypass the proxy |
| `${rails.env_var}` | `PORT` | Env var name for the service |
| `${rails.alias.NAME}` | `app.myapp.test` | Alias hostname by label |
| `${rails.alias_url.NAME}` | `https://app.myapp.test` | Alias URL by label |

**When to use `url` vs `url:direct`:**
- `${service.url}` — for values the browser sends (CORS origins, asset
  hosts, OAuth redirect URIs). Uses the `.test` hostname when configured.
- `${service.url:direct}` — for server-to-server calls (API base URLs a
  backend fetches, WebSocket connections from a Node server). Always uses
  `localhost` — no proxy hop.

### Standalone variables and bash-style parameter expansion

Computed values support standalone variables and bash-style parameter
expansion for instance-aware configuration:

| Variable | Main instance | Worktree instance (e.g., `bxcf`) |
|----------|--------------|----------------------------------|
| `${project_name}` | `myapp` | `myapp` |
| `${instance}` | *(empty string)* | `bxcf` |
| `${instance:-default}` | `default` | `bxcf` |
| `${instance:+replacement}` | *(empty string)* | `replacement` |
| `${instance:+-${instance}}` | *(empty string)* | `-bxcf` |

**Common pattern — Docker Compose project name:**

```yaml
computed:
  COMPOSE_PROJECT_NAME:
    value: "${project_name}${instance:+-${instance}}"
    env_file: .env
```

This produces `myapp` for the main instance and `myapp-bxcf` for worktrees,
giving each instance isolated Docker containers.

### Per-file value overrides

When the same env var needs different values in different files (common in
monorepos where multiple apps share a framework convention), use the object
syntax for `env_file` entries:

```yaml
computed:
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
    hostname: myapp.test
    env_file: backend/.env
  frontend_main:
    env_var: MAIN_PORT
    hostname: app.myapp.test
    env_file:
      - frontend/apps/main/.env
      - backend/.env               # Backend needs this for CORS
  frontend_portal:
    env_var: PORTAL_PORT
    hostname: portal.myapp.test
    env_file:
      - frontend/apps/portal/.env
      - backend/.env               # Backend needs this for CORS

computed:
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

After `outport up`, every service has the right ports AND the right URLs.
No hardcoded values survive.

## Framework Env Var Conventions

When setting up computed values, knowing how frameworks map env vars to
config is essential:

| Framework | Convention | Example |
|-----------|-----------|---------|
| **Nuxt** | `NUXT_` prefix maps to `runtimeConfig` | `NUXT_API_BASE_URL` overrides `runtimeConfig.apiBaseUrl` |
| **Rails (AnyWayConfig)** | `PREFIX_ATTR` maps to config class | `CORE_CORS_ORIGINS` overrides `CoreConfig.cors_origins` |
| **Rails (Shrine)** | Same AnyWayConfig pattern | `SHRINE_ASSET_HOST` overrides `ShrineConfig.asset_host` |
| **Django** | Typically reads `os.environ` directly | Name vars however your `settings.py` expects |
| **Docker Compose** | Reads `.env` automatically | `${DB_PORT:-5432}` in `compose.yml` |

The computed values feature is most powerful when it writes env vars that
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

On each `outport up`, the fenced block is replaced with current values.
Variables removed from `outport.yml` disappear from the block. Everything
outside the block is preserved.

## Multiple Instances

Outport detects git worktrees automatically. Each worktree gets unique ports
and its own `.test` hostname — no configuration needed:

```bash
# Main checkout
$ outport up
my-app [main]
  rails  RAILS_PORT → 24920  http://my-app.test
  web    MAIN_PORT  → 21349

# Worktree — different ports, different hostname, zero conflicts
$ cd ../my-app-feature && outport up
  Registered as my-app-bkrm. Use 'outport rename bkrm <name>' to rename.
my-app [bkrm]
  rails  RAILS_PORT → 20192  http://my-app-bkrm.test
  web    MAIN_PORT  → 21133
```

Computed values are recomputed per instance — CORS origins, API URLs, and
all other computed values automatically use that instance's ports and
hostnames. Two full instances run simultaneously with no port collisions,
no hostname collisions, and no manual configuration.

Manage instances with:

```bash
outport rename bkrm my-feature   # Rename an instance
outport promote                   # Promote current instance to main
```

## Integrating with Setup Scripts

Run `outport up` early in your project's setup flow — after `.env` file
creation but before services start. Make it optional so developers without
Outport aren't blocked:

```bash
# In bin/setup or similar
if command -v outport > /dev/null 2>&1; then
  outport up
else
  echo "Outport not found — using default ports"
  echo "Install: brew install steveclarke/tap/outport"
fi
```

## Common Tasks

### Port conflict with another project
Run `outport up` in both projects. Outport's registry ensures no
collisions across all registered projects.

### Ports are stale from an old allocation
Run `outport up --force` to clear and re-allocate.

### Freeing ports from a project you're done with
Run `outport down` to remove from registry and free all ports.

### Adding a new service to an existing project
Add it to `outport.yml` and run `outport up`. Existing allocations
are preserved — only the new service gets a port.

### Agent needs to know the project's URLs
Run `outport status --json` for structured output with ports, health, and URLs.

### Services moved to different ports than expected
Check `outport system status` to see all allocations. If another project
holds the ports you want, run `outport down` in it first, then
`outport up --force` in yours.

### Accessing dev services from a phone
Run `outport qr` to display a QR code encoding the LAN URL for each HTTP
service. Scan with your phone on the same Wi-Fi to open the app. Use
`outport qr --tunnel` while `outport share` is running to get a QR for the
public tunnel URL instead. QR codes are also available in the dashboard at
`outport.test`.

### Sharing a service with someone outside your network
Run `outport share` to tunnel all HTTP services to public Cloudflare URLs.
Requires `cloudflared` (`brew install cloudflared`). Press Ctrl+C to stop.

### Something isn't working
Run `outport doctor` to check DNS, daemon, certificates, registry, and
project config. Each check shows pass/fail with a fix suggestion.

### .test domain not resolving
Run `outport doctor` to diagnose. Common causes: daemon not running
(`outport system start`) or DNS resolver missing (`outport system start`).

## Bugs & Feature Requests

Report bugs or request new features at https://github.com/steveclarke/outport/issues
