# Stats Card

Dashboard metric card for displaying KPIs. Specialized Card layout with
tighter spacing and sub-parts optimized for stats.

**Locals:** `variant:` (outline, soft, subtle), `css_classes:`, `**component_options`

**Sub-parts:** `kui(:stats_card, :header)`, `kui(:stats_card, :label)`, `kui(:stats_card, :value)`, `kui(:stats_card, :description)`

**Defaults:** `variant: :outline`

```erb
<%# Simple — label, value, description %>
<%= kui(:stats_card) do %>
  <%= kui(:stats_card, :label) { "Total Revenue" } %>
  <%= kui(:stats_card, :value) { "$45,231.89" } %>
  <%= kui(:stats_card, :description) { "+20.1% from last month" } %>
<% end %>

<%# With icon — use header to position label + icon %>
<%= kui(:stats_card) do %>
  <%= kui(:stats_card, :header) do %>
    <%= kui(:stats_card, :label) { "Total Revenue" } %>
    <svg class="size-4 text-muted-foreground">...</svg>
  <% end %>
  <%= kui(:stats_card, :value) { "$45,231.89" } %>
  <%= kui(:stats_card, :description) { "+20.1% from last month" } %>
<% end %>
```

**Theme modules:** `Kiso::Themes::StatsCard`, `StatsCardHeader`, `StatsCardLabel`, `StatsCardValue`, `StatsCardDescription` (`lib/kiso/themes/stats_card.rb`)

## Stats Grid

Responsive grid wrapper for stats cards.

**Locals:** `columns:` (2, 3, 4), `css_classes:`, `**component_options`

**Defaults:** `columns: 4`

```erb
<%= kui(:stats_grid, columns: 4) do %>
  <%= kui(:stats_card) do %>...<%  end %>
  <%= kui(:stats_card) do %>...<%  end %>
  <%= kui(:stats_card) do %>...<%  end %>
  <%= kui(:stats_card) do %>...<%  end %>
<% end %>
```

**Theme module:** `Kiso::Themes::StatsGrid` (`lib/kiso/themes/stats_card.rb`)
