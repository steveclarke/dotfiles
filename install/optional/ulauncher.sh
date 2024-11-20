sudo add-apt-repository universe -y
sudo add-apt-repository ppa:agornostal/ulauncher -y
sudo apt update
sudo apt install -y ulauncher

# Lots of quirks with this one under Wayland.
# https://github.com/Ulauncher/Ulauncher/discussions/1350

# To disable the ulauncher default shortcut on Wayland, edit:
# .config/ulauncher/settings.json
# Set "hotkey-show-app": "null"
