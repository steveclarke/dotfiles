# https://www.codeandweb.com/babeledit/download
installer_file="$(find "${HOME}"/Downloads -name "BabelEdit*.deb" -maxdepth 1)"

if [ -z "$installer_file" ]; then
  echo "Installer file not found in Downloads folder"
  exit 1
fi

echo "Installing $installer_file"
sudo apt install -y "$installer_file"
