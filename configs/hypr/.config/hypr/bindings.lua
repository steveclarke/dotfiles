-- Personal keybinding overrides. Ported from bindings.conf on 2026-08-13 during
-- the Omarchy 4 upgrade, which converted Hyprland's config to Lua and left every
-- .conf file inert.
--
-- See current bindings: omarchy menu keybindings --print
--
-- Roughly half of the old bindings.conf became redundant: Quattro now ships
-- defaults for Terminal, Tmux, Browser, File manager, Passwords, ChatGPT, Grok,
-- YouTube, WhatsApp, Google Messages, X, X Post and Music TUI on the same keys.
-- Only the genuinely personal ones are kept below.

-- Applications not covered by Omarchy's defaults ----------------------------

o.bind("SUPER + SHIFT + M", "Music", "omarchy-launch-or-focus spotify")
o.bind("SUPER + SHIFT + N", "Editor", "omarchy-launch-editor")
o.bind("SUPER + SHIFT + D", "Docker", "omarchy-launch-tui lazydocker")
-- o.launch_sole wraps the command in uwsm-app itself, so pass it bare.
o.bind("SUPER + SHIFT + O", "Obsidian",
  o.launch_sole("^obsidian$", "obsidian -disable-gpu --enable-wayland-ime"))
o.bind("SUPER + SHIFT + E", "Email", o.launch_webapp("https://app.hey.com"))
o.bind("SUPER + SHIFT + P", "Google Photos",
  o.launch_webapp_sole("Google Photos", "https://photos.google.com/"))

-- SUPER + SHIFT + C is "Calendar" in Quattro's defaults. Unbind it first; this
-- key has meant VS Code here for years. Calendar is still on SUPER + CTRL + ALT + D.
hl.unbind("SUPER + SHIFT + C")
o.bind("SUPER + SHIFT + C", "VS Code", "setsid uwsm-app -- code")

-- Dictation ----------------------------------------------------------------
-- Right Alt push-to-talk is NOT bound here. It is handled by voxtype's own
-- evdev grabber ([hotkey] in ~/.config/voxtype/config.toml), because Hyprland
-- never fires a release event for a bare modifier. Do not try to move it here;
-- it has been tested twice and the release edge never arrives.
--
-- Omarchy's stock binds stay as they are: SUPER + CTRL + X toggles dictation,
-- SUPER + CTRL + V opens the clipboard manager to recover a lost transcript.
-- Stock F9 is unusable on the MX Keys, whose F-row needs Fn held.

-- Mouse --------------------------------------------------------------------
-- Middle-click drag to move floating windows, no keyboard needed.
o.bind("mouse:274", "Move window", hl.dsp.window.drag(), { mouse = true })

-- Numpad workspace switching -----------------------------------------------
-- Mirrors SUPER + top-row-N (an Omarchy default) so the top row and the numpad
-- are interchangeable. Workspace-to-monitor pinning is managed by hyprmoncfg,
-- not here.
--
-- Numpad keycodes are not sequential, hence the explicit table:
--   KP_1=87 KP_2=88 KP_3=89 / KP_4=83 KP_5=84 KP_6=85 / KP_7=79 KP_8=80 KP_9=81
local numpad = { 87, 88, 89, 83, 84, 85, 79, 80, 81 }
local labels = { "Main", "Dev", "Misc", "Prod", "DevL", "DB", "DevR", "Chat", "Music" }

for workspace, code in ipairs(numpad) do
  local key = "code:" .. tostring(code)
  o.bind("SUPER + " .. key,
    "Workspace " .. workspace .. " (" .. labels[workspace] .. ")",
    hl.dsp.focus({ workspace = tostring(workspace) }))
  o.bind("SUPER + SHIFT + " .. key,
    "Move to workspace " .. workspace,
    hl.dsp.window.move({ workspace = tostring(workspace) }))
end

-- Disarmed bindings --------------------------------------------------------

-- SUPER + SHIFT + SPACE toggles the top bar, and sits one Shift away from
-- SUPER + SPACE (the Omarchy menu), so it gets fat-fingered. Under Waybar this
-- cost a bar-less login that went undiagnosed for two months, because anything
-- restarting the bar in-session brought it back and hid the evidence. The same
-- hazard applies to Quattro's bar, so it stays disarmed. No replacement.
hl.unbind("SUPER + SHIFT + SPACE")
