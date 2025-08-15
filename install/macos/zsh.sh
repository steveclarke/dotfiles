#!/usr/bin/env bash
#
# Script Name: zsh.sh
# Description: Configure Zsh shell as default shell on macOS
# Platform: macos
# Dependencies: Zsh shell (from Homebrew), sudo access
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}"/lib/macos.sh

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("zsh" "chsh" "sudo")
SCRIPT_DEPENDS_PLATFORM=("macos")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")
SCRIPT_DEPENDS_FILES=("/opt/homebrew/bin/zsh" "/etc/shells")

if ! is_installed zsh; then
  echo "ERROR: Zsh shell not installed. Should be installed via Homebrew."
  exit 1
fi

# Set zsh as the default shell
config_banner "Zsh shell as default"

# Add zsh to /etc/shells if not already there
ZSH_PATH="/opt/homebrew/bin/zsh"
if ! grep -q "$ZSH_PATH" /etc/shells; then
  echo "Adding $ZSH_PATH to /etc/shells"
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

# Change default shell to zsh
echo "Setting zsh as default shell"
chsh -s "$ZSH_PATH"

echo "Zsh shell configuration complete!"
