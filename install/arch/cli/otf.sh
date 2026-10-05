#!/usr/bin/env bash

# Install or upgrade the 135 Main content CLI (`otf`, for onethreefive) from the latest
# otf-cli-v* release in the public steveclarke/homebrew-tap repository.
# Idempotent - skips if already current.

# Allow running directly: bash install/arch/cli/otf.sh
if ! declare -F installing_banner &>/dev/null; then
  DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
  [[ -f "${HOME}/.dotfilesrc" ]] && source "${HOME}/.dotfilesrc"
  source "${DOTFILES_DIR}/lib/dotfiles.sh"
fi

_install_otf() (
  set -e
  installing_banner "otf"

  if ! is_installed gh; then
    error "otf: gh is required to download the release"
    return 1
  fi

  local tmpdir arch go_arch tag version current tarball
  arch=$(uname -m)
  go_arch="amd64"
  [[ "$arch" == "aarch64" ]] && go_arch="arm64"

  if ! tag=$(github_latest_tag steveclarke/homebrew-tap "otf-cli-v"); then
    error "otf: no otf-cli-v* release found in steveclarke/homebrew-tap"
    return 1
  fi
  version=${tag#otf-cli-v}

  if is_installed otf; then
    current=$(otf version --json 2>/dev/null | jq -r '.data.version // empty')
    if [[ "$current" == "$version" ]]; then
      success "otf ${version} already installed"
      return 0
    fi
  fi

  tmpdir=$(mktemp -d)
  tarball="otf-cli_${version}_linux_${go_arch}.tar.gz"
  gh release download "$tag" --repo steveclarke/homebrew-tap \
    --pattern "$tarball" --pattern checksums.txt --dir "$tmpdir"
  (cd "$tmpdir" && grep " ${tarball}\$" checksums.txt | sha256sum -c --quiet -)

  tar xzf "${tmpdir}/${tarball}" -C "$tmpdir"
  # ~/.local/bin and the per-user completion dirs, so no sudo is needed and
  # install.sh can run unattended.
  install -Dm755 "${tmpdir}/otf" "${HOME}/.local/bin/otf"
  install -Dm644 "${tmpdir}/completions/otf.bash" \
    "${HOME}/.local/share/bash-completion/completions/otf"
  install -Dm644 "${tmpdir}/completions/_otf" \
    "${HOME}/.local/share/zsh/site-functions/_otf"
  install -Dm644 "${tmpdir}/completions/otf.fish" \
    "${HOME}/.local/share/fish/vendor_completions.d/otf.fish"

  rm -rf "$tmpdir"
  success "otf ${version} installed - run 'otf login' to sign in"
)

_install_otf
