# Dotfiles Agent Guide

Guide for AI agents working on this repo.

## Commands

| Task | Command |
|------|---------|
| Install everything | `bash install.sh` |
| Update symlinks | `dotfiles stow` |
| Update packages | `dotfiles update` |
| Upgrade all | `just up` |

No test suite. Scripts test if commands exist.

## Code Style

**Shebang:** Use `#!/usr/bin/env bash` for all scripts.

**Shared code:** Source `lib/dotfiles.sh` at the top of each script.

**Helpers:**
- `installing_banner "Name"` — show progress
- `is_installed cmd` — check if command exists
- `is_macos` / `is_linux` — detect OS
- `cache_sudo_credentials` — keep sudo alive

**Naming:** Use `DOTFILES_*` prefix for env vars.

**Paths:** Quote paths with spaces: `"${HOME}/.config/app"`

**File ops:** Use `mkdir -p` to create dirs, `rm -f` to delete safely.

**Errors:** Exit with code 1 or 2. Show clear error messages.

## Repo Structure

| Folder | What's Inside |
|--------|---------------|
| `configs/` | Stow packages (dotfile configs) |
| `install/` | Install scripts (cli, apps, optional) |
| `lib/dotfiles.sh` | Shared functions for all scripts |
| `setups/` | Post-install config scripts |
| `install/macos/` | macOS-only installs |
| `setups/linux/` | Linux-only setup |
