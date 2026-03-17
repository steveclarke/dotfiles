# DropdownMenu

Popover-based menu with keyboard navigation, nested sub-menus, checkbox/radio items. 14 sub-parts matching shadcn exports.

**Locals (item):** `variant:` (default/destructive), `inset:` (true/false), `disabled:` (true/false), `css_classes:`, `**component_options`

**Defaults (item):** `variant: :default, inset: false, disabled: false`

**Locals (checkbox_item):** `checked:` (true/false), `disabled:` (true/false), `css_classes:`, `**component_options`

**Locals (radio_item):** `value:` (required), `checked:` (true/false), `disabled:` (true/false), `css_classes:`, `**component_options`

**Locals (label):** `inset:` (true/false), `css_classes:`, `**component_options`

**Locals (sub_trigger):** `inset:` (true/false), `css_classes:`, `**component_options`

**Locals (radio_group):** `value:` (current value), `css_classes:`, `**component_options`

**Sub-parts:** trigger, content, item, checkbox_item, radio_group, radio_item, label, separator, shortcut, group, sub, sub_trigger, sub_content

**Stimulus controller:** `kiso--dropdown-menu` (registered via `KisoUi.start()`)

```erb
<%# Basic usage %>
<%= kui(:dropdown_menu) do %>
  <%= kui(:dropdown_menu, :trigger) do %>
    <%= kui(:button, variant: :outline) { "Open" } %>
  <% end %>
  <%= kui(:dropdown_menu, :content) do %>
    <%= kui(:dropdown_menu, :label) { "My Account" } %>
    <%= kui(:dropdown_menu, :separator) %>
    <%= kui(:dropdown_menu, :group) do %>
      <%= kui(:dropdown_menu, :item) { "Profile" } %>
      <%= kui(:dropdown_menu, :item) { "Settings" } %>
    <% end %>
  <% end %>
<% end %>

<%# With icons and shortcuts %>
<%= kui(:dropdown_menu, :item) do %>
  <%= kiso_icon("user") %>
  Profile
  <%= kui(:dropdown_menu, :shortcut) { "⇧⌘P" } %>
<% end %>

<%# Destructive item %>
<%= kui(:dropdown_menu, :item, variant: :destructive) do %>
  <%= kiso_icon("trash") %>
  Delete
<% end %>

<%# Checkbox items %>
<%= kui(:dropdown_menu, :checkbox_item, checked: true) do %>
  Status Bar
<% end %>

<%# Radio group %>
<%= kui(:dropdown_menu, :radio_group, value: "bottom") do %>
  <%= kui(:dropdown_menu, :radio_item, value: "top") { "Top" } %>
  <%= kui(:dropdown_menu, :radio_item, value: "bottom", checked: true) { "Bottom" } %>
<% end %>

<%# Sub-menu %>
<%= kui(:dropdown_menu, :sub) do %>
  <%= kui(:dropdown_menu, :sub_trigger) { "More options" } %>
  <%= kui(:dropdown_menu, :sub_content) do %>
    <%= kui(:dropdown_menu, :item) { "Option A" } %>
    <%= kui(:dropdown_menu, :item) { "Option B" } %>
  <% end %>
<% end %>

<%# Disabled item %>
<%= kui(:dropdown_menu, :item, disabled: true) { "API" } %>
```

**Theme modules:** `Kiso::Themes::DropdownMenu`, `DropdownMenuTrigger`, `DropdownMenuContent`, `DropdownMenuItem`, `DropdownMenuCheckboxItem`, `DropdownMenuRadioGroup`, `DropdownMenuRadioItem`, `DropdownMenuLabel`, `DropdownMenuSeparator`, `DropdownMenuShortcut`, `DropdownMenuGroup`, `DropdownMenuSub`, `DropdownMenuSubTrigger`, `DropdownMenuSubContent` (`lib/kiso/themes/dropdown_menu.rb`)
