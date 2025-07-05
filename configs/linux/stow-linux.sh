#!/usr/bin/env bash

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

config_banner() {
  banner "Configuring $1"
}

do_stow() {
  stow -d "${DOTFILES_DIR}"/configs -t "${HOME}" "$1"
}

# Linux-specific configurations
if [ "${DOTFILES_CONFIG_I3^^}" = "TRUE" ]; then
  config_banner "i3 Window Manager"
  mkdir -p "${HOME}/.config/i3"
  do_stow i3

  config_banner "Picom (compositor)"
  mkdir -p "${HOME}/.config/picom"
  do_stow picom

  config_banner "Polybar"
  mkdir -p "${HOME}/.config/polybar"
  do_stow polybar

  config_banner "Rofi"
  mkdir -p "${HOME}/.config/rofi"
  do_stow rofi
fi 
