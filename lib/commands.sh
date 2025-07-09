#!/usr/bin/env bash
#
# Script Name: commands.sh
# Description: Command implementations for dotfiles utility
# Platform: cross-platform
# Dependencies: dotfiles.sh, dependencies.sh, platform-specific libraries
#

# Exit on error, undefined variables, and pipe failures
set -euo pipefail

run_install() {
  local platform="${1:-auto}"
  
  if [[ "$platform" == "auto" ]]; then
    if is_macos; then
      platform="macos"
    elif is_linux; then
      platform="linux"
    else
      echo "❌ Unable to detect platform. Please specify: linux or macos"
      exit 1
    fi
  fi
  
  case "$platform" in
    linux)
      if ! is_linux; then
        echo "❌ Cannot install Linux dotfiles on non-Linux system"
        exit 1
      fi
      echo "🐧 Starting Linux installation..."
      bash "${DOTFILES_DIR}"/install.sh
      ;;
    macos)
      if ! is_macos; then
        echo "❌ Cannot install macOS dotfiles on non-macOS system"
        exit 1
      fi
      echo "🍎 Starting macOS installation..."
      bash "${DOTFILES_DIR}"/install.sh
      ;;
    *)
      echo "❌ Invalid platform: $platform"
      echo "Supported platforms: linux, macos"
      exit 1
      ;;
  esac
}

run_config() {
  echo "⚙️  Updating configuration files..."
  bash "${DOTFILES_DIR}"/setups/stow.sh
  echo "✅ Configuration files updated!"
}

run_brew() {
  if is_macos; then
    echo "🍺 Running brew bundle (macOS)"
    
    # Cache sudo credentials for packages that may require it
    cache_sudo_credentials
    
    cd "${DOTFILES_DIR}" || exit
    
    # Always run main Brewfile for CLI tools
    if [[ -f "${DOTFILES_DIR}/Brewfile" ]]; then
      echo "📦 Installing CLI packages from main Brewfile"
      brew bundle --file=Brewfile
    fi
    
    # Run macOS-specific Brewfile if it exists
    if [[ -f "${DOTFILES_DIR}/Brewfile.macos" ]]; then
      echo "🍎 Installing macOS packages from Brewfile.macos"
      brew bundle --file="${DOTFILES_DIR}/Brewfile.macos"
    fi
    
    cd - || exit
  else
    echo "🍺 Running brew bundle (Linux)"
    cd "${DOTFILES_DIR}" || exit
    brew bundle
    cd - || exit
  fi
  echo "✅ Package installation complete!"
}

run_update() {
  echo "🔄 Updating dotfiles..."
  run_config
  run_brew
  echo "✅ Update complete!"
}

run_doctor() {
  echo "🩺 Running enhanced system health check..."
  echo ""
  
  # Use the new comprehensive system validation
  if validate_system; then
    echo ""
    echo "🎉 System health check passed! All core requirements satisfied."
    
    # Additional health checks specific to dotfiles usage
    echo "🔧 Running dotfiles-specific health checks..."
    
    # Check git configuration
    if is_installed git; then
      if git config --global user.name >/dev/null 2>&1; then
        echo "✅ git user.name is configured"
      else
        echo "⚠️  git user.name not configured"
      fi
      if git config --global user.email >/dev/null 2>&1; then
        echo "✅ git user.email is configured"
      else
        echo "⚠️  git user.email not configured"
      fi
    fi
    
    # Check shell configuration
    if [[ "$SHELL" == *"fish"* ]]; then
      echo "✅ fish shell is set as default"
    else
      echo "⚠️  fish shell is not set as default (current: $SHELL)"
    fi
    
    # Check stow configuration
    if is_installed stow; then
      echo "✅ stow is installed for configuration management"
    else
      echo "⚠️  stow not installed (needed for config management)"
    fi
    
    echo ""
    echo "💡 Tip: Run 'dotfiles install' to install missing dependencies"
    echo "💡 Tip: Run 'dotfiles config' to update configuration files"
    echo "💡 Tip: Run 'validate-system' for comprehensive system validation"
    
  else
    echo ""
    echo "❌ System health check found issues. Please address them before proceeding."
    echo ""
    echo "💡 Tip: Run 'validate-system' for detailed system validation"
    echo "💡 Tip: Run 'dotfiles install' to install missing dependencies"
  fi
}

