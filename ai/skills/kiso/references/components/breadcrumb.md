# Breadcrumb

Navigation breadcrumb trail showing the current page's location in the site hierarchy. Pure HTML/CSS, no JavaScript.

**Locals:** `css_classes:`, `**component_options`

**Sub-parts:** `kui(:breadcrumb, :list)`, `kui(:breadcrumb, :item)`, `kui(:breadcrumb, :link)`, `kui(:breadcrumb, :page)`, `kui(:breadcrumb, :separator)`, `kui(:breadcrumb, :ellipsis)`

**Defaults:** None (no variant axes).

```erb
<%= kui(:breadcrumb) do %>
  <%= kui(:breadcrumb, :list) do %>
    <%= kui(:breadcrumb, :item) do %>
      <%= kui(:breadcrumb, :link, href: "/") { "Home" } %>
    <% end %>
    <%= kui(:breadcrumb, :separator) %>
    <%= kui(:breadcrumb, :item) do %>
      <%= kui(:breadcrumb, :link, href: "/components") { "Components" } %>
    <% end %>
    <%= kui(:breadcrumb, :separator) %>
    <%= kui(:breadcrumb, :item) do %>
      <%= kui(:breadcrumb, :page) { "Breadcrumb" } %>
    <% end %>
  <% end %>
<% end %>
```

**Ellipsis** for truncated segments:

```erb
<%= kui(:breadcrumb, :item) do %>
  <%= kui(:breadcrumb, :ellipsis) %>
<% end %>
```

**Custom separator** (pass a block):

```erb
<%= kui(:breadcrumb, :separator) do %>
  <%= kiso_icon "slash", class: "size-3.5" %>
<% end %>
```

**Theme modules:** `Kiso::Themes::Breadcrumb`, `BreadcrumbList`, `BreadcrumbItem`, `BreadcrumbLink`, `BreadcrumbPage`, `BreadcrumbSeparator`, `BreadcrumbEllipsis` (`lib/kiso/themes/breadcrumb.rb`)
