# SelectNative

A styled native `<select>` element with chevron icon overlay. No JavaScript.

**Locals:** `variant:` (outline/soft/ghost), `size:` (sm/md/lg), `disabled:`, `css_classes:`, `**component_options`

**Sub-parts:** `kui(:select_native)` only — options are plain `<option>` elements yielded in the block

**Defaults:** `variant: :outline`, `size: :md`

```erb
<%= kui(:select_native, name: "timezone") do %>
  <option value="">Select a timezone...</option>
  <option value="utc">UTC</option>
  <option value="est">Eastern (ET)</option>
<% end %>

<%# With field %>
<%= kui(:field) do %>
  <%= kui(:label, for: "role") { "Role" } %>
  <%= kui(:select_native, name: "role", id: "role") do %>
    <option value="member">Member</option>
    <option value="admin">Admin</option>
  <% end %>
<% end %>

<%# Option groups %>
<%= kui(:select_native, name: "city") do %>
  <optgroup label="North America">
    <option value="nyc">New York</option>
  </optgroup>
<% end %>
```

**Theme modules:** `Kiso::Themes::SelectNativeWrapper`, `SelectNative`, `SelectNativeIcon` (`lib/kiso/themes/select_native.rb`)

**When to use:** Simple dropdowns (timezone, role, country). Use `kui(:select)` for custom option styling, search, or multi-select.
