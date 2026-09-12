#!/usr/bin/env bash
#
# Tailscale, installed but deliberately NOT authenticated.
#
# `omarchy install service tailscale` is the right installer, but it runs
# `sudo tailscale up --accept-routes`, which waits on a browser login. In an
# unattended install.sh that just prints a URL and stops, and a stalled install
# is indistinguishable from a slow one. So every non-interactive step happens
# here and joining the tailnet is left to you:
#
#   sudo tailscale up --accept-routes
#
# Re-running this script after that point fills in the operator setting.

installing_banner "tailscale"

if is_installed tailscale; then
  skipping "tailscale package"
else
  omarchy-pkg-add tailscale
fi

sudo systemctl enable --now tailscaled.service

# Safe without a login: Taildrop receiver, bar widget, admin console web app.
# These mirror omarchy-install-service-tailscale minus the `tailscale up`.
systemctl --user enable --now omarchy-tailscale-receive.service 2>/dev/null \
  || echo "  could not enable omarchy-tailscale-receive.service"
is_installed omarchy-plugin-enable && omarchy-plugin-enable omarchy.tailscale >/dev/null 2>&1
is_installed omarchy-webapp-install && omarchy-webapp-install "Tailscale" \
  "https://login.tailscale.com/admin/machines" \
  "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/tailscale-light.png" >/dev/null 2>&1

if sudo tailscale status >/dev/null 2>&1; then
  sudo tailscale set --operator="$USER" 2>/dev/null || true
  success "tailscale installed and authenticated (operator: ${USER})"
else
  success "tailscale installed, NOT authenticated"
  echo "  Join your tailnet when ready:  sudo tailscale up --accept-routes"
  echo "  Then re-run:                   dotfiles install tailscale"
fi
