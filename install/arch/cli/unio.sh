#!/usr/bin/env bash

# Allow running directly: bash install/arch/cli/unio.sh
if ! declare -F installing_banner &>/dev/null; then
  DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
  [[ -f "${HOME}/.dotfilesrc" ]] && source "${HOME}/.dotfilesrc"
  source "${DOTFILES_DIR}/lib/dotfiles.sh"
fi

_install_unio() (
  set -e
  installing_banner "unio"

  local tmpdir
  tmpdir=$(mktemp -d)
  local arch
  arch=$(uname -m)
  local go_arch="amd64"
  [[ "$arch" == "aarch64" ]] && go_arch="arm64"

  # Find latest CLI release from private repo (cli-v* tags, not app v* tags)
  local tag
  tag=$(gh release list --repo myunio/unio --limit 20 --json tagName --jq '[.[] | select(.tagName | startswith("cli-v"))][0].tagName')
  if [[ -z "$tag" ]]; then
    echo "unio: could not find a cli-v* release on myunio/unio (is gh authenticated?)" >&2
    rm -rf "$tmpdir"
    return 1
  fi
  local version=${tag#cli-v}

  # Skip if already at latest version
  if command -v unio &>/dev/null; then
    local current
    current=$(unio version 2>/dev/null | awk '{print $3}')
    if [[ "$current" == "$version" ]]; then
      success "unio ${version} already installed"
      rm -rf "$tmpdir"
      return 0
    fi
  fi

  gh release download "${tag}" --repo myunio/unio \
    --pattern "unio_${version}_linux_${go_arch}.tar.gz" \
    --dir "$tmpdir"

  tar xzf "${tmpdir}/unio_${version}_linux_${go_arch}.tar.gz" -C "$tmpdir"
  sudo install -Dm755 "${tmpdir}/unio" /usr/bin/unio
  sudo install -Dm644 "${tmpdir}/completions/unio.bash" /usr/share/bash-completion/completions/unio
  sudo install -Dm644 "${tmpdir}/completions/_unio" /usr/share/zsh/site-functions/_unio
  sudo install -Dm644 "${tmpdir}/completions/unio.fish" /usr/share/fish/vendor_completions.d/unio.fish

  rm -rf "$tmpdir"
  success "unio ${version} installed"
)

_install_unio
