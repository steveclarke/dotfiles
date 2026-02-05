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
for ext in mp4 m4v mkv avi mov wmv webm; do
  duti -s "$VLC_ID" ".$ext" all
done

echo "Default application configuration complete!"
