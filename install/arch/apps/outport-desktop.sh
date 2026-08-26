#!/usr/bin/env bash

# Install the Outport desktop app from its latest outport-desktop-v* release.
# Outport updates itself from its own feed after that; this only bootstraps
# a machine, so it pulls the AppImage from GitHub instead.

# Allow running directly: bash install/arch/apps/outport.sh
if ! declare -F installing_banner &>/dev/null; then
  DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
  [[ -f "${HOME}/.dotfilesrc" ]] && source "${HOME}/.dotfilesrc"
  source "${DOTFILES_DIR}/lib/dotfiles.sh"
fi

_install_outport() (
  set -e
  installing_banner "outport desktop"

  if ! is_installed gh; then
    error "outport: gh is required to download the release"
    return 1
  fi

  local tag version tmpdir appimage
  if ! tag=$(github_latest_tag myunio/outport-app "outport-desktop-v"); then
    error "outport: no outport-desktop-v* release found (is gh authenticated for myunio?)"
    return 1
  fi
  version=${tag#outport-desktop-v}

  if appimage_is_installed Outport "$version"; then
    success "Outport ${version} already installed"
    return 0
  fi

  tmpdir=$(mktemp -d)
  gh release download "$tag" --repo myunio/outport-app \
    --pattern '*.AppImage' --dir "$tmpdir"

  appimage=$(compgen -G "${tmpdir}/*.AppImage" | head -1)
  if [[ -z "$appimage" ]]; then
    error "outport: release ${tag} has no AppImage"
    rm -rf "$tmpdir"
    return 1
  fi

  install_appimage Outport "$version" "$appimage"
  rm -rf "$tmpdir"
)

_install_outport
