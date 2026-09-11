# Quattro / Quickshell facts that are not obvious

Layout and manifest
- Manifest is `manifest.json`: `schemaVersion`, `id` (permanent, global, reverse-DNS `io.github.<user>.<name>`), `kinds` (`bar-widget`, `service`, `panel`, `overlay`, `menu`, `bar`), `entryPoints` (`barWidget`, `service`), `barWidget` (`displayName`, `category`, `allowMultiple`, `defaultSection`, `aliases`, `defaults`, `schema`).
- `barWidget.schema` entries: `{key, type: integer|enum|path|string, label, min, max, step, defaultValue, options, description}`. Read with `setting(name, fallback)`; save with `shell.updateEntryInline(id, settings)`, merging the existing entry so unrelated options survive.
- First-party plugins: `/usr/share/omarchy/shell/plugins/`. Shared UI: `/usr/share/omarchy/shell/Ui/`. Tokens: `/usr/share/omarchy/shell/Commons/{Style,Color}.qml`.
- The shape that scales: `kinds: ["service","bar-widget"]`, a singleton `Service.qml` reached with `bar.shell.serviceFor(moduleName)`, a per-monitor `BarWidget.qml` that lazily `Loader`s `Panel.qml`.

Bar widget
- Root is `BarWidget` (or `Panel` if it needs popup + IPC). Set `implicitWidth`/`implicitHeight` from the inner button or the bar gives a 0x0 slot.
- One bar per monitor means N instances. Never poll hardware or run a heavy process per instance; poll once in the service. The duplicate `IpcHandler` warning with `manageIpc: false` is benign.
- Glyphs: check first-party plugins for collisions before choosing a Nerd Font codepoint. Or tint an SVG (`TintedIcon` pattern from Headroom) sized to `Style.bar.iconCanvas`.
- Pin text width with `TextMetrics` so the bar does not jitter. `textFormat: Text.PlainText`, `renderType: Text.NativeRendering`.

Panel
- `KeyboardPanel` has required `anchorItem` and `bar`; qmllint does not check required properties inside a Repeater or inline Component. Keep a positive-control check script.
- Menu width 380, setup/settings 460. Spacing from `Style.space()`, colours from theme roles.
- Text fields: seed in `Component.onCompleted`, write back on `onTextEdited`. Binding `text` to model state loops.
- In settings set `PanelKeyCatcher.blocked`, not `enabled: false` (disables children too).
- `Column` already has `move`; name a reorder function `reorder`.
- Hot reload keeps stale glyphs and IPC handlers: `omarchy-restart-shell`.

Processes
- Quickshell `Process` has no `errorOccurred`; a missing binary emits nothing. Always a watchdog `Timer` that rejects.
- Build commands positionally (`["kopia","snapshot","list","--json"]`), never string-concatenated.
- Cap stdout/stderr buffers; parse JSON in a `.js` module you can unit test with node.
- Schedule with a 1 s heartbeat timer and a `nextRefreshAt` timestamp, not `repeat` intervals; handle the clock going backwards.

Notifications
- No plugin API. `notify-send` from a `Process`. `-u critical` from `notify-send` is treated as an emergency alert by the shell's daemon. `-A key=Label` actions come back on stdout.

Hotkeys
- Anything that must work with no picture on screen calls the engine binary by absolute path from `bindings.lua`, not shell IPC.

CLI quirks seen
- `omarchy bar set <id> <key> '[...]' --json` failed for array values ("Too many arguments"); scalars and objects worked. Use the settings UI for arrays.
- `hyprctl dispatch movecursor` fails on Lua Hyprland; use `hyprctl eval` with `hl.dsp.cursor.move`.

Learned on the Kopia plugin (2026-09-11)
- `shell.shellConfig` is gone from the plugin API. A plugin's `shell` object carries `barConfig`, and it is a one-time copy made when the object is created; it never updates. Live settings come from the bar widget's `settings` property (the bar patches it on `omarchy bar set` and on `updateEntryInline`). Push them into the service from `onSettingsChanged`, JSON-compare first so N bars do not trigger N refreshes.
- `omarchy bar set <id> <key> 6` stores the string "6". Coerce numeric and boolean strings in the settings normaliser or the CLI silently does nothing.
- Naming a property `state` or `settings` on an Item/Panel root overrides a base-type property; qmllint flags `property-override`. Use `health`, `prefs`.
- A `Repeater` delegate cannot reach `parent.someProperty` of the enclosing Column during creation; give the container an id.
- `Process.started` fires only when the binary launched. A watchdog that times out without `started` means "not installed"; one that times out after `started` means "slow", and must not flip the widget to its unset state.
- A `-A key=Label` `notify-send` process lives until the notification is acted on. A second `start()` while it is active is a silent no-op; cancel first.
- `systemctl --user start` of a oneshot blocks until it finishes; pass `--no-block` or the watchdog kills the client.
- Under bats, `! cmd` never fails a test (`set -e` ignores negated commands). Assert on captured output: `[ -z "$(grep ...)" ]`. Prove every guard with a planted positive control before trusting it.
- No click tool on Wayland here (no ydotool). `wtype` sends keys, so give every panel action a key and capture through it; a "," settings key doubles as a feature.
- Reusing one `Process` for a cancelled run and the next one lets the killed run's late `exited` complete the new run with an empty buffer. Create a Process per run with a token and drop signals whose token is stale.
- A stub that returns fixed-date fixtures makes "healthy" tests pass only for a few hours after capture. Shift fixture timestamps relative to now inside the stub.
