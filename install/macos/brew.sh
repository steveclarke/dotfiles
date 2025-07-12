#!/usr/bin/env bash
#
# Script Name: brew.sh
# Description: Install Homebrew packages from Brewfile and Brewfile.macos
# Platform: macos
# Dependencies: Homebrew, Brewfile, .dotfilesrc
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}"/lib/macos.sh

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("brew")
SCRIPT_DEPENDS_PLATFORM=("macos")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR" "DOTFILES_INSTALL_GUI")
SCRIPT_DEPENDS_FILES=("/opt/homebrew/bin/brew")
SCRIPT_DEPENDS_MINIMUM_VERSION=("brew:3.0")

if ! is_installed brew; then
  echo "ERROR: Homebrew not installed. Run prereq first."
  exit 1
fi

# Cache sudo credentials for packages that may require it
cache_sudo_credentials

# Install CLI packages from main Brewfile
installing_banner "Homebrew CLI packages"
if [[ -f "${DOTFILES_DIR}/Brewfile" ]]; then
  cd "${DOTFILES_DIR}" || exit
  brew bundle --file=Brewfile
  cd - || exit
else
  echo "WARNING: No Brewfile found in ${DOTFILES_DIR}"
fi

# Install GUI applications from Brewfile.macos only if DOTFILES_INSTALL_GUI is true
if [ "${DOTFILES_INSTALL_GUI^^}" = "TRUE" ]; then
  installing_banner "Homebrew GUI applications"
  if [[ -f "${DOTFILES_DIR}/Brewfile.macos" ]]; then
    cd "${DOTFILES_DIR}" || exit
    brew bundle --file=Brewfile.macos
    cd - || exit
  else
    echo "WARNING: No Brewfile.macos found in ${DOTFILES_DIR}"
  fi
else
  echo "Skipping GUI applications (DOTFILES_INSTALL_GUI not set to true)"
fi

echo "Homebrew package installation complete!" 
