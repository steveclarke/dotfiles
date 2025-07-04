#!/usr/bin/env bash

# ⚠️  DEPRECATED: This script is no longer needed!
# 
# The installation process has been unified. Please use the new simplified process:
# 1. Download .dotfilesrc template
# 2. Clone the repository 
# 3. Run install.sh directly
#
# See README.md for updated installation instructions.
#
# This script will be removed in a future version.

echo "⚠️  WARNING: This bootstrap script is deprecated!"
echo ""
echo "Please use the new unified installation process:"
echo "1. Download .dotfilesrc: curl -o ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/feature/macos/.dotfilesrc.template"
echo "2. Clone repository: git clone -b feature/macos https://github.com/steveclarke/dotfiles.git ~/.local/share/dotfiles"
echo "3. Run install script: cd ~/.local/share/dotfiles && bash install.sh"
echo ""
echo "See README.md for full instructions."
echo ""
echo "This script will continue to work for now but will be removed in a future version."
echo ""
read -p "Press Enter to continue with the deprecated bootstrap process, or Ctrl+C to abort..."

# Original bootstrap-macos.sh content below
source "$HOME"/.dotfilesrc
source ~/.local/share/dotfiles/lib/dotfiles.sh

# Detect OS
detect_os

# Check for .dotfilesrc
check_dotfilesrc

# Show warning
bootstrap_warning

# Confirm bootstrap
if bootstrap_confirm; then
	install_macos_prerequisites
	copy_ssh_keys
	configure_ssh
	clone_git_repo
	run_installation
	
	echo ""
	bootstrap_banner "Bootstrap complete!"
fi 
