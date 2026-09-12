#!/usr/bin/env bash
installing_banner "tailscale"

# Omarchy 4 ships a first-party installer that also sets up a web app for the
# Tailscale Admin Console. Fall back to the raw package on vanilla Arch, where
# the omarchy command doesn't exist.
if omarchy installed service tailscale >/dev/null 2>&1; then
  skipping "tailscale"
elif is_installed omarchy; then
  omarchy install service tailscale
else
  omarchy-pkg-add tailscale
  sudo systemctl enable --now tailscaled
fi
