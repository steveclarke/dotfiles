# https://support.brother.com/g/b/downloadhowto.aspx?c=ca&lang=en&prod=dcpl2550dw_us&os=128&dlid=dlf103577_000&flang=4&type3=10283
installer_file="$(find "${HOME}"/Downloads -name "dcpl2550*.deb" -maxdepth 1)"

if [ -z "$installer_file" ]; then
  echo "Brother installer file not found in Downloads folder"
  exit 1
fi

echo "Installing $installer_file"
sudo apt install -y "$installer_file"
