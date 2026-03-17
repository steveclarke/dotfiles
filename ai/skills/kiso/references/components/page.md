# Page

Landing page layout components inspired by Nuxt UI's page system. Composed from
six top-level components: Page (grid layout), PageHeader, PageBody, PageSection,
PageGrid, and PageCard.

## Page

Root grid layout with left/center/right sidebar slots. Responsive 10-column grid
on desktop, stacked on mobile.

**Locals:** `css_classes:`, `**component_options`

**Sub-parts:** `kui(:page, :left)` (aside), `kui(:page, :center)`, `kui(:page, :right)` (aside, ordered first on mobile)

```erb
<%= kui(:page) do %>
  <%= kui(:page, :left) do %>
    <nav>Sidebar navigation</nav>
  <% end %>
  <%= kui(:page, :center) do %>
    <p>Main content</p>
  <% end %>
  <%= kui(:page, :right) do %>
    <aside>Table of contents</aside>
  <% end %>
<% end %>
```

**Theme modules:** `Kiso::Themes::Page`, `PageLeft`, `PageCenter`, `PageRight` (`lib/kiso/themes/page.rb`)

## PageHeader

Section header with title, description, headline, and action links. Supports
props for common usage or yield for full control.

**Locals:** `headline:` (nil), `title:` (nil), `description:` (nil), `ui: {}`, `css_classes:`, `**component_options`

**Sub-parts:** `kui(:page_header, :headline)`, `kui(:page_header, :title)`, `kui(:page_header, :description)`, `kui(:page_header, :links)`

**Defaults:** All props nil (pass props or yield a block)

```erb
<%# Props-based usage %>
<%= kui(:page_header,
    headline: "Getting Started",
    title: "Build Beautiful UIs",
    description: "A Rails engine for UI components.") %>

<%# Yield-based with action links %>
<%= kui(:page_header) do %>
  <div>
    <%= kui(:page_header, :headline) { "Docs" } %>
    <%= kui(:page_header, :title) { "Components" } %>
    <%= kui(:page_header, :description) { "Browse all available components." } %>
  </div>
  <%= kui(:page_header, :links) do %>
    <%= kui(:button) { "Get Started" } %>
    <%= kui(:button, variant: :outline) { "GitHub" } %>
  <% end %>
<% end %>
```

**`ui:` slots:** `wrapper`, `headline`, `title`, `description`

**Theme modules:** `Kiso::Themes::PageHeader`, `PageHeaderWrapper`, `PageHeaderHeadline`, `PageHeaderTitle`, `PageHeaderDescription`, `PageHeaderLinks` (`lib/kiso/themes/page.rb`)

## PageBody

Main content wrapper with vertical spacing. Wraps page sections.

**Locals:** `css_classes:`, `**component_options`

```erb
<%= kui(:page_body) do %>
  <%= kui(:page_section) { ... } %>
  <%= kui(:page_section) { ... } %>
<% end %>
```

**Theme module:** `Kiso::Themes::PageBody` (`lib/kiso/themes/page.rb`)

## PageSection

Content section with orientation variants (horizontal/vertical). Horizontal uses
a 2-column grid for side-by-side layout. Vertical centers text. Contains 7
sub-parts for structured content.

**Locals:** `orientation:` (:horizontal), `ui: {}`, `css_classes:`, `**component_options`

**Sub-parts:** `kui(:page_section, :wrapper)`, `kui(:page_section, :header)`, `kui(:page_section, :headline)`, `kui(:page_section, :title)`, `kui(:page_section, :description)`, `kui(:page_section, :body)`, `kui(:page_section, :links)`

**Defaults:** `orientation: :horizontal`

```erb
<%# Horizontal section (side-by-side on desktop) %>
<%= kui(:page_section) do %>
  <%= kui(:page_section, :wrapper) do %>
    <%= kui(:page_section, :header) do %>
      <%= kui(:page_section, :headline) { "Features" } %>
      <%= kui(:page_section, :title) { "Everything You Need" } %>
      <%= kui(:page_section, :description) { "Build UIs fast." } %>
    <% end %>
    <%= kui(:page_section, :links) do %>
      <%= kui(:button) { "Learn More" } %>
    <% end %>
  <% end %>
  <%= kui(:page_section, :body) do %>
    <p>Visual content, screenshots, etc.</p>
  <% end %>
<% end %>

<%# Vertical centered section %>
<%= kui(:page_section, orientation: :vertical) do %>
  <%= kui(:page_section, :wrapper) do %>
    <%= kui(:page_section, :header) do %>
      <%= kui(:page_section, :title) { "Trusted by Developers" } %>
      <%= kui(:page_section, :description) { "Join the community." } %>
    <% end %>
  <% end %>
<% end %>
```

**Orientation variants:** `:horizontal` (2-column grid, left-aligned), `:vertical` (centered text). Orientation propagates to headline, title, description, and links sub-parts.

**`ui:` slots:** `container`

**Theme modules:** `Kiso::Themes::PageSection`, `PageSectionContainer`, `PageSectionWrapper`, `PageSectionHeader`, `PageSectionHeadline`, `PageSectionTitle`, `PageSectionDescription`, `PageSectionBody`, `PageSectionLinks` (`lib/kiso/themes/page.rb`)

## PageGrid

Responsive grid for arranging PageCard components. 1 column on mobile, 2 on sm,
3 on lg.

**Locals:** `css_classes:`, `**component_options`

```erb
<%= kui(:page_grid) do %>
  <%= kui(:page_card, icon: "zap", title: "Fast", description: "Built for speed.") %>
  <%= kui(:page_card, icon: "shield", title: "Secure", description: "Safe by default.") %>
  <%= kui(:page_card, icon: "code", title: "Open", description: "Fully open source.") %>
<% end %>
```

**Theme module:** `Kiso::Themes::PageGrid` (`lib/kiso/themes/page.rb`)

## PageCard

Content card for grid/column layouts. Supports props for icon/title/description
or yield for full control. Four variant styles.

**Locals:** `variant:` (:outline), `icon:` (nil), `title:` (nil), `description:` (nil), `ui: {}`, `css_classes:`, `**component_options`

**Sub-parts:** `kui(:page_card, :header)`, `kui(:page_card, :icon)`, `kui(:page_card, :title)`, `kui(:page_card, :description)`, `kui(:page_card, :body)`, `kui(:page_card, :footer)`

**Defaults:** `variant: :outline`

```erb
<%# Props-based %>
<%= kui(:page_card,
    variant: :soft,
    icon: "rocket",
    title: "Quick Start",
    description: "Get up and running in minutes.") %>

<%# Yield-based with sub-parts %>
<%= kui(:page_card, variant: :subtle) do %>
  <%= kui(:page_card, :icon) { kiso_icon("star") } %>
  <%= kui(:page_card, :title) { "Featured" } %>
  <%= kui(:page_card, :description) { "Hand-picked components." } %>
  <%= kui(:page_card, :footer) do %>
    <%= kui(:button, size: :sm) { "View All" } %>
  <% end %>
<% end %>
```

**Variants:** `:outline` (ring + background), `:soft` (elevated bg), `:subtle` (elevated bg + ring), `:ghost` (no background or border)

**`ui:` slots:** `container`, `wrapper`, `icon`, `title`, `description`

**Theme modules:** `Kiso::Themes::PageCard`, `PageCardContainer`, `PageCardWrapper`, `PageCardHeader`, `PageCardBody`, `PageCardFooter`, `PageCardIcon`, `PageCardTitle`, `PageCardDescription` (`lib/kiso/themes/page.rb`)
