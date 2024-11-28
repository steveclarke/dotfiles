# Bananas Screen Sharing
# https://github.com/mistweaverco/bananas
# https://getbananas.net/

cd /tmp || exit
wget https://github.com/mistweaverco/bananas/releases/latest/download/bananas_amd64.deb
sudo apt install -y ./bananas_amd64.deb
rm bananas_amd64.deb
cd - || exit
