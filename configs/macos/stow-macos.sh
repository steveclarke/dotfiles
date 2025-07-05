#!/usr/bin/env bash

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

config_banner() {
  banner "Configuring $1"
}

do_stow() {
  stow -d "${DOTFILES_DIR}"/configs -t "${HOME}" "$1"
}

# macOS-specific configurations
# Currently no macOS-specific configurations
# Add them here as needed in the future

# Example for future macOS-specific configs:
# if [ "${DOTFILES_CONFIG_MACOS_SPECIFIC^^}" = "TRUE" ]; then
#   config_banner "macOS-specific tool"
#   mkdir -p "${HOME}/.config/macos-tool"
#   do_stow macos-tool
# fi

echo "macOS-specific configurations completed (currently none)" 
