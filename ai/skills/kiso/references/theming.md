# Theming

## Semantic colors

| Color | Default | Purpose |
|---|---|---|
| `primary` | blue | CTAs, active states, brand |
| `secondary` | teal | Secondary actions |
| `success` | green | Success messages |
| `info` | sky | Informational |
| `warning` | amber | Warnings |
| `error` | red | Errors, destructive actions |
| `neutral` | zinc | Text, borders, surfaces |

## CSS utilities

### Text

| Class | Use | Light value | Dark value |
|---|---|---|---|
| `text-foreground` | Body text | `zinc-950` | `zinc-50` |
| `text-muted-foreground` | Secondary text | `zinc-500` | `zinc-400` |
| `text-inverted` | On dark/light backgrounds | `zinc-900` | `white` |

### Background

| Class | Use | Light value | Dark value |
|---|---|---|---|
| `bg-background` | Page background | `white` | `zinc-950` |
| `bg-muted` | Subtle sections | `zinc-100` | `zinc-800` |
| `bg-elevated` | Cards, modals | `zinc-100` | `zinc-800` |
| `bg-inverted` | Inverted sections | `zinc-900` | `white` |

### Border

| Class | Use | Light value | Dark value |
|---|---|---|---|
| `border-border` | Default borders | `zinc-200` | `zinc-800` |
| `border-accented` | Emphasized borders | `zinc-300` | `zinc-700` |

### Semantic color utilities

Each semantic color is available as a Tailwind utility: `text-primary`, `bg-primary`, `border-primary`, `ring-primary`, plus opacity modifiers like `bg-primary/10`.

Foreground pairing: `text-primary-foreground` for accessible text on `bg-primary`.

## Configuring brand colors

Override semantic colors in your app's Tailwind CSS:

```css
@theme inline {
  --color-primary: var(--color-orange-600);
  --color-primary-foreground: white;
}

.dark {
  --color-primary: var(--color-orange-400);
  --color-primary-foreground: var(--color-zinc-950);
}
```

## Component theme architecture

Variant definitions live in Ruby theme modules (`lib/kiso/themes/`), not CSS files. Components compute Tailwind class strings at render time using `class_variants` + `tailwind_merge`.

- **Flat variants** — for single-axis components (Label, Separator)
- **Compound variants** — for color x variant matrix (Badge, Button, Alert)

## Override layers

Four layers, each wins over the previous:

1. **Theme default** — `Kiso::Themes::Button` (gem code)
2. **Global config** — `Kiso.configure { |c| c.theme[:button] = ... }` (host app initializer)
3. **Instance `ui:`** — per-slot class overrides (call site)
4. **Instance `css_classes:`** — root element override (call site, deduped by tailwind_merge)

## Global theme overrides

Host apps override component styles globally in an initializer:

```ruby
# config/initializers/kiso.rb
Kiso.configure do |config|
  # Root element overrides (base:, variants:, defaults:)
  config.theme[:button] = { base: "rounded-full", defaults: { variant: :outline } }
  config.theme[:card_header] = { base: "p-8 sm:p-10" }

  # Per-slot overrides (ui: key) — targets inner sub-part elements
  config.theme[:card] = { base: "rounded-xl", ui: { header: "p-8", footer: "px-8" } }
  config.theme[:alert] = { ui: { close: "opacity-50", wrapper: "gap-4" } }
end
```

Override hashes accept `base:`, `variants:`, `compound_variants:`, `defaults:`, `ui:`. Applied once at boot — zero per-render cost. Snake_case keys map to PascalCase constants (`:card_header` -> `Kiso::Themes::CardHeader`).

## Per-slot `ui:` overrides

The `ui:` prop accepts a hash of slot-name to class-string pairs. It targets inner sub-part elements that `css_classes:` can't reach.

### Composed components

Sub-parts inherit `ui:` overrides automatically via a context stack in `kui()`:

```erb
<%= kui(:card, ui: { header: "p-8 bg-muted", title: "text-xl" }) do %>
  <%= kui(:card, :header) do %>
    <%= kui(:card, :title) { "Dashboard" } %>
  <% end %>
  <%= kui(:card, :content) { "Body" } %>
<% end %>
```

### Self-rendering components

Components that render sub-parts internally (Alert, Dialog, Slider, Switch, etc.) accept `ui:` as a local and apply overrides to their inner elements:

```erb
<%= kui(:alert, icon: "triangle-alert", color: :warning, ui: {
  close: "opacity-50",
  wrapper: "gap-4"
}) do %>
  <%= kui(:alert, :title) { "Heads up" } %>
  <%= kui(:alert, :description) { "Something happened." } %>
<% end %>

<%= kui(:slider, ui: { track: "bg-muted", thumb: "bg-primary" }) %>
```

### Slot name reference

Slot names match sub-part names used in `kui(:component, :part)`:

| Component | Available slots |
|---|---|
| Alert | `:wrapper`, `:close`, `:icon` |
| AlertDialog | `:content` |
| Avatar | `:fallback`, `:image` |
| Dialog | `:content` |
| SelectNative | `:wrapper`, `:icon` |
| Slider | `:track`, `:range`, `:thumb` |
| Switch | `:thumb` |
| Command Group | `:heading` |
| Command Input | `:wrapper` |
| Combobox Item | `:indicator` |
| Nav Item | `:badge` |
| Nav Section | `:title`, `:content` |
| Select Item | `:indicator` |

See `project/component-strategy.md` and `project/decisions/004-per-slot-ui-prop.md` for the full architecture reference.
