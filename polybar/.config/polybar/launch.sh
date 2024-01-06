#!/usr/bin/env bash

polybar-msg cmd quit

# https://github.com/polybar/polybar/issues/763
# for m in $(polybar --list-monitors | cut -d":" -f1); do
# 	MONITOR=$m polybar --reload main &
# done

MONITOR=DisplayPort-0 polybar --reload main &
MONITOR=DisplayPort-2 polybar --reload left &
MONITOR=DisplayPort-1 polybar --reload right &
