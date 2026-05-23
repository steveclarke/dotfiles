#!/usr/bin/env bash
#
# Add the current user to the `adbusers` group so USB debugging works without
# sudo. The group is created by the `android-udev` package. No-op on systems
# without it (e.g. non-Arch Linux where android-udev isn't installed).
#

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if ! getent group adbusers >/dev/null; then
  return 0 2>/dev/null || exit 0
fi

if id -nG "$USER" | tr ' ' '\n' | grep -qx adbusers; then
  return 0 2>/dev/null || exit 0
fi

banner "Adding $USER to adbusers group (USB debugging)"
sudo gpasswd -a "$USER" adbusers
echo "Note: log out and back in for group membership to take effect."
