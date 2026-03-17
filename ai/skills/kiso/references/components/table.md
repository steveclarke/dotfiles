# Table

Data table with semantic HTML elements. Scrollable container wrapper with
7 sub-parts mapping to native table elements.

**Locals:** `css_classes:`, `**component_options`

**Sub-parts:** `kui(:table, :header)` (thead), `kui(:table, :body)` (tbody), `kui(:table, :footer)` (tfoot), `kui(:table, :row)` (tr), `kui(:table, :head)` (th), `kui(:table, :cell)` (td), `kui(:table, :caption)` (caption)

```erb
<%= kui(:table) do %>
  <%= kui(:table, :caption) { "A list of recent invoices." } %>
  <%= kui(:table, :header) do %>
    <%= kui(:table, :row) do %>
      <%= kui(:table, :head) { "Invoice" } %>
      <%= kui(:table, :head) { "Status" } %>
      <%= kui(:table, :head, css_classes: "text-right") { "Amount" } %>
    <% end %>
  <% end %>
  <%= kui(:table, :body) do %>
    <%= kui(:table, :row) do %>
      <%= kui(:table, :cell, css_classes: "font-medium") { "INV001" } %>
      <%= kui(:table, :cell) { "Paid" } %>
      <%= kui(:table, :cell, css_classes: "text-right") { "$250.00" } %>
    <% end %>
  <% end %>
<% end %>
```

**Theme modules:** `Kiso::Themes::Table`, `TableHeader`, `TableBody`, `TableFooter`, `TableRow`, `TableHead`, `TableCell`, `TableCaption` (`lib/kiso/themes/table.rb`)
