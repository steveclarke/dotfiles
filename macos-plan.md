# macOS Integration Implementation Plan

This document outlines the strategy for extending the dotfiles system to support macOS while maintaining existing Linux functionality.

## Implementation Status

✅ **COMPLETED** - All phases have been successfully implemented and tested.

## Strategy Overview

**Approach**: Dual-mode architecture with OS detection and platform-specific branching.

**Goals**:
- Maintain existing Linux functionality without breaking changes ✅
- Leverage existing `Brewfile.macos` for macOS package management ✅
- Minimize code duplication between platforms ✅
- Provide seamless experience for both Linux and macOS users ✅

## Phase 1: Foundation & OS Detection ✅ COMPLETED

### 1.1 Add OS Detection Logic ✅
**File**: `lib/dotfiles.sh`
```bash
# Add OS detection function
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    export DOTFILES_OS="macos"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export DOTFILES_OS="linux"
  else
    echo "Unsupported OS: $OSTYPE"
    exit 1
  fi
}

# Add macOS-specific helper functions
macos_defaults() {
  # Helper for setting macOS system preferences
  defaults write "$@"
}

is_macos() {
  [[ "$DOTFILES_OS" == "macos" ]]
}

is_linux() {
  [[ "$DOTFILES_OS" == "linux" ]]
}
```

### 1.2 Create macOS Directory Structure ✅
```
install/
├── macos/
│   ├── prereq.sh          # Homebrew, Command Line Tools
│   └── brew.sh            # CLI tools + GUI apps via brew bundle
└── [existing linux dirs]

setups/
├── macos/
│   └── macos-defaults.sh  # System preferences including Dock, Finder, etc.
└── [existing cross-platform setups]
```

## Phase 2: Installation Script Integration ✅ COMPLETED

### 2.1 Update Main Install Script ✅
**File**: `install.sh`
```bash
#!/usr/bin/env bash
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Detect OS at start
detect_os

install() {
  if is_macos; then
    # macOS installation flow
    source "${DOTFILES_DIR}"/install/macos/prereq.sh
    source "${DOTFILES_DIR}"/configs/stow.sh
    source "${DOTFILES_DIR}"/install/macos/brew.sh
    
    # Run macOS-specific setups
    for setup in "${DOTFILES_DIR}"/setups/macos/*.sh; do 
      [[ -f $setup ]] && source "$setup"
    done
    
    # Run cross-platform setups
    for setup in "${DOTFILES_DIR}"/setups/*.sh; do
      [[ -f $setup ]] && source "$setup"
    done
  else
    # Existing Linux logic unchanged
    source "${DOTFILES_DIR}"/install/prereq.sh
    source "${DOTFILES_DIR}"/configs/stow.sh
    source "$DOTFILES_DIR"/install/cli.sh
    
    if [ "${DOTFILES_INSTALL_GUI^^}" = "TRUE" ]; then
      source "$DOTFILES_DIR"/install/apps.sh
      source "$DOTFILES_DIR"/install/desktop-entries.sh
    fi
    
    for installer in "${DOTFILES_DIR}"/setups/*.sh; do 
      source $installer
    done
  fi
  
  echo "Installation complete! $(is_macos && echo "Consider restarting to apply system changes." || echo "You should now reboot the system.")"
}
```

### 2.2 Create macOS Prerequisites Script ✅
**File**: `install/macos/prereq.sh`
```bash
#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# Install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  installing_banner "Xcode Command Line Tools"
  xcode-select --install
  echo "Please complete the Xcode Command Line Tools installation and re-run this script."
  exit 1
fi

# Install Homebrew
if ! is_installed brew; then
  installing_banner "Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add Homebrew to PATH for current session
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install Stow
if ! is_installed stow; then
  installing_banner "GNU Stow"
  brew install stow
fi
```

### 2.3 Create macOS Brew Integration ✅
**File**: `install/macos/brew.sh`
```bash
#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if ! is_installed brew; then
  echo "ERROR: Homebrew not installed. Run prereq first."
  exit 1
fi

# Install CLI packages from main Brewfile
installing_banner "Homebrew CLI packages"
if [[ -f "${DOTFILES_DIR}/Brewfile" ]]; then
  cd "${DOTFILES_DIR}" || exit
  brew bundle --file=Brewfile
  cd - || exit
else
  echo "WARNING: No Brewfile found in ${DOTFILES_DIR}"
fi

# Install GUI applications from Brewfile.macos
installing_banner "Homebrew GUI applications"
if [[ -f "${DOTFILES_DIR}/Brewfile.macos" ]]; then
  cd "${DOTFILES_DIR}" || exit
  brew bundle --file=Brewfile.macos
  cd - || exit
else
  echo "WARNING: No Brewfile.macos found in ${DOTFILES_DIR}"
fi

echo "Homebrew package installation complete!" 
```

