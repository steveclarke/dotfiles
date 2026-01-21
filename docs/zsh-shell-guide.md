# ZSH Shell Guide

When do `.zprofile` and `.zshrc` load? This guide explains shell types and config files.

## Two Types of Shells

Shells have two traits. These traits combine in different ways.

### Interactive vs Non-Interactive

| Type | What It Means | Example |
|------|---------------|---------|
| Interactive | You type commands | Normal terminal use |
| Non-Interactive | Scripts run on their own | Cron jobs, `./script.sh` |

### Login vs Non-Login

| Type | What It Means | Example |
|------|---------------|---------|
| Login | You logged in to get this shell | SSH, first terminal |
| Non-Login | You opened a shell from inside another | New tab, running `zsh` |

## The Four Shell Types

### 1. Interactive + Login

You can type commands. You logged in to get here.

**Examples:**
- SSH into a server: `ssh user@server`
- Terminal.app on macOS
- Linux console (Ctrl+Alt+F1)

**Files loaded:** `.zprofile` → `.zshrc`

### 2. Interactive + Non-Login

You can type commands. You're already logged in.

**Examples:**
- New terminal tab (most Linux terminals)
- Running `zsh` from another shell
- VS Code terminal

**Files loaded:** `.zshrc` only

### 3. Non-Interactive + Login

A script runs. You're logging in.

**Examples:**
- `ssh user@server 'some-command'`
- Login scripts at startup

**Files loaded:** `.zprofile` only

### 4. Non-Interactive + Non-Login

A script runs from an existing session.

**Examples:**
- Shell scripts: `./myscript.sh`
- Command substitution: `$(some-command)`
- Cron jobs

**Files loaded:** None (scripts should set their own env)

## Which File Does What?

### .zprofile — Login Setup

Loads once when you log in. Runs before `.zshrc`.

**Put these things here:**
- Environment variables (PATH, etc.)
- Package manager setup (Homebrew, mise)
- One-time init that all processes need

### .zshrc — Interactive Setup

Loads for every interactive shell.

**Put these things here:**
- Aliases and functions
- Prompt settings
- Key bindings
- Plugins and completions
- Anything that makes typing nicer

## Quick Reference

| Shell Type | Interactive | Login | Files Loaded |
|------------|-------------|-------|--------------|
| Interactive Login | Yes | Yes | `.zprofile` → `.zshrc` |
| Interactive Non-Login | Yes | No | `.zshrc` only |
| Non-Interactive Login | No | Yes | `.zprofile` only |
| Non-Interactive Non-Login | No | No | Usually none |

## macOS vs Linux

### macOS

- **Terminal.app**: Login shell (loads both files)
- **iTerm2**: Login shell (loads both files)

### Linux

- **Most terminals**: Non-login shell (`.zshrc` only)
- **SSH sessions**: Login shell (loads both files)
- **Console login**: Login shell (loads both files)

## Common Problems

### Env vars work on macOS but not Linux

**Why:** You put env setup in `.zshrc` instead of `.zprofile`.

**Fix:** Move env setup to `.zprofile`.

### Shell starts slowly

**Why:** Heavy work in `.zshrc` runs every time you open a tab.

**Fix:** Move one-time setup to `.zprofile`.

### SSH commands fail

**Why:** Interactive code in `.zprofile` breaks non-interactive shells.

**Fix:** Guard with `[[ -o interactive ]]` or move to `.zshrc`.

## Full Load Order

For interactive login shells:

1. `/etc/zshenv` → `~/.zshenv`
2. `/etc/zprofile` → `~/.zprofile`
3. `/etc/zshrc` → `~/.zshrc`
4. `/etc/zlogin` → `~/.zlogin`

For interactive non-login shells:

1. `/etc/zshenv` → `~/.zshenv`
2. `/etc/zshrc` → `~/.zshrc`

## Test Your Shell

Check if your shell is interactive:

```bash
[[ $- == *i* ]] && echo "Interactive" || echo "Non-interactive"
```

Check if it's a login shell:

```bash
[[ -o login ]] && echo "Login" || echo "Non-login"
```

Debug which files load:

```bash
# Add this to each file
echo "Loading ~/.zprofile" # or ~/.zshrc
```
