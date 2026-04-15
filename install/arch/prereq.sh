#!/usr/bin/env bash
#
# Arch/Omarchy Prerequisites
#
# Installs foundational packages needed before stow, CLI tools, and apps.
# Omarchy provides most build tools (base-devel, rust, clang, etc.) —
# this fills in the gaps for Rails dev, PDF tools, and app distribution.
#
# Usage: sourced by install.sh (or run standalone for testing)
#

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

cache_sudo_credentials

banner "Installing Arch prerequisites"

# Development libraries (Rails/Ruby apps need these)
installing_banner "jemalloc"
omarchy-pkg-add jemalloc

installing_banner "libvips"
omarchy-pkg-add libvips

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
