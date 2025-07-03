#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

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
