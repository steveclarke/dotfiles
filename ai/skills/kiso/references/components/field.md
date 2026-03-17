# Field

Composable form field wrapper. Provides accessible structure for labels,
descriptions, errors, and layout orientation.

**Locals:** `orientation:` (vertical, horizontal, responsive), `invalid:` (true/false), `disabled:` (true/false), `css_classes:`, `**component_options`

**Defaults:** `orientation: :vertical, invalid: false, disabled: false`

**Sub-parts:** `kui(:field, :label)`, `kui(:field, :content)`, `kui(:field, :title)`, `kui(:field, :description)`, `kui(:field, :error)`, `kui(:field, :separator)`

```erb
<%# Vertical field (default) %>
<%= kui(:field) do %>
  <%= kui(:field, :label, for: :email) { "Email" } %>
  <%= kui(:input, id: :email, name: :email) %>
  <%= kui(:field, :description) { "We'll never share your email." } %>
  <%= kui(:field, :error, errors: @user.errors[:email]) %>
<% end %>

<%# Horizontal (checkbox/switch layout) %>
<%= kui(:field, orientation: :horizontal) do %>
  <%= kui(:checkbox, id: :terms) %>
  <%= kui(:field, :label, for: :terms) { "Accept terms" } %>
<% end %>
```

**FieldError:** Only renders when content is present. Accepts `errors:` array (Rails model errors) or block content. Multiple errors render as a bulleted list.

**Theme modules:** `Kiso::Themes::Field`, `FieldContent`, `FieldLabel`, `FieldTitle`, `FieldDescription`, `FieldError`, `FieldSeparator`, `FieldSeparatorText` (`lib/kiso/themes/field.rb`)

## FieldGroup

Stacks multiple fields with `gap-7` spacing. Provides `@container/field-group` scope for responsive Field orientation.

```erb
<%= kui(:field_group) do %>
  <%= kui(:field) do %>...<% end %>
  <%= kui(:field) do %>...<% end %>
<% end %>
```

**Theme module:** `Kiso::Themes::FieldGroup` (`lib/kiso/themes/field_group.rb`)

## FieldSet

Semantic `<fieldset>` for grouping related controls.

**Sub-parts:** `kui(:field_set, :legend)` — accepts `variant:` (legend, label)

```erb
<%= kui(:field_set) do %>
  <%= kui(:field_set, :legend) { "Notifications" } %>
  <%= kui(:field, orientation: :horizontal) do %>
    <%= kui(:checkbox, id: :email_notifs) %>
    <%= kui(:field, :label, for: :email_notifs) { "Email" } %>
  <% end %>
<% end %>
```

**Theme modules:** `Kiso::Themes::FieldSet`, `FieldLegend` (`lib/kiso/themes/field_set.rb`)
