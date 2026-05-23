# Install logitune from the upstream OBS apt repo
echo 'deb http://download.opensuse.org/repositories/home:/mmaher88:/logitune/xUbuntu_24.04/ /' | \
  sudo tee /etc/apt/sources.list.d/logitune.list
wget -qO- https://download.opensuse.org/repositories/home:mmaher88:logitune/xUbuntu_24.04/Release.key | \
  gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/logitune.gpg > /dev/null
sudo apt update && sudo apt install -y logitune
