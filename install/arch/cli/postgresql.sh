#!/usr/bin/env bash
# Omarchy runs databases in Docker rather than as a native service. Its
# installer presents a `gum choose` picker, so it can only run interactively —
# an unattended install.sh would hang on it.
installing_banner "postgresql (Omarchy docker dbs)"
if [ -t 0 ]; then
  omarchy install docker dbs
else
  echo "  skipping — interactive picker; run 'omarchy install docker dbs' by hand"
fi
