#!/usr/bin/env bash

polybar-msg cmd quit

# TODO: Configure multiple monitors
# https://github.com/polybar/polybar/issues/763
# for m in $(polybar --list-monitors | cut -d":" -f1); do
# 	MONITOR=$m polybar --reload example &
# done

polybar --reload main &
