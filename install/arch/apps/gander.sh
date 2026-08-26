#!/usr/bin/env bash

# Install the Gander desktop app from its latest GitHub release.
# Gander updates itself from then on; this only bootstraps a machine.

# Allow running directly: bash install/arch/apps/gander.sh
if ! declare -F installing_banner &>/dev/null; then
  DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
  [[ -f "${HOME}/.dotfilesrc" ]] && source "${HOME}/.dotfilesrc"
  source "${DOTFILES_DIR}/lib/dotfiles.sh"
fi

_install_gander() (
  set -e
  installing_banner "gander"

  if ! is_installed gh; then
    error "gander: gh is required to download the release"
    return 1
  fi

  local tag version tmpdir appimage
  if ! tag=$(github_latest_tag steveclarke/gander "v"); then
    error "gander: no release found on steveclarke/gander (is gh authenticated?)"
    return 1
  fi
  version=${tag#v}

  if appimage_is_installed Gander "$version"; then
    success "Gander ${version} already installed"
    return 0
  fi

  tmpdir=$(mktemp -d)
  gh release download "$tag" --repo steveclarke/gander \
    --pattern '*.AppImage' --dir "$tmpdir"

  appimage=$(compgen -G "${tmpdir}/"*".AppImage" | head -1)
  if [[ -z "$appimage" ]]; then
    error "gander: release ${tag} has no AppImage"
    rm -rf "$tmpdir"
    return 1
  fi

  install_appimage Gander "$version" "$appimage"
  rm -rf "$tmpdir"
)

_install_gander
