#!/usr/bin/env bash

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

for installer in "${DOTFILES_DIR}"/install/arch/cli/*.sh; do source "$installer"; done
