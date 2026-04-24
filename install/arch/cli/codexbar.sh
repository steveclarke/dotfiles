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

if ! declare -F skipping >/dev/null; then
  skipping() { echo "=== skipping $1 - already installed"; }
fi

if ! declare -F success >/dev/null; then
  success() { echo "✓ $1"; }
fi

if ! declare -F error >/dev/null; then
  error() { echo "✗ ERROR: $1" >&2; }
fi

finish() {
  local code="$1"
  # shellcheck disable=SC2317
  return "${code}" 2>/dev/null || exit "${code}"
}

installing_banner "codexbar"

if command -v omarchy-pkg-add >/dev/null 2>&1; then
  omarchy-pkg-add libxml2-legacy
fi

repo="steipete/CodexBar"
api_url="https://api.github.com/repos/${repo}/releases/latest"
bin_dir="${HOME}/.local/bin"
bin_path="${bin_dir}/codexbar"
machine="$(uname -m)"

case "${machine}" in
  x86_64) asset_arch="x86_64" ;;
  aarch64|arm64) asset_arch="aarch64" ;;
  *)
    error "Unsupported architecture for CodexBar CLI: ${machine}"
    finish 1
    ;;
esac

if ! release_json="$(curl -fsSL "${api_url}")"; then
  error "Could not fetch latest CodexBar release metadata"
  finish 1
fi
tag="$(printf '%s' "${release_json}" | sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' | head -n1)"
version="${tag#v}"

if [[ -z ${tag} || -z ${version} ]]; then
  error "Could not resolve latest CodexBar release"
  finish 1
fi

if command -v codexbar >/dev/null 2>&1; then
  current="$(codexbar --version 2>/dev/null | grep -Eo '[0-9]+(\.[0-9]+)+' | head -n1 || true)"
  if [[ ${current} == "${version}" ]]; then
    skipping "codexbar ${version}"
    finish 0
  fi
fi

asset_url="$(printf '%s' "${release_json}" |
  grep -Eo 'https://[^"]*CodexBarCLI-[^"]+-linux-[^"]+\.tar\.gz' |
  grep -F "CodexBarCLI-${tag}-linux-${asset_arch}.tar.gz" |
  head -n1)"

if [[ -z ${asset_url} ]]; then
  error "Could not find CodexBar CLI Linux asset for ${asset_arch} in ${tag}"
  finish 1
fi

tmpdir="$(mktemp -d)"

if ! curl -fsSL "${asset_url}" -o "${tmpdir}/codexbar.tar.gz"; then
  rm -rf "${tmpdir}"
  error "CodexBar CLI download failed"
  finish 1
fi

if ! tar -xzf "${tmpdir}/codexbar.tar.gz" -C "${tmpdir}"; then
  rm -rf "${tmpdir}"
  error "CodexBar CLI archive extraction failed"
  finish 1
fi

binary="$(find "${tmpdir}" -type f \( -name codexbar -o -name CodexBarCLI \) -perm -u+x | head -n1)"
if [[ -z ${binary} ]]; then
  rm -rf "${tmpdir}"
  error "CodexBar CLI archive did not contain an executable"
  finish 1
fi

mkdir -p "${bin_dir}"
install -m 0755 "${binary}" "${bin_path}"
rm -rf "${tmpdir}"
success "codexbar ${version} installed to ${bin_path}"
