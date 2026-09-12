#!/usr/bin/env bash
# Omarchy's installer also pulls graphics drivers matched to the detected GPU.
installing_banner "steam"
if is_installed steam; then
  skipping "steam"
else
  omarchy install gaming steam
fi
