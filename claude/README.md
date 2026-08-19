# Claude Code settings

Claude Code's settings live in two files, deliberately split.

## `managed-settings.json` (this directory — shared)

Symlinked by `configs/stow.sh` to the system managed-settings path:

| Platform | Path |
|----------|------|
| macOS | `/Library/Application Support/ClaudeCode/managed-settings.json` |
| Linux | `/etc/claude-code/managed-settings.json` |
| Windows | not wired up (dotfiles doesn't officially support Windows) |

Those are root-owned directories, so the symlink is created with `sudo`.

This file holds only settings written by hand: permissions, hooks, statusline,
plugins, attribution, env. Claude Code never writes to it.

It lives outside `configs/` because stow packages mirror `$HOME`, and this file
does not go into `$HOME` — same reason `omarchy-plugins/` sits outside.

## `~/.claude/settings.json` (machine-local — NOT in this repo)

A real file on each machine. Claude Code writes here whenever you change
something in the UI: effort level, theme, model, the auto mode environment
survey. That survey describes the machine's infrastructure — internal
hostnames, trusted repos, where sensitive data lives — which is why it must
never land in this repo. **This repo is public.**

## The one rule

**Never put a key in `managed-settings.json` that Claude Code writes at
runtime.** Managed settings are the highest precedence and cannot be overridden
by anything, including CLI flags. If `effortLevel` is in the managed file, you
change it mid-session, and the next launch silently reverts it.

Machine-side keys, as of this writing: `model`, `effortLevel`, `advisorModel`,
`theme`, `tui`, `voiceEnabled`, `autoDreamEnabled`, `agentPushNotifEnabled`,
`remoteControlAtStartup`, `skipWorkflowUsageWarning`, `skipAutoPermissionPrompt`,
`autoMode`.

Rule of thumb: if you can change it from inside Claude Code, it belongs in the
machine file.

## Why managed settings rather than a shared user file

`~/.claude/settings.json` is both your config and Claude Code's scratchpad —
there's no way to make it read-only or to point part of it elsewhere. Managed
settings is the only scope that merges with the user file on every launch path
(terminal, IDE extension, cron) without a wrapper or alias.

Verified behaviour (Claude Code, August 2026): the symlink is followed, arrays
concatenate across scopes, and keys the managed file omits fall through to the
user file. See <https://code.claude.com/docs/en/settings>.

## Caveat

Whatever can write the managed file controls the highest-precedence config on
the machine, and no CLI flag can override it. Keep this file small and boring.
