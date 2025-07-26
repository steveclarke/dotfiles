# Configure Electron-based apps to run on Wayland (e.g. VSCode)
# https://github.com/microsoft/vscode/issues/207033

# NOTE: This works for VSCode, but after setting it Slack, 1Password and other
# Electron-based apps stopped working. So, it's better to set it only for VSCode.

mkdir -p "${HOME}"/.config/environment.d
echo "ELECTRON_OZONE_PLATFORM_HINT=auto" > "${HOME}"/.config/environment.d/99-electron-wayland.conf
