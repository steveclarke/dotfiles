# https://linuxcapable.com/how-to-install-steam-on-ubuntu-linux/

# Enable 32-bit support for Steam
sudo dpkg --add-architecture i386

cd /tmp
wget https://cdn.akamai.steamstatic.com/client/installer/steam.deb 
sudo apt install -y ./steam.deb
rm steam.deb
cd -


