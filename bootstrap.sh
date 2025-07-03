#!/usr/bin/env bash

set -e -o pipefail

# Load shared library functions
source "$(dirname "${BASH_SOURCE[0]}")/lib/dotfiles.sh"

# Detect OS and check for .dotfilesrc
detect_os
check_dotfilesrc

# [[ Entry Point ]]
bootstrap_warning

if bootstrap_confirm; then
	install_linux_prerequisites
	copy_ssh_keys
	configure_ssh
	clone_git_repo
fi
