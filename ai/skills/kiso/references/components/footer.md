# Footer

Semantic `<footer>` element. A minimal wrapper with no default styling — add
your own classes via `css_classes:` or style the content inside.

**Locals:** `css_classes:`, `**component_options`

**Defaults:** none (no variants)

```erb
<%= kui(:footer, css_classes: "border-t border-border py-8") do %>
  <%= kui(:container) do %>
    <p class="text-sm text-muted-foreground">
      &copy; 2026 Acme Inc.
    </p>
  <% end %>
<% end %>
```

**Theme module:** `Kiso::Themes::Footer` (`lib/kiso/themes/layout.rb`)

No variants. Base classes are empty — the component provides semantic markup
only. Style via `css_classes:`.
