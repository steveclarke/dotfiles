# ColorModeSelect

A three-way theme selector (Light, Dark, System) built on `kui(:select)`.
Allows users to choose explicit light/dark modes or follow the OS preference.

**Locals:** `size:` (sm/md), `css_classes:`, `**component_options`

**Defaults:** `size: :md`

```erb
<%= kui(:color_mode_select) %>
<%= kui(:color_mode_select, size: :sm) %>
```

**Theme module:** `Kiso::Themes::ColorModeSelect` (`lib/kiso/themes/color_mode_select.rb`)

**Stimulus:** `kiso--theme` controller (set mode via `kiso--select:change` event), `kiso--select` (from composed select)

**Composes:** `kui(:select)` with trigger, value, content, and three items (system/light/dark)

**Icons:** `kiso_component_icon(:monitor)`, `kiso_component_icon(:sun)`, `kiso_component_icon(:moon)` — swappable via `Kiso.config.icons`

**Requires:** `kiso_theme_script` in `<head>` for FOUC-free initial theme
