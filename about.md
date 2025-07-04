# About This Repository

This is a personal dotfiles repository that helps me bootstrap my computers quickly and consistently.

## Key Components

- **`install.sh`** - Main installation script that handles both Linux and macOS
- **`configs/`** - Configuration files managed by GNU Stow
- **`install/`** - Installation scripts organized by category (prereq, cli, apps, etc.)
- **`setups/`** - Configuration scripts for services and applications
- **`lib/dotfiles.sh`** - Shared library functions
- **`.dotfilesrc.template`** - Configuration template for user-specific settings

## Installation Process

Both Linux and macOS follow the same unified process:

1. **Download configuration template**: Download `.dotfilesrc` template and customize settings
2. **Clone repository**: Clone the dotfiles repository to `~/.local/share/dotfiles`
3. **Run installation**: Execute `install.sh` which handles prerequisites, installation, and configuration

## Platform Support

- **Linux**: Debian-derived distributions (Ubuntu, Pop!_OS, etc.)
- **macOS**: macOS 10.15 (Catalina) or later


