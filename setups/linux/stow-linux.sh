#!/usr/bin/env bash
#
# Script Name: stow-linux.sh
# Description: Stow Linux-specific configuration files (i3, polybar, rofi, etc.)
# Platform: linux
# Dependencies: .dotfilesrc, stow, i3, polybar, rofi
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/linux.sh

# Note: config_banner and do_stow functions are available from sourced libraries

# Linux-specific configurations
config_banner "Fonts"
mkdir -p "${HOME}/.local/share/fonts"
do_stow fonts

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
