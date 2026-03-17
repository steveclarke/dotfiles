# Dialog

Modal dialog wrapping the native `<dialog>` element. Opens via `showModal()`
through a Stimulus controller for focus trapping, backdrop, and Escape-to-close.

**Locals:** `open:` (boolean), `css_classes:`, `**component_options`

**Sub-parts:** `:header`, `:title` (h2), `:description` (p), `:body`, `:footer`, `:close`

**Defaults:** `open: false`

```erb
<%# Trigger button %>
<button onclick="document.getElementById('my-dialog').showModal()">Open</button>

<%# Dialog %>
<%= kui(:dialog, id: "my-dialog") do %>
  <%= kui(:dialog, :close) %>
  <%= kui(:dialog, :header) do %>
    <%= kui(:dialog, :title) { "Title" } %>
    <%= kui(:dialog, :description) { "Description text." } %>
  <% end %>
  <%= kui(:dialog, :body) do %>
    <p>Content here.</p>
  <% end %>
  <%= kui(:dialog, :footer) do %>
    <%= kui(:button, variant: :outline, data: { action: "kiso--dialog#close" }) { "Cancel" } %>
    <%= kui(:button) { "Confirm" } %>
  <% end %>
<% end %>

<%# Server-rendered open state %>
<%= kui(:dialog, open: true, id: "welcome") do %>
  ...
<% end %>

<%# Confirmation (no body, no close button) %>
<%= kui(:dialog, id: "confirm") do %>
  <%= kui(:dialog, :header) do %>
    <%= kui(:dialog, :title) { "Are you sure?" } %>
    <%= kui(:dialog, :description) { "This cannot be undone." } %>
  <% end %>
  <%= kui(:dialog, :footer) do %>
    <%= kui(:button, variant: :outline, data: { action: "kiso--dialog#close" }) { "Cancel" } %>
    <%= kui(:button, color: :error) { "Delete" } %>
  <% end %>
<% end %>
```

**Close methods:** X button (`kui(:dialog, :close)`), Escape key, backdrop click, any element with `data-action="kiso--dialog#close"`.

**Stimulus:** `kiso--dialog` controller on the `<dialog>` element. Values: `open` (Boolean). Events: `kiso--dialog:open`, `kiso--dialog:close`.

**Theme module:** `Kiso::Themes::Dialog` + 7 sub-part constants (`lib/kiso/themes/dialog.rb`)
