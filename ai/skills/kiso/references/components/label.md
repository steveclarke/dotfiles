# Label

Styled `<label>` element for form controls. Automatically dims when the associated control is disabled.

**Locals:** `css_classes:`, `**component_options`

```erb
<%= kui(:label, for: "email") { "Email address" } %>

<%# Inside a Field (most common usage) %>
<%= kui(:field) do %>
  <%= kui(:field, :label) { "Name" } %>
  <%= kui(:input, name: "name") %>
<% end %>
```

**Theme module:** `Kiso::Themes::Label` (`lib/kiso/themes/label.rb`)
