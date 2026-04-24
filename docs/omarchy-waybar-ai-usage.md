# Omarchy Waybar AI Usage

This dotfiles setup adds a small Waybar module for Codex and Claude usage on Omarchy/Hyprland.

The design is split into two parts:

- Waybar reads one local cache file and renders immediately.
- A systemd user timer refreshes that cache in the background with CodexBar CLI.

Waybar never calls CodexBar directly. Provider timeouts, OAuth rate limits, and CLI failures stay out of the bar render path.

## What It Shows

The bar uses short labels:

```text
Cx 86 · Cl 87
```

The tooltip uses full provider names and reset times:

```text
Codex
  weekly: 86% left
  session: 99% left
  weekly reset: Wed, 29 Apr at 4:18 PM
  session reset: Fri, 24 Apr at 11:19 PM

Claude
  weekly: 87% left
  session: 98% left
  weekly reset: Sat, 25 Apr at 1:30 PM
  session reset: Fri, 24 Apr at 11:10 PM

Updated: Fri, 24 Apr at 6:55 PM
```

Left-click the module to start a refresh. Otherwise the systemd user timer refreshes every five minutes.

## Files

| File | Purpose |
|------|---------|
| `configs/waybar/.config/waybar/config.jsonc` | Adds `custom/ai-usage` to the Omarchy Waybar center modules |
| `configs/waybar/.config/waybar/style.css` | Spacing, font size, and warning/error colors for the module |
| `configs/waybar/.config/waybar/scripts/ai-usage.sh` | Fast Waybar renderer; reads the cache only |
| `configs/waybar/.config/waybar/scripts/ai-usage-refresh.sh` | Refresh worker and click handler |
| `configs/systemd/.config/systemd/user/dotfiles-ai-usage-refresh.service` | Runs the refresh worker |
| `configs/systemd/.config/systemd/user/dotfiles-ai-usage-refresh.timer` | Runs the refresh service every five minutes |
| `setups/arch/ai-usage.sh` | Enables the timer during Arch/Omarchy setup |
| `install/arch/cli/codexbar.sh` | Installs the Linux CodexBar CLI release into `~/.local/bin` |
| `install/arch/cli/jq.sh` | Installs `jq`, required by the scripts |
| `install/arch/prereq.sh` | Installs `libxml2-legacy`, required by the current CodexBar Linux binary |

## Runtime State

The refresh worker writes:

```text
~/.cache/dotfiles/ai-usage/state.json
```

The state file is the contract between systemd and Waybar:

```json
{
  "schema": 1,
  "updated_at_epoch": 1777050000,
  "stale_after_seconds": 900,
  "providers": {
    "codex": {
      "ok": true,
      "weekly_left": 86,
      "session_left": 99,
      "weekly_reset": "Wed, 29 Apr at 4:18 PM",
      "session_reset": "Fri, 24 Apr at 11:19 PM",
      "error": null
    },
    "claude": {
      "ok": true,
      "weekly_left": 87,
      "session_left": 98,
      "weekly_reset": "Sat, 25 Apr at 1:30 PM",
      "session_reset": "Fri, 24 Apr at 11:10 PM",
      "error": null
    }
  }
}
```

Writes are atomic: the refresh worker builds a temporary JSON file, validates it with `jq`, then renames it over the live cache.

## Provider Sources

The refresh worker uses provider-specific CodexBar sources:

| Provider | Default source | Reason |
|----------|----------------|--------|
| Codex | `cli` | Reads the local Codex CLI account |
| Claude | `oauth` | Matches the preferred CodexBar app source and avoids the interactive Claude `/usage` PTY path |

The provider timeout defaults to 25 seconds because refreshes run in the background:

```bash
export DOTFILES_AI_USAGE_PROVIDER_TIMEOUT_SECONDS=25
```

The cache is considered stale after 15 minutes by default:

```bash
export DOTFILES_AI_USAGE_STALE_AFTER_SECONDS=900
```

## Manual Control

Start a refresh:

```bash
systemctl --user start dotfiles-ai-usage-refresh.service
```

Enable the timer:

```bash
systemctl --user daemon-reload
systemctl --user enable --now dotfiles-ai-usage-refresh.timer
```

Read the Waybar output directly:

```bash
~/.config/waybar/scripts/ai-usage.sh
```

Refresh Waybar after a cache update:

```bash
pkill -RTMIN+11 waybar
```

Check logs:

```bash
journalctl --user -u dotfiles-ai-usage-refresh.service --since today
```

## Failure Behavior

Provider refreshes are independent. If Codex fails, Claude can still update. If Claude is rate-limited, Codex can still update.

When a provider fails and the previous cache has data for that provider, the refresh worker keeps the previous values and records the latest error. The tooltip shows a note, but the bar does not collapse to `Cx !` or `Cl !` unless there has never been a successful refresh for that provider.

Common failures:

- Claude OAuth `HTTP 429`: Anthropic rate-limited the usage endpoint. Wait for the next timer run, or re-auth with `claude logout` then `claude login` if the token is stale.
- Codex `app-server closed stdout`: the Codex CLI probe failed. The next timer run usually recovers.
- Missing cache: start the refresh service manually.
