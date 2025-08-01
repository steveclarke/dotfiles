#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Cache sudo credentials for installations that may require it
cache_sudo_credentials

# Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  installing_banner "Xcode Command Line Tools"
  xcode-select --install
  echo "Please complete the Xcode Command Line Tools installation and re-run this script."
  exit 1
fi

# Install Homebrew
if ! is_installed brew; then
  installing_banner "Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add Homebrew to PATH for current session
  eval "$(/opt/homebrew/bin/brew shellenv)"
  
  # Also add to shell profile for future sessions
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME}/.zprofile"
else
  skipping "Homebrew"
fi

# Install Stow
if ! is_installed stow; then
  installing_banner "GNU Stow"
  brew install stow
else
  skipping "GNU Stow"
fi

echo "macOS prerequisites installation complete!" 
