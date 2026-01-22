---
name: youtube-mp3
description: Download YouTube playlists as properly tagged MP3s for Steve's music library. Use when Steve wants to download music from YouTube, tag MP3 files, or add albums to his collection.
---

# YouTube Playlist to MP3 Skill

Composable CLI for downloading YouTube playlists as properly tagged MP3s.

## Commands

```bash
ytmp3 info URL              # Show playlist info without downloading
ytmp3 download URL          # Download playlist to staging
ytmp3 staging               # List what's in staging
ytmp3 tag DIR [options]     # Tag all MP3s in directory
ytmp3 cover DIR [options]   # Download and embed cover art
ytmp3 finalize DIR [opts]   # Rename to final structure
ytmp3 show FILE             # View tags on a file
```

## Prerequisites

In Brewfile:
- `yt-dlp` — YouTube downloader
- `eye-d3` — MP3 tagging tool

## Typical Workflow

```bash
# 1. Check what you're downloading
ytmp3 info "https://youtube.com/playlist?list=..."

# 2. Download to staging
ytmp3 download "https://youtube.com/playlist?list=..."
# => Files saved to: ~/Music/staging/Perfecta

# 3. See what's in staging
ytmp3 staging

# 4. Tag the files
ytmp3 tag ~/Music/staging/Perfecta \
  --artist "Adam Again" \
  --album "Perfecta" \
  --year 1995

# 5. Add cover art
ytmp3 cover ~/Music/staging/Perfecta \
  --url "https://f4.bcbits.com/img/a2043159314_10.jpg"

# 6. Finalize to Steve's naming convention
ytmp3 finalize ~/Music/staging/Perfecta \
  --artist "Adam Again" \
  --album "Perfecta"
# => Files moved to: ~/Music/staging/Adam Again/Adam Again - Perfecta/
```

## Steve's Naming Convention

Final structure:
```
~/Music/staging/
└── {Artist}/
    └── {Artist} - {Album}/
        ├── 01 {Title} - {Artist}.mp3
        ├── 02 {Title} - {Artist}.mp3
        └── folder.jpg
```

## Command Details

### `ytmp3 info URL`

Shows playlist info without downloading:
- Album/playlist name
- Artist (if available from YouTube Music)
- Track count and listing

### `ytmp3 download URL`

Downloads all tracks as MP3s to `~/Music/staging/{album-name}/`

Options:
- `-o, --output NAME` — Custom output directory name

### `ytmp3 staging`

Lists all directories in staging with track counts and cover status.

### `ytmp3 tag DIR`

Tags all MP3 files in directory with metadata.

Required options:
- `-a, --artist NAME` — Artist name
- `-A, --album NAME` — Album name
- `-y, --year YEAR` — Release year

Optional:
- `-g, --genre GENRE` — Genre (default: "Christian Rock")

Sets: artist, album, year, genre, track number, track total, title.

### `ytmp3 cover DIR`

Downloads cover art and embeds in all MP3s.

Options (one required):
- `-u, --url URL` — Download from URL
- `-f, --file PATH` — Use local file

Saves as `folder.jpg` and embeds in all tracks.

### `ytmp3 finalize DIR`

Renames files to Steve's convention and reorganizes.

Required options:
- `-a, --artist NAME` — Artist name
- `-A, --album NAME` — Album name

Moves files from source dir to `~/Music/staging/{Artist}/{Artist} - {Album}/`

### `ytmp3 show FILE`

Shows current tags on an MP3 file using eyeD3.

## Finding Cover Art

Best sources:
1. **Bandcamp** — `{artist}.bandcamp.com/album/{album}`, look for `bcbits.com/img/` URLs
2. **Discogs** — Search release, right-click image → Copy URL
3. **MusicBrainz Cover Art Archive**

## Future: Navidrome Deployment

After processing, files are in `~/Music/staging/`. Manual deploy:
- rsync/scp to Unraid server
- Copy to Navidrome music directory
- Trigger library rescan
