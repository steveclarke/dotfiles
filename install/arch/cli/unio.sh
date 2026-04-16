#!/usr/bin/env bash
installing_banner "unio"

if is_installed unio; then
  return 0 2>/dev/null
fi

local tmpdir=$(mktemp -d)
local arch=$(uname -m)
local go_arch="amd64"
[[ "$arch" == "aarch64" ]] && go_arch="arm64"

# Download from private repo using gh (handles auth)
local version=$(gh release view --repo myunio/unio --json tagName --jq '.tagName' | sed 's/^v//')
gh release download "v${version}" --repo myunio/unio \
  --pattern "unio_${version}_linux_${go_arch}.tar.gz" \
  --dir "$tmpdir"

# Extract and install
tar xzf "${tmpdir}/unio_${version}_linux_${go_arch}.tar.gz" -C "$tmpdir"
sudo install -Dm755 "${tmpdir}/unio" /usr/bin/unio
sudo install -Dm644 "${tmpdir}/completions/unio.bash" /usr/share/bash-completion/completions/unio
sudo install -Dm644 "${tmpdir}/completions/_unio" /usr/share/zsh/site-functions/_unio
sudo install -Dm644 "${tmpdir}/completions/unio.fish" /usr/share/fish/vendor_completions.d/unio.fish

rm -rf "$tmpdir"
success "unio ${version} installed"
