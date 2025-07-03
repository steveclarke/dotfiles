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

* `configs` - contains the stow folders for applicable apps.
  Note: Fonts are in this folder.
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


## Installation

### Linux Installation

#### Bootstrapping the Dotfiles Directory

First download and copy the `.dotfilesrc` to $HOME. This will contain settings
and (possibly) secrets for the target machine.

```bash
wget -qO ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc
```

After downloading you'll want to adjust the settings accordingly for the machine.

Next, run the bootstrap script.

```bash
/bin/bash -c "$(wget -qO- https://raw.githubusercontent.com/steveclarke/dotfiles/master/bootstrap.sh)"
```

#### Main Setup Script

Run the `install.sh` script. This will also be used to update the dotfiles regularly.

```bash
cd ~/.local/share/dotfiles
bash install.sh
```

### macOS Installation

#### Prerequisites

First, install Xcode Command Line Tools if not already installed:

```bash
xcode-select --install
```

#### Bootstrapping the Dotfiles Directory

Download and copy the `.dotfilesrc` to $HOME:

```bash
curl -o ~/.dotfilesrc https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc
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
4. Install GUI applications from the mac/Brewfile
5. Configure system preferences via macOS defaults
6. Set up shell configurations and dotfiles

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
