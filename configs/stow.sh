source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

config_banner() {
  banner "Configuring $1"
}

do_stow() {
	stow -d "${DOTFILES_DIR}"/configs -t "${HOME}" "$1"
}

config_banner "${HOME}/bin"
mkdir -p "${HOME}/bin"
do_stow bin

config_banner "Bash"
rm "${HOME}"/.bash_aliases
do_stow bash

config_banner "Tmux"
mkdir -p "${HOME}/.config/tmux"
do_stow tmux

config_banner "Alacritty"
mkdir -p "${HOME}/.config/alacritty"
do_stow alacritty

config_banner "Fish shell"
mkdir -p "${HOME}/.config/fish"
do_stow fish

config_banner "Ruby"
do_stow ruby

config_banner "Neovim"
mkdir -p "${HOME}/.config/nvim"
do_stow nvim

config_banner "Zellij"
mkdir -p "${HOME}/.config/zellij"
do_stow zellij

config_banner "Fonts"
mkdir -p "${HOME}/.local/share/fonts"
do_stow fonts

config_banner "Idea"
if [ -f "${HOME}"/.ideavimrc ]; then
  rm "${HOME}"/.ideavimrc
fi
do_stow idea

config_banner "Just"
if [ -f "${HOME}"/justfile ]; then
  rm "${HOME}"/justfile
fi
do_stow just

if [ "${DOTFILES_CONFIG_I3^^}" = "TRUE" ]; then
	config_banner "i3 Window Manager"
	mkdir -p "${HOME}/.config/i3"
	do_stow i3

	config_banner "Picom (compositor)"
	mkdir -p "${HOME}/.config/picom"
	do_stow picom

	config_banner "Polybar"
	mkdir -p "${HOME}/.config/polybar"
	do_stow polybar

	config_banner "Rofi"
	mkdir -p "${HOME}/.config/rofi"
	do_stow rofi
fi