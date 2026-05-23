# GUI Apps Audit — Omarchy Install Decisions

**Date:** 2026-04-15
**Machine:** uber-om (Omarchy 3.5)
**Purpose:** Decide which GUI apps to script for Arch/Omarchy install

Legend:
- **Installed**: Already on this machine (via Omarchy base or manual install)
- **Available (extra)**: In official Arch repos — use `omarchy-pkg-add`
- **Available (AUR)**: In AUR — use `omarchy-pkg-aur-add`
- **Not available**: Would need Flatpak, AppImage, or manual install
- **Decision**: `Y` = install, `N` = skip, `?` = undecided

---

## Apps from Ubuntu Installers (`install/apps/*.sh`)

| # | App | What it does | Omarchy Status | Arch Package | Decision |
|---|-----|-------------|----------------|--------------|----------|
| 1 | 1Password | Password manager | **Installed** (1password-beta) | Omarchy base | N (already installed) |
| 2 | Alacritty | Terminal emulator | **Installed** | Omarchy base | N (already installed) |
| 3 | Audacity | Audio editor | Not installed | extra/audacity | Y |
| 4 | Beekeeper Studio | Database GUI | Not installed | AUR: beekeeper-studio-appimage | Y |
| 5 | Bottles | Wine manager | Not installed | extra/bottles or AUR | Y |
| 6 | Brave | Web browser | Not installed | AUR: brave-bin | Y |
| 7 | BreakTimer | Break reminder | Not installed | AUR: breaktimer-appimage | Y |
| 8 | Bruno | REST API client | Not installed | AUR: bruno-git | Y |
| 9 | Chrome | Web browser | **Installed** (google-chrome) | Omarchy base | N (already installed) |
| 10 | Deja Dup | Backup tool | Not installed | extra/deja-dup | N (skip for now) |
| 11 | Discord | Chat/voice | Not installed | extra/discord | Y |
| 12 | Ear Tag | Audio tagger | Not installed | Not in repos | Y |
| 13 | Flameshot | Screenshot tool | Not installed | extra/flameshot | N (skip for now) |
| 14 | Flatseal | Flatpak permissions | Not installed | extra/flatseal | DEFER (if needed for Flatpak apps) |
| 15 | Gear Lever | AppImage manager | Not installed | Not in repos | DEFER (if needed for AppImage apps) |
| 16 | Ghostty | Terminal emulator | Not installed | extra/ghostty | Y |
| 17 | GNOME Extension Mgr | GNOME extensions | Not installed | N/A (GNOME-specific) | N (Omarchy uses Hyprland) |
| 18 | GNOME Sushi | File preview | Not installed | N/A (GNOME-specific) | N (Omarchy uses Hyprland) |
| 19 | GNOME Tweak Tool | GNOME settings | Not installed | N/A (GNOME-specific) | N (Omarchy uses Hyprland) |
| 20 | HandBrake | Video transcoder | Not installed | extra/handbrake | Y |
| 21 | JetBrains Toolbox | IDE manager | Not installed | AUR: jetbrains-toolbox | Y |
| 22 | LibreOffice | Office suite | **Installed** (libreoffice-fresh) | Omarchy base | N (already installed) |
| 23 | LocalSend | Local file sharing | **Installed** | Omarchy base | N (already installed) |
| 24 | OBS Studio | Screen recording | **Installed** | Omarchy base | N (already installed) |
| 25 | Obsidian | Note-taking | **Installed** | Omarchy base | N (already installed) |
| 26 | Oh My SVG | SVG icon app | Not installed | Not in repos | N (agents handle this now) |
| 27 | Parabolic | YouTube downloader GUI | Not installed | AUR or Flatpak | Y |
| 28 | PDF Arranger | PDF page editor | Not installed | extra/pdfarranger | Y |
| 29 | Pinta | Paint app | **Installed** | Omarchy base | N (already installed) |
| 30 | Plex | Media player | Not installed | AUR: plex-desktop | N (web access) |
| 31 | Postman | API testing | Not installed | AUR: postman-bin | Y |
| 32 | Remmina | Remote desktop | Not installed | extra/remmina | Y |
| 33 | Spotify | Music streaming | **Installed** | Omarchy base | N (already installed) |
| 34 | Syncthing Tray | File sync GUI | Not installed | extra/syncthing | N |
| 35 | Telegram | Messaging | Not installed | extra/telegram-desktop | Y |
| 36 | Thunderbird | Email client | Not installed | extra/thunderbird | Y |
| 37 | Todoist | Task manager | Not installed | AUR: todoist-appimage | Y |
| 38 | Transmission | Torrent client | Not installed | extra/transmission-gtk | Y |
| 39 | VLC | Media player | Not installed | extra/vlc | Y |
| 40 | VS Code | Code editor | **Installed** (visual-studio-code-bin) | Already installed | N (already installed) |
| 41 | WezTerm | Terminal emulator | Not installed | extra/wezterm | N |

## Apps from Ubuntu Optional (`install/optional/*.sh`)

