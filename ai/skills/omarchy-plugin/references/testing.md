# Testing

Pick the cases a change touches while building. Before a release, cover every
declared kind and lifecycle step, and mark a case that does not apply with the
reason. A check that could not be run is unrun, not passed.

## State cases (data-driven plugins)

Force each through the stub binaries and the `debugState` IPC, then capture it.

- Dependency missing.
- Dependency present but an unsupported version.
- Not authenticated.
- Authenticated, empty result.
- Success with one record and with many.
- Partial upstream failure (some data, some errors).
- Malformed JSON.
- Non-zero exit with stderr, and without.
- Timeout or stalled process (watchdog path).
- Retry and recovery back to healthy.
- Duplicate refresh while one is in flight.
- Dependency removed after startup.

## Live lifecycle (on an Omarchy desktop)

- `omarchy plugin add <git url>` from a clean checkout.
- Enable, place in the bar, confirm every declared kind appears or answers IPC.
- Horizontal and vertical bar positions.
- One monitor and several, when the plugin touches monitors or runs per bar.
- QML file reload, then a full `omarchy-restart-shell`. A reload destroys and
  recreates instances, so stale processes and timers show up only here.
- `omarchy plugin update` fast-forward.
- Disable and re-enable.
- Remove, and confirm what is documented as left behind.

## Evidence record

For a release, write down: date, full plugin SHA, Omarchy version, commands
run, fixture set, what could not be tested, pass or fail. Do not claim a state
or platform that was not run.

Adapted from the `omarchy-plugin-test` skill in
github.com/tcballard/build-omarchy-plugins (MIT).
