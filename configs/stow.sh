source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

config_banner() {
  banner "Configuring $1"
}

do_stow() {
	stow -d "${DOTFILES_DIR}"/configs -t "${HOME}" "$1"
}

config_banner "Configuring ~/bin"
mkdir -p "${HOME}/bin"
do_stow bin

banner "Configuring Bash"
rm "${HOME}"/.bash_aliases
do_stow bash

banner "Configuring Tmux"
mkdir -p "${HOME}/.config/tmux"
do_stow tmux

banner "Configuring Alacritty"
mkdir -p "${HOME}/.config/alacritty"
do_stow alacritty

banner "Configuring Fish shell"
mkdir -p "${HOME}/.config/fish"
do_stow fish

banner "Configuring Ruby"
do_stow ruby

banner "Configuring Neovim"
mkdir -p "${HOME}/.config/nvim"
do_stow nvim

banner "Configuring Zellij"
mkdir -p "${HOME}/.config/zellij"
do_stow zellij

banner "Configuring Fonts"
mkdir -p "${HOME}/.local/share/fonts"
do_stow fonts

banner "Configuring Idea"
rm "${HOME}"/.ideavimrc
do_stow idea

banner "Configuring Just"
rm "${HOME}"/justfile
do_stow just

if [ "${DOTFILES_CONFIG_I3^^}" = "TRUE" ]; then
	banner "Configuring i3 Window Manager"
	mkdir -p "${HOME}/.config/i3"
	do_stow i3

	banner "Configuring Picom (compositor)"
	mkdir -p "${HOME}/.config/picom"
	do_stow picom

	banner "Configuring Polybar"
	mkdir -p "${HOME}/.config/polybar"
	do_stow polybar

	banner "Configuring Rofi"
	mkdir -p "${HOME}/.config/rofi"
	do_stow rofi
fi
