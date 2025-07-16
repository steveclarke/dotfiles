# iTerm2 Configuration

This directory contains iTerm2 preferences that are synced using iTerm2's built-in custom folder feature.

## Setup Instructions

1. **Open iTerm2 Preferences**
   - Press `Cmd + ,` or go to **iTerm2 → Preferences**

2. **Configure Custom Folder**
   - Go to **General → Preferences** tab
   - Check **"Load preferences from a custom folder or URL"**
   - Set the path to: `~/.local/share/dotfiles/configs/iterm2/`
   - Select **"Save changes to folder when iTerm2 quits"**

3. **Initial Export** (if you have existing settings)
   - iTerm2 will ask if you want to copy current settings to the folder
   - Click **"Copy Current Settings"** to export your existing configuration

## How It Works

- iTerm2 automatically loads settings from this folder on startup
- Changes are automatically saved to this folder when iTerm2 quits
- All preference files are stored in this directory and synced with your dotfiles
- No manual stowing or symlinking required

## Files

After setup, this directory will contain:
- `com.googlecode.iterm2.plist` - Main preferences file
- Any other iTerm2 configuration files

## Notes

- This method uses iTerm2's native preference management
- Changes are automatically synced when you quit iTerm2
- No need to manually export/import settings
- Works across multiple machines when dotfiles are synced