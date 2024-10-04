version=5.2.1
filename=BabelEdit-$version.deb

cd /tmp || exit
wget https://www.codeandweb.com/download/babeledit/5.2.1/${filename}
sudo apt install -y ./${filename}
rm ${filename}
cd - || exit
