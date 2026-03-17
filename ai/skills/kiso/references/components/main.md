# Main

Semantic `<main>` element for primary page content. Uses `flex-1` to fill
remaining vertical space, so it needs a flex column parent (like App).

**Locals:** `css_classes:`, `**component_options`

**Defaults:** none (no variants)

```erb
<%= kui(:app) do %>
  <%= kui(:header) do %>
    <!-- nav -->
  <% end %>
  <%= kui(:main) do %>
    <%= kui(:container) do %>
      <%= yield %>
    <% end %>
  <% end %>
  <%= kui(:footer) do %>
    <!-- footer -->
  <% end %>
<% end %>
```

**Theme module:** `Kiso::Themes::Main` (`lib/kiso/themes/layout.rb`)

No variants. Base class: `flex-1`. Requires a flex column parent to expand
and fill available space.
