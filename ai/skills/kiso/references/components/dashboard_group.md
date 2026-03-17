# DashboardGroup

Full-screen sidebar + topbar layout shell for dashboard applications. Components
compose into a responsive 2x2 CSS grid.

**Locals (dashboard_group):** `sidebar_open:` (true/false/nil), `css_classes:`, `**component_options`

**Locals (dashboard_navbar, dashboard_sidebar, dashboard_panel, dashboard_toolbar):** `css_classes:`, `**component_options`

**Sub-parts:**
- `kui(:dashboard_sidebar, :toggle)` — mobile-only hamburger (`lg:hidden`), accepts block for custom icon
- `kui(:dashboard_sidebar, :collapse)` — desktop-only collapse (`hidden lg:flex`), accepts `open_icon:` / `closed_icon:` props
- `kui(:dashboard_sidebar, :header)` — top section of sidebar (logo, collapse button)
- `kui(:dashboard_sidebar, :footer)` — bottom section of sidebar (sign-out, color mode)
- `kui(:dashboard_toolbar, :left)` / `kui(:dashboard_toolbar, :right)` — toolbar slots

**Defaults:** `sidebar_open: nil` (reads `cookies[:sidebar_open]`)

```erb
<%# In layouts/dashboard.html.erb %>
<body>
  <%= kui(:dashboard_group) do %>
    <%= kui(:dashboard_navbar) do %>
      <%= kui(:dashboard_sidebar, :toggle) %>
      <%= kui(:dashboard_sidebar, :collapse) %>
      <div class="flex-1"><!-- logo, search --></div>
      <%= kui(:color_mode_button) %>
    <% end %>

    <%= kui(:dashboard_sidebar) do %>
      <%= kui(:nav) do %>
        <%= kui(:nav, :section, title: "Main") do %>
          <%= kui(:nav, :item, href: "/", icon: "layout-dashboard", active: true) { "Dashboard" } %>
          <%= kui(:nav, :item, href: "/settings", icon: "settings") { "Settings" } %>
        <% end %>
      <% end %>
    <% end %>

    <%= kui(:dashboard_panel) do %>
      <%= kui(:dashboard_toolbar) do %>
        <%= kui(:dashboard_toolbar, :left) do %>
          <%= kui(:breadcrumb) { ... } %>
        <% end %>
        <%= kui(:dashboard_toolbar, :right) do %>
          <%= kui(:button, size: :sm) { "Export" } %>
        <% end %>
      <% end %>
      <%= yield %>
    <% end %>
  <% end %>
</body>
```

**Active nav item:** Use `controller_name` to highlight the current page:
```erb
<%= kui(:nav, :item, href: dashboard_path, icon: "layout-dashboard",
      active: controller_name == "dashboard") { "Dashboard" } %>
```
For multiple controllers: `active: controller_name.in?(%w[settings billing])`

**Custom toggle icons:** Toggle accepts a block to override the default icon:
```erb
<%= kui(:dashboard_sidebar, :toggle) do %>
  <%= kiso_icon("align-justify", class: "size-4") %>
<% end %>
```

Collapse accepts `open_icon:` and `closed_icon:` props for per-instance overrides:
```erb
<%= kui(:dashboard_sidebar, :collapse,
    open_icon: kiso_icon("chevron-left", class: "size-4"),
    closed_icon: kiso_icon("chevron-right", class: "size-4")) %>
```

Or override globally: `Kiso.configure { |c| c.icons[:menu] = "align-justify" }` (also `:panel_left_close`, `:panel_left_open`)

**Sidebar state variants:** `kui-sidebar-open:` and `kui-sidebar-closed:` — custom Tailwind variants for showing/hiding any descendant based on sidebar state. Compose with breakpoints:

```erb
<%# Hide navbar logo on desktop when sidebar open %>
<div class="kui-sidebar-open:lg:hidden">MyApp</div>

<%# Show only when collapsed %>
<div class="hidden kui-sidebar-closed:lg:block">icon</div>
```

**Sidebar header collapse pattern (Linear/Notion):** Move the collapse button into the sidebar header and hide the navbar on desktop:
```erb
<%= kui(:dashboard_navbar, css_classes: "lg:hidden") do %>
  <%= kui(:dashboard_sidebar, :toggle) %>
<% end %>

<%= kui(:dashboard_sidebar) do %>
  <%= kui(:dashboard_sidebar, :header) do %>
    <div class="flex items-center gap-1.5 flex-1 min-w-0">Logo</div>
    <%= kui(:dashboard_sidebar, :collapse) %>
  <% end %>
  ...
<% end %>
```

To keep the navbar on desktop but hide just the toggle when sidebar is open:
```erb
<%= kui(:dashboard_sidebar, :toggle, css_classes: "kui-sidebar-open:lg:hidden") %>
```

**Recipes:**

Page-specific sidebar content — use `content_for` to inject per-page content into the sidebar from any view:
```erb
<%# In layouts/dashboard.html.erb %>
<%= kui(:dashboard_sidebar) do %>
  <%= kui(:nav) { ... } %>
  <% if content_for?(:sidebar) %>
    <%= yield :sidebar %>
  <% end %>
  <%= kui(:dashboard_sidebar, :footer) do %>
    <%= kui(:color_mode_button) %>
  <% end %>
<% end %>

<%# In any view %>
<% content_for :sidebar do %>
  <div class="p-4">Page-specific sidebar content here</div>
<% end %>
```

Navbar logo with sidebar state — hide the navbar logo on desktop when the sidebar is open (since the sidebar header already shows it):
```erb
<%= kui(:dashboard_navbar) do %>
  <%= kui(:dashboard_sidebar, :toggle) %>
  <div class="kui-sidebar-open:lg:hidden flex items-center gap-2">
    <%= image_tag "logo.svg", class: "h-6 w-6" %>
    <span class="font-semibold">MyApp</span>
  </div>
  <div class="flex-1"></div>
  <%= kui(:color_mode_button) %>
<% end %>
```

**Theme modules:** `Kiso::Themes::DashboardGroup`, `DashboardNavbar`, `DashboardSidebar`, `DashboardSidebarToggle`, `DashboardSidebarCollapse`, `DashboardSidebarHeader`, `DashboardSidebarFooter`, `DashboardToolbar`, `DashboardToolbarLeft`, `DashboardToolbarRight`, `DashboardPanel` (`lib/kiso/themes/dashboard.rb`)

**Nav theme modules:** `Kiso::Themes::Nav`, `NavSection`, `NavSectionTitle`, `NavSectionContent`, `NavItem`, `NavItemBadge` (`lib/kiso/themes/nav.rb`)

**CSS:** `app/assets/tailwind/kiso/dashboard.css` — grid mechanics, sidebar tokens, mobile overlay, collapse icon switching, nav section/item sidebar context

**Stimulus:** `kiso--sidebar` controller (toggle, cookie persistence, mobile scrim close, multiple trigger targets)

**Key CSS tokens:** `--sidebar-width` (16rem), `--topbar-height` (3.5rem), `--sidebar-duration` (220ms), `--sidebar-background`, `--sidebar-foreground`, `--sidebar-border`, `--sidebar-accent`, `--sidebar-accent-foreground`