## Phase 3: Configuration Updates ✅ COMPLETED

### 3.1 Update Stow Configuration ✅
**File**: `configs/stow.sh`
```bash
# Add platform-specific logic where needed
if is_linux; then
  # Linux-specific configurations (i3, polybar, etc.)
  if [ "${DOTFILES_CONFIG_I3^^}" = "TRUE" ]; then
    config_banner "i3 Window Manager"
    mkdir -p "${HOME}/.config/i3"
    do_stow i3
    # ... rest of existing i3 logic
  fi
  
  if [ "${DOTFILES_CONFIG_POLYBAR^^}" = "TRUE" ]; then
    config_banner "Polybar"
    mkdir -p "${HOME}/.config/polybar"
    do_stow polybar
  fi
fi

# Cross-platform configurations work on both macOS and Linux
# ... rest of existing stow logic
```

### 3.2 Update Utility Script ✅
**File**: `bin/dotfiles`
```bash
run_brew() {
  if is_macos; then
    echo "Running brew bundle (macOS)"
    cd "${DOTFILES_DIR}" || exit
    
    # Always run main Brewfile for CLI tools
    if [[ -f "${DOTFILES_DIR}/Brewfile" ]]; then
      echo "Installing CLI packages from main Brewfile"
      brew bundle --file=Brewfile
    fi
    
    # Run macOS-specific Brewfile if it exists
    if [[ -f "${DOTFILES_DIR}/Brewfile.macos" ]]; then
      echo "Installing macOS packages from Brewfile.macos"
      brew bundle --file="${DOTFILES_DIR}/Brewfile.macos"
    fi
    
    cd - || exit
  else
    echo "Running brew bundle (Linux)"
    cd "${DOTFILES_DIR}" || exit
    brew bundle
    cd - || exit
  fi
}
```

## Phase 4: macOS System Configuration ✅ COMPLETED

### 4.1 System Preferences Script ✅
**File**: `setups/macos/macos-defaults.sh`
```bash
#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

banner "Configuring macOS system preferences"

# General UI/UX
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
defaults write NSGlobalDomain AppleReduceDesktopTinting -bool true
defaults write NSGlobalDomain AppleAccentColor -int 1
defaults write NSGlobalDomain AppleHighlightColor -string "0.65098 0.85490 0.58431"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Keyboard settings
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Trackpad settings
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2

# Dock preferences
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock largesize -int 64
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock expose-group-by-app -bool false
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock static-only -bool true
defaults write com.apple.dock mru-spaces -bool false

# Finder preferences
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowTabView -bool true
defaults write com.apple.finder ShowPreviewPane -bool false
defaults write com.apple.finder ShowSidebar -bool true
defaults write com.apple.finder SidebarWidth -int 200
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXInfoPanesExpanded -dict General -bool true OpenWith -bool true Privileges -bool true
defaults write com.apple.finder WarnOnEmptyTrash -bool false
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Screen settings
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# Restart affected applications
for app in "Activity Monitor" "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" &> /dev/null || true
done

echo "System preferences updated. Some changes may require a restart."
```

## Phase 5: Brewfile Consolidation ✅ COMPLETED

### 5.1 Reorganize Package Management ✅
**Current structure**:
```
Brewfile              # Cross-platform CLI tools
Brewfile.macos        # macOS-specific casks and tools
```

### 5.2 Updated Brewfile Structure ✅
**Root Brewfile** - Cross-platform CLI tools:
```ruby
# Cross-platform CLI tools
tap "homebrew/bundle"

# Terminal and shell utilities
brew "bash"
brew "fish"
brew "tmux"
brew "zellij"

# Development tools
brew "git"
brew "neovim"
brew "gh"

# System utilities
brew "htop"
brew "jq"
brew "ripgrep"
brew "bat"
brew "fzf"
brew "fd"
brew "eza"
brew "tree"
brew "wget"
brew "curl"
brew "rsync"
brew "unzip"
brew "zip"
brew "gpg"
brew "stow"
```

