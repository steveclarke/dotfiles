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

* `ai` - AI/LLM resources including development guides and prompts.
  See the [AI Resources README](ai/README.md) for details.
* `configs` - contains the stow folders for applicable apps.
  Note: Fonts are in this folder.
* `docs` - documentation and reference guides for various topics.
* `fixes` - contains scripts to fix issues with the system. These are not run by
  default. Run them individually if you need a specific fix.
* `install` - contains scripts to install software. This is broken down further
  by category:
   * `prereq` - scripts to install prerequisites for other scripts
   * `cli` - command line tools
   * `apps` - GUI applications
   * `desktop-entries` - `.desktop` files for applications. Mainly acts as a
     wrapper for web apps.
   * `optional` - scripts to install optional software. These must be run manually.
* `setups` - scripts to configure things that can't be configured via stow.

## Documentation

For detailed guides and reference materials, see the `docs/` directory:

- **[ZSH Shell Configuration Guide](docs/zsh-shell-guide.md)** - Complete reference for understanding when `.zprofile` and `.zshrc` are loaded, interactive vs login shells, and platform differences
- **[Restructuring Plan](docs/restructure-spec.md)** - Detailed plan for reorganizing the repository structure
- **[Restructuring Todo](docs/restructure-todo.md)** - Implementation checklist for the restructuring plan

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
wget -qO ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc.template
```

After downloading, adjust the settings for your machine.

#### Clone and Install

Clone the repository and run the installation:

```bash
git clone https://github.com/steveclarke/dotfiles.git ~/.local/share/dotfiles
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
curl -o ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc.template
```

After downloading, adjust the settings for your machine.

#### Clone and Install

Clone the repository and run the installation:

```bash
git clone https://github.com/steveclarke/dotfiles.git ~/.local/share/dotfiles
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
`install/optional` directory,

e.g. `bash install/optional/steam.sh` to install Emacs.

## Configuration and Secrets

### Shared Environment Variables

The `.dotfilesrc` file in your home directory serves as a centralized location for environment variables and secrets that are shared across all shells (Fish, Zsh, Bash).

**Location**: `~/.dotfilesrc`

Both Fish and Zsh automatically source this file on startup, making any exported variables available in your shell environment.

#### Adding Secrets

Add environment variables using standard bash export syntax:

```bash
# API keys and tokens
export MY_API_KEY="your-secret-key"
export GITHUB_TOKEN="ghp_..."

# Database credentials
export DATABASE_URL="postgresql://user:pass@host/db"

# Custom environment variables
export MY_CUSTOM_VAR="value"
```

**Security Note**: The `.dotfilesrc` file lives in your home directory and is NOT tracked in git, making it safe for storing secrets and machine-specific configuration.
