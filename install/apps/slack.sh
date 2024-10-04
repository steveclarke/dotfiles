# flatpak install -y flathub com.slack.Slack
sudo snap install slack

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
