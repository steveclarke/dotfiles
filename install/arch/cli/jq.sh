#!/usr/bin/env bash

if [[ -z ${DOTFILES_DIR:-} && -f "${HOME}/.dotfilesrc" ]]; then
  # shellcheck source=/dev/null
  source "${HOME}/.dotfilesrc"
fi

if [[ -n ${DOTFILES_DIR:-} && -f "${DOTFILES_DIR}/lib/dotfiles.sh" ]]; then
  # shellcheck source=/dev/null
  source "${DOTFILES_DIR}/lib/dotfiles.sh"
fi

if ! declare -F installing_banner >/dev/null; then
  installing_banner() { echo "=== Installing $1"; }
fi

finish() {
  local code="$1"
  # shellcheck disable=SC2317
  return "${code}" 2>/dev/null || exit "${code}"
}

if ! command -v omarchy-pkg-add >/dev/null 2>&1; then
  echo "✗ ERROR: omarchy-pkg-add is required to install jq on Omarchy" >&2
  finish 1
fi

installing_banner "jq"
omarchy-pkg-add jq
