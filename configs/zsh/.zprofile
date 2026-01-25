# =============================================================================
# ZSH PROFILE - LOGIN SHELL CONFIGURATION
# =============================================================================
# This file (.zprofile) is loaded for LOGIN shells only, before .zshrc
# 
# LOGIN SHELLS are created when:
# - Logging into a system via SSH
# - Opening Terminal.app on macOS (default behavior)
# - Running `zsh -l` or `zsh --login` explicitly
# - Some terminal emulators configured to start login shells
#
# LOADING ORDER for interactive login shells:
# 1. /etc/zshenv → ~/.zshenv (always loaded first)
# 2. /etc/zprofile → ~/.zprofile (THIS FILE - login shells only)
# 3. /etc/zshrc → ~/.zshrc (interactive shells)
# 4. /etc/zlogin → ~/.zlogin (login shells only, after zshrc)
#
# Use this file for:
# - Environment variables that should be set once per login session
# - PATH modifications that need to be available to all processes
# - One-time initialization that doesn't need to run for every shell
# =============================================================================

# If brew is present, load its env (login shell is the right place to eval this)
eval "$(/opt/homebrew/bin/brew shellenv)"

# =============================================================================
# MISE VERSION MANAGER - SHIMS MODE FOR AI AGENT COMPATIBILITY
# =============================================================================
#
# WHY SHIMS MODE?
# ---------------
# Standard `mise activate zsh` works by modifying PATH each time the shell
# prompt displays. This is great for interactive use but FAILS for:
#   - Claude Code (spawns non-interactive subprocesses to run ruby, node, etc.)
#   - Cursor, VS Code, and other IDEs (don't display prompts)
#   - CI/CD pipelines and automated scripts
#   - Any tool that runs commands without an interactive shell
#
# When Claude Code runs `bundle install`, it spawns a non-interactive shell.
# Without shims, that shell has no idea where mise's Ruby is located, and the
# command fails with "ruby not found" or uses the wrong system Ruby.
#
# HOW SHIMS WORK
# --------------
# Shims are tiny wrapper scripts in ~/.local/share/mise/shims/ (one per tool).
# When you run `ruby`, the shim intercepts the call, loads mise's context,
# finds the correct Ruby version for your current directory, and executes it.
#
# This works because shims are actual files on PATH - they don't require
# prompt hooks or interactive shell features to function.
#
# TRADEOFFS
# ---------
# Shims mode has some limitations vs standard activation:
#   - Environment variables from mise.toml may not load automatically
#   - Some hooks and aliases may not work
#   - Slightly slower tool invocation (shim overhead)
#
# For most development work, these tradeoffs are acceptable. If you need
# full mise features for a specific task, run `mise activate zsh` in that
# terminal session to layer on the full activation.
#
# CONFIGURATION
# -------------
# The `--shims` flag tells mise to:
#   1. Add ~/.local/share/mise/shims to the front of PATH
#   2. Skip the prompt-hook-based activation
#
# This ensures ruby, node, python, etc. are found by ANY process that inherits
# this shell's environment - including Claude Code, IDE terminals, and scripts.
#
# DOCUMENTATION
# -------------
# - Shims: https://mise.jdx.dev/dev-tools/shims.html
# - IDE Integration: https://mise.jdx.dev/ide-integration.html
# - Troubleshooting: https://mise.jdx.dev/troubleshooting.html
# =============================================================================

if command -v mise >/dev/null 2>&1; then
  # Guard: skip if shims are already on PATH (prevents double-prepending)
  case ":$PATH:" in
    *":$HOME/.local/share/mise/shims:"*)
      # Shims already present - nothing to do
      ;;
    *)
      # Use --shims mode for non-interactive shell compatibility
      # This is essential for Claude Code, Cursor, VS Code, and other AI agents
      eval "$(mise activate zsh --shims)"
      ;;
  esac
fi
