#!/usr/bin/env bash

# Allow running directly: bash install/arch/cli/process-compose.sh
if ! declare -F installing_banner &>/dev/null; then
  DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)}"
  [[ -f "${HOME}/.dotfilesrc" ]] && source "${HOME}/.dotfilesrc"
  source "${DOTFILES_DIR}/lib/dotfiles.sh"
fi

_install_process_compose() (
  set -e
  installing_banner "process-compose"

  # Refuse to overwrite a pacman-managed binary
  if pacman -Qo /usr/bin/process-compose &>/dev/null; then
    local owner
    owner=$(pacman -Qo /usr/bin/process-compose | awk '{print $(NF-1)}')
    echo "process-compose: /usr/bin/process-compose is owned by AUR package '${owner}'." >&2
    echo "Remove it first: yay -R ${owner}" >&2
    return 1
  fi

  local arch go_arch
  arch=$(uname -m)
  go_arch="amd64"
  [[ "$arch" == "aarch64" ]] && go_arch="arm64"

  # Resolve latest release tag via the redirect on /releases/latest
  local tag
  tag=$(curl -sI https://github.com/F1bonacc1/process-compose/releases/latest \
    | awk -F'/' 'tolower($1) ~ /^location:/ {gsub(/\r/,"",$NF); print $NF}')
  if [[ -z "$tag" ]]; then
    echo "process-compose: could not resolve latest release tag" >&2
    return 1
  fi
  local version=${tag#v}

  # Skip if already at latest version
  if command -v process-compose &>/dev/null; then
    local current
    current=$(process-compose version 2>/dev/null | awk '/Version:/ {sub(/^v/,"",$2); print $2}')
    if [[ "$current" == "$version" ]]; then
      success "process-compose ${version} already installed"
      return 0
    fi
  fi

  local tmpdir
  tmpdir=$(mktemp -d)
  trap "rm -rf '$tmpdir'" RETURN

  local tarball="process-compose_linux_${go_arch}.tar.gz"
  curl -fsSL -o "${tmpdir}/${tarball}" \
    "https://github.com/F1bonacc1/process-compose/releases/download/${tag}/${tarball}"

  tar xzf "${tmpdir}/${tarball}" -C "$tmpdir"

  # Release tarball ships the binary as `process-compose_linux_amd64`; rename on install
  local bin_src
  bin_src=$(find "$tmpdir" -maxdepth 2 -type f -name 'process-compose*' ! -name '*.tar.gz' | head -1)
  if [[ -z "$bin_src" ]]; then
    echo "process-compose: binary not found in tarball" >&2
    return 1
  fi

  sudo install -Dm755 "$bin_src" /usr/bin/process-compose
  success "process-compose ${version} installed"
)

_install_process_compose
