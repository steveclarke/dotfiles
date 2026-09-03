-- Change the default Omarchy look'n'feel.
-- Ported from looknfeel.conf on 2026-08-13 (Omarchy 4 Lua cutover). Everything
-- else in that file was commented out, so this one setting is the whole of it.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
hl.config({
  layout = {
    -- Avoid overly wide single-window layouts on these 4K screens.
    single_window_aspect_ratio = { 8, 9 },
  },
})

-- Close the gap between the bar and the top row of windows. The bar is
-- transparent, so a top gap reads as bar padding rather than as a gap.
hl.config({
  general = {
    gaps_out = { top = 0, right = 10, bottom = 10, left = 10 },
  },
})
