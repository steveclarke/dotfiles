source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if ! test -d ~/.asdf; then
	installing_banner "asdf"

	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
else
	skipping "asdf"
fi
