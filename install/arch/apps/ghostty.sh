#!/usr/bin/env bash
# Omarchy's installer also sets ghostty as the default terminal (Super+Return).
installing_banner "ghostty"
if is_installed ghostty; then
  skipping "ghostty"
else
  omarchy install terminal ghostty
fi
