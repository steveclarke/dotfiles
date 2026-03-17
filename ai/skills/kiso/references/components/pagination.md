# Pagination

Page navigation with previous/next links, page numbers, and ellipsis. Pure HTML/CSS, no JavaScript.

**Locals:** `css_classes:`, `**component_options`

**Sub-parts:** `kui(:pagination, :content)`, `kui(:pagination, :item)`, `kui(:pagination, :link)`, `kui(:pagination, :previous)`, `kui(:pagination, :next)`, `kui(:pagination, :ellipsis)`

**Defaults:** None (no variant axes). Link has `active:` boolean.

```erb
<%= kui(:pagination) do %>
  <%= kui(:pagination, :content) do %>
    <%= kui(:pagination, :item) do %>
      <%= kui(:pagination, :previous, href: "/page/1") %>
    <% end %>
    <%= kui(:pagination, :item) do %>
      <%= kui(:pagination, :link, href: "/page/1") { "1" } %>
    <% end %>
    <%= kui(:pagination, :item) do %>
      <%= kui(:pagination, :link, href: "/page/2", active: true) { "2" } %>
    <% end %>
    <%= kui(:pagination, :item) do %>
      <%= kui(:pagination, :ellipsis) %>
    <% end %>
    <%= kui(:pagination, :item) do %>
      <%= kui(:pagination, :link, href: "/page/10") { "10" } %>
    <% end %>
    <%= kui(:pagination, :item) do %>
      <%= kui(:pagination, :next, href: "/page/3") %>
    <% end %>
  <% end %>
<% end %>
```

**Link locals:** `href:`, `active:` (boolean, sets `aria-current="page"` and outline style), `css_classes:`

**Previous/Next locals:** `href:`, `active:` (boolean, controls visibility), `css_classes:`. Text is responsive — hidden on mobile via `sr-only sm:not-sr-only`.

**Theme modules:** `Kiso::Themes::Pagination`, `PaginationContent`, `PaginationItem`, `PaginationLink`, `PaginationPrevious`, `PaginationNext`, `PaginationEllipsis` (`lib/kiso/themes/pagination.rb`)
