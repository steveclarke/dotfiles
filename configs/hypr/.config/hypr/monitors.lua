-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })

-- uber-om desk: which Dell is left and which is right, so the mouse crosses to
-- the right screen. Scale stays Omarchy's default. Kept during the 2026-11
-- vanilla trial; see infrastructure/omarchy/set-aside-2026-11.md in hugo.
hl.monitor({ output = "desc:Dell Inc. DELL S2721QS D0X1M43", mode = "preferred", position = "0x0", scale = omarchy_monitor_scale })
hl.monitor({ output = "desc:Dell Inc. DELL S2721QS 3QL0M43", mode = "preferred", position = "auto-right", scale = omarchy_monitor_scale })
