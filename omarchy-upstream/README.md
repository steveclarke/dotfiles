# Omarchy upstream snapshots

Copies of the stock config files Omarchy ships, taken when a file was brought
into dotfiles. Not stowed. Each is the base for a three-way merge, so an
Omarchy update to a stock file can be folded into the dotfiles version without
losing the customizations.

| File | Dotfiles version | Merge command |
|------|------------------|---------------|
| `herdr/config.toml` | `configs/herdr/.config/herdr/config.toml` | `herdr-upstream-merge` |
| `tmux/tmux.conf` | `configs/tmux/.config/tmux/tmux.conf` | `tmux-upstream-merge` |

`omarchy refresh <thing>` does not know about any of this: it copies the stock
file over `~/.config/...`, and a stow symlink there means it writes stock
straight into this repo. Never run it on a stowed file. If a migration does it
anyway, `git diff` shows exactly what upstream changed and `git checkout`
restores the dotfiles version.

## Which files need a snapshot

Only files Omarchy ships **complete**, with no way to layer your own config on
top. Those are the ones where an Omarchy improvement is invisible until someone
diffs it by hand.

The Hyprland `*.lua` files deliberately have no snapshot. The copies Omarchy
puts in `~/.config/hypr/` are entirely comments — zero settings. The real
defaults live in the package at `$OMARCHY_PATH/default/hypr/` and load via
`require("default.hypr.omarchy")` in `hyprland.lua`, which dotfiles never
touches. So Omarchy's improvements arrive with a package update on their own,
and a snapshot would only ever show our own edits back to us.
