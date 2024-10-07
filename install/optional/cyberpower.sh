# https://www.cyberpowersystems.com/product/software/power-panel-personal/powerpanel-for-linux/
installer_file=$(find "${HOME}"/Downloads -name "PPL_64bit*.deb" -maxdepth 1)

if [ -z "$installer_file" ]; then
  echo "Installer file not found in Downloads folder"
  exit 1
fi

echo "Installing $installer_file"
sudo apt install -y "$installer_file"

sudo pwrstat -status
echo "You can now control the UPS using \`sudo pwrstat\`"
