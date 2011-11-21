echo "+++ Setting OS X sane defaults"

# Many of these taken from:
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx

# Lemme see Library big brother!
chflags nohidden ~/Library

# enable key repeating in Lion
defaults write -g ApplePressAndHoldEnabled -bool false

# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Show remaining battery time; hide percentage
defaults write com.apple.menuextra.battery ShowPercent -string "NO"
defaults write com.apple.menuextra.battery ShowTime -string "YES"

# Show all filename extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Expand save panel by default:
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Enable mouse right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode "TwoButton"

# Enable tap to click (Trackpad)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Map bottom right Trackpad corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

# Enable iTunes song and artist dock icon popups
defaults write com.apple.dock itunes-notifications -bool TRUE

# Back out previous if desired
# defaults delete com.apple.dock itunes-notifications

# restart Dock to make some settings take effect
killall Dock
