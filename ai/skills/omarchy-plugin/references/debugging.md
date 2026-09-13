# Debugging a plugin that does not load or does not work

Work down the ladder and stop at the first layer that fails.

| Layer | Read-only check | Usual cause |
|---|---|---|
| Files | `manifest.json`, entry-point files, `find . -type l` | Missing file, symlink, malformed JSON |
| Schema | `omarchy plugin validate <path>` | Reserved or malformed id, kind and entry point mismatch |
| Discovery | `omarchy plugin list --json` | Wrong directory, duplicate id |
| Enablement | `omarchy-shell shell listPlugins` (`enabled`, `active`) | Plugin disabled or widget not placed in the bar layout |
| Load | `$XDG_RUNTIME_DIR/quickshell/by-id/*/log.log` after `omarchy-restart-shell` | Missing import or type, required property, syntax error, 0x0 slot |
| Lifecycle | `omarchy-shell shell toggle <id>` | Missing `open`/`close`, bad payload handling |
| IPC | `omarchy-shell <target> <method>` | Wrong target, service kind not enabled |
| Process | run the exact argv by hand against a fixture | PATH, version, auth, timeout, output shape |
| Interaction | the live panel on the focused monitor | Anchor, focus, multi-monitor, stale instance state |

Commands (verified 2026-09-13 on Omarchy 4):

```sh
omarchy-shell shell ping            # prints "ok" when the shell answers IPC
omarchy-shell shell listPlugins     # JSON: id, kinds, enabled, active, firstParty
omarchy plugin validate <path>      # silent with exit 0 when valid
omarchy debug --no-sudo --print     # system debug report
```

Over SSH, `omarchy-shell` prints `OMARCHY_PATH is not set` and still exits 0,
which looks like success. Take the value from the desktop session first:
`export OMARCHY_PATH=$(systemctl --user show-environment | sed -n 's/^OMARCHY_PATH=//p')`.

Review `omarchy debug` output for hostnames, paths and account data before
pasting it into a public issue.

A reload of files under `~/.config/omarchy/plugins/` can destroy and recreate
QML instances. A bug that appears only after an edit, and not on first load, is
usually a timer, process or property that outlived its instance.

Adapted from the `omarchy-plugin-debug` skill in
github.com/tcballard/build-omarchy-plugins (MIT).
