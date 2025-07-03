#!/usr/bin/env bash
# macOS Bootstrap Script

set -e -o pipefail

# Load shared library functions
source "$(dirname "${BASH_SOURCE[0]}")/lib/dotfiles.sh"

# Detect OS and check for .dotfilesrc
detect_os
check_dotfilesrc

# [[ Entry Point ]]
bootstrap_warning

if bootstrap_confirm; then
	install_macos_prerequisites
	copy_ssh_keys
	configure_ssh
	clone_git_repo
	run_installation
	
	echo ""
	bootstrap_banner "Bootstrap complete!"
	echo "Consider restarting your terminal or running 'source ~/.zprofile' to ensure all changes take effect."
fi 
