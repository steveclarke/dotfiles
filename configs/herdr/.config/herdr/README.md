# Herdr config

`config.toml` is Omarchy's stock herdr config (which mirrors the Omarchy tmux
bindings: `Ctrl+Space` prefix, session → workspace, window → tab) plus Steve's
changes, stowed on every machine so the Mac and uber-om share one keymap.

Omarchy only seeds this file (`[[ -f config.toml ]] || omarchy-refresh-config`),
so owning it is the supported arrangement. Herdr edits it in place, so the
stow symlink survives its own writes (`onboarding`, `herdr config reset-keys`).

- Reload after an edit: `herdr server reload-config`
- Pick up an Omarchy update to the stock file: `herdr-upstream-merge` (on
  uber-om; three-way merge against `omarchy-upstream/herdr/config.toml`)
- Never `omarchy refresh herdr`: it `cp -f`s stock over the symlink, i.e. into
  this repo. Recoverable with `git checkout`, but pointless.
