# Input

Single-line text field. Non-colored component (no `color:` axis).

**Locals:** `variant:` (outline, soft, ghost), `size:` (sm, md, lg), `type:` (text, email, password, search, number, file, etc.), `disabled:` (true/false), `css_classes:`, `**component_options`

**Defaults:** `variant: :outline, size: :md, type: :text`

All standard HTML input attributes (`placeholder:`, `name:`, `id:`, `value:`, `required:`) pass through via `**component_options`.

```erb
<%= kui(:input, placeholder: "Email address") %>
<%= kui(:input, variant: :soft, size: :sm) %>
<%= kui(:input, type: :file, id: :avatar) %>

<%# With Field %>
<%= kui(:field) do %>
  <%= kui(:field, :label, for: :email) { "Email" } %>
  <%= kui(:input, type: :email, id: :email, name: :email, placeholder: "you@example.com") %>
  <%= kui(:field, :description) { "We'll never share your email." } %>
<% end %>

<%# With Rails form helpers %>
<%= f.text_field :email, class: Kiso::Themes::Input.render(variant: :outline, size: :md) %>
```

**Theme module:** `Kiso::Themes::Input` (`lib/kiso/themes/input.rb`)
