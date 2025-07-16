cat <<EOF >~/.local/share/applications/Parcel.desktop
[Desktop Entry]
Version=1.0
Name=Parcel
Comment=Parcel tracking app
Exec=google-chrome --app="https://web.parcelapp.net" --name=Parcel --class=Parcel
Terminal=false
Type=Application
Icon=/home/$USER/dotfiles/install/linux/desktop-entries/icons/Parcel.png
Categories=GTK;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupNotify=true
EOF
