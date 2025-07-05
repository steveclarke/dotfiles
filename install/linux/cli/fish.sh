sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt update
sudo apt install -y fish

# Set fish as the default shell
chsh -s /usr/bin/fish
