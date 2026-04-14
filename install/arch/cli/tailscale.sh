#!/usr/bin/env bash
installing_banner "tailscale"
omarchy-pkg-add tailscale
sudo systemctl enable --now tailscaled
