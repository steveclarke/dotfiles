#!/usr/bin/env bash
installing_banner "deno"
if is_installed deno; then
  skipping "deno"
else
  omarchy install dev-env deno
fi
