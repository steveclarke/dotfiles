# Container

Content containment with consistent max-width, horizontal centering, and
responsive padding. Used inside Header, Main, or Footer to constrain content
width.

**Locals:** `size:` (narrow, default, wide, full), `css_classes:`, `**component_options`

**Defaults:** `size: :default`

```erb
<%# Default container (max-w-7xl) %>
<%= kui(:container) do %>
  <p>Page content</p>
<% end %>

<%# Narrow for prose/forms (max-w-3xl) %>
<%= kui(:container, size: :narrow) do %>
  <article>Long-form content</article>
<% end %>

<%# Wide for dashboards (max-w-screen-2xl) %>
<%= kui(:container, size: :wide) do %>
  <div>Dashboard grid</div>
<% end %>

<%# Full width (max-w-full) %>
<%= kui(:container, size: :full) do %>
  <div>Edge-to-edge content</div>
<% end %>
```

**Theme module:** `Kiso::Themes::Container` (`lib/kiso/themes/layout.rb`)

Size variants: `:narrow` (max-w-3xl), `:default` (max-w-7xl), `:wide`
(max-w-screen-2xl), `:full` (max-w-full). Base classes include
`mx-auto w-full px-4 sm:px-6 lg:px-8`.
