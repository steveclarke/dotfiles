# InputGroup

Wraps an input with inline prefix/suffix addons. Provides a shared ring — child input strips its own border.

**Locals:** `css_classes:`, `**component_options`

**Sub-parts:** `kui(:input_group, :addon)` — accepts `align:` (start, end)

```erb
<%# Prefix text %>
<%= kui(:input_group) do %>
  <%= kui(:input_group, :addon) { "https://" } %>
  <%= kui(:input, type: :text, placeholder: "example.com") %>
<% end %>

<%# Suffix icon %>
<%= kui(:input_group) do %>
  <%= kui(:input, type: :search, placeholder: "Search...") %>
  <%= kui(:input_group, :addon, align: :end) do %>
    <svg>...</svg>
  <% end %>
<% end %>

<%# Both %>
<%= kui(:input_group) do %>
  <%= kui(:input_group, :addon) { "$" } %>
  <%= kui(:input, type: :number, placeholder: "0.00") %>
  <%= kui(:input_group, :addon, align: :end) { "USD" } %>
<% end %>
```

**Theme modules:** `Kiso::Themes::InputGroup`, `InputGroupAddon` (`lib/kiso/themes/input_group.rb`)
