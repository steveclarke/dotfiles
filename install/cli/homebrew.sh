source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if ! is_installed brew; then
	banner "Homebrew"

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
		cd "${DOTFILES_DIR}" &&
		(
			echo
			echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
		) >>"${HOME}"/.bashrc &&
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" &&
		brew bundle
else
	echo "Running brew bundle"
	cd "${DOTFILES_DIR}" && brew bundle
  cd - || exit
fi
