#!/usr/bin/env bash
#
# Add the personal-email include for personal repos (setups/git-personal.sh)
# to machines installed before it existed.

set -euo pipefail

bash "${DOTFILES_DIR:-${HOME}/.local/share/dotfiles}"/setups/git-personal.sh
