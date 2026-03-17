# Badge

Inline label for status, categories, or counts.

**Locals:** `color:` (primary, secondary, success, info, warning, error, neutral), `variant:` (solid, outline, soft, subtle), `size:` (xs, sm, md, lg, xl), `css_classes:`, `**component_options`

**Defaults:** `color: :primary, variant: :soft, size: :md`

```erb
<%= kui(:badge, color: :success, variant: :soft) { "Active" } %>
<%= kui(:badge, color: :error, variant: :solid, size: :sm) { "Failed" } %>
<%= kui(:badge, color: :neutral, variant: :outline) { "Draft" } %>
```

**Theme module:** `Kiso::Themes::Badge` (`lib/kiso/themes/badge.rb`)
