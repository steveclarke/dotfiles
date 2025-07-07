#!/usr/bin/env bash
#
# Script Name: apps.sh
# Description: Install Linux GUI applications by sourcing all scripts in apps/ directory
# Platform: linux
# Dependencies: .dotfilesrc, GNOME settings, application installation scripts
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/linux.sh

# Ensure computer doesn't go to sleep or lock while installing
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.session idle-delay 0

# Install all Linux GUI applications
for installer in "${DOTFILES_DIR}"/install/linux/apps/*.sh; do 
    if [[ -f "$installer" ]]; then
        # shellcheck disable=SC1090
        bash "$installer"
    fi
done

# Revert to normal idle and lock settings
gsettings set org.gnome.desktop.screensaver lock-enabled true
gsettings set org.gnome.desktop.session idle-delay 300

# Logout to pickup changes
#gum confirm "Ready to reboot for all settings to take effect?" && sudo reboot
