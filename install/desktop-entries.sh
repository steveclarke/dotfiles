source "${HOME}"/.dotfilesrc

for installer in "${DOTFILES_DIR}"/install/desktop-entries/*.sh; do source $installer; done
