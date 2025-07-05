source "${HOME}"/.dotfilesrc

for installer in "${DOTFILES_DIR}"/install/linux/prereq/*.sh; do source $installer; done
