# Icons

Kiso uses **kiso-icons** for server-side inline SVG rendering. Icons are
resolved from Iconify JSON data — no client-side JavaScript, no font files,
no CDN requests.

## How it works

`kiso_icon("name")` resolves the icon name, reads the SVG path data from a
JSON file, and renders an inline `<svg>` element. All rendering happens on
the server at template time.

## Built-in: Lucide

Lucide (~1500 icons) is bundled in the gem as compressed JSON. It works out
of the box with zero configuration:

```erb
<%= kiso_icon("check") %>
<%= kiso_icon("settings") %>
<%= kiso_icon("layout-dashboard") %>
```

Lucide is the default set — bare icon names resolve to Lucide automatically.

## Adding icon libraries

Pin additional Iconify sets with the CLI:

```bash
bin/kiso-icons pin heroicons        # Heroicons (Tailwind Labs)
bin/kiso-icons pin mdi              # Material Design Icons
bin/kiso-icons pin tabler           # Tabler Icons
bin/kiso-icons pin phosphor         # Phosphor Icons
bin/kiso-icons pin ri               # Remix Icons
```

This downloads JSON files to `vendor/icons/`. Commit them to git (like
importmap-rails vendor pattern). Browse all available sets at
https://icon-sets.iconify.design/

Manage pinned sets:

```bash
bin/kiso-icons list       # show pinned sets with icon counts
bin/kiso-icons unpin mdi  # remove a set
bin/kiso-icons pristine   # re-download all pinned sets
```

## Using icons from other sets

Prefix with the set name:

```erb
<%= kiso_icon("heroicons:check-circle") %>
<%= kiso_icon("mdi:account") %>
<%= kiso_icon("tabler:settings") %>
```

Without a prefix, the default set (Lucide) is used.

## Resolution order

1. In-memory cache (instant, per-request)
2. Already-loaded set (parsed JSON in memory)
3. Vendored JSON (`vendor/icons/<set>.json`)
4. Bundled (gem's `data/<set>.json.gz` — Lucide only)

## Sizing

Icons render at `1em` by default (inherits parent font size). Use the
`size:` parameter for explicit sizing via Tailwind presets:

```erb
<%= kiso_icon("check", size: :xs) %>   <%# size-3 (12px) %>
<%= kiso_icon("check", size: :sm) %>   <%# size-4 (16px) %>
<%= kiso_icon("check", size: :md) %>   <%# size-5 (20px) %>
<%= kiso_icon("check", size: :lg) %>   <%# size-6 (24px) %>
<%= kiso_icon("check", size: :xl) %>   <%# size-8 (32px) %>
```

Or pass a class directly:

```erb
<%= kiso_icon("check", class: "size-5 text-success") %>
```

Inside Kiso components (Button, Alert, Nav), parent CSS handles icon sizing
via `[&>svg]:size-4` or similar — no explicit size needed.

## Component icons

Kiso components use `kiso_component_icon(:semantic_name)` for built-in
icons (separator chevrons, pagination arrows, close buttons). These resolve
through a configurable registry:

```ruby
# config/initializers/kiso.rb
Kiso.configure do |config|
  config.icons[:chevron_right] = "heroicons:chevron-right"
  config.icons[:menu] = "heroicons:bars-3"
  config.icons[:x] = "heroicons:x-mark"
end
```

This lets host apps swap the icon library globally without touching any
component templates. Default mappings use Lucide names.

### Registered semantic icons

| Name | Default (Lucide) | Used by |
|---|---|---|
| `chevron_right` | `chevron-right` | Breadcrumb separator |
| `chevron_down` | `chevron-down` | Select trigger, Nav section |
| `chevrons_up_down` | `chevrons-up-down` | Combobox trigger |
| `check` | `check` | Select/Combobox selected item |
| `x` | `x` | Command dialog close |
| `search` | `search` | Command input |
| `ellipsis` | `ellipsis` | Breadcrumb ellipsis, Pagination |
| `chevron_left` | `chevron-left` | Pagination prev |
| `menu` | `menu` | Sidebar toggle (hamburger) |
| `minus` | `minus` | InputOTP separator |
| `panel_left_close` | `panel-left-close` | Sidebar collapse (open) |
| `panel_left_open` | `panel-left-open` | Sidebar collapse (closed) |
| `sun` | `sun` | Color mode button (light) |
| `moon` | `moon` | Color mode button (dark) |

## Accessibility

Icons are `aria-hidden="true"` by default (decorative). For standalone
meaningful icons, pass an `aria` label:

```erb
<%= kiso_icon("check", aria: { label: "Done" }) %>
```

This removes `aria-hidden` and adds `role="img"`.

## Configuration

```ruby
# config/initializers/kiso_icons.rb
Kiso::Icons.configure do |config|
  config.default_set = "heroicons"     # change default from Lucide
  config.vendor_path = "vendor/icons"  # where pinned sets live
end
```
