source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if ! is_installed fish; then
	installing_banner "fish"

	sudo apt-add-repository -y ppa:fish-shell/release-3
	apt_install fish
else
	skipping "fish"
fi
