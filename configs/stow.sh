#!/usr/bin/env bash
#
# Stow Configuration Script
#
# Symlinks dotfile configurations from the configs/ directory to $HOME
# using GNU Stow. Handles cross-platform configs with Omarchy awareness.
#
# On Omarchy, configs managed by the framework are skipped. For bash,
# a source line is added to ~/.bashrc to hook into our config.
#
# Prerequisites: GNU Stow must be installed
# Usage: bash stow.sh (or sourced by install.sh)
#

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Detect OS/distro (needed for is_omarchy guards when run standalone)
detect_os

# Exit on any error
set -e

# Validate stow is installed
if ! is_installed stow; then
  error "GNU Stow is not installed. Run prereq installation first."
  exit 1
fi

config_banner() {
  banner "Configuring $1"
}

do_stow() {
  if ! stow -d "${DOTFILES_DIR}"/configs -t "${HOME}" "$1"; then
    error "Failed to stow $1"
    return 1
  fi
}

# Remove files or directories that would conflict with stow (non-symlinks only)
# This makes the script idempotent - existing stow symlinks are left untouched
cleanup_paths() {
  local path
  for path in "$@"; do
    if [ -e "$path" ] && [ ! -L "$path" ]; then
      if [ -d "$path" ]; then
        rm -rf "$path"
      else
        rm -f "$path"
      fi
    fi
  done
}

# Ensure directories exist (for stow to symlink into)
ensure_dir() {
  local path
  for path in "$@"; do
    mkdir -p "$path"
  done
}

# Stow a configuration package
# Args: display_name, stow_package
stow_package() {
  local display_name="$1"
  local stow_package="$2"

  config_banner "${display_name}"
  do_stow "${stow_package}"
}

# =============================================================================
# Cross-platform packages (stow on all platforms)
# =============================================================================

ensure_dir "${HOME}/bin"
stow_package "Bin scripts" "bin"

# Bash — new XDG-style layout under ~/.config/bash/
ensure_dir "${HOME}/.config/bash"
cleanup_paths "${HOME}/.bash_aliases"
stow_package "Bash" "bash"

# On Omarchy, hook our bash config into ~/.bashrc (which is safe from updates)
if is_omarchy; then
  if ! grep -q 'config/bash/rc' "${HOME}/.bashrc" 2>/dev/null; then
    echo '[[ -f ~/.config/bash/rc ]] && source ~/.config/bash/rc' >> "${HOME}/.bashrc"
  fi
fi

ensure_dir "${HOME}/.config/fish"
stow_package "Fish shell" "fish"

ensure_dir "${HOME}/.config/mise"
cleanup_paths "${HOME}/.config/mise/config.toml"
stow_package "Mise" "mise"

stow_package "Ruby" "ruby"

stow_package "Node (default npm packages)" "node"

ensure_dir "${HOME}/.config/zellij"
stow_package "Zellij" "zellij"

ensure_dir "${HOME}/.config/process-compose"
stow_package "Process compose" "process-compose"

# On macOS, process-compose uses ~/Library/Application Support/ instead of ~/.config/
if is_macos; then
  ensure_dir "${HOME}/Library/Application Support/process-compose"
  ln -sf "${HOME}/.config/process-compose/settings.yaml" "${HOME}/Library/Application Support/process-compose/settings.yaml"
fi

cleanup_paths "${HOME}/.zshrc" "${HOME}/.zprofile"
stow_package "Zsh" "zsh"

cleanup_paths "${HOME}/.ideavimrc"
stow_package "Idea" "idea"

cleanup_paths "${HOME}/justfile"
stow_package "Just" "just"

config_banner "Claude"
ensure_dir "${HOME}/.claude"
cleanup_paths "${HOME}/.claude/settings.json"
do_stow "claude"

# =============================================================================
# Omarchy-only packages
# =============================================================================

if is_omarchy; then
  # Voxtype — Omarchy updates can overwrite config with stock defaults
  ensure_dir "${HOME}/.config/voxtype"
  cleanup_paths "${HOME}/.config/voxtype/config.toml"
  stow_package "Voxtype" "voxtype"

  # Waybar — workspace labels, persistent workspaces, 12h clock, accent theme variable
  ensure_dir "${HOME}/.config/waybar"
  ensure_dir "${HOME}/.config/omarchy/themed"
  cleanup_paths "${HOME}/.config/waybar/config.jsonc" "${HOME}/.config/waybar/style.css" "${HOME}/.config/omarchy/themed/waybar.css.tpl"
  stow_package "Waybar" "waybar"

  # Hyprland — customizations go in Omarchy's user hook files (monitors.conf,
  # bindings.conf, autostart.conf) — never touch hyprland.conf itself, Omarchy owns it
  ensure_dir "${HOME}/.config/hypr"
  cleanup_paths "${HOME}/.config/hypr/monitors.conf" "${HOME}/.config/hypr/bindings.conf" "${HOME}/.config/hypr/autostart.conf" "${HOME}/.config/hypr/hypridle.conf"
  stow_package "Hyprland" "hypr"

  # Omarchy custom themes — user-authored themes under ~/.config/omarchy/themes/
  ensure_dir "${HOME}/.config/omarchy/themes"
  stow_package "Omarchy themes" "omarchy-themes"

  # Omarchy hooks — post-update re-enables Voxtype GPU after upgrades swap it to CPU
  ensure_dir "${HOME}/.config/omarchy/hooks"
  cleanup_paths "${HOME}/.config/omarchy/hooks/post-update"
  stow_package "Omarchy hooks" "omarchy-hooks"
fi

# =============================================================================
# Skip on Omarchy (Omarchy manages these)
# =============================================================================

if ! is_omarchy; then
  # Tmux — Omarchy manages tmux.conf
  ensure_dir "${HOME}/.config/tmux"
  stow_package "Tmux" "tmux"

  # Terminals — Omarchy manages via theming
  ensure_dir "${HOME}/.config/alacritty"
  stow_package "Alacritty" "alacritty"

  ensure_dir "${HOME}/.config/ghostty"
  stow_package "Ghostty" "ghostty"

  # Neovim — Omarchy ships its own LazyVim
  ensure_dir "${HOME}/.config/nvim"
  stow_package "Neovim" "nvim"

  # Starship — Omarchy manages starship prompt
  stow_package "Starship" "starship"

  # Fonts — Omarchy ships JetBrains Mono NF
  ensure_dir "${HOME}/.local/share/fonts"
  stow_package "Fonts" "fonts"

  # OpenCode — Omarchy has its own config
  stow_package "OpenCode" "opencode"
fi

success "All configurations stowed successfully"
