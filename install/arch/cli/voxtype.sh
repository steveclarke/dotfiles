#!/usr/bin/env bash

# Omarchy's built-in dictation tool (push-to-talk voice-to-text).
# Bar indicator: omarchy.indicators -> Dictation (native in Omarchy 4).
#
# omarchy-voxtype-install installs voxtype-bin + wtype, downloads the base.en
# Whisper model (~150MB), enables Vulkan GPU acceleration if available, and
# sets up the systemd user service.
#
# Post-install:
#   - Select a better model:  voxtype setup model
#     Recommended: large-v3-turbo (~1.6GB, fast+accurate with GPU)
#   - Enable GPU manually if installer failed:  sudo voxtype setup gpu --enable
#   - Config: ~/.config/voxtype/config.toml (stowed from configs/voxtype)
#     Critical settings:
#       [output]
#       mode = "paste"                    (NOT "type" — type mode is painfully slow)
#       paste_keys = "shift+insert"       (ctrl+v does NOT work on Hyprland)
#       restore_clipboard = true
#       [audio.feedback] enabled = true
#       [output.notification] on_recording_start/stop/transcription = true
#   - Rebind to a single key in ~/.config/hypr/bindings.lua
#   - Restart after config changes:  systemctl --user restart voxtype

installing_banner "voxtype"

# Omarchy installs voxtype during its own setup, and the installer cannot
# replace an existing /usr/bin/voxtype without sudo — it just errors out. Skip
# when it is already there and let `voxtype setup` handle upgrades.
if is_installed voxtype; then
  skipping "voxtype ($(voxtype --version 2>/dev/null || echo 'already installed'))"
else
  omarchy-voxtype-install
fi
