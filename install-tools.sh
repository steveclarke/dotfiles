#!/usr/bin/env bash

# [[ i3 Window Manager Requirements ]]
if [ "${DOTFILES_CONFIG_I3^^}" = "TRUE" ]; then
	echo "=== checking i3 Requirements"

	if ! is_installed polybar; then
		banner "polybar"
		apt_install polybar
	else
		skipping "polybar"
	fi
	if ! is_installed rofi; then
		banner "rofi"
		apt_install rofi
	else
		skipping "rofi"
	fi
	if ! is_installed picom; then
		banner "picom"
		apt_install picom
	else
		skipping "picom"
	fi
	if ! is_installed redshift; then
		banner "redshift"
		apt_install redshift
	else
		skipping "redshift"
	fi
	if ! is_installed xautolock; then
		banner "xautolock"
		apt_install xautolock
	else
		skipping "xautolock"
	fi
	if ! is_installed numlockx; then
		banner "numlockx"
		apt_install numlockx
	else
		skipping "numlockx"
	fi
	if ! is_installed playerctl; then
		banner "playerctl"
		apt_install playerctl
	else
		skipping "playerctl"
	fi
	if ! is_installed yad; then
		banner "yad"
		apt_install yad
	else
		skipping "yad"
	fi
fi
