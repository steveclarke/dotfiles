#!/usr/bin/env bash
# Tailscale via Omarchy's own installer, which also sets the operator, enables
# the Taildrop receiver, adds the bar widget, and installs the Admin Console web
# app. It ends in `tailscale up`, so it waits on a browser login the first time.
installing_banner "tailscale"

if is_installed tailscale && sudo tailscale status >/dev/null 2>&1; then
  skipping "tailscale"
else
  omarchy install service tailscale
fi
