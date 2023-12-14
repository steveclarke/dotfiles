# Steve Clarke's Dotfiles

This is a collection of my config files to help me get each of my
computers quickly bootstrapped. It's a work in progress and is
specifically tweaked with lots of assumptions about where I like
to place things.

## Pre-requisites

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

```bash
git clone git@github.com:steveclarke/dotfiles ~/dotfiles
cd ~/dotfiles
./setup
```

## Updating

```bash
cd ~/dotfies
git pull
./setup
```
