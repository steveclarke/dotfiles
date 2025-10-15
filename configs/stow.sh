#!/usr/bin/env bash
#
# Stow Configuration Script
#
# Symlinks dotfile configurations from the configs/ directory to $HOME
# using GNU Stow. Handles cross-platform and Linux/macOS-specific configs.
#
# Prerequisites: GNU Stow must be installed
# Usage: bash stow.sh (or via 'dotfiles config' command)
#

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

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

# Cross-platform configurations
ensure_dir "${HOME}/bin"
stow_package "${HOME}/bin" "bin"

cleanup_paths "${HOME}/.bash_aliases"
stow_package "Bash" "bash"

ensure_dir "${HOME}/.config/tmux"
stow_package "Tmux" "tmux"

ensure_dir "${HOME}/.config/alacritty"
stow_package "Alacritty" "alacritty"

ensure_dir "${HOME}/.config/ghostty"
stow_package "Ghostty" "ghostty"

ensure_dir "${HOME}/.config/fish"
stow_package "Fish shell" "fish"

stow_package "Ruby" "ruby"

ensure_dir "${HOME}/.config/nvim"
stow_package "Neovim" "nvim"

ensure_dir "${HOME}/.config/zellij"
stow_package "Zellij" "zellij"

cleanup_paths "${HOME}/.zshrc" "${HOME}/.zprofile"
stow_package "zsh" "zsh"

stow_package "starship" "starship"

ensure_dir "${HOME}/.local/share/fonts"
stow_package "Fonts" "fonts"

cleanup_paths "${HOME}/.ideavimrc"
stow_package "Idea" "idea"

cleanup_paths "${HOME}/justfile"
stow_package "Just" "just"

ensure_dir "${HOME}/.cursor"
cleanup_paths "${HOME}/.cursor/commands"
stow_package "Cursor" "cursor"

# Linux-specific configurations
if is_linux; then
  if [ "${DOTFILES_CONFIG_I3^^}" = "TRUE" ]; then
    ensure_dir "${HOME}/.config/i3"
    stow_package "i3 Window Manager" "i3"
    
    ensure_dir "${HOME}/.config/picom"
    stow_package "Picom (compositor)" "picom"
    
    ensure_dir "${HOME}/.config/polybar"
    stow_package "Polybar" "polybar"
    
    ensure_dir "${HOME}/.config/rofi"
    stow_package "Rofi" "rofi"
  fi
fi

# macOS-specific configurations
if is_macos; then
  # macOS-specific configurations will be added here as needed
  # For now, all existing configurations work cross-platform
  :
fi

success "All configurations stowed successfully"
exit 0
