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
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

# Activate mise for *login* shells only, and only if not already active.
# Guard prevents double activation if something else sourced this earlier.
if command -v mise >/dev/null 2>&1; then
  case ":$PATH:" in
    *":$HOME/.local/share/mise/shims:"*) : ;;  # shims already on PATH → assume active enough
    *) eval "$(mise activate zsh)";;
  esac
fi
