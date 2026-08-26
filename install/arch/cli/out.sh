#!/usr/bin/env bash

# Install or upgrade the Outport App CLI (`out`) from the latest
# outport-app-cli-v* GitHub release. Idempotent - skips if already current.

# Allow running directly: bash install/arch/cli/out.sh
if ! declare -F installing_banner &>/dev/null; then
  DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
  [[ -f "${HOME}/.dotfilesrc" ]] && source "${HOME}/.dotfilesrc"
  source "${DOTFILES_DIR}/lib/dotfiles.sh"
fi

_install_out() (
  set -e
  installing_banner "out"

  if ! is_installed gh; then
    error "out: gh is required to download the release"
    return 1
  fi

  local tmpdir arch go_arch tag version current tarball
  arch=$(uname -m)
  go_arch="amd64"
  [[ "$arch" == "aarch64" ]] && go_arch="arm64"

  if ! tag=$(github_latest_tag myunio/outport-app "outport-app-cli-v"); then
    error "out: no outport-app-cli-v* release found (is gh authenticated for myunio?)"
    return 1
  fi
  version=${tag#outport-app-cli-v}

  if is_installed out; then
    current=$(out version 2>/dev/null | awk '{print $2}')
    if [[ "$current" == "$version" ]]; then
      success "out ${version} already installed"
      return 0
    fi
  fi

  tmpdir=$(mktemp -d)
  tarball="outport-app-cli_${version}_linux_${go_arch}.tar.gz"
  gh release download "$tag" --repo myunio/outport-app \
    --pattern "$tarball" --dir "$tmpdir"

  tar xzf "${tmpdir}/${tarball}" -C "$tmpdir"
  sudo install -Dm755 "${tmpdir}/out" /usr/bin/out
  sudo install -Dm644 "${tmpdir}/completions/out.bash" /usr/share/bash-completion/completions/out
  sudo install -Dm644 "${tmpdir}/completions/_out" /usr/share/zsh/site-functions/_out
  sudo install -Dm644 "${tmpdir}/completions/out.fish" /usr/share/fish/vendor_completions.d/out.fish

  rm -rf "$tmpdir"
  success "out ${version} installed - run 'out setup' to add your API token"
)

_install_out
