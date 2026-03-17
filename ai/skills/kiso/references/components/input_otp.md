# InputOTP

One-time password input with individual character slots, auto-advance, and paste support.
Uses a single transparent `<input>` overlaying visual slot divs managed by the `kiso--input-otp` Stimulus controller.

**Locals (input_otp):** `length:` (6), `name:`, `id:`, `value:`, `pattern:` (`"\\d"`), `disabled:`, `autocomplete:` (`"one-time-code"`), `aria_label:`, `css_classes:`, `**component_options`

**Locals (slot):** `size:` (sm/md/lg), `css_classes:`, `**component_options`

**Locals (group, separator):** `css_classes:`, `**component_options`

**Sub-parts:**
- `kui(:input_otp, :group)` — groups adjacent slots
- `kui(:input_otp, :slot)` — individual character display
- `kui(:input_otp, :separator)` — visual divider (default: minus icon, block override)

**Defaults:** `length: 6, pattern: "\\d", size: :md, autocomplete: "one-time-code"`

```erb
<%= kui(:input_otp, length: 6, name: "otp_code") do %>
  <%= kui(:input_otp, :group) do %>
    <% 3.times do %><%= kui(:input_otp, :slot) %><% end %>
  <% end %>
  <%= kui(:input_otp, :separator) %>
  <%= kui(:input_otp, :group) do %>
    <% 3.times do %><%= kui(:input_otp, :slot) %><% end %>
  <% end %>
<% end %>
```

**Alphanumeric:** `pattern: "[a-zA-Z0-9]"`

**With field:**
```erb
<%= kui(:field) do %>
  <%= kui(:field, :label) { "Verification Code" } %>
  <%= kui(:input_otp, length: 6, name: "code") do %>
    ...
  <% end %>
  <%= kui(:field, :description) { "Enter the code sent to your email." } %>
<% end %>
```

**Events:** `kiso--input-otp:change` ({ value }), `kiso--input-otp:complete` ({ value })

**Auto-submit on complete:**
```erb
<%= kui(:input_otp, length: 6, name: "otp",
    data: { action: "kiso--input-otp:complete->verification#submit" }) do %>
```

**Theme modules:** `Kiso::Themes::InputOtp`, `InputOtpGroup`, `InputOtpSlot`, `InputOtpSeparator` (`lib/kiso/themes/input_otp.rb`)

**CSS:** `app/assets/tailwind/kiso/input-otp.css` — caret blink animation

**Stimulus:** `kiso--input-otp` controller (value distribution, active slot tracking, pattern filtering, caret management)
