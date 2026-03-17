# Skeleton

A placeholder element displayed while content is loading. Pure CSS shimmer
animation, no variants.

**Locals:** `css_classes:`, `**component_options`

**Defaults:** none (shape and size set via `css_classes:`)

```erb
<%# Text line placeholder %>
<%= kui(:skeleton, css_classes: "h-4 w-[250px]") %>

<%# Circle (avatar placeholder) %>
<%= kui(:skeleton, css_classes: "h-12 w-12 rounded-full") %>

<%# Card placeholder %>
<div class="flex items-center gap-4">
  <%= kui(:skeleton, css_classes: "h-12 w-12 rounded-full") %>
  <div class="flex flex-col gap-2">
    <%= kui(:skeleton, css_classes: "h-4 w-[250px]") %>
    <%= kui(:skeleton, css_classes: "h-4 w-[200px]") %>
  </div>
</div>
```

**Theme module:** `Kiso::Themes::Skeleton` (`lib/kiso/themes/skeleton.rb`)
