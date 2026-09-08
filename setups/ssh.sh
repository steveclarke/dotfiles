#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# SSH Setup - handles SSH key copying and configuration
# This replaces the SSH functionality previously in bootstrap.sh

# Let this machine be reached from any box holding the GitHub-published keys.
# Public keys only; it does not replace the private-key copy below.
install_github_authorized_keys

# 1Password agent present: keys live in 1Password, nothing copied to disk.
if use_onepassword_agent; then
    configure_ssh_agent_1password
    return 0
fi

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
