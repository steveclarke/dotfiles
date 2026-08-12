# Omarchy 4 migration — Waybar → Quickshell "Omarchy Shell"

**Status:** draft, **untested**. Re-verified 2026-08-12 against `origin/quattro`
(`4.0.0.alpha`, still moving — last commit that day). Steve is on 3.8.4;
Quickshell/`omarchy-shell` are **not installed**, so none of this has run. When
Omarchy 4 is installable, do the real port + test with the shell running, then
move `shell.json` to `~/.config/omarchy/shell.json`.

> The original draft was written against the `omarchy-shell` branch, which went
> stale on 2026-05-25. **`quattro` is the live branch.** Check that first.

## Release state (2026-08-12)

- [PR #6231 "Quattro"](https://github.com/basecamp/omarchy/pull/6231): still a
  **draft**, `mergeable: CONFLICTING`, 1766 files / +97,840 −14,230.
- Latest actual release is still **v3.8.4** (2026-07-21).
- So no confirmed release date. Watch the PR, not the rumour mill.

## Do not upgrade before doing these three things

Sourced from [discussion #6577](https://github.com/basecamp/omarchy/discussions/6577),
a real 3.8.4 → Quattro upgrade report. All three bite this setup specifically.

1. **Back up `/var/lib/iwd` first.** Quattro moves from `iwd` to NetworkManager
   and **nothing converts saved Wi-Fi profiles**. uber-om is on wlan0, so every
   saved network disappears at the reboot. Copy the directory before starting.
2. **`~/.config/waybar/` is moved aside wholesale** to
   `waybar.omarchy-upgrade-to-quattro.<ts>.bak/`. Everything in it goes, not just
   waybar's own config. Here that directory is stowed symlinks, so the content
   survives in the dotfiles repo — but `sun.py`, `ai-usage.sh`,
   `ai-usage-refresh.sh`, `clock.py`, and `notification-silencing.sh` all need a
   new home (`~/.config/omarchy/bar/scripts/`) and a re-stow.
3. **`omarchy plugin validate` rejects symlinks in or as a plugin folder.** This
   breaks the stow pattern for plugins specifically — every other Omarchy config
   tolerates symlinks. A repo-managed plugin has to be **copied** into
   `~/.config/omarchy/plugins/<id>/`, not linked. Plan an install step, not a
   stow package.

## The upgrade command

Quattro is **package-backed** — it stops being a git checkout in
`~/.local/share/omarchy/` and becomes the `omarchy` / `omarchy-settings` Arch
packages. The upgrade ships as a self-contained script:

```bash
omarchy-upgrade-to-quattro --help     # [--yes] [--reboot] [--dev] [--channel stable|rc|edge]
```

It writes timestamped `*.omarchy-upgrade-to-quattro.<ts>.bak` backups, and a
legacy Hyprland shim keeps the pre-reboot session alive.

Reference docs on the branch: `docs/omarchy-shell.md` (plugin manifest, IPC,
`shell.json`, theme tokens, custom bar modules), `docs/file-layout.md`,
`docs/theming.md`, `docs/update-process.md`, `docs/migrations.md`.

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
| `custom/sun` (sun.py) | `command` module, then promote to a plugin | reuses your script (Waybar JSON) ✓ — **no built-in equivalent, see below** |
| `custom/ai-usage` (ai-usage.sh) | `omarchy.agents` | **DELETE the script — first-party now, and far richer. See below** |
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

## ai-usage.sh is obsolete — drop it

Quattro ships `omarchy.agents`: one bar icon plus a panel per AI coding
subscription, with first-party collectors already written for **Claude Code and
Codex** (`bin/omarchy-agent-usage-claude`, `-codex`, `-fireworks`, driven by
`omarchy-agent-usage-update`).

It does everything `ai-usage.sh` does and a lot more: plan detection ("Max 20x"),
per-allowance percentage meters, time until the session and weekly windows reset,
prepaid credit ledgers, tokens-by-day for the last week, tokens-by-model with the
input/output/cache split, and optional cross-device aggregation. The Claude
collector reads `~/.claude/projects` transcripts plus the OAuth usage endpoint for
authoritative rate limits.

It ships enabled in the default bar layout and hides itself when no usage is
recorded, so it just appears. Nothing to port.

**Action:** delete `ai-usage.sh`, `ai-usage-refresh.sh`, the `custom/ai-usage`
module, and the `dotfiles-ai-usage-refresh` systemd service/timer. Verify the
built-in panel picks up both Claude and Codex first.

## sun.py is a genuine gap — port it and publish it

Nothing in Quattro does sunrise/sunset. `omarchy.weather`
(`shell/plugins/panels/weather/`) is weather only, and the `hyprsunset` commands
are blue-light filtering, unrelated. Confirmed by grepping the whole branch for
`sunrise|sunset|daylight` — no hits outside hyprsunset.

**Two-stage plan.** Stage 1 gets it working, stage 2 makes it shareable.

1. **Keep the script, run it as a `command` module.** `type: "command"` accepts
   Waybar-style JSON (`{text, tooltip, class}`), which `sun.py` already emits, so
   it works unchanged. Only the `exec` path moves. Zero QML.
2. **Promote to a plugin** for publishing. A plugin is a git repo with
   `manifest.json` at the root:

   ```json
   {
     "schemaVersion": 1,
     "id": "steveclarke.sun",
     "name": "Sunrise / Sunset",
     "version": "1.0.0",
     "author": "Steve Clarke",
     "description": "Next sun event with first/last light, day length, and delta vs yesterday",
     "kinds": ["bar-widget"],
     "entryPoints": { "barWidget": "Widget.qml" }
   }
   ```

   Validate with `omarchy-plugin-validate` before publishing. Remember the
   symlink restriction: install by copy, not stow.

**Where to publish:** [omarchyplugins.com](https://omarchyplugins.com/) —
community-curated, **not** official or 37signals-affiliated. Submission wants one
public GitHub repo per plugin with `manifest.json`, README, and license at the
root, plus a category and 1-3 tags, then automated compatibility checks and
maintainer approval. There is no first-party registry: `omarchy plugin add <git-url>`
clones any repo directly, so the site is discovery, not distribution.

`sun.py` is worth publishing as-is — it's self-contained (USNO "Almanac for
Computers", ~1 minute accuracy, no API key, no network call) and configurable by
`SUN_LAT` / `SUN_LON` / `SUN_LOCATION` env vars rather than hardcoded to
Greenwich. That makes it useful to strangers with no edits.

## Files here

- `shell.json` — draft bar config (single shared bar; blockers noted inline).
