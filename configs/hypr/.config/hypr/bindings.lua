-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Dictation keys from before Alt + Space and Right Alt became the defaults.
-- Remove these lines to give the keys back to applications.
if o.dictation_installed and o.dictation_installed() then
  o.bind("SUPER + CTRL + X", "Toggle dictation", "omarchy-dictation toggle")
  o.bind_hold("F9", "Start dictation (push-to-talk)", "omarchy-dictation start", "Stop dictation (push-to-talk)", "omarchy-dictation stop")
end

-- Caps Lock as a second push-to-talk key, beside Omarchy's Right Alt, so
-- either hand can dictate. Superwhisper's own hold key can't be Caps Lock.
-- code:66 is Caps Lock (evdev 58 + 8); input.lua turns its own job off.
if o.dictation_installed and o.dictation_installed() then
  o.bind_hold("code:66", "Start dictation (push-to-talk)", "omarchy-dictation start", "Stop dictation (push-to-talk)", "omarchy-dictation stop", { ignore_mods = true })
end

-- Monitor handoff ----------------------------------------------------------
-- The desk monitors are cabled to two machines. This brings them all HERE
-- over DDC/CI instead of menu-diving on the monitor OSD. It runs the Screen
-- Push plugin's engine (github.com/steveclarke/omarchy-screenpush); the desk,
-- its computers and input codes live in ~/.config/screenpush/desks.json,
-- written by the plugin's setup sheet, and are machine-specific.
--
-- One-way on purpose: each machine has its own keyboard now, so the key on
-- each side means "I am here, send me the screens". The earlier toggle was
-- for a Mac with no input device of its own.
--
-- It works blind - Hyprland still gets the keypress with no picture on
-- screen - which is what makes it a real recovery rather than a convenience.
-- It calls the engine directly, not the shell's IPC, so it still works while
-- the shell is dead or restarting. Absolute path: Hyprland launches binds
-- with a PATH that lacks ~/bin and may not go through a shell for "$HOME".
o.bind("SUPER + SHIFT + H", "Bring the monitors to this machine",
  os.getenv("HOME") .. "/.config/omarchy/plugins/io.github.steveclarke.screenpush/bin/screenpush switch this")

-- Snap Layouts plugin (github.com/n0rthstar88/omarchy-snap-layouts): open the
-- Windows 11-style layout picker for the focused window. Drag a floating
-- window to the top of the screen for the same picker.
o.bind("SUPER + Z", "Snap layouts", hl.dsp.event("io.github.n0rthstar88.snap-layouts:toggle"))
