# https://support.brother.com/g/b/downloadhowto.aspx?c=ca&lang=en&prod=hll3280cdw_us_as&os=128&dlid=dlf105735_000&flang=4&type3=10283
installer_file="$(find "${HOME}"/Downloads -name "hll3280*.deb" -maxdepth 1)"

if [ -z "$installer_file" ]; then
  echo "Brother installer file not found in Downloads folder"
  exit 1
fi

echo "Installing $installer_file"
sudo apt install -y "$installer_file"
