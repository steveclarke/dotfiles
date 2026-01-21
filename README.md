# Dotfiles

My personal setup scripts for Mac and Linux machines. Clone the repo, run one command, and you're done.

> [!CAUTION]
> This is my personal config. It makes lots of assumptions about how I like things set up. Feel free to browse and borrow ideas, but don't expect it to work for you out of the box.

## What This Does

- Installs your preferred CLI tools and apps
- Sets up shell configs (Fish, Zsh, Bash)
- Manages dotfiles with GNU Stow
- Configures system settings
- Sets up SSH keys

## Supported Systems

| Platform | Version |
|----------|---------|
| macOS | 10.15 (Catalina) or later |
| Linux | Debian-based (Ubuntu, Pop!_OS, etc.) |

## Quick Start

### 1. Install Prerequisites

**macOS:**
```bash
xcode-select --install
```

**Linux:**
```bash
sudo apt update && sudo apt install -y git curl
```

### 2. Download the Config File

**macOS:**
```bash
curl -o ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc.template
```

**Linux:**
```bash
wget -qO ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc.template
```

Edit `~/.dotfilesrc` to match your preferences.

### 3. Clone and Install

```bash
git clone https://github.com/steveclarke/dotfiles.git ~/.local/share/dotfiles
cd ~/.local/share/dotfiles
bash install.sh
```

> [!NOTE]
> The script detects your OS. It uses Homebrew on macOS and apt on Linux.

## What Gets Installed

**macOS:**
1. Homebrew (if missing)
2. GNU Stow
3. CLI tools from Brewfile
4. GUI apps (if enabled)
5. SSH keys (if set up)
6. System settings
7. Shell configs

**Linux:**
1. Build tools
2. GNU Stow
3. CLI tools
4. GUI apps (if enabled)
5. SSH keys (if set up)
6. Shell configs

## Directory Structure

| Folder | What It Contains |
|--------|------------------|
| `ai/` | AI prompts, skills, and agents. See [AI README](ai/README.md). |
| `configs/` | Stow packages for app configs. Fonts live here too. |
| `docs/` | Guides and reference docs. |
| `fixes/` | Scripts to fix issues. Run by hand when needed. |
| `install/` | Install scripts by category (see below). |
| `setups/` | Config scripts for things Stow can't handle. |

### Install Scripts

| Folder | Purpose |
|--------|---------|
| `install/prereq/` | Tools needed by other scripts |
| `install/cli/` | Command line tools |
| `install/apps/` | GUI apps |
| `install/desktop-entries/` | `.desktop` files (web app wrappers) |
| `install/optional/` | Extra software. Run by hand. |

## Updating

Pull the latest changes:

```bash
git pull
```

Update configs and packages:

```bash
dotfiles stow    # Update symlinks
dotfiles brew    # Update Homebrew packages
dotfiles update  # Run both
```

### Installing New Scripts

New install scripts don't run on their own. Run them by hand:

```bash
bash install/cli/some-tool.sh
bash install/optional/steam.sh
```

## Configuration

### The .dotfilesrc File

The `~/.dotfilesrc` file holds your settings and secrets. Fish and Zsh load it on startup.

> [!IMPORTANT]
> This file is NOT tracked in git. It's safe for secrets and machine-specific settings.

Add secrets like this:

```bash
# API keys
export MY_API_KEY="your-secret-key"
export GITHUB_TOKEN="ghp_..."

# Database credentials
export DATABASE_URL="postgresql://user:pass@host/db"
```

## Documentation

| Guide | Description |
|-------|-------------|
| [ZSH Shell Guide](docs/zsh-shell-guide.md) | Shell startup files, shell types, OS differences |
| [AI Resources](ai/README.md) | Prompts, skills, and agents for AI coding tools |

## Requirements

- Repo goes in `~/.local/share/dotfiles` (or set a custom path in `.dotfilesrc`)
- **macOS**: Xcode Command Line Tools
- **Linux**: Debian-based distro (apt package manager)
