# Components

Rails ERB components powered by Tailwind CSS and class_variants. Each component is a partial rendered via the `kui()` helper. Theme definitions live in `lib/kiso/themes/`.

All colored components use **identical compound variant formulas** — see `project/design-system.md`.

**Each component has its own reference file in `components/`.** Load only the ones you need.

## Data Display

| Component | Key locals | Reference |
|---|---|---|
| `avatar` | `src`, `alt`, `text`, `size` (xs/sm/md/lg/xl/2xl), `color` (CSS color for bg). Sub-parts: image, fallback, badge, group, group_count | [avatar.md](components/avatar.md) |

## Layout

| Component | Key locals | Reference |
|---|---|---|
| `app` | No variants. Root wrapper with `bg-background text-foreground antialiased` | [app.md](components/app.md) |
| `container` | `size` (narrow/default/wide/full). Centered content with responsive padding | [container.md](components/container.md) |
| `header` | No variants. Semantic `<header>` with sticky positioning and backdrop blur | [header.md](components/header.md) |
| `footer` | No variants. Semantic `<footer>` element | [footer.md](components/footer.md) |
| `main` | No variants. Semantic `<main>` with `flex-1` to fill remaining space | [main.md](components/main.md) |
| `aspect_ratio` | `ratio` (number, default 16.0/9). No variants | [aspect_ratio.md](components/aspect_ratio.md) |
| `card` | `variant` (outline/soft/subtle) | [card.md](components/card.md) |
| `dashboard_group` | `sidebar_open`, `layout` (`:sidebar` default / `:navbar`). Sub-parts via separate components: `dashboard_navbar`, `dashboard_sidebar`, `dashboard_panel`. Stimulus: `kiso--sidebar` | [dashboard_group.md](components/dashboard_group.md) |
| `dashboard_navbar` | Topbar container (panel column only in `:sidebar` layout, full-width in `:navbar` layout). Sub-part: toggle | [dashboard_group.md](components/dashboard_group.md) |
| `dashboard_sidebar` | Collapsible sidebar with auto-rendered inner scroll container | [dashboard_group.md](components/dashboard_group.md) |
| `dashboard_panel` | Main content area | [dashboard_group.md](components/dashboard_group.md) |
| `dashboard_toolbar` | Page-level toolbar. Sub-parts: left, right | [dashboard_group.md](components/dashboard_group.md) |
| `empty` | Media sub-part has `variant` (default/icon) | [empty.md](components/empty.md) |
| `page` | Grid layout with left/right sidebar slots. Sub-parts: left, center, right | [page.md](components/page.md) |
| `page_header` | Section header with `headline`, `title`, `description` props. Sub-parts: headline, title, description, links. `ui:` slots: wrapper, headline, title, description | [page.md](components/page.md) |
| `page_body` | Main content wrapper with vertical spacing (`mt-8 pb-24 space-y-12`) | [page.md](components/page.md) |
| `page_section` | `orientation` (horizontal/vertical). Sub-parts: wrapper, header, headline, title, description, body, links. `ui:` slots: container | [page.md](components/page.md) |
| `page_grid` | Responsive grid (1/2/3 columns). Wrapper for page cards | [page.md](components/page.md) |
| `page_card` | `variant` (outline/soft/subtle/ghost), `icon`, `title`, `description`. Sub-parts: icon, title, description, header, body, footer. `ui:` slots: container, wrapper, icon, title, description | [page.md](components/page.md) |
| `stats_card` | `variant` (outline/soft/subtle) | [stats_card.md](components/stats_card.md) |
| `stats_grid` | `columns` (1-4). Responsive grid wrapper for stats cards | [stats_card.md](components/stats_card.md) |
| `separator` | `orientation` (horizontal/vertical), `decorative` | [separator.md](components/separator.md) |
| `skeleton` | No variants. Loading placeholder with `animate-pulse`. Shape via `css_classes:` | [skeleton.md](components/skeleton.md) |
| `spinner` | No variants. Spinning loading indicator with `animate-spin`. Size via `css_classes:`. Inherits `currentColor` | [spinner.md](components/spinner.md) |
| `table` | 7 sub-parts: header, body, footer, row, head, cell, caption | [table.md](components/table.md) |

## Forms

| Component | Key locals | Reference |
|---|---|---|
| `field` | `orientation` (vertical/horizontal/responsive), `invalid`, `disabled` | [field.md](components/field.md) |
| `field_group` | Container for stacking fields with gap-7 spacing | [field.md](components/field.md) |
| `field_set` | Semantic `<fieldset>` for checkbox/radio groups | [field.md](components/field.md) |
| `label` | Styled `<label>` element | [label.md](components/label.md) |
| `input` | `variant` (outline/soft/ghost), `size` (sm/md/lg) | [input.md](components/input.md) |
| `textarea` | `variant` (outline/soft/ghost), `size` (sm/md/lg) | [textarea.md](components/textarea.md) |
| `input_group` | Wraps input + addons with shared ring | [input_group.md](components/input_group.md) |
| `input_otp` | `length`, `name`, `pattern`, `size` (sm/md/lg). Sub-parts: group, slot, separator. Stimulus: `kiso--input-otp` | [input_otp.md](components/input_otp.md) |
| `select_native` | `variant` (outline/soft/ghost), `size` (sm/md/lg). Styled native `<select>` with chevron overlay, no JS | [select_native.md](components/select_native.md) |
| `checkbox` | `color` (7 colors), `checked` | [checkbox.md](components/checkbox.md) |
| `radio_group` | `color` (7 colors). Sub-part: item | [radio_group.md](components/radio_group.md) |
| `combobox` | `name`, `multiple`. Sub-parts: input, content, list, item, empty, group, label, separator, chips, chip, chips_input. Stimulus: `kiso--combobox` | [combobox.md](components/combobox.md) |
| `select` | `name`, `size` (sm/md). Sub-parts: trigger, value, content, group, label, item, separator. Stimulus: `kiso--select` | [select.md](components/select.md) |
| `slider` | `min`, `max`, `step`, `value`, `size` (sm/md/lg), `disabled`. Stimulus: `kiso--slider` | [slider.md](components/slider.md) |
| `switch` | `color` (7 colors), `size` (sm/md), `checked` | [switch.md](components/switch.md) |

