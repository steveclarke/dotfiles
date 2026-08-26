#!/usr/bin/env bash

# Install the Jots desktop app from its latest jots-v* GitHub release.
# Jots updates itself from then on; this only bootstraps a machine.
# Releases are moving from the old clients repo to the outport-app monorepo,
# so both are checked, newest home first.

# Allow running directly: bash install/arch/apps/jots.sh
if ! declare -F installing_banner &>/dev/null; then
  DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
  [[ -f "${HOME}/.dotfilesrc" ]] && source "${HOME}/.dotfilesrc"
  source "${DOTFILES_DIR}/lib/dotfiles.sh"
fi

_install_jots() (
  set -e
  installing_banner "jots"

  if ! is_installed gh; then
    error "jots: gh is required to download the release"
    return 1
  fi

  local repo tag version tmpdir appimage found=""
  for repo in myunio/outport-app myunio/outport-clients; do
    if tag=$(github_latest_tag "$repo" "jots-v"); then
      found=$repo
      break
    fi
  done

  if [[ -z "$found" ]]; then
    error "jots: no jots-v* release found (is gh authenticated for myunio?)"
    return 1
  fi
  version=${tag#jots-v}

  if appimage_is_installed Jots "$version"; then
    success "Jots ${version} already installed"
    return 0
  fi

  tmpdir=$(mktemp -d)
  gh release download "$tag" --repo "$found" \
    --pattern '*.AppImage' --dir "$tmpdir"

  appimage=$(compgen -G "${tmpdir}/"*".AppImage" | head -1)
  if [[ -z "$appimage" ]]; then
    error "jots: release ${tag} has no AppImage"
    rm -rf "$tmpdir"
    return 1
  fi

  install_appimage Jots "$version" "$appimage"
  rm -rf "$tmpdir"
)

_install_jots
