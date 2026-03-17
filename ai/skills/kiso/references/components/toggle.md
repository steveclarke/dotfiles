# Toggle

A two-state button that can be toggled on or off. Uses a `<button>` element
with `aria-pressed` and `data-state` attributes.

**Locals:** `variant:` (default, outline), `size:` (sm, default, lg), `pressed:` (true/false), `css_classes:`, `**component_options`

**Defaults:** `variant: :default, size: :default, pressed: false`

```erb
<%= kui(:toggle, "aria-label": "Toggle bold") do %>
  <%= kiso_icon("bold") %>
<% end %>

<%= kui(:toggle, variant: :outline, "aria-label": "Toggle italic") do %>
  <%= kiso_icon("italic") %>
<% end %>

<%= kui(:toggle, pressed: true, "aria-label": "Bold") do %>
  <%= kiso_icon("bold") %>
<% end %>

<%# With text %>
<%= kui(:toggle, "aria-label": "Toggle italic") do %>
  <%= kiso_icon("italic") %>
  Italic
<% end %>
```

**Theme modules:** `Kiso::Themes::Toggle` (`lib/kiso/themes/toggle.rb`)

**Stimulus:** `kiso--toggle` controller toggles `data-state` on click.
