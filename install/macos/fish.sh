#!/usr/bin/env bash
#
# Script Name: fish.sh
# Description: Configure Fish shell as default shell on macOS
# Platform: macos
# Dependencies: Fish shell (from Homebrew), sudo access
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}"/lib/macos.sh

# Dependency declarations
SCRIPT_DEPENDS_COMMANDS=("fish" "chsh" "sudo")
SCRIPT_DEPENDS_PLATFORM=("macos")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR")
SCRIPT_DEPENDS_FILES=("/opt/homebrew/bin/fish" "/etc/shells")

if ! is_installed fish; then
  echo "ERROR: Fish shell not installed. Should be installed via Homebrew."
  exit 1
fi

# Set fish as the default shell
config_banner "Fish shell as default"

# Add fish to /etc/shells if not already there
FISH_PATH="/opt/homebrew/bin/fish"
if ! grep -q "$FISH_PATH" /etc/shells; then
  echo "Adding $FISH_PATH to /etc/shells"
  echo "$FISH_PATH" | sudo tee -a /etc/shells
fi

# Change default shell to fish
echo "Setting fish as default shell"
chsh -s "$FISH_PATH"

echo "Fish shell configuration complete!" 
