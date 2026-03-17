# Combobox

Autocomplete input with a searchable dropdown of suggestions. Supports single
and multi-select (with chips). Requires the `kiso--combobox` Stimulus controller.

**Locals (root):** `name:` (form field name), `multiple:` (true/false), `css_classes:`, `**component_options`

**Defaults:** `name: nil, multiple: false`

**Locals (input):** `placeholder:`, `disabled:` (true/false), `css_classes:`, `**component_options`

**Locals (item):** `value:` (required), `disabled:` (true/false), `css_classes:`, `**component_options`

**Locals (chip):** `value:` (required), `removable:` (true/false), `css_classes:`, `**component_options`

**Locals (chips_input):** `placeholder:`, `disabled:` (true/false), `css_classes:`, `**component_options`

**Sub-parts:** input, content, list, item, empty, group, label, separator, chips, chip, chips_input

**Stimulus controller:** `kiso--combobox` (registered via `KisoUi.start()`)

```erb
<%# Single select %>
<%= kui(:combobox, name: :framework) do %>
  <%= kui(:combobox, :input, placeholder: "Select a framework") %>
  <%= kui(:combobox, :content) do %>
    <%= kui(:combobox, :list) do %>
      <%= kui(:combobox, :item, value: "rails") { "Rails" } %>
      <%= kui(:combobox, :item, value: "django") { "Django" } %>
      <%= kui(:combobox, :item, value: "laravel") { "Laravel" } %>
      <%= kui(:combobox, :empty) { "No frameworks found." } %>
    <% end %>
  <% end %>
<% end %>

<%# Multi-select with chips %>
<%= kui(:combobox, name: "tags[]", multiple: true) do %>
  <%= kui(:combobox, :chips) do %>
    <%= kui(:combobox, :chip, value: "rails") { "Rails" } %>
    <%= kui(:combobox, :chips_input, placeholder: "Add tag...") %>
  <% end %>
  <%= kui(:combobox, :content) do %>
    <%= kui(:combobox, :list) do %>
      <%= kui(:combobox, :item, value: "rails") { "Rails" } %>
      <%= kui(:combobox, :item, value: "django") { "Django" } %>
      <%= kui(:combobox, :empty) { "No tags found." } %>
    <% end %>
  <% end %>
<% end %>

<%# Groups with separators %>
<%= kui(:combobox, name: :timezone) do %>
  <%= kui(:combobox, :input, placeholder: "Select a timezone") %>
  <%= kui(:combobox, :content) do %>
    <%= kui(:combobox, :list) do %>
      <%= kui(:combobox, :group) do %>
        <%= kui(:combobox, :label) { "Americas" } %>
        <%= kui(:combobox, :item, value: "new-york") { "(GMT-5) New York" } %>
      <% end %>
      <%= kui(:combobox, :separator) %>
      <%= kui(:combobox, :group) do %>
        <%= kui(:combobox, :label) { "Europe" } %>
        <%= kui(:combobox, :item, value: "london") { "(GMT+0) London" } %>
      <% end %>
      <%= kui(:combobox, :empty) { "No timezones found." } %>
    <% end %>
  <% end %>
<% end %>

<%# With Field %>
<%= kui(:field) do %>
  <%= kui(:field, :label, for: :framework) { "Framework" } %>
  <%= kui(:combobox, name: :framework) do %>
    <%= kui(:combobox, :input, placeholder: "Search frameworks...") %>
    <%= kui(:combobox, :content) do %>
      <%= kui(:combobox, :list) do %>
        <%= kui(:combobox, :item, value: "rails") { "Rails" } %>
        <%= kui(:combobox, :item, value: "django") { "Django" } %>
      <% end %>
    <% end %>
  <% end %>
  <%= kui(:field, :description) { "Choose your preferred framework." } %>
<% end %>
```

**Theme modules:** `Kiso::Themes::Combobox`, `ComboboxInput`, `ComboboxContent`, `ComboboxList`, `ComboboxItem`, `ComboboxItemIndicator`, `ComboboxGroup`, `ComboboxLabel`, `ComboboxEmpty`, `ComboboxSeparator`, `ComboboxChips`, `ComboboxChip`, `ComboboxChipsInput` (`lib/kiso/themes/combobox.rb`)
