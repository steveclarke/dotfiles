#!/usr/bin/env bash
installing_banner "WhatsApp (web app)"
if is_installed omarchy-webapp-install; then
  omarchy-webapp-install "WhatsApp" "https://web.whatsapp.com" "https://www.google.com/s2/favicons?domain=web.whatsapp.com&sz=128"
fi
