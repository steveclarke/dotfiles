#!/usr/bin/env bash

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

config_banner() {
  banner "Configuring $1"
}

do_stow() {
  stow -d "${DOTFILES_DIR}"/configs -t "${HOME}" "$1"
}

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

config_banner "Fonts"
mkdir -p "${HOME}/.local/share/fonts"
do_stow fonts

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
  source "${DOTFILES_DIR}"/configs/linux/stow-linux.sh
fi

if is_macos; then
  banner "Applying macOS-specific configurations"
  source "${DOTFILES_DIR}"/configs/macos/stow-macos.sh
fi
