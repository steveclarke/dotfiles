#!/usr/bin/env bash
source "${DOTFILES_DIR}/lib/dotfiles.sh"

installing_banner "gogcli"

if ! is_installed gog; then
  mise install go@1.26.2
  eval "$(mise activate bash)"
  mise use go@1.26.2
  GOBIN="${HOME}/.local/bin" go install github.com/steipete/gogcli/cmd/gog@latest
else
  skipping "gogcli"
fi
