# Dotfiles System Overview

This dotfiles repository provides a comprehensive system for setting up and maintaining development environments across multiple machines. It's designed with modularity, safety, and maintainability in mind.

## Architecture

### Core Design Principles
- **Modular Installation**: Components are broken down into logical categories (prerequisites, CLI tools, GUI apps, configurations)
- **Safety First**: Installation scripts include warnings and confirmations before making system changes
- **Cross-Platform Ready**: Designed to support both Linux and macOS environments
- **Declarative Configuration**: Uses GNU Stow for symlink management and Homebrew bundles for package management

### Key Components

#### 1. Entry Points
- **`bootstrap.sh`** - Initial system setup for fresh installations
  - Installs basic prerequisites (git, curl, build tools)
  - Sets up SSH configuration
  - Clones the dotfiles repository
- **`install.sh`** - Main installation orchestrator
  - Runs prerequisite installations
  - Applies configuration files via Stow
  - Installs CLI tools and GUI applications
  - Executes system setup scripts

#### 2. Configuration Management
- **`configs/`** - Application-specific configuration files organized for GNU Stow
  - Each subdirectory represents a "package" that can be stowed independently
  - Supports: fish, tmux, nvim, alacritty, ghostty, fonts, and more
- **`configs/stow.sh`** - Orchestrates the symlinking of all configurations
  - Creates necessary directories
  - Handles existing file conflicts
  - Supports conditional stowing (e.g., i3 window manager configs)

#### 3. Installation Categories
- **`install/prereq/`** - System prerequisites
  - Package managers (flatpak, stow)
  - Core libraries and tools
- **`install/cli/`** - Command-line tools
  - Shell utilities (fish, htop, vim)
  - Development tools
- **`install/apps/`** - GUI applications
  - Productivity software
  - Development IDEs
  - Media applications
- **`install/optional/`** - Optional software for manual installation
  - Specialized tools
  - Platform-specific applications

#### 4. System Setup Scripts
- **`setups/`** - Post-installation system configuration
  - Git configuration
  - GNOME desktop settings
  - Hardware-specific configurations (keyboards, etc.)

#### 5. Utility Tools
- **`bin/dotfiles`** - Maintenance utility
  - Updates Stow configurations
  - Runs Homebrew bundle updates
  - Provides unified interface for common tasks
- **`lib/dotfiles.sh`** - Shared utility functions
  - Installation checks
  - Logging and banner functions
  - Package installation helpers

## Environment Configuration

The system relies on a `.dotfilesrc` file in the user's home directory that contains:
- Installation preferences (GUI apps, i3 window manager, etc.)
- User-specific settings (Git username/email)
- System-specific configurations
- Directory paths and SSH key settings

## Installation Flow

1. **Bootstrap Phase**: Set up basic system requirements and clone repository
2. **Prerequisites**: Install package managers and core tools
3. **Configuration**: Deploy dotfiles via Stow symlinks
4. **CLI Tools**: Install command-line utilities
5. **GUI Applications**: Install desktop applications (if enabled)
6. **System Setup**: Configure system preferences and settings

## Current Platform Support

- **Linux**: Full support for Ubuntu/Debian-based systems
  - Uses `apt` for system packages
  - Uses `flatpak` for GUI applications
  - Supports i3 window manager setup
- **macOS**: Partial support with existing Brewfile
  - CLI tools via Homebrew
  - GUI applications via Homebrew Cask
  - Needs integration with main installation system

## Maintenance

The system includes tools for ongoing maintenance:
- `dotfiles stow` - Re-apply configuration symlinks
- `dotfiles brew` - Update Homebrew packages
- `dotfiles update` - Run both stow and brew updates
- Manual execution of new install scripts as needed
