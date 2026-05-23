#!/usr/bin/env bash
#
# Android SDK baseline — installs platform-tools, the latest platform,
# and matching build-tools via Google's Android CLI. Cross-platform.
#
# Opt-in via ~/.dotfilesrc:
#   export DOTFILES_INSTALL_ANDROID_SDK=true
#
# Override package list (space-separated) via:
#   export DOTFILES_ANDROID_SDK_PACKAGES="platform-tools platforms/android-36 build-tools/36.0.0 emulator"
#

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if [[ "${DOTFILES_INSTALL_ANDROID_SDK^^}" != "TRUE" ]]; then
  return 0 2>/dev/null || exit 0
fi

if ! is_installed android; then
  error "android CLI not found — run 'dotfiles install android-cli' first"
  return 0 2>/dev/null || exit 0
fi

banner "Installing Android SDK baseline"

packages=(${DOTFILES_ANDROID_SDK_PACKAGES:-platform-tools platforms/android-36 build-tools/36.0.0})

# `android sdk install` is idempotent — already-installed packages are skipped.
android sdk install "${packages[@]}"

success "Android SDK baseline ready at ${ANDROID_HOME:-$HOME/Android/Sdk}"
