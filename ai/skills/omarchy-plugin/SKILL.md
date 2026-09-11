---
name: omarchy-plugin
description: "Build or polish an Omarchy (Quattro bar / Quickshell QML) plugin: bar widget, panel, service, settings, marketplace submission. Use for 'omarchy plugin', 'bar widget', 'quickshell panel', or any work in a plugin repo."
---

# Omarchy plugin

How to take a bar-widget idea from nothing to a marketplace-quality plugin
without burning a day on a widget that never appears. The process is the
product: prototype in HTML first, get a yes on every state, then build.

## Phase 1: Research (agents, read-only, parallel)

1. **Marketplace scan.** `https://plugins.omarchy.org/catalog.json` is the full
   catalog (the site's `registry.json` is a 404; the GitHub `registry.json`
   holds only repo URLs). Grep ids, names, descriptions. Confirm the idea is
   not already there and the id you want is free. Shallow-clone the 3 to 5
   nearest plugins and write down what each puts in the bar, what the panel
   shows, how it polls, and what to steal.
2. **Reference implementations.** Read `references/quattro-facts.md`, then the
   shipped panels in `/usr/share/omarchy/shell/plugins/panels/` (power,
   network, bluetooth, audio) and `plugins/dev-gallery/GalleryPanel.qml`, the
   live catalogue of every shared component.
3. **Data spike.** Run the real CLI (`--json` where it exists) and paste the
   fields the widget can show. Design only from data that exists.

## Phase 2: Prototype in HTML before any QML

The user is visual. Words about a panel mean nothing; a rendered panel means
everything. Do this in one pass, one voice, no agent fan-out.

1. Three directions as `option-a/b/c.html` plus an `index.html` that iframes
   them side by side. Same data in all three. Each page: a mock bar strip
   showing every widget state, then the panel, a light/dark toggle. Read the
   user's theme from `~/.config/omarchy/themes/*/colors.toml` and default to it.
   Use a monospace stack (`"JetBrainsMono Nerd Font", ui-monospace`) and the
   panel geometry from `references/design-language.md`.
2. Screenshot each with headless Chromium and look at the PNG yourself before
   showing anything.
3. Serve them (tiny Python HTTP server on a fixed port, `webbrowser.open`) and
   open the browser for the user. State your pick and why in three sentences.
4. After a direction is chosen: `design-<x>-full.html` with **every state**
   (healthy, running, failed, stale/warn, not set up, settings) each in its own
   card with a one-paragraph "why" under it, and the notification mocked
   inline. Every string is a sentence with a next step. Get a yes on this page.
5. Only then write the spec (`superpowers:brainstorming` architectural path).

## Phase 3: Build

Order matters. Each step ends with a screenshot the user can see.

1. Manifest + `BarWidget.qml` with the glyph visible in the bar. First hour.
   `implicitWidth`/`implicitHeight` on the root or the slot is 0x0.
2. `Model.js` pure functions with node tests: parsing, state machine, relative
   time, error-class mapping.
3. `Service.qml` singleton with a watchdogged `Process` wrapper (copy
   Headroom's `CollectorProcess.qml`), stub binaries under `test/stub/` so
   tests never touch real hardware or real repositories.
4. `Panel.qml` healthy state from first-party parts only (`PanelHero`,
   `PanelSectionHeader`, `PanelSeparator`, `CursorSurface`, `PanelActionButton`).
   Compare the grim capture to the prototype side by side.
5. Every other state, forced through a debug IPC (`omarchy-shell <id> debugState
   failed`), captured, compared.
6. `SettingsView.qml` via manifest `barWidget.schema`, saved with
   `shell.updateEntryInline`.
7. Notifications: `notify-send -u critical -A key=Label`, one per event,
   deduplicated by the event's timestamp.
8. Design audit: four agents, four lenses (first-party comparison, cold read,
   copy table, flow). Apply, recapture, ask again. Done when the user says so.
9. `preview.png` (check all four edges at zoom, stand-in names only), tag,
   GitHub release, marketplace issue per `references/marketplace.md`.

## Verify without touching the user's mouse

`omarchy-shell <id> open`, `omarchy-shell shell toggle <id>`, then `grim -g`
on the panel's geometry from `omarchy-shell shell debugBarGeometry`. Hover via
`hyprctl eval 'hl.dispatch(hl.dsp.cursor.move({x=..,y=..}))'` after saving
`hyprctl -j cursorpos` and restoring it in a finally. Never ask the user to
click something to tell you what happened.

## Install the real way

Source lives in `~/src/<repo>`. `omarchy plugin add <git url> --enable` clones
into `~/.config/omarchy/plugins/<id>/`; never edit there. Commit, push,
`omarchy plugin update`, `omarchy-restart-shell` after any manifest, glyph or
IPC change. No symlinks in a plugin folder. Nothing personal in the repo,
fixtures, screenshots or history.

## References

- `references/quattro-facts.md`: the non-obvious Quickshell / Quattro facts
  that cost hours each.
- `references/design-language.md`: geometry, tokens, component vocabulary,
  state-colour rules, copy rules.
- `references/marketplace.md`: submission body, validator quirks.
