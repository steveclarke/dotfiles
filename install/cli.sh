
source ~/.dotfilesrc

for installer in "${DOTFILES_DIR}"/install/cli/*.sh; do source $installer; done
