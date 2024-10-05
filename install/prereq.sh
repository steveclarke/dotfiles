source ~/.dotfilesrc

for installer in "${DOTFILES_INSTALL_DIR}"/install/prereq/*.sh; do source $installer; done
