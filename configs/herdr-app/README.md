# Herdr app config

The Herdr desktop app (`herdr-app`) owns `~/.config/herdr-app` and replaces its
shipped layouts and panels on every start. It never writes over these, so they
are stowed here. Themes go to every machine; `keys.json` and `settings.json`
go to the Macs only, because Linux Herdr's keys are ctrl-based:

- `keys.json`: every key binding (Herdr's defaults plus Steve's alt keys, kept
  from the old terminal Herdr)
- `settings.json`: zoom, sounds, appearance, and the theme (Catppuccin Mocha in
  dark mode, Latte in light)
- `themes/`: Catppuccin Latte, Frappé, Macchiato and Mocha, each setting the
  terminal palette and every panel colour

Herdr writes `settings.json` itself (zoom keys), through the link. It does not
notice a change made to the file behind the link, so settings pulled from
another machine apply the next time Herdr starts. On a machine that had its own
copies, the first stow keeps them as `*.pre-dotfiles`.

Pick another theme in Herdr's theme picker, or
`herdr-app do app.theme --name catppuccin-frappe`. A pick made in the picker
stays on that machine (`layouts/.state/`).
