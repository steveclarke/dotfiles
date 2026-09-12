#!/usr/bin/env bash
installing_banner "firefox"
if is_installed firefox; then
  skipping "firefox"
else
  omarchy install browser firefox
fi
