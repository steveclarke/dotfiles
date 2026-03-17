# Progress

Visual progress bar showing task completion percentage. Div-based structure with optional status text and step labels. Pure CSS — no Stimulus controller.

**Locals:** `value:` (integer or nil), `max:` (integer or array of step labels), `status:` (boolean), `color:`, `size:` (xs-xl), `animation:` (carousel/carousel_inverse/swing/elastic), `orientation:` (horizontal/vertical), `inverted:`, `ui:`, `css_classes:`, `**component_options`

**Defaults:** `value: nil` (indeterminate), `max: 100`, `color: :primary`, `size: :md`, `animation: :carousel`, `orientation: :horizontal`

```erb
<%# Basic %>
<%= kui(:progress, value: 33) %>

<%# Color + size %>
<%= kui(:progress, value: 75, color: :success, size: :lg) %>

<%# Indeterminate (no value) %>
<%= kui(:progress) %>

<%# With status percentage text %>
<%= kui(:progress, value: 60, status: true) %>

<%# With step labels (max as array) %>
<%= kui(:progress, value: 1, max: ["Sign Up", "Profile", "Complete"]) %>

<%# Animation variant for indeterminate %>
<%= kui(:progress, animation: :swing) %>
```

**Sub-parts:** track (`data-slot="progress-track"`), indicator (`data-slot="progress-indicator"`), status (`data-slot="progress-status"`), steps (`data-slot="progress-steps"`), step (`data-slot="progress-step"`)

**Color axis:** primary, secondary, success, info, warning, error, neutral — maps directly to `bg-{color}` on the indicator. No variant axis (solid/outline/soft/subtle).

**Indeterminate:** Omit `value:` for animated state. 4 animation styles gated by `data-[state=indeterminate]:` CSS selector. `prefers-reduced-motion` disables animation.

**Steps:** Pass `max:` as an array of label strings. `value:` is the current step index (0-based). Steps stack in a grid cell with opacity transitions.

**Theme module:** `Kiso::Themes::Progress`, `ProgressTrack`, `ProgressIndicator`, `ProgressStatus`, `ProgressSteps`, `ProgressStep` (`lib/kiso/themes/progress.rb`)
