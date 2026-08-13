-- Auto-launch apps onto specific workspaces at login.
-- Ported from autostart.conf on 2026-08-13 (Omarchy 4 Lua cutover).
--
-- The "[workspace N silent]" prefix is a Hyprland exec rule and must come before
-- uwsm-app, so these use hl.exec_cmd with o.launch() rather than
-- o.launch_on_start(), which would put the prefix in the wrong position.
--
-- This lands the app on workspace N once at boot. Later manual launches of the
-- same app go to whatever workspace is active - no pinning. To pin every launch
-- (rarely wanted), add a separate o.window() rule instead.

hl.on("hyprland.start", function()
  -- Workspace 1 (Main)
  hl.exec_cmd("[workspace 1 silent] " .. o.launch("google-chrome-stable"))

  -- Workspace 4 (Prod)
  hl.exec_cmd("[workspace 4 silent] " .. o.launch("todoist"))
  hl.exec_cmd("[workspace 4 silent] " .. o.launch("slack"))
  hl.exec_cmd("[workspace 4 silent] " .. o.launch("nautilus --new-window"))
  hl.exec_cmd("[workspace 4 silent] " .. o.launch("xdg-terminal-exec"))
end)
