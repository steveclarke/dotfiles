# Select

Custom accessible select dropdown with keyboard navigation and form integration.
Not a native `<select>` -- uses a styled trigger button and dropdown panel.

**Locals (root):** `name:` (form field name), `css_classes:`, `**component_options`

**Locals (trigger):** `size:` (sm, md), `disabled:` (true/false), `css_classes:`, `**component_options`

**Defaults:** `size: :md, disabled: false`

**Locals (value):** `placeholder:` (placeholder text), `css_classes:`, `**component_options`

**Locals (item):** `value:` (required, the option value), `disabled:` (true/false), `css_classes:`, `**component_options`

**Sub-parts:** trigger, value, content, group, label, item, separator

**Stimulus controller:** `kiso--select` (registered via `KisoUi.start()`)

```erb
<%# Basic usage %>
<%= kui(:select, name: :fruit) do %>
  <%= kui(:select, :trigger) do %>
    <%= kui(:select, :value, placeholder: "Select a fruit") %>
  <% end %>
  <%= kui(:select, :content) do %>
    <%= kui(:select, :group) do %>
      <%= kui(:select, :label) { "Fruits" } %>
      <%= kui(:select, :item, value: "apple") { "Apple" } %>
      <%= kui(:select, :item, value: "banana") { "Banana" } %>
    <% end %>
  <% end %>
<% end %>

<%# Groups with separator %>
<%= kui(:select, name: :food) do %>
  <%= kui(:select, :trigger) do %>
    <%= kui(:select, :value, placeholder: "Pick one...") %>
  <% end %>
  <%= kui(:select, :content) do %>
    <%= kui(:select, :group) do %>
      <%= kui(:select, :label) { "Fruits" } %>
      <%= kui(:select, :item, value: "apple") { "Apple" } %>
    <% end %>
    <%= kui(:select, :separator) %>
    <%= kui(:select, :group) do %>
      <%= kui(:select, :label) { "Vegetables" } %>
      <%= kui(:select, :item, value: "carrot") { "Carrot" } %>
    <% end %>
  <% end %>
<% end %>

<%# With Field %>
<%= kui(:field) do %>
  <%= kui(:field, :label, for: :language) { "Language" } %>
  <%= kui(:select, name: :language) do %>
    <%= kui(:select, :trigger) do %>
      <%= kui(:select, :value, placeholder: "Select a language") %>
    <% end %>
    <%= kui(:select, :content) do %>
      <%= kui(:select, :group) do %>
        <%= kui(:select, :item, value: "ruby") { "Ruby" } %>
        <%= kui(:select, :item, value: "python") { "Python" } %>
      <% end %>
    <% end %>
  <% end %>
  <%= kui(:field, :description) { "Choose your preferred language." } %>
<% end %>

<%# Disabled items %>
<%= kui(:select, :item, value: "grapes", disabled: true) { "Grapes" } %>

<%# Small size trigger %>
<%= kui(:select, :trigger, size: :sm) do %>
  <%= kui(:select, :value, placeholder: "Pick one...") %>
<% end %>
```

**Theme modules:** `Kiso::Themes::SelectTrigger`, `SelectContent`, `SelectItem`, `SelectLabel`, `SelectSeparator`, `SelectGroup`, `SelectValue`, `SelectItemIndicator` (`lib/kiso/themes/select.rb`)
