#!/usr/bin/env bash
# Postgres runs in a Docker container via Omarchy's installer, which presents a
# picker for which database to set up. install.sh is interactive, so let it ask.
installing_banner "postgresql (Omarchy docker dbs)"

if docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q '^postgres'; then
  skipping "postgresql (container exists)"
else
  omarchy install docker dbs
fi
