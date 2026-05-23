#!/usr/bin/env bash
installing_banner "vdu_controls"

# Qt GUI for ddcutil — multi-monitor sliders, presets/profiles, tray icon.
# Launched from the waybar custom/monitor button (configs/waybar/...). Needs
# i2c access from setups/arch/monitor-ddc.sh.
omarchy-pkg-aur-add vdu_controls
