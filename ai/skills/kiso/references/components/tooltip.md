# Tooltip

Floating label that appears on hover/focus. Uses Floating UI for positioning and native `[popover="manual"]` for top-layer rendering.

**Locals:** `text:` (string), `kbds:` (array of keyboard shortcuts), `side:` (top/right/bottom/left), `align:` (center/start/end), `delay:` (ms), `ui: {}`, `css_classes:`, `**component_options`

**Sub-parts:** `kui(:tooltip, :trigger)`, `kui(:tooltip, :content)`

**Defaults:** `side: :top, align: :center, delay: 0`

```erb
<%# Simple text tooltip %>
<%= kui(:tooltip, text: "Add to library") do %>
  <%= kui(:button, variant: :outline) { "Hover me" } %>
<% end %>

<%# With keyboard shortcut %>
<%= kui(:tooltip, text: "Bold", kbds: ["⌘", "B"]) do %>
  <%= kui(:button, variant: :outline) { "B" } %>
<% end %>

<%# Positioning %>
<%= kui(:tooltip, text: "Right side", side: :right) do %>
  <%= kui(:button) { "Hover" } %>
<% end %>

<%# Rich content with sub-parts %>
<%= kui(:tooltip) do %>
  <%= kui(:tooltip, :trigger) do %>
    <%= kui(:button) { "Details" } %>
  <% end %>
  <%= kui(:tooltip, :content) do %>
    <p class="font-semibold">Custom content</p>
    <p>Rich tooltip with HTML.</p>
  <% end %>
<% end %>
```

**Stimulus:** `kiso--tooltip` controller. Manages show/hide lifecycle with delay and animation.

**Theme modules:** `Kiso::Themes::TooltipContent`, `TooltipArrow` (`lib/kiso/themes/tooltip.rb`)
