# ZSH Shell Configuration Guide

Understanding when shell configuration files are loaded can be confusing. Here's a comprehensive reference for when `.zprofile` and `.zshrc` are loaded and what should go in each.

## Interactive vs Login Shells

The key is understanding that these are **two separate, independent characteristics** that can be combined:

**Interactive vs Non-Interactive:**
- **Interactive**: You can type commands and get responses (normal terminal use)
- **Non-Interactive**: Running scripts, commands via SSH, etc. (no human interaction)

**Login vs Non-Login:**
- **Login**: You "logged in" to get this shell (authenticated to the system)
- **Non-Login**: You got this shell from within an existing session

## The Four Shell Types

### 1. Interactive Login Shell
*You can type commands AND you logged in to get here*

**Examples:**
- SSH into a server: `ssh user@server`
- Terminal.app on macOS (by default)
- Logging into a Linux console (Ctrl+Alt+F1)
- Running `zsh --login`

**Files loaded:** `.zprofile` → `.zshrc`

### 2. Interactive Non-Login Shell
*You can type commands BUT you didn't log in (you're already logged in)*

**Examples:**
- Opening a new terminal tab/window (most Linux terminals)
- Running `zsh` from within an existing shell
- Opening a terminal in VS Code
- Most terminal emulators on Linux

**Files loaded:** `.zshrc` only

### 3. Non-Interactive Login Shell
*Running a script/command AND you're logging in*

**Examples:**
- `ssh user@server 'some-command'` (SSH with a command)
- Login scripts during system startup

**Files loaded:** `.zprofile` only

### 4. Non-Interactive Non-Login Shell
*Running a script from within an existing session*

**Examples:**
- Shell scripts: `./myscript.sh`
- Command substitution: `$(some-command)`
- Cron jobs

**Files loaded:** Usually none (scripts should be self-contained)

## Configuration File Purpose

### `.zprofile` - Login Shell Environment Setup
**When it loads:** Login shells only, before `.zshrc`

**Use this file for:**
- Environment variables that should be set once per login session
- PATH modifications that need to be available to all processes
- One-time initialization that doesn't need to run for every shell
- Package manager environment setup (Homebrew, mise, etc.)

### `.zshrc` - Interactive Shell Experience
**When it loads:** All interactive shells (login + non-login)

**Use this file for:**
- Interactive features: completion, prompt, key bindings, aliases
- Plugin configuration and shell enhancements
- Settings that should apply to every interactive session
- Anything that makes the shell more pleasant to use interactively

## Complete ZSH Loading Order

For reference, here's the complete loading order for zsh:

### Interactive Login Shells
1. `/etc/zshenv` → `~/.zshenv` (always loaded first)
2. `/etc/zprofile` → `~/.zprofile` (login shells only)
3. `/etc/zshrc` → `~/.zshrc` (interactive shells)
4. `/etc/zlogin` → `~/.zlogin` (login shells only, after zshrc)

### Interactive Non-Login Shells
1. `/etc/zshenv` → `~/.zshenv` (always loaded first)
2. `/etc/zshrc` → `~/.zshrc` (interactive shells)

### Non-Interactive Shells
1. `/etc/zshenv` → `~/.zshenv` (always loaded first)
2. (Additional files may load for login shells, but not interactive features)

## Platform Differences

### macOS
- **Terminal.app**: Defaults to login shells (loads both `.zprofile` and `.zshrc`)
- **iTerm2**: Usually defaults to login shells
- **Third-party terminals**: May vary

### Linux
- **Most terminal emulators**: Default to non-login shells (only `.zshrc`)
- **SSH sessions**: Always login shells (loads both files)
- **Console login**: Login shells (loads both files)

## Common Gotchas

### Environment Variables Not Available
**Problem:** PATH or other environment variables work on macOS but not Linux
**Cause:** Environment setup in `.zshrc` instead of `.zprofile`
**Solution:** Move environment setup to `.zprofile`

### Slow Shell Startup
**Problem:** New terminal tabs/windows take a long time to open
**Cause:** Heavy processing in `.zshrc` that runs for every interactive shell
**Solution:** Move one-time setup to `.zprofile`

### SSH Command Failures
**Problem:** Commands work in interactive SSH but fail when run via `ssh user@server 'command'`
**Cause:** Interactive features in `.zprofile` breaking non-interactive shells
**Solution:** Guard interactive features with `[[ -o interactive ]]` or move to `.zshrc`

## Quick Reference

| Shell Type | Interactive | Login | Files Loaded | Common Examples |
|------------|-------------|-------|--------------|-----------------|
| Interactive Login | ✅ | ✅ | `.zprofile` → `.zshrc` | SSH, Terminal.app |
| Interactive Non-Login | ✅ | ❌ | `.zshrc` only | New terminal tab (Linux) |
| Non-Interactive Login | ❌ | ✅ | `.zprofile` only | `ssh server 'command'` |
| Non-Interactive Non-Login | ❌ | ❌ | Usually none | Shell scripts |

## Testing Your Setup

To test which type of shell you're in:

```bash
# Check if interactive
[[ $- == *i* ]] && echo "Interactive" || echo "Non-interactive"

# Check if login shell  
shopt -q login_shell && echo "Login shell" || echo "Non-login shell"

# Or use this one-liner
echo "Interactive: $([[ $- == *i* ]] && echo yes || echo no), Login: $(shopt -q login_shell && echo yes || echo no)"
```

To see which files were loaded:
```bash
# Add this to your shell files to trace loading
echo "Loading $(basename $0) at $(date)"
```
