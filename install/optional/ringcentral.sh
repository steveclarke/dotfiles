# https://www.ringcentral.com/apps/linux-phone
sudo snap install ringcentral-embeddable-voice
sudo snap connect ringcentral-embeddable-voice:pulseaudio :pulseaudio

autostart_dir="$HOME/.config/autostart"

cat <<EOL > "$autostart_dir"/ringcentral.desktop
[Desktop Entry]
Type=Application
Exec=ringcentral-embeddable-voice
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=RingCentral
Comment=Start RingCentral on login
EOL

chmod +x "$autostart_dir"/ringcentral.desktop
