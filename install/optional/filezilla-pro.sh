install_file=$(find "${HOME}/Downloads" -name "FileZilla_Pro_*.tar.xz")
destination_dir="/opt/FileZilla3"

if [ ! -f "${install_file}" ]; then
  echo "Installer file not found! ${install_file}"
  exit 1
fi

# Create destination directory if it doesn't exist
sudo mkdir -p "${destination_dir}"

# Extract the tar.gz file
tar xf "${install_file}" -C /tmp

# Copy the FileZilla3 directory to /opt/FileZilla3
sudo cp -r /tmp/FileZilla3/* "${destination_dir}"

rm -rf /tmp/FileZilla3

# Create a desktop entry
cp ${destination_dir}/share/applications/filezilla.desktop ~/.local/share/applications/

# Update the exec and icon paths
sed -i 's|Exec=filezilla|Exec=/opt/FileZilla3/bin/filezilla|g' ~/.local/share/applications/filezilla.desktop
sed -i 's|Icon=filezilla|Icon=/opt/FileZilla3/share/icons/hicolor/scalable/apps/filezilla_pro.svg|g' ~/.local/share/applications/filezilla.desktop

echo "FileZilla Pro installed to ${destination_dir}"