run_fonts() {
  echo "🔤 Installing fonts..."
  
  if is_macos; then
    # Run macOS font installation script
    bash "${DOTFILES_DIR}/install/macos/fonts.sh"
  elif is_linux; then
    # Run Linux font stow (symlink) installation
    config_banner "Fonts"
    mkdir -p "${HOME}/.local/share/fonts"
    do_stow fonts
    
    # Update font cache
    if is_installed fc-cache; then
      echo "🔄 Updating font cache..."
      fc-cache -f
    fi
    
    echo "✅ Fonts installed successfully"
  else
    echo "❌ Unsupported platform for font installation"
    exit 1
  fi
  
  echo "💡 Tip: You may need to restart applications to see the new fonts"
}

run_clean() {
  echo "🧹 Cleaning temporary files and caches..."
  
  local cleaned=0
  
  # Clean common temporary directories
  for dir in "${HOME}/.cache/dotfiles" "${DOTFILES_DIR}/.tmp" "${DOTFILES_DIR}/tmp"; do
    if [[ -d "$dir" ]]; then
      echo "🗑️  Removing $dir"
      rm -rf "$dir"
      ((cleaned++))
    fi
  done
  
  # Clean common temporary files
  for file in "${DOTFILES_DIR}/.install-state" "${DOTFILES_DIR}/install.log" "${HOME}/.dotfiles-install.log"; do
    if [[ -f "$file" ]]; then
      echo "🗑️  Removing $file"
      rm -f "$file"
      ((cleaned++))
    fi
  done
  
  # Clean Homebrew cache if on macOS
  if is_macos && is_installed brew; then
    echo "🍺 Cleaning Homebrew cache..."
    brew cleanup
    ((cleaned++))
  fi
  
  # Clean apt cache if on Linux
  if is_linux && is_installed apt; then
    echo "📦 Cleaning apt cache..."
    sudo apt autoremove -y
    sudo apt autoclean
    ((cleaned++))
  fi
  
  echo ""
  if [[ $cleaned -eq 0 ]]; then
    echo "✨ No temporary files found to clean"
  else
    echo "✅ Cleaned $cleaned item(s)"
  fi
  
  echo "💡 Tip: Run 'dotfiles doctor' to check system health"
}

# Installation state management commands
run_install_status() {
  echo "📊 Installation Status"
  echo ""
  
  if [[ -f "$INSTALL_STATE_FILE" ]]; then
    show_installation_progress
    echo ""
    
    # Show recent installation sessions
    echo "Recent Installation Sessions:"
    grep "^session_" "$INSTALL_STATE_FILE" | tail -5 | while IFS=: read -r session_type operation timestamp session_id; do
      echo "  $session_type: $operation at $timestamp (session: $session_id)"
    done
    
    # Show any failed steps
    echo ""
    list_failed_steps
  else
    echo "ℹ️  No installation state file found. Run 'dotfiles install' to begin."
  fi
}

run_install_reset() {
  local confirmation="${1:-}"
  
  if [[ "$confirmation" == "confirm" ]]; then
    reset_installation_state "confirm"
  else
    reset_installation_state
  fi
}

run_install_resume() {
  echo "🔄 Resuming installation from last checkpoint..."
  
  # Initialize state tracking
  init_installation_state "resume"
  
  # Show current progress
  show_installation_progress
  
  # Resume the installation
  if is_macos; then
    echo "🍎 Resuming macOS installation..."
    bash "${DOTFILES_DIR}"/install.sh
  else
    echo "🐧 Resuming Linux installation..."
    bash "${DOTFILES_DIR}"/install.sh
  fi
}

