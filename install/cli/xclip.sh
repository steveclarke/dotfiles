
source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if ! is_installed xclip; then
	installing_banner "xclip"
	apt_install xclip
else
	skipping "xclip"
fi
