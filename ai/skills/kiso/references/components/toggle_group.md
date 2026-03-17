# ToggleGroup

A group of toggle buttons with single or multiple selection mode.
Container renders a `<div>` with `role="group"`, items render `<button>` elements.

**Locals (ToggleGroup):** `type:` (single, multiple), `variant:` (default, outline), `size:` (sm, default, lg), `css_classes:`, `**component_options`

**Locals (Item):** `value:`, `variant:` (default, outline), `size:` (sm, default, lg), `pressed:` (true/false), `css_classes:`, `**component_options`

**Defaults:** `type: :single, variant: :default, size: :default`

**Sub-parts:** `item`

```erb
<%# Single selection %>
<%= kui(:toggle_group, type: :single) do %>
  <%= kui(:toggle_group, :item, value: "left", "aria-label": "Align left") do %>
    <%= kiso_icon("align-left") %>
  <% end %>
  <%= kui(:toggle_group, :item, value: "center", "aria-label": "Align center") do %>
    <%= kiso_icon("align-center") %>
  <% end %>
  <%= kui(:toggle_group, :item, value: "right", "aria-label": "Align right") do %>
    <%= kiso_icon("align-right") %>
  <% end %>
<% end %>

<%# Multiple selection %>
<%= kui(:toggle_group, type: :multiple) do %>
  <%= kui(:toggle_group, :item, value: "bold", "aria-label": "Bold") do %>
    <%= kiso_icon("bold") %>
  <% end %>
  <%= kui(:toggle_group, :item, value: "italic", "aria-label": "Italic") do %>
    <%= kiso_icon("italic") %>
  <% end %>
<% end %>

<%# Outline variant %>
<%= kui(:toggle_group, type: :single, variant: :outline) do %>
  <%= kui(:toggle_group, :item, value: "a", variant: :outline, "aria-label": "A") do %>
    <%= kiso_icon("align-left") %>
  <% end %>
<% end %>
```

**Theme modules:** `Kiso::Themes::ToggleGroup`, `Kiso::Themes::ToggleGroupItem` (`lib/kiso/themes/toggle.rb`, `lib/kiso/themes/toggle_group.rb`)

**Stimulus:** `kiso--toggle-group` controller manages single/multi selection, arrow key navigation, dispatches `change` event.
