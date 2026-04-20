#!/usr/bin/env bash
#
# Grant user-space access to Keychron HID devices so VIA (usevia.app) and
# QMK tooling can reprogram the keyboard over Chrome's WebHID API.
#
# Without this rule, Chrome can't open /dev/hidraw* and VIA throws
# "NotAllowedError: Failed to open the device". Arch/Omarchy doesn't
# ship HID access rules by default; Ubuntu does for many devices, which
# is why Keychron boards often "just work" on Ubuntu but not here.
#
# Only applies to modern Keychron boards (K Max, Q, V series) which use
# VID 0x3434. Older Keychrons that masquerade as Apple keyboards (VID
# 0x05ac) are handled by the hid_apple kernel module instead.
#
# Full K5 Max reference (layers, remap procedure, cable-mode warning,
# dead-end paths) lives at:
#   ~/src/hugo/keymaps/keychron-k5-max.md
# Manual PDF: ~/src/hugo/keymaps/Keychron_K5_Max_User_Manual.pdf
#

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if ! is_linux; then
  return 0 2>/dev/null || exit 0
fi

RULE_FILE=/etc/udev/rules.d/50-keychron.rules
read -r -d '' RULE_CONTENT <<'RULE' || true
# Allow user-space (e.g. VIA via Chrome WebHID) to open Keychron HID devices.
# Vendor ID 0x3434 = Keychron (K Max, Q, V series).
KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", TAG+="uaccess", GROUP="users", MODE="0660"
RULE

if [[ -f $RULE_FILE ]] && diff -q <(printf '%s\n' "$RULE_CONTENT") "$RULE_FILE" >/dev/null 2>&1; then
  skipping "Keychron udev rule"
  return 0 2>/dev/null || exit 0
fi

banner "Installing Keychron udev rule for VIA access"
printf '%s\n' "$RULE_CONTENT" | sudo tee "$RULE_FILE" >/dev/null
sudo udevadm control --reload-rules
sudo udevadm trigger

success "Keychron udev rule installed. Unplug/replug the keyboard to apply."
