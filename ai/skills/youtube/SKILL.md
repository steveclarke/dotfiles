---
name: youtube
description: Download content from YouTube including transcripts, captions, subtitles, music, MP3s, and playlists. Use when the user provides a YouTube URL or asks to download, transcribe, or get content from YouTube videos or playlists.
allowed-tools: Bash,Read,Write
---

# YouTube

Download and process content from YouTube videos and playlists.

## Capabilities

This skill handles two main workflows:

| Task | Reference | Use When |
|------|-----------|----------|
| **Transcripts** | `references/transcripts.md` | User wants captions, subtitles, or text content from a video |
| **Music/MP3s** | `references/mp3-download.md` | User wants to download audio, tag MP3s, or build a music library |

## Quick Start

### For Transcripts

```bash
# Check available subtitles
yt-dlp --list-subs "YOUTUBE_URL"

# Download auto-generated subtitles
yt-dlp --write-auto-sub --skip-download -o "transcript" "YOUTUBE_URL"
```

Load `references/transcripts.md` for the full workflow including VTT-to-text conversion and Whisper fallback.

### For Music/MP3s

```bash
# Check playlist info
ytmp3 info "YOUTUBE_URL"

# Download playlist
ytmp3 download "YOUTUBE_URL"
```

Load `references/mp3-download.md` for the full tagging and organization workflow.

## Prerequisites

- **yt-dlp** — YouTube downloader (install via `brew install yt-dlp`)
- **eyeD3** — MP3 tagging (install via `brew install eye-d3`, needed for MP3 workflow)

## Workflow Selection

Based on the user's request:

- "transcript", "captions", "subtitles", "transcribe", "text from video" → Load `references/transcripts.md`
- "download music", "MP3", "playlist", "tag", "album", "music library" → Load `references/mp3-download.md`

If unclear, ask the user what they want to do with the YouTube content.
