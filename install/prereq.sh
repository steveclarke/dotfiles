source "${HOME}"/.dotfilesrc

for installer in "${DOTFILES_DIR}"/install/prereq/*.sh; do source $installer; done
