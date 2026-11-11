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

-- uber-om desk: three Dell S2725QC, left to right, so the mouse crosses to the
-- right screen. Positions assume the 1.5 scale Omarchy picks for these 4K
-- screens (2560 logical pixels wide each).
hl.monitor({ output = "desc:Dell Inc. DELL S2725QC 5C4G464", mode = "3840x2160@120", position = "0x0", scale = omarchy_monitor_scale })
hl.monitor({ output = "desc:Dell Inc. DELL S2725QC 154G464", mode = "3840x2160@120", position = "2560x0", scale = omarchy_monitor_scale })
hl.monitor({ output = "desc:Dell Inc. DELL S2725QC H04G464", mode = "3840x2160@120", position = "5120x0", scale = omarchy_monitor_scale })