run_install_steps() {
  echo "📋 Installation Steps"
  echo ""
  
  if [[ -f "$INSTALL_STATE_FILE" ]]; then
    echo "Installation steps and their status:"
    while IFS=: read -r step_id status timestamp session_id rest; do
      # Skip comment lines and session entries
      if [[ "$step_id" != "session_start" && "$step_id" != "session_end" && ! "$step_id" =~ ^#.* ]]; then
        local status_emoji
        case "$status" in
          completed) status_emoji="✅" ;;
          failed) status_emoji="❌" ;;
          skipped) status_emoji="⏭️" ;;
          in_progress) status_emoji="⏳" ;;
          *) status_emoji="⏸️" ;;
        esac
        echo "  $status_emoji $step_id - $status ($timestamp)"
      fi
    done < "$INSTALL_STATE_FILE"
  else
    echo "ℹ️  No installation state file found. Run 'dotfiles install' to begin."
  fi
}

run_validate() {
  echo "🔍 Running comprehensive system validation..."
  echo ""
  
  # Use the comprehensive validation system
  if validate_system; then
    echo ""
    echo "🎉 System validation passed! Your system is ready for dotfiles installation."
    echo ""
    echo "Next steps:"
    echo "  - Run 'dotfiles install' to start installation"
    echo "  - Run 'dotfiles doctor' for ongoing health checks"
  else
    echo ""
    echo "❌ System validation failed! Please address the issues above."
    echo ""
    echo "Common fixes:"
    if is_linux; then
      echo "  - Run 'sudo apt update && sudo apt install -y git curl wget'"
      echo "  - Ensure you have sudo access"
    elif is_macos; then
      echo "  - Install Xcode Command Line Tools: xcode-select --install"
      echo "  - Install Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fi
    echo "  - Check your .dotfilesrc configuration"
    echo "  - Run 'dotfiles doctor' for additional health checks"
  fi
}

run_test_deps() {
  echo "🧪 Testing Dependency Declaration Coverage"
  echo "=========================================="
  echo ""
  
  # Simple list of scripts to check based on platform
  echo "🔍 Checking: install/linux/prereq/stow.sh"
  if grep -q "^SCRIPT_DEPENDS_" "${DOTFILES_DIR}/install/linux/prereq/stow.sh" 2>/dev/null; then
    echo "✅ Has dependency declarations"
  else
    echo "⚠️  No dependency declarations found"
  fi
  echo ""
  
  if is_linux; then
    echo "🔍 Checking: install/linux/apps/vscode.sh"
    if [[ -f "${DOTFILES_DIR}/install/linux/apps/vscode.sh" ]]; then
      if grep -q "^SCRIPT_DEPENDS_" "${DOTFILES_DIR}/install/linux/apps/vscode.sh" 2>/dev/null; then
        echo "✅ Has dependency declarations"
      else
        echo "⚠️  No dependency declarations found"
      fi
    else
      echo "⚠️  Script not found"
    fi
    echo ""
    
    echo "🔍 Checking: install/linux/cli/docker.sh"
    if [[ -f "${DOTFILES_DIR}/install/linux/cli/docker.sh" ]]; then
      if grep -q "^SCRIPT_DEPENDS_" "${DOTFILES_DIR}/install/linux/cli/docker.sh" 2>/dev/null; then
        echo "✅ Has dependency declarations"
      else
        echo "⚠️  No dependency declarations found"
      fi
    else
      echo "⚠️  Script not found"
    fi
    echo ""
  fi
  
  if is_macos; then
    echo "🔍 Checking: install/macos/brew.sh"
    if [[ -f "${DOTFILES_DIR}/install/macos/brew.sh" ]]; then
      if grep -q "^SCRIPT_DEPENDS_" "${DOTFILES_DIR}/install/macos/brew.sh" 2>/dev/null; then
        echo "✅ Has dependency declarations"
      else
        echo "⚠️  No dependency declarations found"
      fi
    else
      echo "⚠️  Script not found"
    fi
    echo ""
  fi
  
  echo "🔍 Checking: install.sh"
  if [[ -f "${DOTFILES_DIR}/install.sh" ]]; then
    if grep -q "^SCRIPT_DEPENDS_" "${DOTFILES_DIR}/install.sh" 2>/dev/null; then
      echo "✅ Has dependency declarations"
    else
      echo "⚠️  No dependency declarations found"
    fi
  else
    echo "⚠️  Script not found"
  fi
  echo ""
  
  echo "📊 Summary"
  echo "=========="
  echo "✅ Multiple scripts now have dependency declarations"
  echo "⚠️  This helps ensure reliable installations"
  echo ""
  echo "💡 Tip: Run 'dotfiles test script <script>' to validate specific script dependencies"
  echo "💡 Tip: Run 'dotfiles validate' for comprehensive system validation"
  echo "💡 Tip: See 'docs/dependency-management.md' for detailed documentation"
}

