#!/usr/bin/env bash
# Pandoc — universal document converter
# https://pandoc.org/

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh
detect_os

if is_installed pandoc; then
  skipping "pandoc (already installed)"
  return 0 2>/dev/null || exit 0
fi

installing_banner "pandoc"

if is_arch; then
  omarchy-pkg-add pandoc-cli
elif is_ubuntu; then
  sudo apt install -y pandoc
elif is_macos; then
  brew install pandoc
else
  error "pandoc: unsupported OS ($DOTFILES_OS/$DOTFILES_DISTRO)"
  exit 1
fi

is_installed pandoc && success "pandoc installed"
