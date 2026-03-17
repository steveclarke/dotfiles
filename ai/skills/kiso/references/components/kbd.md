# Kbd

Displays a keyboard key or shortcut inline. Uses the semantic `<kbd>` HTML
element.

**Locals:** `size:` (sm/md/lg), `css_classes:`, `**component_options`

**Defaults:** `size: :md`

**Sub-parts:** `:group` (wraps multiple Kbd elements)

```erb
<%# Single key %>
<%= kui(:kbd) { "⌘K" } %>

<%# Modifier symbols grouped %>
<%= kui(:kbd, :group) do %>
  <%= kui(:kbd) { "⌘" } %>
  <%= kui(:kbd) { "⇧" } %>
  <%= kui(:kbd) { "⌥" } %>
<% end %>

<%# Key combination with separator %>
<%= kui(:kbd, :group) do %>
  <%= kui(:kbd) { "Ctrl" } %>
  <span>+</span>
  <%= kui(:kbd) { "B" } %>
<% end %>

<%# Inside a button %>
<%= kui(:button, variant: :outline) do %>
  Accept <%= kui(:kbd) { "⏎" } %>
<% end %>

<%# Inside an input group %>
<%= kui(:input_group, :addon, align: :end) do %>
  <%= kui(:kbd) { "⌘" } %>
  <%= kui(:kbd) { "K" } %>
<% end %>

<%# Sizes %>
<%= kui(:kbd, size: :sm) { "A" } %>
<%= kui(:kbd, size: :md) { "B" } %>
<%= kui(:kbd, size: :lg) { "C" } %>
```

**Theme module:** `Kiso::Themes::Kbd`, `Kiso::Themes::KbdGroup` (`lib/kiso/themes/kbd.rb`)
