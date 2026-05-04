#!/usr/bin/env bash
# CyberPower PowerPanel Personal — UPS daemon (`pwrstat`)
# https://www.cyberpowersystems.com/product/software/power-panel-personal/powerpanel-for-linux/

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh
detect_os

if is_installed pwrstat; then
  skipping "cyberpower (pwrstat already installed)"
else
  installing_banner "cyberpower (PowerPanel Personal)"

  if is_arch; then
    # AUR: powerpanel — pulls in openssl-1.1 and paho-mqtt-c
    omarchy-pkg-aur-add powerpanel
  elif is_ubuntu; then
    installer_file=$(find "${HOME}"/Downloads -name "PPL_64bit*.deb" -maxdepth 1)
    if [ -z "$installer_file" ]; then
      error "PPL_64bit*.deb not found in ~/Downloads — get it from https://www.cyberpowersystems.com/product/software/power-panel-personal/powerpanel-for-linux/"
      exit 1
    fi
    echo "Installing $installer_file"
    sudo apt install -y "$installer_file"
  else
    error "cyberpower: unsupported OS ($DOTFILES_OS/$DOTFILES_DISTRO)"
    exit 1
  fi
fi

# Enable and start the daemon (systemd — Arch and Ubuntu both)
if is_linux && command -v systemctl >/dev/null 2>&1; then
  if systemctl list-unit-files pwrstatd.service >/dev/null 2>&1; then
    sudo systemctl enable --now pwrstatd.service
  fi
fi

# Configure: ride out brief outages, only shut down on low battery.
# Defaults ship with pwrfail shutdown=on at 60s delay, which would shut the
# desktop down on any outage >60s — that defeats the UPS. Low-battery shutdown
# (35% / 300s runtime) stays on to handle the worst case (extended outage,
# generator unavailable).
if is_installed pwrstat; then
  sudo pwrstat -pwrfail -shutdown off
fi

# Verify
if is_installed pwrstat; then
  sudo pwrstat -status || true
  success "cyberpower installed — control with \`sudo pwrstat\`"
fi
