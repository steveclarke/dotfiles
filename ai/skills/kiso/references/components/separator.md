# Separator

A visual divider between content sections. Renders as a 1px line, horizontal
or vertical.

**Locals:** `orientation:` (horizontal, vertical), `decorative:` (true/false), `css_classes:`, `**component_options`

**Defaults:** `orientation: :horizontal, decorative: true`

```erb
<%# Horizontal (default) %>
<%= kui(:separator) %>

<%# With spacing %>
<%= kui(:separator, css_classes: "my-4") %>

<%# Vertical — parent needs height + flex %>
<div class="flex h-5 items-center space-x-4 text-sm">
  <div>Blog</div>
  <%= kui(:separator, orientation: :vertical) %>
  <div>Docs</div>
</div>

<%# Non-decorative (adds role="separator" + aria-orientation) %>
<%= kui(:separator, decorative: false) %>
```

**Theme module:** `Kiso::Themes::Separator` (`lib/kiso/themes/separator.rb`)
