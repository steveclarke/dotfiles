# Avatar

An image element with a fallback for representing the user. Pure CSS, no JavaScript.

**Locals:** `src:` (String), `alt:` (String), `text:` (String), `size:` (xs/sm/md/lg/xl/2xl), `color:` (String, hex), `contrast_threshold:` (Float), `ui:` (Hash), `css_classes:`, `**component_options`

**Sub-parts:** `kui(:avatar, :image)`, `kui(:avatar, :fallback)`, `kui(:avatar, :badge)`, `kui(:avatar, :group)`, `kui(:avatar, :group_count)`

**Defaults:** `size: :md`

```erb
<%# Props-based (common case) %>
<%= kui(:avatar, src: "/photo.jpg", alt: "Steve Clarke", text: "SC") %>
<%= kui(:avatar, text: "SC", size: :lg) %>

<%# Custom color — text contrast is automatic %>
<%= kui(:avatar, text: "SC", color: "#e11d48") %>
<%= kui(:avatar, text: "YL", color: "#eab308") %>

<%# Composition-based (full control) %>
<%= kui(:avatar) do %>
  <%= kui(:avatar, :image, src: "/photo.jpg", alt: "Steve Clarke") %>
  <%= kui(:avatar, :fallback) { "SC" } %>
  <%= kui(:avatar, :badge, css_classes: "bg-success") %>
<% end %>
```

**Group** for stacked avatars:

```erb
<%= kui(:avatar, :group) do %>
  <%= kui(:avatar, src: "/a.jpg", alt: "Alice", text: "A") %>
  <%= kui(:avatar, src: "/b.jpg", alt: "Bob", text: "B") %>
  <%= kui(:avatar, :group_count) { "+3" } %>
<% end %>
```

**Size variants:** `:xs` (20px), `:sm` (24px), `:md` (32px), `:lg` (40px), `:xl` (64px), `:2xl` (80px). Badge scales automatically via `group-data-[size]` selectors.

**Auto-contrast:** When `color:` is a hex string, text color (white/black) is computed automatically via WCAG luminance. Default threshold is 0.42. Override per-instance with `contrast_threshold:` or globally via `Kiso.config.contrast_threshold`.

**Image fallback:** Image is absolute-positioned over fallback. On load error, `onerror` hides the image, revealing the fallback underneath. No `overflow-hidden` on root (allows badge to render outside circle).

**Theme modules:** `Kiso::Themes::Avatar`, `AvatarImage`, `AvatarFallback`, `AvatarBadge`, `AvatarGroup`, `AvatarGroupCount` (`lib/kiso/themes/avatar.rb`)

**Utility:** `Kiso::ColorUtils.contrast_text_color(hex, threshold:)` — available for use in host app components.
