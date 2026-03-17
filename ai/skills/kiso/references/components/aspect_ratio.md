# AspectRatio

Displays content within a desired width-to-height ratio. Used for constraining
images, videos, and other media to consistent proportions.

**Locals:** `ratio:` (number), `css_classes:`, `**component_options`

**Defaults:** `ratio: 16.0/9`

```erb
<%# 16:9 landscape (default) %>
<%= kui(:aspect_ratio) do %>
  <%= image_tag "photo.jpg", class: "h-full w-full rounded-md object-cover" %>
<% end %>

<%# 1:1 square %>
<%= kui(:aspect_ratio, ratio: 1) do %>
  <%= image_tag "avatar.jpg", class: "h-full w-full rounded-lg object-cover" %>
<% end %>

<%# 9:16 portrait %>
<%= kui(:aspect_ratio, ratio: 9.0/16) do %>
  <%= image_tag "story.jpg", class: "h-full w-full rounded-md object-cover" %>
<% end %>

<%# 4:3 classic %>
<%= kui(:aspect_ratio, ratio: 4.0/3) do %>
  <%= image_tag "photo.jpg", class: "h-full w-full object-cover" %>
<% end %>

<%# With video %>
<%= kui(:aspect_ratio, ratio: 16.0/9) do %>
  <iframe src="https://www.youtube.com/embed/..." class="h-full w-full" allowfullscreen></iframe>
<% end %>
```

**Theme module:** `Kiso::Themes::AspectRatio` (`lib/kiso/themes/aspect_ratio.rb`)

No variants. The `ratio:` local sets `aspect-ratio` via inline style. The base
classes are `relative w-full`.