| # | App | What it does | Omarchy Status | Arch Package | Decision |
|---|-----|-------------|----------------|--------------|----------|
| 42 | Anki | Flashcards | Not installed | extra/anki | N |
| 43 | BabelEdit | Translation editor | Not installed | Not in repos | Y |
| 44 | Bananas | Screen sharing | Not installed | Not in repos | N |
| 45 | Brother DCP-L2550 | Printer driver | Not installed | AUR (if needed) | N |
| 46 | Brother HL-L3280 | Printer driver | Not installed | AUR (if needed) | N |
| 47 | Cursor | AI code editor | Not installed | omarchy/cursor-bin | Y |
| 48 | CyberPower PowerPanel | UPS monitoring | Not installed | AUR: powerpanel | N |
| 49 | FileZilla Pro | FTP client | Not installed | extra/filezilla | Y |
| 50 | FreeCAD | 3D modeling | Not installed | extra/freecad | N |
| 51 | Google Cloud CLI | GCP tools | Not installed | AUR: google-cloud-cli | Y |
| 52 | Gradia | Gradient design | Not installed | Flatpak only | N |
| 53 | Insync | Google Drive/Dropbox/OneDrive | Not installed | AUR: insync | Y |
| 54 | Kdenlive | Video editor | **Installed** | Omarchy base | N (already installed) |
| 55 | Mark Text | Markdown editor | Not installed | AUR: marktext-bin | N |
| 56 | Microsoft Edge | Web browser | Not installed | AUR: microsoft-edge-stable-bin | N |
| 57 | MuseScore | Music notation | Not installed | extra/musescore | N |
| 58 | RingCentral | Voice/video calls | Not installed | Not in repos | Y |
| 59 | Slack | Team chat | **Installed** (slack-desktop) | Already installed | N (already installed) |
| 60 | Solaar | Logitech device mgr | Not installed | extra/solaar | N |
| 61 | Steam | Gaming platform | Not installed | extra/steam | Y |
| 62 | TablePlus | SQL client | Not installed | AUR: tableplus | N |
| 63 | Terraform | Infrastructure CLI | Not installed | extra/terraform | N |
| 64 | ULauncher | App launcher | Not installed | N/A (Omarchy uses Walker) | N (Walker replaces this) |
| 65 | VirtualBox | Virtual machines | Not installed | extra/virtualbox | Y |
| 66 | Zoom | Video conferencing | Not installed | AUR: zoom | Y |

## macOS-Only Apps (from Brewfile, not in Ubuntu list)

| # | App | What it does | Worth adding to Omarchy? | Decision |
|---|-----|-------------|-------------------------|----------|
| 67 | Adobe Creative Cloud | Design suite | macOS only | N |
| 68 | AppCleaner | Uninstaller | macOS only | N |
| 69 | ChatGPT | OpenAI client | Omarchy has web app | N |
| 70 | Claude | Anthropic client | claude-code already installed | N |
| 71 | CleanShot | Screenshot | macOS only (Hyprland has satty) | N |
| 72 | Codex / CodexBar | Code search | Omarchy installs via npx | N |
| 73 | DockAnchor | Dock utility | macOS only | N |
| 74 | Docker Desktop | Container GUI | Docker CLI already installed | N |
| 75 | Dropbox | Cloud storage | Insync covers this | N |
| 76 | Figma | Design tool | Omarchy has as web app | N |
| 77 | Firefox | Web browser | Not installed | Y (extra/firefox) |
| 78 | GitHub Desktop | GitHub GUI | Not installed | N |
| 79 | Google Drive | Cloud storage | Insync covers this | N |
| 80 | GrandPerspective | Disk analyzer | dust/ncdu already installed | N |
| 81 | Hammerspoon | Automation | macOS only | N |
| 82 | iTerm2 | Terminal | macOS only | N |
| 83 | Itsycal | Menu bar calendar | macOS only | N |
| 84 | Karabiner Elements | Keyboard remapper | macOS only (Hyprland handles this) | N |
| 85 | Kid3 | ID3 tag editor | Not installed | N |
| 86 | LM Studio | Local AI models | Not installed | N |
| 87 | Mac Mouse Fix | Mouse utility | macOS only | N |
| 88 | Microsoft Office | Office suite | LibreOffice already installed | N |
| 89 | Notion | Productivity | Not installed | N |
| 90 | Raycast | Launcher | macOS only (Walker replaces) | N |
| 91 | RepoBar | GitHub menu bar | macOS only | N |
| 92 | Setapp | App subscription | macOS only | N |
| 93 | Supersonic | Music player | Not installed | N |
| 94 | Tailscale | VPN | CLI already installed (tailscale) | N |
| 95 | UTM | Virtual machines | macOS only | N |
| 96 | WhatsApp | Messaging | Omarchy web app | Y (omarchy-webapp-install) |
| 97 | Zed | Code editor | Not installed | Y |

## Already Installed by Omarchy (no action needed)

These are installed by Omarchy's base packages — no install script needed:

| App | Package |
|-----|---------|
| 1Password | 1password-beta, 1password-cli |
| Alacritty | alacritty |
| Chrome | google-chrome |
| Chromium | chromium |
| Evince (PDF viewer) | evince |
| Kdenlive | kdenlive |
| LibreOffice | libreoffice-fresh |
| LocalSend | localsend |
| mpv (video player) | mpv |
| OBS Studio | obs-studio |
| Obsidian | obsidian |
| Pinta | pinta |
| Signal | signal-desktop |
| Spotify | spotify |
| Typora | typora |
| VS Code | visual-studio-code-bin |
| Xournal++ | xournalpp |

## Notes

- **Omarchy web apps**: Omarchy can install web apps (WhatsApp, Discord, Figma, Zoom, ChatGPT, etc.) via `omarchy-webapp-install`. These run in Chromium as PWAs. Consider using these instead of native apps where available.
- **Flatpak**: Flatpak is installed (we added it in prereqs). Some apps are only available via Flatpak on Arch.
- **Omarchy's philosophy**: Omarchy prefers native Arch packages > AUR > Flatpak. Check `omarchy-pkg-add` first.
- **Postman alternative**: Bruno is the open-source replacement Steve already uses. May not need Postman at all.
- **VLC vs mpv**: Omarchy ships mpv as its video player. VLC is available but may be redundant.
- **Todoist**: No native Linux app in Arch repos. Options: web app, Flatpak, or Omarchy web app install.
