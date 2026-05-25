# Omarchy 4 migration — Waybar → Quickshell "Omarchy Shell"

**Status:** head-start draft, **untested**. Written against the `omarchy-shell`
branch (`4.0.0.alpha`) of `~/src/vendor/omarchy` as of 2026-05-25. Steve is on
3.8.2; Quickshell/`omarchy-shell` are **not installed**, so none of this has run.
When Omarchy 4 is installable, do the real port + test with the shell running,
then move `shell.json` to `~/.config/omarchy/shell.json` (and into the dotfiles
repo if desired).

## How the bar config works in Omarchy 4

- One long-running Quickshell process (`omarchy-shell`) hosts everything as
  plugins: bar, launcher, notifications, OSD, lock, clipboard, panels.
- Bar layout lives under `bar:` in `~/.config/omarchy/shell.json`. No deep-merge:
  once your file exists it is canonical.
- Edit via `omarchy launch bar settings` (GUI) or `omarchy plugin bar {list,add,move,remove,set}`.
- Custom modules: `type: "command"` (prints plain text or **Waybar-style JSON** —
  so existing scripts work as-is) or `type: "qml"` (custom widget).
- The bar renders **one PanelWindow per output** — same layout replicated on every
  monitor. (See blocker #1.)

## Module mapping (your Waybar → Omarchy 4)

| Waybar module | Omarchy 4 | Notes |
|---|---|---|
| `custom/omarchy` | `omarchy.menu` | first-party |
| `hyprland/workspaces` (custom MN/DV/MC labels) | `omarchy.workspaces` | **labels NOT portable — blocker #2** |
| `custom/clock` (clock.py) | `omarchy.clock` | richer native widget; or keep clock.py as a `command` module |
| `custom/sun` (sun.py) | `command` module | reuses your script (Waybar JSON) ✓ |
| `custom/ai-usage` (ai-usage.sh) | `command` module | reuses your script ✓ |
| `custom/update` | `omarchy.system-update` | first-party |
| `custom/voxtype` | `omarchy.indicators` → `Dictation` | native, same `omarchy-voxtype-*` backend ✓ |
| `custom/screenrecording-indicator` | `omarchy.indicators` → `ScreenRecording` | native ✓ |
| `custom/idle-indicator` | `omarchy.indicators` → `StayAwake` | **verify** this is the right indicator |
| `custom/notification-silencing-indicator` (notification-silencing.sh) | `omarchy.indicators` → `Dnd` | native DND; **verify** parity with your script |
| `mpris` | `omarchy.media` | first-party |
| `group/tray-expander` | `omarchy.tray` | first-party |
| `custom/monitor` | `omarchy.monitor` | brightness/display |
| `bluetooth` | `omarchy.bluetooth` | richer popup |
| `network` | `omarchy.network` | richer popup |
| `pulseaudio` | `omarchy.audio` | per-app mixer popup |
| `cpu` | `omarchy.system-stats` | CPU+mem sparklines |
| `battery` | `omarchy.power` | battery/profiles popup |

Available bar indicators: `Dictation`, `Dnd`, `NightLight`, `Reminder`,
`ScreenRecording`, `StayAwake`.

## Blockers (need upstream support or custom QML — can't config around)

1. **Per-monitor layouts.** Your Waybar config differs per output (DP-4 = plain;
   DP-1/DP-2 = + media). Omarchy 4's bar engine replicates **one** layout across
   all outputs. The draft uses a single shared bar (media included everywhere).
   To restore per-monitor differences: feature request to Omarchy, or a custom
   bar fork. Track against [[project_3_monitor_setup]].
2. **Custom workspace labels.** `omarchy.workspaces` renders the workspace
   *number* only — no config for your MN/DV/MC/PR/DL/DB/DR/CH/MS names. Options:
   (a) custom `type: "qml"` workspaces widget reading Hyprland IPC, or (b) upstream
   a labels schema. This is the one real chunk of QML the port would need.

## Other things to verify on the real shell

- mako `output=HDMI-A-1` (notifications pinned to one monitor) — does
  `omarchy.notifications` support output pinning? Unknown.
- mako theme template colors → handled by theme `shell.toml` (`[notifications]`).
- Keybinds move to `hyprland.lua` calling `omarchy-shell shell toggle <plugin>`.
- The voxtype evdev push-to-talk grabber (Right Ctrl) is independent of the shell
  and keeps working unchanged. See [[project_voxtype_ptt_evdev]].
- `command` module `exec` paths: draft points at `~/.config/waybar/scripts/`;
  relocate to `~/.config/omarchy/bar/scripts/` if Waybar is removed.

## Files here

- `shell.json` — draft bar config (single shared bar; blockers noted inline).
