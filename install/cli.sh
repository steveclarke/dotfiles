
source ~/.dotfilesrc

for installer in "${DOTFILES_INSTALL_DIR}"/install/cli/*.sh; do source $installer; done
