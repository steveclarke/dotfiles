# Alert

Contextual feedback message with optional icon, title, description, actions, and close button. Composition-based — use sub-parts for structure.

**Locals:** `icon:` (string, icon name), `color:` (primary, secondary, success, info, warning, error, neutral), `variant:` (solid, outline, soft, subtle), `close:` (boolean), `css_classes:`, `**component_options`

**Sub-parts:** `kui(:alert, :title)`, `kui(:alert, :description)`, `kui(:alert, :actions)`

**Defaults:** `color: :primary, variant: :soft, close: false`

```erb
<%# Default: primary soft %>
<%= kui(:alert) do %>
  <%= kui(:alert, :title) { "Heads up!" } %>
  <%= kui(:alert, :description) { "You can add components using the CLI." } %>
<% end %>

<%# With icon %>
<%= kui(:alert, color: :error, variant: :solid, icon: "circle-alert") do %>
  <%= kui(:alert, :title) { "Error" } %>
  <%= kui(:alert, :description) { "Something went wrong." } %>
<% end %>

<%# Dismissible with close button %>
<%= kui(:alert, color: :info, close: true, icon: "info") do %>
  <%= kui(:alert, :title) { "Heads up!" } %>
  <%= kui(:alert, :description) { "You can dismiss this alert." } %>
<% end %>

<%# With actions %>
<%= kui(:alert, color: :error, variant: :outline, icon: "circle-x", close: true) do %>
  <%= kui(:alert, :title) { "Deployment failed" } %>
  <%= kui(:alert, :description) { "The build process exited with code 1." } %>
  <%= kui(:alert, :actions) do %>
    <%= kui(:button, size: :xs, color: :neutral) { "Retry" } %>
    <%= kui(:button, size: :xs, color: :neutral, variant: :outline) { "View logs" } %>
  <% end %>
<% end %>
```

**Close event:** `kiso--alert:close` fires before removal. Cancelable with `event.preventDefault()`.

**Theme modules:** `Kiso::Themes::Alert`, `AlertWrapper`, `AlertTitle`, `AlertDescription`, `AlertActions`, `AlertClose` (`lib/kiso/themes/alert.rb`)
