# Alert Dialog

Modal confirmation dialog wrapping the native `<dialog>` element with
`role="alertdialog"`. Cannot be dismissed by backdrop click or Escape —
requires explicit user action via Cancel or Action buttons.

**Locals:** `open:` (boolean), `size:` (default/sm), `css_classes:`, `**component_options`

**Sub-parts:** `:header`, `:title` (h2), `:description` (p), `:media`, `:footer`, `:action`, `:cancel`

**Defaults:** `open: false`, `size: :default`

```erb
<%# Basic confirmation %>
<button onclick="document.getElementById('confirm').showModal()">Delete</button>

<%= kui(:alert_dialog, id: "confirm") do %>
  <%= kui(:alert_dialog, :header) do %>
    <%= kui(:alert_dialog, :title) { "Are you sure?" } %>
    <%= kui(:alert_dialog, :description) { "This action cannot be undone." } %>
  <% end %>
  <%= kui(:alert_dialog, :footer) do %>
    <%= kui(:alert_dialog, :cancel) { "Cancel" } %>
    <%= kui(:alert_dialog, :action, color: :error) { "Delete" } %>
  <% end %>
<% end %>

<%# With media icon, sm size %>
<%= kui(:alert_dialog, id: "delete", size: :sm) do %>
  <%= kui(:alert_dialog, :header) do %>
    <%= kui(:alert_dialog, :media, css_classes: "bg-error/10 text-error") do %>
      <%= kiso_icon("lucide:trash-2", class: "size-8") %>
    <% end %>
    <%= kui(:alert_dialog, :title) { "Delete project?" } %>
    <%= kui(:alert_dialog, :description) { "This is permanent." } %>
  <% end %>
  <%= kui(:alert_dialog, :footer) do %>
    <%= kui(:alert_dialog, :cancel) { "Cancel" } %>
    <%= kui(:alert_dialog, :action, color: :error) { "Delete" } %>
  <% end %>
<% end %>
```

**Action/Cancel props:** `color:` (7 colors), `variant:` (action defaults solid, cancel defaults outline), `size:` (sm/md/lg). Both auto-close the dialog.

**Size variants:** `:default` (sm:max-w-lg, left-aligned on desktop), `:sm` (max-w-xs, centered, 2-column footer grid).

**Media:** Optional icon container in header. At default size, icon sits beside title/description on desktop. At sm size, centered above text.

**ARIA:** `role="alertdialog"`, `aria-labelledby` and `aria-describedby` auto-linked when `id:` is provided.

**Stimulus:** Reuses `kiso--dialog` controller with `dismissable: false`. Events: `kiso--dialog:open`, `kiso--dialog:close`.

**Theme module:** `Kiso::Themes::AlertDialog` + 7 sub-part constants (`lib/kiso/themes/alert_dialog.rb`)
