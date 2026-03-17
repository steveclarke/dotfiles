# Switch

A binary toggle for on/off states. Uses a native `<input type="checkbox">` with `role="switch"` inside a `<label>` that doubles as the track.

**Locals:** `color:` (7 colors), `size:` (sm, md), `checked:` (true/false), `css_classes:`, `**component_options`

**Defaults:** `color: :primary, size: :md`

```erb
<%= kui(:switch) %>
<%= kui(:switch, color: :success, checked: true) %>
<%= kui(:switch, size: :sm) %>

<%# With Field %>
<%= kui(:field, orientation: :horizontal) do %>
  <%= kui(:switch, id: :dark_mode, name: :dark_mode, value: "1") %>
  <%= kui(:field, :label, for: :dark_mode) { "Dark mode" } %>
<% end %>
```

**Theme modules:** `Kiso::Themes::SwitchTrack`, `SwitchThumb` (`lib/kiso/themes/switch.rb`)