**Brewfile.macos** - macOS-specific applications:
```ruby
# macOS-specific applications
tap "homebrew/cask"

# Development
cask "cursor"
cask "ghostty"
cask "docker"

# Productivity
cask "1password"
cask "notion"
cask "slack"
cask "todoist"
cask "obsidian"

# Media
cask "spotify"
cask "vlc"
cask "plex"

# Utilities
cask "raycast"
cask "cleanmymac"
cask "the-unarchiver"
cask "appcleaner"
cask "finder-toolbar"
```

## Phase 6: Documentation & Testing ✅ COMPLETED

### 6.1 Update Documentation ✅
- ✅ Updated `README.md` with macOS installation instructions
- ✅ Created `.dotfilesrc.macos` template for macOS
- ✅ Updated documentation to reflect new Brewfile structure

### 6.2 Create macOS Bootstrap Script ✅
**File**: `bootstrap-macos.sh`
```bash
#!/usr/bin/env bash
# macOS-specific bootstrap script

set -e

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "This script is for macOS only."
  exit 1
fi

# Set default dotfiles directory
DOTFILES_DIR="${HOME}/.local/share/dotfiles"

echo "Setting up dotfiles for macOS..."

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Please complete the Xcode Command Line Tools installation and re-run this script."
  exit 1
fi

# Create the dotfiles directory
mkdir -p "${DOTFILES_DIR}"

# Clone the repository if it doesn't exist
if [[ ! -d "${DOTFILES_DIR}/.git" ]]; then
  echo "Cloning dotfiles repository..."
  git clone -b feature/macos https://github.com/steveclarke/dotfiles.git "${DOTFILES_DIR}"
else
  echo "Repository already exists, pulling latest changes..."
  cd "${DOTFILES_DIR}"
  git pull
fi

# Copy .dotfilesrc if it doesn't exist
if [[ ! -f "${HOME}/.dotfilesrc" ]]; then
  echo "Creating .dotfilesrc configuration..."
  cp "${DOTFILES_DIR}/.dotfilesrc.macos" "${HOME}/.dotfilesrc"
  echo "Please edit ~/.dotfilesrc to configure your preferences."
fi

# Run the installation
echo "Running installation script..."
cd "${DOTFILES_DIR}"
bash install.sh

echo "macOS dotfiles setup complete!"
echo "You may need to restart your terminal or run 'source ~/.zshrc' to apply shell changes."
```

## Implementation Results

### ✅ Completed Features

1. **OS Detection**: Automatic detection of macOS vs Linux with appropriate branching
2. **Package Management**: Dual Brewfile system with cross-platform CLI tools and macOS-specific GUI apps
3. **Configuration Management**: Platform-aware stow configuration that skips Linux-specific configs on macOS
4. **System Preferences**: Comprehensive macOS defaults configuration for optimal developer experience
5. **Installation Flow**: Streamlined macOS installation with proper prerequisite handling
6. **Documentation**: Complete installation guides for both platforms
7. **Utility Scripts**: Updated `bin/dotfiles` with macOS support for ongoing maintenance

### ✅ Testing Results

- **Linux Compatibility**: All existing Linux functionality preserved and tested
- **macOS Fresh Install**: Successfully tested on fresh macOS installations
- **Cross-Platform Configs**: Verified shared configurations work on both platforms
- **Brewfile Structure**: Confirmed clean separation of CLI tools and GUI applications

### 🎯 Architecture Benefits

- **Zero Breaking Changes**: Existing Linux users experience no disruption
- **Clean Separation**: Platform-specific code is clearly isolated
- **Maintainable**: Easy to add new platform-specific features
- **Consistent**: Similar workflow and commands across both platforms
- **Native Integration**: Uses platform-native tools (Homebrew, macOS defaults)

## Usage

### Linux (Unchanged)
```bash
# Bootstrap
/bin/bash -c "$(wget -qO- https://raw.githubusercontent.com/steveclarke/dotfiles/feature/macos/bootstrap.sh)"

# Install
cd ~/.local/share/dotfiles
bash install.sh
```

### macOS (New)
```bash
# Bootstrap  
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/steveclarke/dotfiles/feature/macos/bootstrap-macos.sh)"

# Install
cd ~/.local/share/dotfiles
bash install.sh
```

### Ongoing Maintenance (Both Platforms)
```bash
dotfiles update  # Updates configs and packages
dotfiles stow    # Just update configurations
dotfiles brew    # Just update packages
```

---

**Status**: ✅ **IMPLEMENTATION COMPLETE**

The macOS integration has been successfully implemented with full backward compatibility for Linux users and comprehensive macOS support including system preferences, package management, and configuration management.
