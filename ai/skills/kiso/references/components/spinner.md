# Spinner

Spinning loading indicator. No variants — size is controlled via `css_classes:`. Inherits `currentColor` from parent context.

**Locals:** `label:` (string, ARIA label), `css_classes:`, `**component_options`

**Defaults:** `label: "Loading"` (i18n: `kiso.spinner.loading`)

```erb
<%= kui(:spinner) %>
<%= kui(:spinner, css_classes: "size-6") %>
<%= kui(:spinner, label: "Saving changes") %>

<%# Inside a button %>
<%= kui(:button, disabled: true) do %>
  <%= kui(:spinner, css_classes: "size-3") %>
  Loading…
<% end %>
```

**Icon:** Registered as `kiso_component_icon(:spinner)`. Host apps swap globally via `Kiso.config.icons[:spinner]`.

**Theme module:** `Kiso::Themes::Spinner` (`lib/kiso/themes/spinner.rb`)
