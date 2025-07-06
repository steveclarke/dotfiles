source "${HOME}"/.dotfilesrc
source "${DOTFILES_DIR}"/lib/linux.sh

# i3 Window Manager Requirements

# Note: the ^^ converts the variable to uppercase
if [ "${DOTFILES_CONFIG_I3^^}" = "TRUE" ]; then
	banner "=== Installing i3 Requirements"
	# Install i3 window manager and related tools
	apt_install polybar rofi picom redshift xautolock numlockx playerctl yad
fi
