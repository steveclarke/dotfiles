#!/usr/bin/env bash
#
# Script Name: fonts.sh
# Description: Install fonts on macOS by copying them to ~/Library/Fonts
# Platform: macos
# Dependencies: .dotfilesrc, font files in configs/fonts/Library/Fonts/
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

# Source required libraries
source "${DOTFILES_DIR}"/lib/macos.sh

# Dependency declarations
SCRIPT_DEPENDS_PLATFORM=("macos")
SCRIPT_DEPENDS_ENV=("DOTFILES_DIR" "HOME")
SCRIPT_DEPENDS_DIRS=("${DOTFILES_DIR}/configs/fonts/.local/share/fonts")

installing_banner "Fonts"

# Create fonts directory if it doesn't exist
mkdir -p "${HOME}/Library/Fonts"

# Copy fonts from dotfiles to system fonts directory
# macOS doesn't support symlinked fonts, so we need to copy them
# We copy from the Linux font directory to avoid duplication
if [[ -d "${DOTFILES_DIR}/configs/fonts/.local/share/fonts" ]]; then
    font_count=$(find "${DOTFILES_DIR}/configs/fonts/.local/share/fonts" -name "*.ttf" -o -name "*.otf" | wc -l)
    
    if [[ $font_count -gt 0 ]]; then
        echo "📝 Copying ${font_count} font files to ~/Library/Fonts/"
        
        # Copy all font files from the Linux directory
        cp "${DOTFILES_DIR}/configs/fonts/.local/share/fonts/"*.ttf "${HOME}/Library/Fonts/" 2>/dev/null || true
        cp "${DOTFILES_DIR}/configs/fonts/.local/share/fonts/"*.otf "${HOME}/Library/Fonts/" 2>/dev/null || true
        
        echo "✅ Fonts installed successfully"
        echo "💡 You may need to restart applications to see the new fonts"
    else
        echo "⚠️  No font files found in ${DOTFILES_DIR}/configs/fonts/.local/share/fonts/"
    fi
else
    echo "❌ Font directory not found: ${DOTFILES_DIR}/configs/fonts/.local/share/fonts/"
    exit 1
fi 
