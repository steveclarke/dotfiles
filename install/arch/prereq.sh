#!/usr/bin/env bash
#
# Arch/Omarchy Prerequisites
#
# Installs foundational packages needed before stow, CLI tools, and apps.
# Omarchy 4 provides base-devel and clang but NOT stow or rust —
# this fills in the gaps for Rails dev, PDF tools, and app distribution.
#
# Usage: sourced by install.sh (or run standalone for testing)
#

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

cache_sudo_credentials

banner "Installing Arch prerequisites"

# GNU Stow — Omarchy 3 shipped this, Omarchy 4 does not. configs/stow.sh runs
# before install/arch/cli.sh, so stow has to land here or the install aborts.
installing_banner "stow"
omarchy-pkg-add stow

# Rust — Omarchy 3 shipped this, Omarchy 4 does not. The herdr-lazy sync in
# configs/stow.sh builds ez-corp.git-status with cargo, and that runs before
# install/arch/cli.sh, so rust has to land here too.
installing_banner "rust"
if is_installed cargo; then
  skipping "rust"
else
  omarchy install dev-env rust
fi

# Development libraries (Rails/Ruby apps need these)
installing_banner "jemalloc"
omarchy-pkg-add jemalloc

# Runtime compatibility libraries
installing_banner "libxml2-legacy"
omarchy-pkg-add libxml2-legacy

# PDF tools (used by md-to-pdf skill and mupdf-based workflows)
installing_banner "mupdf-tools"
omarchy-pkg-add mupdf mupdf-tools

# Redis-compatible server (Arch ships Valkey, the community fork)
installing_banner "valkey"
omarchy-pkg-add valkey

# Flatpak (for GUI app distribution)
installing_banner "flatpak"
omarchy-pkg-add flatpak

success "Arch prerequisites installed"
