# https://help.insynchq.com/en/articles/2352071-linux-installation-guide#method-1-via-the-apt-repository
installer_file=$(find "${HOME}/Downloads" -name "insync_*.deb" -maxdepth 1)
fileman_installer_file=$(find "${HOME}/Downloads" -name "insync-nautilus_*.deb" -maxdepth 1)

if [ ! -f "${installer_file}" ]; then
  echo "Installer file not found! ${installer_file}"
  exit 1
fi

if [ ! -f "${fileman_installer_file}" ]; then
  echo "File manager installer file not found! ${fileman_installer_file}"
  exit 1
fi

# # Install the deb file
sudo apt install -y "${installer_file}"
sudo apt install -y "${fileman_installer_file}"

insync start
