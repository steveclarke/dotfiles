# Slider

A range input where the user selects a value by dragging a thumb along a track. Uses a hidden `<input type="range">` for form submission and a visual overlay with `role="slider"` on the thumb for accessibility. Stimulus controller handles drag, keyboard, and track click.

**Locals:** `min:` (0), `max:` (100), `step:` (1), `value:` (nil), `name:`, `id:`, `disabled:` (false), `size:` (sm/md/lg), `css_classes:`, `**component_options`

**Defaults:** `size: :md, min: 0, max: 100, step: 1`

```erb
<%= kui(:slider) %>
<%= kui(:slider, value: 75, max: 100, step: 1) %>
<%= kui(:slider, size: :sm, value: 50) %>
<%= kui(:slider, min: 0, max: 1, step: 0.1, value: 0.5) %>
<%= kui(:slider, disabled: true, value: 50) %>

<%# With Field %>
<%= kui(:field) do %>
  <%= kui(:field, :label, for: :volume) { "Volume" } %>
  <%= kui(:slider, id: :volume, name: :volume, value: 33) %>
<% end %>
```

**Theme modules:** `Kiso::Themes::Slider`, `SliderTrack`, `SliderRange`, `SliderThumb` (`lib/kiso/themes/slider.rb`)

**Stimulus:** `kiso--slider` controller. Dispatches `kiso--slider:change` with `{ value }` detail. Keyboard: Arrow keys (+/-step), Page Up/Down (+/-10x step), Home/End (min/max).
