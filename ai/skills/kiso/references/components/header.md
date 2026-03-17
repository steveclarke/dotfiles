# Header

Semantic `<header>` element for site/app navigation. Sticky-positioned at the
top of the viewport with a translucent backdrop blur and bottom border.

**Locals:** `css_classes:`, `**component_options`

**Defaults:** none (no variants)

```erb
<%= kui(:header) do %>
  <%= kui(:container) do %>
    <nav class="flex h-16 items-center justify-between">
      <a href="/">Logo</a>
      <div class="flex items-center gap-4">
        <a href="/docs">Docs</a>
        <%= kui(:color_mode_button) %>
      </div>
    </nav>
  <% end %>
<% end %>
```

**Theme module:** `Kiso::Themes::Header` (`lib/kiso/themes/layout.rb`)

No variants. Base classes: `bg-background/75 backdrop-blur border-b border-border
sticky top-0 z-50`.
