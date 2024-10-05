# A collection of functions used in the dotfiles installation scripts

is_installed() {
	command -v "$1" >/dev/null 2>&1
}

banner() {
	echo "=== $1"
}

installing_banner() {
  banner "Installing $1"
}

skipping() {
	echo "=== skipping $1 - already installed"
}

apt_install() {
	sudo apt install -y "$1"
}
