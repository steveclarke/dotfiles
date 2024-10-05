# This is the temporary holding place for the new core install experience.

source ~/.dotfilesrc

bash "$DOTFILES_INSTALL_DIR"/install/prereq.sh
bash "$DOTFILES_INSTALL_DIR"/install/cli.sh
bash "$DOTFILES_INSTALL_DIR"/install/apps.sh
bash "$DOTFILES_INSTALL_DIR"/install/desktop-entries.sh
