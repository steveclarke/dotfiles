#!/usr/bin/env bash
#
# Script Name: cli.sh
# Description: Install Linux CLI tools by sourcing all scripts in cli/ directory
# Platform: linux
# Dependencies: .dotfilesrc, apt, CLI installation scripts
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/linux.sh

# Install all Linux CLI tools
for installer in "${DOTFILES_DIR}"/install/linux/cli/*.sh; do 
    if [[ -f "$installer" ]]; then
        # shellcheck disable=SC1090
        bash "$installer"
    fi
done
