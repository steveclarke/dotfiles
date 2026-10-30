# Herdr app config

The Herdr desktop app (`herdr-app`) owns `~/.config/herdr-app` and rewrites most
of it on every start, so only files Herdr never writes are stowed here: the
Catppuccin themes in `themes/` (Latte, Frappé, Macchiato, Mocha). Each sets the
terminal palette and every panel colour (sidebars and bars on mantle, terminals
on base, mauve accent).

Pick one in Herdr's theme picker, or `herdr-app do app.theme --name catppuccin-mocha`.
The terminal Herdr (`configs/herdr`) has Catppuccin built in.
