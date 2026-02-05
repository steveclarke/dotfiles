#!/usr/bin/env bash
source "${DOTFILES_DIR}"/lib/dotfiles.sh

if ! is_installed duti; then
  echo "duti not installed, skipping default app configuration"
  return 0
fi

banner "Configuring default applications with duti"

VLC_ID="org.videolan.vlc"

echo "Setting VLC as default for audio files..."
for ext in mp3 m4a aac wav flac ogg wma aiff; do
  duti -s "$VLC_ID" ".$ext" all
done

echo "Setting VLC as default for video files..."
for ext in mp4 m4v mkv avi mov wmv webm flv mpeg mpg 3gp vob; do
  duti -s "$VLC_ID" ".$ext" all
done

# Cursor for code, config, and text files
CURSOR_ID="com.todesktop.230313mzl4w4u92"

echo "Setting Cursor as default for code files..."
for ext in js ts rb py css json sql dockerfile svg; do
  duti -s "$CURSOR_ID" ".$ext" all
done

echo "Setting Cursor as default for config files..."
for ext in yaml yml toml xml cfg ini conf; do
  duti -s "$CURSOR_ID" ".$ext" all
done

echo "Setting Cursor as default for shell scripts..."
for ext in sh bash zsh; do
  duti -s "$CURSOR_ID" ".$ext" all
done

echo "Setting Cursor as default for text and workspace files..."
for ext in txt code-workspace; do
  duti -s "$CURSOR_ID" ".$ext" all
done

echo "Default application configuration complete!"
