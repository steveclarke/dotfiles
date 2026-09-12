#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# SSH Setup - handles SSH key copying and configuration
# This replaces the SSH functionality previously in bootstrap.sh

# Let this machine be reached from any box holding the GitHub-published keys.
# Public keys only; it does not replace the private-key copy below.
install_github_authorized_keys

# Keys come out of 1Password, which ships with Omarchy and is always up. Set
# DOTFILES_SSH_KEYS_OP in ~/.dotfilesrc to map key names to 1Password items.
if [[ -z "${DOTFILES_SSH_KEYS_OP:-}" ]]; then
    echo "DOTFILES_SSH_KEYS_OP not set in ~/.dotfilesrc, skipping SSH key setup"
    return 0
fi

fetch_ssh_keys_from_1password || return 0

if [[ -n "${DOTFILES_SSH_KEYS_PRIMARY:-}" ]]; then
    configure_ssh
fi

echo "SSH setup complete!"
