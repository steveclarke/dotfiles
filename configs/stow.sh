#!/usr/bin/env bash
#
# Script Name: stow.sh
# Description: Stow cross-platform configuration files using GNU Stow
# Platform: cross-platform
# Dependencies: .dotfilesrc, stow, platform-specific configs
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Note: config_banner and do_stow functions are already defined in lib/dotfiles.sh

# Cross-platform configurations
config_banner "${HOME}/bin"
mkdir -p "${HOME}/bin"
do_stow bin

config_banner "Bash"
rm -f "${HOME}"/.bash_aliases
do_stow bash

config_banner "Tmux"
mkdir -p "${HOME}/.config/tmux"
do_stow tmux

config_banner "Alacritty"
mkdir -p "${HOME}/.config/alacritty"
do_stow alacritty

config_banner "Ghostty"
mkdir -p "${HOME}/.config/ghostty"
do_stow ghostty

config_banner "Fish shell"
mkdir -p "${HOME}/.config/fish"
do_stow fish

config_banner "Ruby"
do_stow ruby

config_banner "Neovim"
mkdir -p "${HOME}/.config/nvim"
do_stow nvim

config_banner "Zellij"
mkdir -p "${HOME}/.config/zellij"
do_stow zellij



config_banner "Idea"
if [ -f "${HOME}"/.ideavimrc ]; then
  rm -f "${HOME}"/.ideavimrc
fi
do_stow idea

config_banner "Just"
if [ -f "${HOME}"/justfile ]; then
  rm -f "${HOME}"/justfile
fi
do_stow just

# Platform-specific configurations
if is_linux; then
  banner "Applying Linux-specific configurations"
  bash "${DOTFILES_DIR}"/configs/linux/stow-linux.sh
fi

if is_macos; then
  banner "Applying macOS-specific configurations"
  bash "${DOTFILES_DIR}"/configs/macos/stow-macos.sh
fi
