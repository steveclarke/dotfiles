# macOS Integration Implementation Plan

This document outlines the strategy for extending the dotfiles system to support macOS while maintaining existing Linux functionality.

## Strategy Overview

**Approach**: Dual-mode architecture with OS detection and platform-specific branching.

**Goals**:
- Maintain existing Linux functionality without breaking changes
- Leverage existing `Brewfile.macos` for macOS package management
- Minimize code duplication between platforms
- Provide seamless experience for both Linux and macOS users

## Phase 1: Foundation & OS Detection

### 1.1 Add OS Detection Logic
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
```

### 1.2 Create macOS Directory Structure
```
install/
├── macos/
│   ├── prereq.sh          # Homebrew, Command Line Tools
│   ├── brew.sh            # CLI tools via brew bundle
│   └── cask.sh            # GUI apps via brew bundle --cask
└── [existing linux dirs]

setups/
├── macos/
│   ├── macos-defaults.sh  # System preferences
│   ├── dock.sh            # Dock configuration  
│   └── finder.sh          # Finder preferences
└── [existing cross-platform setups]
```

## Phase 2: Installation Script Integration

### 2.1 Update Main Install Script
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

### 2.2 Create macOS Prerequisites Script
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

### 2.3 Create macOS Brew Integration
**File**: `install/macos/brew.sh`
```bash
#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

installing_banner "Homebrew CLI packages"
if is_installed brew; then
  cd "${DOTFILES_DIR}" || exit
  brew bundle --file=Brewfile
  cd - || exit
else
  echo "ERROR: Homebrew not installed. Run prereq first."
  exit 1
fi

installing_banner "Homebrew GUI applications"
if is_installed brew; then
  cd "${DOTFILES_DIR}/mac" || exit
  brew bundle --file=Brewfile
  cd - || exit
else
  echo "ERROR: Homebrew not installed. Run prereq first."
  exit 1
fi
```

## Phase 3: Configuration Updates

### 3.1 Update Stow Configuration
**File**: `configs/stow.sh`
```bash
# Add platform-specific logic where needed
if is_macos; then
  # macOS-specific configurations
  config_banner "macOS-specific configs"
  # Add any macOS-only stow operations here
else
  # Linux-specific configurations (i3, polybar, etc.)
  if [ "${DOTFILES_CONFIG_I3^^}" = "TRUE" ]; then
    config_banner "i3 Window Manager"
    mkdir -p "${HOME}/.config/i3"
    do_stow i3
    # ... rest of existing i3 logic
  fi
fi
```

### 3.2 Update Utility Script
**File**: `bin/dotfiles`
```bash
run_brew() {
  echo "Running brew bundle"
  cd "${DOTFILES_DIR}" || exit
  
  # Always run main Brewfile
  brew bundle
  
  # Run macOS-specific Brewfile if on macOS
if is_macos && [[ -f "${DOTFILES_DIR}/Brewfile.macos" ]]; then
    cd "${DOTFILES_DIR}/macos" || exit
    brew bundle
  fi
  
  cd - || exit
}
```

## Phase 4: macOS System Configuration

### 4.1 System Preferences Script
**File**: `setups/macos/macos-defaults.sh`
```bash
#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

banner "Configuring macOS system preferences"

# Dock preferences
defaults write com.apple.dock "autohide" -bool true
defaults write com.apple.dock "tilesize" -int 48
defaults write com.apple.dock "show-recents" -bool false

# Finder preferences
defaults write com.apple.finder "AppleShowAllFiles" -bool true
defaults write com.apple.finder "ShowPathbar" -bool true
defaults write com.apple.finder "ShowStatusBar" -bool true

# Keyboard preferences
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15

# Trackpad preferences
defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool true

# Restart affected applications
killall Dock
killall Finder

echo "System preferences updated. Some changes may require a restart."
```

## Phase 5: Brewfile Consolidation

### 5.1 Reorganize Package Management
```
# Current structure:
Brewfile              # CLI tools for Linux compatibility
Brewfile.macos        # macOS-specific packages

# Proposed structure:
Brewfile              # Cross-platform CLI tools
Brewfile.macos        # macOS-specific casks and tools
```

### 5.2 Update Root Brewfile
Move common CLI tools to root `Brewfile` for cross-platform compatibility:
```ruby
# Cross-platform CLI tools
brew "bat"
brew "fzf"
brew "git"
brew "jq"
brew "neovim"
brew "ripgrep"
brew "tmux"
# ... other CLI tools
```

Keep macOS-specific applications in `Brewfile.macos`:
```ruby
# macOS-specific applications
cask "1password"
cask "cursor"
cask "docker"
cask "ghostty"
# ... other GUI applications
```

## Phase 6: Documentation & Testing

### 6.1 Update Documentation
- Update `README.md` with macOS installation instructions
- Create `.dotfilesrc` template for macOS
- Document platform-specific features and limitations

### 6.2 Create macOS Bootstrap Script
**File**: `bootstrap-macos.sh`
```bash
#!/usr/bin/env bash
# macOS-specific bootstrap script
# Similar to existing bootstrap.sh but adapted for macOS

# Install basic prerequisites
if ! command -v git &> /dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  exit 1
fi

# Clone repository
if [[ ! -d "${DOTFILES_DIR:-$HOME/.local/share/dotfiles}" ]]; then
  git clone https://github.com/steveclarke/dotfiles.git "${DOTFILES_DIR:-$HOME/.local/share/dotfiles}"
fi

# Continue with installation
cd "${DOTFILES_DIR:-$HOME/.local/share/dotfiles}"
bash install.sh
```

## Implementation Timeline

1. **Week 1**: Phase 1 - Foundation & OS Detection
2. **Week 2**: Phase 2 - Installation Script Integration  
3. **Week 3**: Phase 3 - Configuration Updates
4. **Week 4**: Phase 4 - macOS System Configuration
5. **Week 5**: Phase 5 - Brewfile Consolidation
6. **Week 6**: Phase 6 - Documentation & Testing

## Testing Strategy

1. **Linux Testing**: Verify no regressions in existing Linux functionality
2. **macOS Testing**: Test fresh macOS installation from scratch
3. **Cross-Platform Testing**: Verify shared configurations work on both platforms
4. **Edge Cases**: Test with existing installations, partial setups, etc.

## Rollback Plan

- Keep existing Linux functionality in separate code paths
- Use feature flags for macOS-specific functionality
- Maintain backward compatibility with existing `.dotfilesrc` configurations
- Document manual rollback procedures for each phase
