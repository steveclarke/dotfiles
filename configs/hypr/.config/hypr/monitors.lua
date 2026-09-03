-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all
--
-- The actual layout is NOT written here. It is managed by hyprmoncfg, which
-- keys each panel by make/model/serial rather than DP port and re-applies the
-- matching profile automatically on plug/unplug:
--
--   hyprmoncfg              open the TUI: drag to arrange, `s` to save
--   hyprmoncfg save <name>  capture the current live layout as a profile
--   hyprmoncfg profiles     list saved profiles
--
-- This file holds only the things that must survive hyprmoncfg overwriting its
-- own output, since it rewrites its target file wholesale.

local omarchy_gdk_scale = 2

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Catch-all for any panel that has no profile rule yet. Specific rules win over
-- this one, so it cannot override the generated layout below - it just means a
-- newly attached monitor lights up instead of staying blank.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

-- The generated layout is NOT loaded here. hyprmoncfg maintains its own
-- include at the end of hyprland.lua (see `hyprmoncfg doctor`), and loading it
-- from here as well just applied the same rules twice.
