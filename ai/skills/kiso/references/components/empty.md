# Empty

Centered placeholder for empty content areas (no data, no results, empty uploads).
Composed from sub-parts like Card. No color axis.

**Locals:** `css_classes:`, `**component_options`

**Sub-parts:** `kui(:empty, :header)`, `kui(:empty, :media)`, `kui(:empty, :title)`, `kui(:empty, :description)`, `kui(:empty, :actions)`, `kui(:empty, :content)`

**Media variants:** `variant:` (default, icon) — `:icon` renders a muted rounded container for SVG icons.

```erb
<%= kui(:empty) do %>
  <%= kui(:empty, :header) do %>
    <%= kui(:empty, :media, variant: :icon) do %>
      <svg>...</svg>
    <% end %>
    <%= kui(:empty, :title) { "No Projects Yet" } %>
    <%= kui(:empty, :description) { "Get started by creating your first project." } %>
  <% end %>
  <%= kui(:empty, :actions) do %>
    <%= kui(:button) { "Create Project" } %>
    <%= kui(:button, variant: :outline) { "Import Project" } %>
  <% end %>
<% end %>
```

**Theme modules:** `Kiso::Themes::Empty`, `EmptyHeader`, `EmptyMedia`, `EmptyTitle`, `EmptyDescription`, `EmptyActions`, `EmptyContent` (`lib/kiso/themes/empty.rb`)
