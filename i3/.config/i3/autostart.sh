#!/usr/bin/env bash

# Start compositor
picom -b

# Launch polybar
$HOME/.config/polybar/launch.sh &

# Set wallpaper
nitrogen --restore &

# Remap caps lock to ctrl
setxkbmap -option ctrl:nocaps
