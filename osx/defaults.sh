# Lemme see Library big brother!
echo "Unhiding ~/Library"
chflags nohidden ~/Library

# enable key repeating in Lion
echo "Enable key repeat in Lion"
defaults write -g ApplePressAndHoldEnabled -bool false

