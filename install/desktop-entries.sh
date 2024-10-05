source ~/.dotfilesrc

for installer in "${DOTFILES_INSTALL_DIR}"/install/desktop-entries/*.sh; do source $installer; done
