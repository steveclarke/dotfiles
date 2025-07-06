# Steve Clarke's Dotfiles

This is a collection of my config files to help me get each of my computers
quickly bootstrapped. It's a work in progress and is specifically tweaked with
lots of assumptions about where I like to place things.

## Supported Platforms

* **Linux**: Debian-derived distributions (e.g. Ubuntu, Pop!_OS)
* **macOS**: macOS 10.15 (Catalina) or later

## Pre-requisites

* Repository lives at `~/.local/share/dotfiles` (unless otherwise specified in
  `.dotfilesrc`)
* **Linux**: Debian-derived operating system
* **macOS**: macOS 10.15 or later with Xcode Command Line Tools

## General Organisation

This repository has been restructured for better organization and cross-platform support:

* `configs/` - contains the stow folders for applicable apps and platform-specific configurations
  * Cross-platform configurations (bash, tmux, nvim, etc.)
  * `linux/` - Linux-specific configurations (i3, polybar, rofi, etc.)
  * `macos/` - macOS-specific configurations (future)
* `docs/` - centralized documentation and project information
  * `CHANGELOG.md` - detailed change tracking
  * `TODO.md` - project todo items
* `fixes/` - platform-specific scripts to fix system issues
  * `linux/` - Linux-specific fixes
  * `macos/` - macOS-specific fixes (future)
* `install/` - platform-organized installation scripts
  * `linux/` - Linux installation scripts
    * `prereq/` - prerequisite software installation
    * `cli/` - command line tools
    * `apps/` - GUI applications
    * `desktop-entries/` - `.desktop` files for applications
    * `optional/` - optional software (manual installation)
  * `macos/` - macOS installation scripts
    * `prereq.sh` - prerequisite software installation
    * `brew.sh` - Homebrew package installation
    * `fish.sh` - Fish shell configuration
* `lib/` - modular library functions
  * `dotfiles.sh` - core cross-platform functions
  * `linux.sh` - Linux-specific functions
  * `macos.sh` - macOS-specific functions
  * `bootstrap.sh` - bootstrap-specific functions
* `setups/` - platform-specific configuration scripts
  * Cross-platform setup scripts
  * `linux/` - Linux-specific setup scripts
  * `macos/` - macOS-specific setup scripts


## Installation

### Linux Installation

#### Prerequisites

Ensure you have `git` and `curl` installed:

```bash
sudo apt update && sudo apt install -y git curl
```

#### Setup

Download and copy the `.dotfilesrc` to $HOME:

```bash
wget -qO ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/feature/restructure/.dotfilesrc.template
```

After downloading, adjust the settings for your machine.

#### Clone and Install

Clone the repository and run the installation:

```bash
git clone -b feature/restructure https://github.com/steveclarke/dotfiles.git ~/.local/share/dotfiles
cd ~/.local/share/dotfiles
bash install.sh
```

The installation script will:
1. Install system prerequisites and build tools
2. Install GNU Stow for configuration management
3. Install CLI tools via package managers
4. Install GUI applications (if DOTFILES_INSTALL_GUI=true)
5. Configure SSH keys and settings (if configured)
6. Set up shell configurations and dotfiles

### macOS Installation

#### Prerequisites

First, install Xcode Command Line Tools if not already installed:

```bash
xcode-select --install
```

#### Setup

Download and copy the `.dotfilesrc` to $HOME:

```bash
curl -o ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/feature/restructure/.dotfilesrc.template
```

After downloading, adjust the settings for your machine.

#### Clone and Install

Clone the repository and run the installation:

```bash
git clone -b feature/restructure https://github.com/steveclarke/dotfiles.git ~/.local/share/dotfiles
cd ~/.local/share/dotfiles
bash install.sh
```

The installation script will:
1. Install Homebrew if not already installed
2. Install GNU Stow for configuration management
3. Install CLI tools from the main Brewfile
4. Install GUI applications from the Brewfile.macos (if DOTFILES_INSTALL_GUI=true)
5. Configure SSH keys and settings (if configured)
6. Configure system preferences via macOS defaults
7. Set up shell configurations and dotfiles

## Updating

Use `git` to update the dotfiles from the repository.

```bash
git pull
```

To update the stowed dotfiles and Homebrew packages you can use the `dotfiles`
script in the `bin` directory (added to path automatically).


```bash
dotfiles stow # re-runs stow on the `configs` directory, updating symlinks
dotfiles brew # Runs `brew bundle` to install and update Homebrew packages
dotfiles update # runs both stow and brew

```
New items added to the `install` directory should be manually run after initial
installation. In general you should run `bash install/**/[name].sh` to run
any of the install scripts. You can also install optional software found in the
`install/linux/optional` directory,

e.g. `bash install/linux/optional/steam.sh` to install Steam.

## Recent Restructuring

This repository has undergone significant restructuring to improve organization and cross-platform support:

### What Changed

- **Platform Separation**: Clear separation between Linux, macOS, and cross-platform code
- **Modular Libraries**: Split large monolithic `lib/dotfiles.sh` into focused modules
- **Organized Documentation**: Centralized documentation in `docs/` directory
- **Improved Structure**: Platform-specific directories for installs, configs, and fixes

### Migration Notes

If you're updating from an older version:

1. **Library Functions**: Platform-specific functions have been moved to separate library files
2. **Directory Structure**: Install scripts are now organized by platform
3. **Documentation**: Check `docs/CHANGELOG.md` for detailed change information

For complete migration details, see `docs/CHANGELOG.md`.

## Contributing

When contributing to this repository:

1. Follow the platform-specific organization structure
2. Update appropriate library files (`lib/`) for shared functions
3. Add documentation for significant changes
4. Test on both Linux and macOS when applicable

## Documentation

- **`docs/CHANGELOG.md`** - Detailed change history and migration information
- **`docs/TODO.md`** - Project todo items and future improvements
- **`README.md`** - This file, general usage and installation guide
