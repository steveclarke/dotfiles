#!/usr/bin/env bash

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# banner "Installing tools"
# bash install-tools.sh

# Install prerequisites
bash "${DOTFILES_DIR}"/install/prereq.sh

# Stow configs
bash "${DOTFILES_DIR}"/configs/stow.sh

# bash "$DOTFILES_DIR"/install/cli.sh
# bash "$DOTFILES_DIR"/install/apps.sh
# bash "$DOTFILES_DIR"/install/desktop-entries.sh
