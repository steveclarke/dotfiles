#!/usr/bin/env bash
installing_banner "brave"
if is_installed brave; then
  skipping "brave"
else
  omarchy install browser brave
fi
