# Linux-specific functions for dotfiles installation

# Source core functions
source "${DOTFILES_DIR}/lib/dotfiles.sh"
source "${DOTFILES_DIR}/lib/bootstrap.sh"

apt_install() {
	sudo apt install -y "$1"
}

install_linux_prerequisites() {
	bootstrap_banner "Installing bootstrap pre-requisites"
	sudo apt update &&
		sudo apt install -y \
			git \
			curl \
			software-properties-common \
			build-essential
} 
