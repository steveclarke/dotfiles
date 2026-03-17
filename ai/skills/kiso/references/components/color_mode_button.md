# ColorModeButton

A toggle button that switches between light and dark mode. Displays a sun
icon in light mode and a moon icon in dark mode.

**Locals:** `size:` (sm/md/lg), `css_classes:`, `**component_options`

**Defaults:** `size: :md`

```erb
<%= kui(:color_mode_button) %>
<%= kui(:color_mode_button, size: :sm) %>
<%= kui(:color_mode_button, size: :lg) %>
```

**Theme module:** `Kiso::Themes::ColorModeButton` (`lib/kiso/themes/color_mode_button.rb`)

**CSS:** `app/assets/tailwind/kiso/color-mode.css` — icon visibility toggling via `.dark` class

**Stimulus:** `kiso--theme` controller (toggle dark mode, persist to localStorage + cookie)

**Icons:** `kiso_component_icon(:sun)` and `kiso_component_icon(:moon)` — swappable via `Kiso.config.icons`

**Requires:** `kiso_theme_script` in `<head>` for FOUC-free initial theme