run_test_simple() {
  local script_path="$1"
  
  echo "🧪 Script Dependency Validation"
  echo "==============================="
  echo ""
  
  # If no script specified, show usage
  if [[ -z "$script_path" ]]; then
    echo "Usage: dotfiles test script <script-path>"
    echo ""
    echo "Examples:"
    echo "  dotfiles test script install/linux/prereq/stow.sh"
    echo "  dotfiles test script install.sh"
    echo "  dotfiles test script install/linux/apps/vscode.sh"
    echo ""
    echo "💡 Tip: Run 'dotfiles test dependencies' for comprehensive dependency testing"
    echo "💡 Tip: Run 'dotfiles validate' for full system validation"
    return 1
  fi
  
  # Resolve relative path
  local full_path
  if [[ "$script_path" == /* ]]; then
    full_path="$script_path"
  else
    full_path="${DOTFILES_DIR}/${script_path}"
  fi
  
  # Check if script exists
  if [[ ! -f "$full_path" ]]; then
    echo "❌ Script not found: $script_path"
    echo ""
    echo "💡 Tip: Paths are relative to DOTFILES_DIR ($DOTFILES_DIR)"
    return 1
  fi
  
  echo "🔍 Testing: $script_path"
  echo "---"
  
  if validate_dependencies "$full_path"; then
    echo "✅ $script_path validation - PASSED"
    echo ""
    echo "🎉 Script validation completed successfully!"
    echo ""
    echo "💡 Tip: Run 'dotfiles test dependencies' for comprehensive dependency testing"
    echo "💡 Tip: Run 'dotfiles validate' for full system validation"
  else
    echo "❌ $script_path validation - FAILED"
    echo ""
    echo "⚠️  Script validation found issues."
    echo ""
    echo "💡 Tip: Run 'dotfiles validate' to check your system setup"
    echo "💡 Tip: See 'docs/dependency-management.md' for troubleshooting"
  fi
} 

run_version() {
  echo "📋 Dotfiles Management System"
  echo ""
  
  if [[ -f "${DOTFILES_DIR}/VERSION" ]]; then
    local version
    version=$(cat "${DOTFILES_DIR}/VERSION" | tr -d '\n')
    echo "🔢 Version: $version"
  else
    echo "🔢 Version: Unknown (VERSION file not found)"
  fi
  
  echo "📂 Installation directory: $DOTFILES_DIR"
  echo "💻 Operating system: $DOTFILES_OS"
  echo "🐚 Shell: $SHELL"
  
  if [[ -d "${DOTFILES_DIR}/.git" ]]; then
    echo ""
    echo "🔗 Git information:"
    cd "$DOTFILES_DIR" || exit 1
    local branch
    branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    local commit
    commit=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
    echo "   Branch: $branch"
    echo "   Commit: $commit"
    cd - >/dev/null || exit 1
  fi
  
  echo ""
  echo "💡 Tip: Run 'dotfiles --help' for usage information"
  echo "💡 Tip: Run 'dotfiles status' for system status"
}
