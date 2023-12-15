# Steve Clarke's Dotfiles

This is a collection of my config files to help me get each of my
computers quickly bootstrapped. It's a work in progress and is
specifically tweaked with lots of assumptions about where I like
to place things.

## Pre-requisites

* Operating system is Debian-derived (e.g. Ubuntu, Pop!_OS)
* Repository lives at `~/dotfiles`

## Applications

* [Stow](http://www.gnu.org/software/stow/) - dotfile management
* [eza](https://github.com/eza-community/eza) -ls replacement
* [Neovim](https://neovim.io)
* [Fish Shell](https://fishshell.com/)
* [Zellij](https://github.com/zellij-org/zellij) - terminal multiplexer
* [Bat](https://github.com/sharkdp/bat) - cat, improved
* [Lazygit](https://github.com/jesseduffield/lazygit)
* [Lazydocker](https://github.com/jesseduffield/lazydocker)

## Installation

### Bootstrapping the Dotfiles Directory

First download and copy the `.dotfilesrc` to $HOME. This will contain settings
and (possibly) secrets for the target machine.

```bash
curl -fsSL https://raw.githubusercontent.com/steveclarke/dotfiles/master/.dotfilesrc -o ~/.dotfilesrc
```

After downloading you'll want to adjust the settings accordingly for the machine.

Next, run the bootstrap script.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/steveclarke/dotfiles/master/bootstrap)"
```

### Main Setup Script

Run the `setup` script. This will also be used to update the dotfiles regularly.

```bash
cd ~/dotfiles
./setup
```

## Updating

```bash
cd ~/dotfies
git pull
./setup
```
