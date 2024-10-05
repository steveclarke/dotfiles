# This is the temporary holding place for the new core install experience.

source ~/.dotfilesrc

bash "$DOTFILES_INSTALL_DIR"/prereq.sh
bash "$DOTFILES_INSTALL_DIR"/cli.sh
bash "$DOTFILES_INSTALL_DIR"/apps.sh
bash "$DOTFILES_INSTALL_DIR"/desktop-entries.sh
