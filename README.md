# Steve Clarke's Dotfiles

This is a collection of my config files to help me get each of my computers
quickly bootstrapped. It's a work in progress and is specifically tweaked with
lots of assumptions about where I like to place things.

## Pre-requisites

* Operating system is Debian-derived (e.g. Ubuntu, Pop!_OS)
* Repository lives at `~/.local/share/dotfiles` (unless otherwise specified in
  `.dotfilesrc`)

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

### Bootstrapping the Dotfiles Directory

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

### Main Setup Script

Run the `install.sh` script. This will also be used to update the dotfiles regularly.

```bash
cd ~/.local/share/dotfiles
bash install.sh
```

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
any of the install scripts.
