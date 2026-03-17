# Popover

Floating panel anchored to a trigger element. Foundation for DropdownMenu, Combobox, and DatePicker.

**Locals (root):** `css_classes:`, `**component_options`

**Locals (content):** `align:` (start, center, end), `css_classes:`, `**component_options`

**Defaults:** `align: :center`

**Sub-parts:** trigger, content, anchor, header, title, description

**Stimulus controller:** `kiso--popover` (registered via `KisoUi.start()`)

```erb
<%# Basic usage with header %>
<%= kui(:popover) do %>
  <%= kui(:popover, :trigger) do %>
    <%= kui(:button, variant: :outline) { "Open Popover" } %>
  <% end %>
  <%= kui(:popover, :content, align: :start) do %>
    <%= kui(:popover, :header) do %>
      <%= kui(:popover, :title) { "Dimensions" } %>
      <%= kui(:popover, :description) { "Set the dimensions for the layer." } %>
    <% end %>
  <% end %>
<% end %>

<%# With form fields %>
<%= kui(:popover) do %>
  <%= kui(:popover, :trigger) do %>
    <%= kui(:button, variant: :outline) { "Open Popover" } %>
  <% end %>
  <%= kui(:popover, :content, css_classes: "w-64", align: :start) do %>
    <%= kui(:popover, :header) do %>
      <%= kui(:popover, :title) { "Dimensions" } %>
      <%= kui(:popover, :description) { "Set the dimensions for the layer." } %>
    <% end %>
    <div class="mt-4 grid gap-4">
      <%= kui(:field, orientation: :horizontal) do %>
        <%= kui(:field, :label, for: "width", css_classes: "w-1/2") { "Width" } %>
        <%= kui(:input, id: "width", value: "100%") %>
      <% end %>
    </div>
  <% end %>
<% end %>

<%# Alignment options %>
<%= kui(:popover, :content, align: :start) do %>...<%end %>
<%= kui(:popover, :content, align: :center) do %>...<%end %>
<%= kui(:popover, :content, align: :end) do %>...<%end %>

<%# With anchor (alternate positioning reference) %>
<%= kui(:popover) do %>
  <%= kui(:popover, :anchor) do %>
    <div>Position relative to this</div>
  <% end %>
  <%= kui(:popover, :trigger) do %>
    <%= kui(:button) { "Open" } %>
  <% end %>
  <%= kui(:popover, :content) do %>
    <p>Content here</p>
  <% end %>
<% end %>
```

**Theme modules:** `Kiso::Themes::PopoverContent`, `PopoverHeader`, `PopoverTitle`, `PopoverDescription` (`lib/kiso/themes/popover.rb`)
