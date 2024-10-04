sudo snap install todoist
 
autostart_dir="$HOME/.config/autostart"

cat <<EOL > "$autostart_dir"/todoist.desktop
[Desktop Entry]
Type=Application
Exec=todoist
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Todoist
Comment=Start Todoist on login
EOL

chmod +x "$autostart_dir"/todoist.desktop
