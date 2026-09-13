# Quattro / Quickshell facts that are not obvious

Each of these cost hours on a real plugin (Screen Push, Headroom, Kopia).

## Layout and manifest

- Manifest is `manifest.json`: `schemaVersion`, `id` (permanent, global, reverse-DNS `io.github.<user>.<name>`), `kinds` (`bar-widget`, `service`, `panel`, `overlay`, `menu`, `bar`), `entryPoints` (`barWidget`, `service`), `barWidget` (`displayName`, `category`, `allowMultiple`, `defaultSection`, `aliases`, `defaults`, `schema`).
- First-party plugins: `/usr/share/omarchy/shell/plugins/`. Shared UI: `/usr/share/omarchy/shell/Ui/`. Tokens: `/usr/share/omarchy/shell/Commons/{Style,Color}.qml`.
- The shape that scales: `kinds: ["service","bar-widget"]`, a singleton `Service.qml` reached with `bar.shell.serviceFor(moduleName)`, a per-monitor `BarWidget.qml` that lazily `Loader`s `Panel.qml`.
- Naming a property `state` or `settings` on an Item/Panel root overrides a base-type property; qmllint flags `property-override`. Use `health`, `prefs`.

## Bar widget

- Root is `BarWidget` (or `Panel` if it needs popup + IPC). Set `implicitWidth`/`implicitHeight` from the inner button or the bar gives a 0x0 slot.
- One bar per monitor means N instances. Never poll hardware or run a heavy process per instance; poll once in the service. The duplicate `IpcHandler` warning with `manageIpc: false` is benign.
- Handle the `vertical` bar position as well as horizontal.
- Glyphs: check first-party plugins for collisions before choosing a Nerd Font codepoint. Or tint an SVG (`TintedIcon` pattern from Headroom) sized to `Style.bar.iconCanvas`.
- Pin text width with `TextMetrics` so the bar does not jitter. `textFormat: Text.PlainText`, `renderType: Text.NativeRendering`.
- A local `component PlainLabel: Text { textFormat: Text.PlainText }` keeps the reviewers' textFormat grep clean; a component named `Label` shows up as dozens of false "missing textFormat" hits.

## Settings

- `barWidget.schema` entries: `{key, type: integer|enum|path|string, label, min, max, step, defaultValue, options, description}`. Read with `setting(name, fallback)`; save with `shell.updateEntryInline(id, settings)`, merging the existing entry so unrelated options survive.
- `shell.shellConfig` is gone from the plugin API. A plugin's `shell` object carries `barConfig`, a one-time copy made when the object is created; it never updates. Live settings come from the bar widget's `settings` property (the bar patches it on `omarchy bar set` and on `updateEntryInline`). Push them into the service from `onSettingsChanged`, JSON-compare first so N bars do not trigger N refreshes.
- `omarchy bar set <id> <key> 6` stores the string "6". Coerce numeric and boolean strings in the settings normaliser or the CLI silently does nothing.
- Schema `min`/`max` limit the settings UI only. Clamp again in the normaliser before a value drives a timer or a process.
- `omarchy bar set <id> <key> '[...]' --json` failed for array values ("Too many arguments"); scalars and objects worked. Use the settings UI for arrays.

## Panel

- `KeyboardPanel` has required `anchorItem` and `bar`; qmllint does not check required properties inside a Repeater or inline Component. Keep a positive-control check script.
- Menu width 380, setup/settings 460. Spacing from `Style.space()`, colours from theme roles.
- Text fields: seed in `Component.onCompleted`, write back on `onTextEdited`. Binding `text` to model state loops.
- In settings set `PanelKeyCatcher.blocked`, not `enabled: false` (disables children too).
- `Column` already has `move`; name a reorder function `reorder`.
- A `Repeater` delegate cannot reach `parent.someProperty` of the enclosing Column during creation; give the container an id.
- Hot reload keeps stale glyphs and IPC handlers: `omarchy-restart-shell`. It refuses while the session is locked; test IPC in a throwaway `quickshell -p <dir>` with a bare `ShellRoot` and `IpcHandler` instead.
- IPC targets are global across the whole shell, so a short target (`kopia`) can collide with another plugin. Use the full plugin id (`io.github.steveclarke.kopia`); dotted targets work with `omarchy-shell` and `quickshell ipc`. Built-ins use `omarchy.<name>`. `quickshell ipc -p /usr/share/omarchy/shell show` lists every live target.

