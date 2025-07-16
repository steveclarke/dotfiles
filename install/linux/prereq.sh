#!/usr/bin/env bash
#
# Script Name: prereq.sh
# Description: Install Linux prerequisites by sourcing all scripts in prereq/ directory
# Platform: linux
# Dependencies: .dotfilesrc, apt, prerequisite installation scripts
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/linux.sh

# Install all Linux prerequisites
for installer in "${DOTFILES_DIR}"/install/linux/prereq/*.sh; do 
    if [[ -f "$installer" ]]; then
        # shellcheck disable=SC1090
        bash "$installer"
    fi
done
