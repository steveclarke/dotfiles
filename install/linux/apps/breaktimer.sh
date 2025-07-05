# https://breaktimer.app/
sudo snap install breaktimer

autostart_dir="$HOME/.config/autostart"

cat <<EOL > "$autostart_dir"/breaktimer.desktop
[Desktop Entry]
Type=Application
Exec=breaktimer
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=BreakTimer
Comment=Start BreakTimer on login
EOL

chmod +x "$autostart_dir"/breaktimer.desktop
