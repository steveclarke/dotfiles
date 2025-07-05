source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/dotfiles.sh

# i3 Window Manager Requirements

# Note: the ^^ converts the variable to uppercase
if [ "${DOTFILES_CONFIG_I3^^}" = "TRUE" ]; then
	banner "=== Installing i3 Requirements"
  sudo apt install -y polybar rofi picom redshift xautolock numlockx playerctl yad
fi
