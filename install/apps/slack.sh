flatpak install -y flathub com.slack.Slack

autostart_dir="$HOME/.config/autostart"

cat <<EOL > "$autostart_dir"/slack.desktop
[Desktop Entry]
Type=Application
Exec=flatpak run com.slack.Slack
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Slack
Comment=Start Slack on login
EOL

chmod +x "$autostart_dir"/slack.desktop
