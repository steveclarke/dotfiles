#!/usr/bin/env bash
# Omarchy's installer also wires Zed to the current Omarchy theme.
installing_banner "zed"
if is_installed zed; then
  skipping "zed"
else
  omarchy install editor zed
fi
