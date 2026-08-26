-- Personal input overrides. Ported from input.conf on 2026-08-13 (Omarchy 4
-- Lua cutover). Only the settings that were actually uncommented in the old
-- file are carried over.
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
  input = {
    kb_layout = "us",

    -- Caps Lock is disabled as a key in its own right so it can be bound to
    -- dictation toggle in bindings.lua. Compose moves to the Menu key.
    -- See docs/dictation.md in the hugo repo before changing this.
    kb_options = "caps:none,compose:menu",

    -- Faster key repeat than the default.
    repeat_rate = 40,
    repeat_delay = 600,

    -- Numlock on at login, which the numpad workspace bindings depend on.
    numlock_by_default = true,

    touchpad = {
      scroll_factor = 0.4,
    },
  },
})

-- Scroll nicely in the terminal.
o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
