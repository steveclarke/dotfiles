#!/usr/bin/env bash

if [[ -z ${DOTFILES_DIR:-} && -f "${HOME}/.dotfilesrc" ]]; then
  # shellcheck source=/dev/null
  source "${HOME}/.dotfilesrc"
fi

if [[ -n ${DOTFILES_DIR:-} && -f "${DOTFILES_DIR}/lib/dotfiles.sh" ]]; then
  # shellcheck source=/dev/null
  source "${DOTFILES_DIR}/lib/dotfiles.sh"
fi

if ! declare -F config_banner >/dev/null; then
  config_banner() { echo "=== Configuring $1"; }
fi

if ! declare -F success >/dev/null; then
  success() { echo "✓ $1"; }
fi

if ! command -v systemctl >/dev/null 2>&1; then
  exit 0
fi

config_banner "Waybar AI usage timer"
systemctl --user daemon-reload
systemctl --user enable --now dotfiles-ai-usage-refresh.timer
systemctl --user start dotfiles-ai-usage-refresh.service || true
success "Waybar AI usage timer enabled"
