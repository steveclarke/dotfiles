# Omarchy Waybar AI Usage

This dotfiles setup adds a small Waybar module for Codex and Claude usage on Omarchy/Hyprland.

It is intentionally thin. Waybar runs a shell script every two minutes, the script asks CodexBar CLI for provider usage,
and the module renders a compact status in the top bar.

## What It Shows

The bar uses short labels:

```text
Cx 88 · Cl 91
```

The tooltip uses full provider names and reset times:

```text
Codex
  weekly: 88% left
  session: 99% left
  weekly reset: Wed, 29 Apr at 4:18 PM
  session reset: Fri, 24 Apr at 6:19 PM

Claude
  weekly: 91% left
  session: 98% left
  weekly reset: Sat, 25 Apr at 1:30 PM
  session reset: Fri, 24 Apr at 6:10 PM
```

Left-click the module to refresh immediately. Otherwise it refreshes every 120 seconds.

Claude usage is cached between refreshes. The script avoids calling Anthropic's OAuth usage endpoint more than once
every five minutes by default, because that endpoint can return `HTTP 429` under repeated polling. If Claude is
rate-limited and a previous good value exists, the module keeps showing the cached value and adds a note to the tooltip.

## Files

| File | Purpose |
|------|---------|
| `configs/waybar/.config/waybar/config.jsonc` | Adds `custom/ai-usage` to the Omarchy Waybar center modules |
| `configs/waybar/.config/waybar/style.css` | Spacing, font size, and warning/error colors for the module |
| `configs/waybar/.config/waybar/scripts/ai-usage.sh` | Fetches CodexBar usage and renders Waybar JSON |
| `install/arch/cli/codexbar.sh` | Installs the Linux CodexBar CLI release into `~/.local/bin` |
| `install/arch/cli/jq.sh` | Installs `jq`, required by the Waybar script |
| `install/arch/prereq.sh` | Installs `libxml2-legacy`, required by the current CodexBar Linux binary |

## Provider Sources

The script uses provider-specific CodexBar sources:

| Provider | Default source | Reason |
|----------|----------------|--------|
| Codex | `cli` | Fast and reliable via the local Codex CLI account |
| Claude | `oauth` | Avoids driving the interactive Claude Code `/usage` PTY flow |

Override sources per machine with environment variables if needed:

```bash
export DOTFILES_AI_USAGE_CODEX_SOURCE=cli
export DOTFILES_AI_USAGE_CLAUDE_SOURCE=oauth
```

The timeout defaults to eight seconds per provider:

```bash
export DOTFILES_AI_USAGE_PROVIDER_TIMEOUT_SECONDS=8
```

Claude's minimum fetch interval defaults to five minutes:

```bash
export DOTFILES_AI_USAGE_CLAUDE_MIN_INTERVAL_SECONDS=300
```

## Troubleshooting

Run the module directly:

```bash
~/.config/waybar/scripts/ai-usage.sh
```

Refresh the Waybar module:

```bash
pkill -RTMIN+11 waybar
```

Check Codex directly:

```bash
codexbar usage --provider codex --source cli --format json --json-only
```

Check Claude directly:

```bash
codexbar usage --provider claude --source oauth --format json --json-only
```

If Claude shows `HTTP 429` or `Rate limited`, refresh the Claude OAuth credentials:

```bash
claude logout
claude login
pkill -RTMIN+11 waybar
```

If it still happens after re-authentication, Anthropic is rate-limiting the usage endpoint itself. The script will use
the last cached Claude value when possible.

If the module disappears after a tooltip change, check for GTK markup warnings from Waybar. Dynamic tooltip text must
escape `&`, `<`, and `>` because Waybar treats tooltips as markup.
