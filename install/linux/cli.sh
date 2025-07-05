source "${HOME}"/.dotfilesrc

for installer in "${DOTFILES_DIR}"/install/linux/cli/*.sh; do source $installer; done
