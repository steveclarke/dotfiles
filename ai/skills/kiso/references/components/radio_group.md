# RadioGroup

A group of radio buttons for selecting one option from a set. Container uses
`role="radiogroup"`, items are native `<input type="radio">`.

**Locals (RadioGroupItem):** `color:` (7 colors), `css_classes:`, `**component_options`

**Defaults:** `color: :primary`

**Sub-parts:** `kui(:radio_group, :item)`

```erb
<%= kui(:radio_group, name: :plan) do %>
  <div class="flex items-center gap-3">
    <%= kui(:radio_group, :item, value: "free", id: :plan_free) %>
    <%= kui(:field, :label, for: :plan_free) { "Free" } %>
  </div>
  <div class="flex items-center gap-3">
    <%= kui(:radio_group, :item, value: "pro", id: :plan_pro) %>
    <%= kui(:field, :label, for: :plan_pro) { "Pro" } %>
  </div>
<% end %>

<%# With Rails form helpers %>
<%= f.radio_button :plan, "free",
    class: Kiso::Themes::RadioGroupItem.render(color: :primary) %>
```

**Theme modules:** `Kiso::Themes::RadioGroup`, `RadioGroupItem` (`lib/kiso/themes/radio_group.rb`)
