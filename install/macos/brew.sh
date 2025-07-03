#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if ! is_installed brew; then
  echo "ERROR: Homebrew not installed. Run prereq first."
  exit 1
fi

# Install CLI packages from main Brewfile
installing_banner "Homebrew CLI packages"
if [[ -f "${DOTFILES_DIR}/Brewfile" ]]; then
  cd "${DOTFILES_DIR}" || exit
  brew bundle --file=Brewfile
  cd - || exit
else
  echo "WARNING: No Brewfile found in ${DOTFILES_DIR}"
fi

# Install GUI applications from mac/Brewfile
installing_banner "Homebrew GUI applications"
if [[ -f "${DOTFILES_DIR}/mac/Brewfile" ]]; then
  cd "${DOTFILES_DIR}/mac" || exit
  brew bundle --file=Brewfile
  cd - || exit
else
  echo "WARNING: No Brewfile found in ${DOTFILES_DIR}/mac"
fi

echo "Homebrew package installation complete!" 
