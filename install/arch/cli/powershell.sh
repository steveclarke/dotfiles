#!/usr/bin/env bash
# AUR package

if [[ -z ${DOTFILES_DIR:-} && -f "${HOME}/.dotfilesrc" ]]; then
  # shellcheck source=/dev/null
  source "${HOME}/.dotfilesrc"
fi

if [[ -n ${DOTFILES_DIR:-} && -f "${DOTFILES_DIR}/lib/dotfiles.sh" ]]; then
  # shellcheck source=/dev/null
  source "${DOTFILES_DIR}/lib/dotfiles.sh"
fi

installing_banner "PowerShell"
omarchy-pkg-aur-add powershell-bin
