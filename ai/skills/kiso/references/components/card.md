# Card

Container component for grouping related content. Composed from sub-parts:
Header, Title, Description, Content, Footer.

**Locals:** `variant:` (outline, soft, subtle), `css_classes:`, `**component_options`

**Sub-parts:** `kui(:card, :header)`, `kui(:card, :title)`, `kui(:card, :description)`, `kui(:card, :content)`, `kui(:card, :footer)`

**Defaults:** `variant: :outline`

```erb
<%= kui(:card) do %>
  <%= kui(:card, :header) do %>
    <%= kui(:card, :title) { "Card Title" } %>
    <%= kui(:card, :description) { "Card description goes here." } %>
  <% end %>
  <%= kui(:card, :content) do %>
    <p>Your content here.</p>
  <% end %>
  <%= kui(:card, :footer) do %>
    <%= kui(:button, variant: :outline) { "Cancel" } %>
    <%= kui(:button) { "Save" } %>
  <% end %>
<% end %>
```

**Theme modules:** `Kiso::Themes::Card`, `CardHeader`, `CardTitle`, `CardDescription`, `CardContent`, `CardFooter` (`lib/kiso/themes/card.rb`)
