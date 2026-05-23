#!/usr/bin/env bash
# AWS CLI v2 — Universal CLI for Amazon Web Services
# https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh
detect_os

if is_installed aws; then
  skipping "aws-cli-v2 (already installed)"
  return 0 2>/dev/null || exit 0
fi

installing_banner "aws-cli-v2"

if is_arch; then
  omarchy-pkg-add aws-cli-v2
elif is_macos; then
  brew install awscli
elif is_ubuntu; then
  tmpdir=$(mktemp -d)
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "${tmpdir}/awscliv2.zip"
  unzip -q "${tmpdir}/awscliv2.zip" -d "${tmpdir}"
  sudo "${tmpdir}/aws/install"
  rm -rf "${tmpdir}"
else
  error "aws-cli-v2: unsupported OS ($DOTFILES_OS/$DOTFILES_DISTRO)"
  exit 1
fi

is_installed aws && success "aws-cli-v2 installed ($(aws --version 2>&1))"
