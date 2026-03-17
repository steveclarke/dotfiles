# Button

Interactive button with smart tag selection. Renders `<button>` by default,
`<a>` when `href:` is present, `button_to` (form) when `method:` is present.

**Locals:** `color:`, `variant:` (solid, outline, soft, subtle, ghost, link), `size:` (xs-xl), `block:` (true/false), `disabled:` (true/false), `type:` (button, submit, reset), `href:` (string), `method:` (delete, post, put, patch), `form:` (hash), `css_classes:`, `**component_options`

**Defaults:** `color: :primary, variant: :solid, size: :md`

```erb
<%= kui(:button) { "Click me" } %>
<%= kui(:button, color: :error) { "Delete" } %>
<%= kui(:button, href: "/settings", variant: :outline) { "Settings" } %>
<%= kui(:button, variant: :ghost) { "Cancel" } %>
<%= kui(:button, block: true, type: :submit) { "Save" } %>

<%# With inline icon %>
<%= kui(:button, variant: :outline) do %>
  <%= kiso_icon("download") %>
  Download
<% end %>

<%# DELETE via button_to (generates <form> + <button>) %>
<%= kui(:button, href: session_path, method: :delete, variant: :ghost) do %>
  <%= kiso_icon("log-out") %> Sign out
<% end %>

<%# With turbo confirm %>
<%= kui(:button, href: post_path(@post), method: :delete,
    color: :error, data: { turbo_confirm: "Are you sure?" }) { "Delete" } %>

<%# Form-level attributes %>
<%= kui(:button, href: archive_path, method: :post,
    form: { data: { turbo_frame: "_top" } }) { "Archive" } %>
```

**Smart tag:** `href:` + `method:` (non-GET) → `button_to` with `form_class: "contents"`. `href:` alone → `<a>`. No `href:` → `<button>`. Do not nest inside an existing `<form>`.

**Theme module:** `Kiso::Themes::Button` (`lib/kiso/themes/button.rb`)
