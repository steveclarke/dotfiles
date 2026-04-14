#!/usr/bin/env bash
installing_banner "voxtype"

# Omarchy's built-in dictation tool (push-to-talk voice-to-text)
# Default binding: Super+Ctrl+X
#
# This runs the official omarchy installer which:
#   - Installs voxtype-bin + wtype
#   - Downloads the base.en Whisper model (~150MB)
#   - Enables GPU acceleration (Vulkan) if available
#   - Sets up systemd user service
#   - Adds Waybar mic indicator
#
# Post-install:
#   - Select a better model:  voxtype setup model
#     Recommended: large-v3-turbo (~1.6GB, fast+accurate with GPU)
#   - Enable GPU manually if installer failed:  sudo voxtype setup gpu --enable
#   - Config: ~/.config/voxtype/config.toml
#     Critical settings:
#       [output]
#       mode = "paste"                    (NOT "type" — type mode is painfully slow)
#       paste_keys = "shift+insert"       (ctrl+v does NOT work on Hyprland)
#       restore_clipboard = true
#       [audio.feedback] enabled = true
#       [output.notification] on_recording_start/stop/transcription = true
#   - Rebind to single key in ~/.config/hypr/bindings.conf:
#       bindd = , Alt_R, Dictation, exec, voxtype record toggle
#   - Restart after config changes:  systemctl --user restart voxtype
omarchy-voxtype-install
