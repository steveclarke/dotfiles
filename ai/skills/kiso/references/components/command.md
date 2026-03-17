# Command

Command menu for search and quick actions with filtering, keyboard navigation, and grouped results.

**Locals (root):** `css_classes:`, `**component_options`

**Locals (input):** `placeholder:`, `css_classes:`, `**component_options`

**Locals (group):** `heading:`, `css_classes:`, `**component_options`

**Locals (item):** `value:`, `disabled:` (false), `css_classes:`, `**component_options`

**Locals (dialog):** `shortcut:` ("k"), `css_classes:`, `**component_options`

**Sub-parts:** input, list, empty, group, item, separator, shortcut, dialog

**Stimulus controllers:** `kiso--command` (search/filter, keyboard nav), `kiso--command-dialog` (Cmd+K modal)

```erb
<%# Inline command palette %>
<%= kui(:command, css_classes: "max-w-sm rounded-lg ring ring-inset ring-border") do %>
  <%= kui(:command, :input, placeholder: "Type a command or search...") %>
  <%= kui(:command, :list) do %>
    <%= kui(:command, :empty) { "No results found." } %>
    <%= kui(:command, :group, heading: "Suggestions") do %>
      <%= kui(:command, :item, value: "calendar") do %>
        <%= kiso_icon("calendar") %>
        <span>Calendar</span>
      <% end %>
      <%= kui(:command, :item, value: "search") do %>
        <%= kiso_icon("search") %>
        <span>Search</span>
        <%= kui(:command, :shortcut) { "⌘K" } %>
      <% end %>
    <% end %>
  <% end %>
<% end %>

<%# Dialog mode (Cmd+K) %>
<%= kui(:command, :dialog) do %>
  <%= kui(:command) do %>
    <%= kui(:command, :input, placeholder: "Search...") %>
    <%= kui(:command, :list) do %>
      <%= kui(:command, :empty) { "No results found." } %>
      <%= kui(:command, :group, heading: "Suggestions") do %>
        <%= kui(:command, :item, value: "calendar") { "Calendar" } %>
      <% end %>
    <% end %>
  <% end %>
<% end %>

<%# Disabled item %>
<%= kui(:command, :item, value: "calculator", disabled: true) do %>
  <%= kiso_icon("calculator") %>
  <span>Calculator</span>
<% end %>
```

**Theme modules:** `Kiso::Themes::Command`, `CommandInputWrapper`, `CommandInput`, `CommandList`, `CommandEmpty`, `CommandGroup`, `CommandGroupHeading`, `CommandItem`, `CommandSeparator`, `CommandShortcut` (`lib/kiso/themes/command.rb`)
