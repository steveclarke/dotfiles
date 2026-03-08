---
name: ui-review
description: Review UI for visual consistency, layout structure, and design system compliance. Two modes — code review (check view files against patterns) and visual audit (screenshot all routes and analyze). Use when reviewing UI code, checking consistency, auditing views, or when user says "review the UI", "check consistency", "UI audit", "design review".
---

# UI Review

Review application UI for consistency, design system compliance, and structural
patterns. This skill acts as the "designer eye" — catching inconsistencies that
accumulate when features are built ad-hoc.

## Two Modes

### Mode 1: Code Review (`/ui-review` or "review the UI code")

Analyze view files for structural consistency. Run this after building new
views or when things feel inconsistent.

**What to check:**

1. **Layout usage** — Every page should use a Kiso dashboard layout component
   (`dashboard_group`, `dashboard_navbar`, `dashboard_sidebar`, `dashboard_panel`).
   Flag any page that hand-rolls its own shell.

2. **Page structure** — Compare all page templates side-by-side. Look for:
   - Consistent page header pattern (title, description, actions)
   - Consistent content wrapper (padding, max-width)
   - Consistent spacing between sections
   - Flag pages that deviate from the dominant pattern

3. **Component usage** — Every UI element should use a `kui()` component.
   Flag raw HTML that Kiso already covers: hand-rolled buttons, cards, tables,
   badges, alerts, avatars, dialogs, dropdowns.

4. **Spacing values** — Check for arbitrary Tailwind spacing (p-7, mt-11,
   gap-3.5). All spacing should come from the standard scale:
   1, 1.5, 2, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24.
   Flag non-standard values as potential inconsistencies.

5. **Typography** — Check for consistent heading hierarchy. Same type of page
   should use the same heading size. Flag mixed heading sizes for the same
   structural role.

6. **Color usage** — Should use semantic tokens (primary, secondary, muted,
   destructive) not raw colors (blue-500, zinc-700). Flag raw color classes
   except in Kiso component overrides.

7. **Pattern drift** — If the same UI concept appears in multiple places
   (e.g., "a list of items with actions"), they should look the same. Flag
   divergent implementations of the same concept.

**Output format:**

```markdown
## UI Code Review

### Consistency Issues
1. **[file:line]** — Description of what's inconsistent and what it should match

### Missing Kiso Components
1. **[file:line]** — Raw HTML that should use `kui(:component)`

### Non-Standard Values
1. **[file:line]** — `p-7` should be `p-6` or `p-8` (standard scale)

### Recommendations
- Concrete suggestions for extracting shared patterns
```

### Mode 2: Visual Audit ("audit the UI" or "screenshot audit")

Systematic visual analysis of every screen in the app.

**Step 1: Discover routes**
```bash
bin/rails routes | grep "GET" | grep -v "rails/" | grep -v "turbo"
```

**Step 2: Capture each page**

Use the browser automation tools (Chrome MCP or claude-in-chrome) to:
1. Log in to the app
2. Navigate to each route
3. For each page, capture two things:
   - **Screenshot** — Save to `tmp/ui-audit/screenshots/` with descriptive names
   - **Rendered HTML** — Save the page's rendered DOM to `tmp/ui-audit/html/`.
     This is the post-render HTML with all Tailwind classes resolved and Kiso
     components expanded. More useful than ERB source because it captures final
     output without tracing through layouts, partials, and components.

**Step 3: Analyze rendered HTML**

The HTML reveals things screenshots can't:

- **Kiso component usage** — Elements with `data-slot` attributes are Kiso
  components. Elements without them are hand-rolled HTML. Flag hand-rolled
  elements that have a Kiso equivalent (e.g. a raw `<button>` when
  `kui(:button)` exists).
- **Spacing scale compliance** — Grep for Tailwind spacing classes (`p-`,
  `m-`, `gap-`, `space-`) and flag values not on the standard scale
  (1, 1.5, 2, 3, 4, 6, 8, 12, 16). Values like `p-7`, `mt-11`, `gap-3.5`
  are drift.
- **Color token compliance** — Flag raw color classes (`text-gray-500`,
  `bg-blue-600`) that should use semantic tokens (`text-muted-foreground`,
  `bg-primary`).
- **Typography consistency** — Check that text size/weight combinations match
  the defined hierarchy across all pages.
- **Layout structure** — Verify pages use the expected wrapper components
  (dashboard shells, content wrappers).

**Step 4: Analyze screenshots as a set**

Look at ALL screenshots together. Check for:

- **Header consistency** — Same height, same elements, same positions across pages
- **Sidebar consistency** — Same width, same style, same active states
- **Content area** — Same padding, same max-width, same background
- **Card styles** — Same border radius, same shadow, same padding
- **Typography hierarchy** — Page titles same size? Section titles same size?
- **Spacing rhythm** — Consistent gaps between sections across pages
- **Color palette** — Are the same semantic colors used for the same purposes?
- **Empty states** — Do pages without data handle it consistently?
- **Action placement** — Are primary actions always in the same position?

**Step 5: Report**

Group findings by severity:

- **Structural** — Different layout shells, missing sidebar, different header
- **Spacing** — Inconsistent padding, gaps, margins between pages
- **Typography** — Different heading sizes for same role
- **Component** — Same concept rendered differently on different pages
- **Minor** — Small visual details (border radius, shadow, opacity)

For each finding, reference specific pages and suggest which version should
be the canonical one (usually the most common pattern wins).

## Design System Principles

When recommending fixes, follow these principles:

**The most common pattern wins.** If 4 pages use `p-6` content padding and 1
uses `p-8`, the fix is changing the 1, not the 4.

**Extract, don't duplicate.** If the same header pattern appears on 3+ pages,
it should be a partial or component, not copy-pasted HTML.

**Kiso first.** Any UI element that Kiso provides should use the Kiso version.
Don't hand-roll what the framework gives you.

**Spacing from the scale.** No arbitrary values. If something needs to be
"between 6 and 8", pick one. Consistency beats precision.

**One way to do each thing.** A list of items should look the same everywhere.
A page header should look the same everywhere. An empty state should look the
same everywhere. Pick the best version and replicate it.
