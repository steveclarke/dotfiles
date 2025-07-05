source "${HOME}"/.dotfilesrc

for installer in "${DOTFILES_DIR}"/install/linux/desktop-entries/*.sh; do source $installer; done
