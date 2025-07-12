# Note: installing from .deb file instead of snap because screen sharing doesn't
# work with snap version of Slack (at least on Wayland)

# Download the .deb file from the official website
# https://slack.com/downloads/linux


installer_file="$(find "${HOME}"/Downloads -maxdepth 1 -name "slack-desktop*.deb")"

if [ -z "$installer_file" ]; then
  echo "Installer file not found in Downloads folder"
  exit 1
fi

echo "Installing $installer_file"
sudo apt install -y "$installer_file"

# Configure Slack to start on login
autostart_dir="$HOME/.config/autostart"

cat <<EOL > "$autostart_dir"/slack.desktop
[Desktop Entry]
Type=Application
Exec=slack
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Slack
Comment=Start Slack on login
EOL

chmod +x "$autostart_dir"/slack.desktop

# Some info I used to try and get screen sharing working with the snap version
# https://www.guyrutenberg.com/2022/03/12/slack-screen-sharing-under-wayland/
# sudo cp /var/lib/snapd/desktop/applications/slack_slack.desktop ~/.local/share/applications/slack.desktop
# Exec=/usr/bin/slack --enable-features=WebRTCPipeWireCapturer %U
# Exec=env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/slack_slack.desktop /snap/bin/slack %U
