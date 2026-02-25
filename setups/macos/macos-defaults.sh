#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

banner "Configuring macOS system preferences"

# Cache sudo credentials for the duration of this script
cache_sudo_credentials

# System Preferences
echo "Setting system preferences..."

# General UI/UX

# REMOVED: Set highlight color to blue
# This would set the system highlight color (used when selecting text/items) to blue
# System default: Uses the default system highlight color
# defaults write NSGlobalDomain AppleHighlightColor -string "0.000000 0.463529 1.000000"

# REMOVED: Set sidebar icon size to medium
# This would set the size of icons in sidebar lists (like Finder sidebar) to medium
# System default: Uses default sidebar icon size
# defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Expand save dialog by default
# Makes save dialogs always open in expanded view showing full folder structure and options
# System default: Save dialogs open in collapsed/compact view by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# REMOVED: Expand print dialog by default
# This would make print dialogs always open in expanded view showing all printing options
# System default: Print dialogs open in collapsed/compact view by default
# defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
# defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
# Makes apps save documents to local disk/computer instead of iCloud by default
# System default: macOS saves documents to iCloud by default when iCloud is enabled
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# COMMENTED OUT: Disable automatic termination of inactive apps
# This would prevent macOS from automatically closing apps that haven't been used in a while
# System default: macOS automatically terminates inactive apps to manage memory usage
# defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable the crash reporter
# Turns off crash reporter dialogs that appear when apps crash
# System default: macOS shows crash reporter dialogs asking if you want to send reports to Apple
defaults write com.apple.CrashReporter DialogType -string "none"

# Keyboard & Input
echo "Configuring keyboard and input..."

# Set a blazingly fast keyboard repeat rate
# Makes keys repeat much faster when held down and reduces delay before repeating starts
# System default: macOS has slower keyboard repeat rates (KeyRepeat ~6, InitialKeyRepeat ~25)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Enable full keyboard access for all controls
# Allows navigation and control of all interface elements using only keyboard
# System default: macOS only allows keyboard navigation for text boxes and lists by default
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
# Turns off accent character menu when holding keys, allowing keys to just repeat instead
# System default: macOS shows accent character menus when holding keys like vowels
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Trackpad & Mouse
echo "Configuring trackpad and mouse..."

# Trackpad: enable tap to click for this user and for the login screen
# Enables tap-to-click functionality instead of requiring physical press
# System default: macOS requires physical press on trackpad to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: map bottom right corner to right-click
# Maps bottom right corner of trackpad to act as right-click and enables right-click
# System default: macOS uses two-finger click for right-click without corner zones
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Enable three finger drag
# Allows dragging windows and selecting text by dragging with three fingers
# System default: macOS disables three-finger drag (normal drag requires click and hold)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Disable Look Up & Data Detectors (dictionary popup on force click / three-finger tap)
# Prevents the dictionary/thesaurus popup from appearing when selecting text
# System default: macOS shows dictionary lookup on force click or three-finger tap
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0

# Increase sound quality for Bluetooth headphones/headsets
# Increases audio quality for Bluetooth devices by raising minimum bitpool value
# System default: macOS uses lower bitpool value which can result in lower audio quality
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Screen
echo "Configuring screen..."

# REMOVED: Require password immediately after sleep or screen saver begins
# This would require password immediately when waking from sleep/screen saver with no delay
# System default: macOS may have a grace period before requiring password
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
# Sets default location where screenshots are saved to Desktop
# System default: macOS saves screenshots to Desktop by default
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
# Sets screenshots to be saved in PNG format
# System default: macOS saves screenshots in PNG format by default
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
# Removes drop shadow effect that appears around window screenshots
# System default: macOS adds subtle drop shadow around window screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
# Enables enhanced font rendering on external displays to make text sharper
# System default: macOS uses lighter font smoothing which may look fuzzy on non-Apple monitors
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Dock
echo "Configuring Dock..."

# REMOVED: Enable autohide
# This would automatically hide the Dock when not in use
# System default: macOS shows the Dock at all times by default
# defaults write com.apple.dock autohide -bool true

# COMMENTED OUT: Set the icon size of Dock items to 48 pixels
# This would make Dock icons smaller than default (64 pixels)
# System default: macOS uses default Dock icon size of around 64 pixels
# defaults write com.apple.dock tilesize -int 48

# Don't show recent applications in Dock
# Prevents recently used apps from appearing in Dock automatically
# System default: macOS shows recently used apps in Dock by default
defaults write com.apple.dock show-recents -bool false

# REMOVED: Automatically hide and show the Dock (duplicate setting)
# This was a duplicate of the autohide setting above
# defaults write com.apple.dock autohide -bool true

# REMOVED: Remove the auto-hiding Dock delay
# This would remove delay before Dock appears when moving mouse to edge
# System default: macOS has small delay (~0.5 seconds) before showing Dock when autohide enabled
# defaults write com.apple.dock autohide-delay -float 0

# REMOVED: Remove the animation when hiding/showing the Dock
# This would remove animation effect when Dock hides/shows
# System default: macOS has smooth animation when Dock hides/appears
# defaults write com.apple.dock autohide-time-modifier -float 0

# REMOVED: Make Dock icons of hidden applications translucent
# This would make icons of hidden apps appear semi-transparent in Dock
# System default: macOS shows hidden app icons at normal opacity in Dock
# defaults write com.apple.dock showhidden -bool true

# Finder
echo "Configuring Finder..."

# COMMENTED OUT: Show hidden files by default
# This would make Finder show all hidden files and folders (starting with dot)
# System default: macOS hides system files and folders that start with dot
# defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
# Makes Finder display file extensions for all files, even those that normally hide them
# System default: macOS hides file extensions for known file types by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
# Shows status bar at bottom of Finder windows with folder info and disk space
# System default: macOS hides status bar in Finder windows by default
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
# Shows path bar at bottom of Finder windows displaying full folder path
# System default: macOS hides path bar in Finder windows by default
defaults write com.apple.finder ShowPathbar -bool true

# COMMENTED OUT: Display full POSIX path as Finder window title
# This would show complete file system path in title bar instead of just folder name
# System default: macOS shows only folder name in Finder window title
# defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
# Makes folders always appear before files when sorting, regardless of alphabetical order
# System default: macOS mixes folders and files together alphabetically
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
# Makes Finder search within current folder instead of entire computer
# System default: macOS searches entire Mac by default when using Finder search
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
# Removes warning dialog when changing file extensions
# System default: macOS shows warning when changing file extensions
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
# Allows dragging files over folders to have them automatically open after hovering
# System default: macOS enables spring loading by default
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# COMMENTED OUT: Remove the spring loading delay for directories
# This would make folders open instantly when dragging files over them
# System default: macOS has small delay (~0.75 seconds) before folders spring open
# defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
# Prevents .DS_Store files from being created on shared drives and USB sticks
# System default: macOS creates .DS_Store files on all volumes to remember folder preferences
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show the ~/Library folder
# Makes the hidden Library folder visible in user directory
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# Disable the warning before emptying the Trash
# Removes confirmation dialog when emptying trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# NOTE: To add the Delete button to Finder toolbar, do this manually:
# View > Customize Toolbar > Drag the Delete button to your toolbar
# There's no simple defaults command for this specific customization

# COMMENTED OUT: Use list view in all Finder windows by default
# This would make all Finder windows show files in detailed list format with columns
# System default: macOS uses icon view by default for new Finder windows
# defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Restart affected applications
echo "Restarting affected applications..."
killall "Dock" &> /dev/null
killall "Finder" &> /dev/null

echo "macOS system preferences configured successfully!" 
