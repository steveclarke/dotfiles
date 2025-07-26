#!/usr/bin/env bash
#
# Script Name: breaktimer.sh
# Description: Install BreakTimer app via snap
# Platform: linux
# Dependencies: snap
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/linux.sh

# Install BreakTimer via snap
# https://breaktimer.app/
installing_banner "BreakTimer"

if is_installed "breaktimer"; then
  skipping "BreakTimer"
else
  log_info "Installing BreakTimer via snap"
  snap_install breaktimer
  
  # Create autostart directory if it doesn't exist
  autostart_dir="$HOME/.config/autostart"
  log_debug "Creating autostart directory: $autostart_dir"
  mkdir -p "$autostart_dir"
  
  # Create autostart desktop entry
  log_info "Creating autostart desktop entry"
  cat <<EOL > "$autostart_dir"/breaktimer.desktop
[Desktop Entry]
Type=Application
Exec=breaktimer
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=BreakTimer
Comment=Start BreakTimer on login
EOL

  chmod +x "$autostart_dir"/breaktimer.desktop
  log_success "BreakTimer installation completed with autostart enabled"
fi