## Overlay

| Component | Key locals | Reference |
|---|---|---|
| `alert_dialog` | `open`, `size` (default/sm). Sub-parts: header, title, description, media, footer, action, cancel. No backdrop/Escape dismiss. Reuses `kiso--dialog` controller with `dismissable: false` | [alert_dialog.md](components/alert_dialog.md) |
| `dropdown_menu` | 13 sub-parts: trigger, content, item, checkbox_item, radio_group, radio_item, label, separator, shortcut, group, sub, sub_trigger, sub_content. Item `variant` (default/destructive), `href:` + `method:` smart tag. Stimulus: `kiso--dropdown-menu` | [dropdown_menu.md](components/dropdown_menu.md) |
| `popover` | `align` (start/center/end) on content. Sub-parts: trigger, content, anchor, header, title, description. Stimulus: `kiso--popover` | [popover.md](components/popover.md) |

## Navigation

| Component | Key locals | Reference |
|---|---|---|
| `nav` | Sidebar navigation. Sub-parts: item (`href`, `icon`, `badge`, `active`), section (`title`, `open`, `collapsible`), section_title. Uses HTML5 `<details>` for collapsible sections | [dashboard_group.md](components/dashboard_group.md) |
| `breadcrumb` | 7 sub-parts: list, item, link, page, separator, ellipsis | [breadcrumb.md](components/breadcrumb.md) |
| `command` | 8 sub-parts: input, list, empty, group, item, separator, shortcut, dialog. Stimulus: `kiso--command`, `kiso--command-dialog` | [command.md](components/command.md) |
| `dialog` | `open:` (boolean). Sub-parts: header, title, description, body, footer, close. Stimulus: `kiso--dialog` | [dialog.md](components/dialog.md) |
| `pagination` | 6 sub-parts: content, item, link, previous, next, ellipsis | [pagination.md](components/pagination.md) |

## Element

| Component | Key locals | Reference |
|---|---|---|
| `alert` | `icon`, `color`, `variant` (solid/outline/soft/subtle), `close`. Sub-parts: title, description, actions. Stimulus: `kiso--alert` | [alert.md](components/alert.md) |
| `badge` | `color`, `variant` (solid/outline/soft/subtle), `size` (xs-xl) | [badge.md](components/badge.md) |
| `button` | `color`, `variant` (solid/outline/soft/subtle/ghost/link), `size` (xs-xl), `loading:` (spinner + disabled), `loading_auto:` (Turbo form auto-loading), `method:` (delete/post/put/patch), `form:` | [button.md](components/button.md) |
| `color_mode_button` | `size` (sm/md/lg). Toggles light/dark via `kiso--theme#toggle`. Icons: `kiso_component_icon(:sun/:moon)` | [color_mode_button.md](components/color_mode_button.md) |
| `color_mode_select` | `size` (sm/md). Three-way select (light/dark/system). Composes `kui(:select)`, dispatches to `kiso--theme#set` | [color_mode_select.md](components/color_mode_select.md) |
| `kbd` | `size` (sm/md/lg). Sub-part: group | [kbd.md](components/kbd.md) |
| `progress` | `value`, `max` (int or array of step labels), `status`, `color`, `size` (xs-xl), `animation` (carousel/carousel_inverse/swing/elastic), `orientation`, `inverted`. Sub-parts: track, indicator, status, steps, step | [progress.md](components/progress.md) |
| `toggle` | `variant` (default/outline), `size` (sm/default/lg), `pressed` | [toggle.md](components/toggle.md) |
| `toggle_group` | `type` (single/multiple), `variant`, `size`. Sub-part: item | [toggle_group.md](components/toggle_group.md) |
| `tooltip` | `text`, `kbds`, `side` (top/right/bottom/left), `align` (center/start/end), `delay`. Sub-parts: trigger, content. Stimulus: `kiso--tooltip` | [tooltip.md](components/tooltip.md) |

## Compound Variant Reference

All colored components share these exact formulas (see `project/design-system.md`):

| Variant | Colored | Neutral |
|---|---|---|
| solid | `bg-{color} text-{color}-foreground` | `bg-inverted text-inverted-foreground` |
| outline | `text-{color} ring-{color}/50` | `text-foreground bg-background ring-accented` |
| soft | `bg-{color}/10 text-{color}` | `text-foreground bg-elevated` |
| subtle | `bg-{color}/10 text-{color} ring-{color}/25` | `text-foreground bg-elevated ring-accented` |

`ring ring-inset` is on the variant axis (outline, subtle), not in compound variants.
