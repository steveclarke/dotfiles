#!/usr/bin/env bash
installing_banner "WhatsApp (web app)"
if is_installed omarchy-webapp-install; then
  omarchy-webapp-install WhatsApp
fi
