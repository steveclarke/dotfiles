# App

Root application wrapper. Sets `bg-background text-foreground antialiased` so
all children inherit the correct text color in dark mode. Wrap your page
content (or body) in this component.

**Locals:** `css_classes:`, `**component_options`

**Defaults:** none (no variants)

```erb
<%# Wrap page content for dark mode support %>
<%= kui(:app) do %>
  <%= kui(:header) do %>
    <!-- nav -->
  <% end %>
  <%= kui(:main) do %>
    <%= yield %>
  <% end %>
  <%= kui(:footer) do %>
    <!-- footer -->
  <% end %>
<% end %>
```

**Theme module:** `Kiso::Themes::App` (`lib/kiso/themes/layout.rb`)

No variants. Base classes: `bg-background text-foreground antialiased`.