## Processes

- Quickshell `Process` has no `errorOccurred`; a missing binary emits nothing. Always a watchdog `Timer` that rejects.
- `Process.started` fires only when the binary launched. A watchdog that times out without `started` means "not installed"; one that times out after `started` means "slow", and must not flip the widget to its unset state.
- Reusing one `Process` for a cancelled run and the next one lets the killed run's late `exited` complete the new run with an empty buffer. Create a Process per run with a token and drop signals whose token is stale.
- Build commands positionally (`["kopia","snapshot","list","--json"]`), never string-concatenated.
- Run tools by absolute path through one `binDir` property (default `/usr/bin/`) so the harness can point it at stubs; the missing-binary case then proves it is honoured.
- Cap stdout/stderr buffers; parse JSON in a `.js` module that node can unit test.
- Schedule with a 1 s heartbeat timer and a `nextRefreshAt` timestamp, not `repeat` intervals; handle the clock going backwards.
- `systemctl --user start` of a oneshot blocks until it finishes; pass `--no-block` or the watchdog kills the client.
- `omarchy-launch-floating-terminal-with-presentation` joins its arguments into a `bash -c` string, so a plugin must not pass data through it. Run `/usr/bin/xdg-terminal-exec --app-id=org.omarchy.terminal --title=... -- /usr/bin/<cmd> args...` as an argv array instead.

## Notifications

- No plugin API. `notify-send` from a `Process`. `-u critical` is treated as an emergency alert by the shell's daemon. `-A key=Label` actions come back on stdout.
- A `-A key=Label` `notify-send` process lives until the notification is acted on. A second `start()` while it is active is a silent no-op; cancel first.

## Security review findings

- Never put a secret in argv, including a password inside a URL handed to `xdg-open` or a browser: `/proc/<pid>/cmdline` is readable by every process of the user. Reviewers treat it as a blocker, not hardening.
- Any credential sent over `http://` must be limited to a literal loopback address (parse with `ipaddress`, refuse names like `localhost` and IPv4-mapped IPv6); require `https://` otherwise.
- `xdg-open` rejects `--` as an unknown option. Validate the URL to start with `http://` or `https://` instead, and say so in a comment for reviewers.
- The full rule set is in the `omarchy-plugin-security` skill.

## Testing and verification

- Under bats, `! cmd` never fails a test (`set -e` ignores negated commands). Assert on captured output: `[ -z "$(grep ...)" ]`. Prove every guard with a planted positive control before trusting it.
- A stub that returns fixed-date fixtures makes "healthy" tests pass only for a few hours after capture. Shift fixture timestamps relative to now inside the stub.
- No click tool on Wayland (no ydotool). `wtype` sends keys, so give every panel action a key and capture through it; a "," settings key doubles as a feature.
- CI on `ubuntu-latest` has no Omarchy, Quickshell or qmllint. Run the unit suites and the agent-file guard there; keep qmllint, offscreen QML checks and `omarchy plugin validate` in local `bin/check`. A test that reaches for `/usr/share/omarchy/bin` passes locally and fails in CI, so stub the file check. A personal-data check that compares against the local username fails in CI (the runner is `runner`, a common word); keep it local.
- `hyprctl dispatch movecursor` fails on Lua Hyprland; use `hyprctl eval` with `hl.dsp.cursor.move`.

## Hotkeys

- Anything that must work with no picture on screen calls the engine binary by absolute path from `bindings.lua`, not shell IPC.
