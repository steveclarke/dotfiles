#!/usr/bin/env bash

# Omarchy Bootstrap — get SSH keys onto a fresh Omarchy box
# Usage: curl -fsSL https://raw.githubusercontent.com/steveclarke/dotfiles/master/bootstrap/omarchy.sh | bash

set -euo pipefail

DOTFILES_DIR="${HOME}/.local/share/dotfiles"
DOTFILESRC="${HOME}/.dotfilesrc"

echo "========================================================================"
echo " Omarchy Bootstrap — SSH Key Setup"
echo "========================================================================"

# Create .dotfilesrc if it doesn't exist
if [[ ! -f "$DOTFILESRC" ]]; then
  echo "Creating ${DOTFILESRC}..."
  curl -fsSL -o "$DOTFILESRC" \
    https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc.template
  echo ""
  echo "Edit ~/.dotfilesrc now to verify your settings (especially SSH host)."
  echo "Then re-run this script."
  exit 0
fi

source "$DOTFILESRC"

# Clone dotfiles repo via HTTPS if not already present
if [[ ! -d "$DOTFILES_DIR" ]]; then
  echo "Cloning dotfiles repo..."
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone https://github.com/steveclarke/dotfiles.git "$DOTFILES_DIR"
else
  echo "Dotfiles repo already exists at ${DOTFILES_DIR}"
fi

# Copy SSH keys and configure SSH
source "${DOTFILES_DIR}/lib/dotfiles.sh"
detect_os
copy_ssh_keys
configure_ssh

# Switch remote to SSH now that we have keys
cd "$DOTFILES_DIR"
git remote set-url origin git@github.com:steveclarke/dotfiles.git
echo ""
echo "✓ Remote switched to SSH: $(git remote get-url origin)"
echo "✓ You're ready to go. cd ${DOTFILES_DIR} and start iterating."
