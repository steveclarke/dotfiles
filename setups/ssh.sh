#!/usr/bin/env bash
#
# Script Name: ssh.sh
# Description: Set up SSH keys and configuration from remote host
# Platform: cross-platform
# Dependencies: .dotfilesrc, SSH configuration variables, remote SSH host
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}"/lib/bootstrap.sh

# SSH Setup - handles SSH key copying and configuration
# This replaces the SSH functionality previously in bootstrap.sh

# Skip if SSH variables are not configured
if [[ -z "${DOTFILES_SSH_KEYS_HOST}" || -z "${DOTFILES_SSH_KEYS}" || -z "${DOTFILES_SSH_KEYS_PRIMARY}" ]]; then
    echo "SSH configuration variables not set in .dotfilesrc, skipping SSH setup"
    echo "To enable SSH setup, configure these variables in ~/.dotfilesrc:"
    echo "  DOTFILES_SSH_KEYS_HOST"
    echo "  DOTFILES_SSH_KEYS"
    echo "  DOTFILES_SSH_KEYS_PRIMARY"
    return 0
fi

# Copy SSH keys and configure SSH
copy_ssh_keys
configure_ssh

echo "SSH setup complete!" 
