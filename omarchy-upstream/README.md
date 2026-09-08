# Omarchy upstream snapshots

Copies of the stock config files Omarchy ships, taken when a file was brought
into dotfiles. Not stowed. Each is the base for a three-way merge, so an
Omarchy update to a stock file can be folded into the dotfiles version without
losing the customizations.

| File | Dotfiles version | Merge command |
|------|------------------|---------------|
| `herdr/config.toml` | `configs/herdr/.config/herdr/config.toml` | `herdr-upstream-merge` |

`omarchy refresh <thing>` does not know about any of this: it copies the stock
file over `~/.config/...`, and a stow symlink there means it writes stock
straight into this repo. Never run it on a stowed file. If a migration does it
anyway, `git diff` shows exactly what upstream changed and `git checkout`
restores the dotfiles version.
