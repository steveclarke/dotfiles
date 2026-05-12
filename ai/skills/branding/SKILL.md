---
name: branding
description: "Create a complete brand identity — logo (via quiver.ai), colors, fonts, SVG refinement in Inkscape, and a full asset pack (PNGs, favicons, OG images), delivered as a brand guide HTML page. Triggers on branding, logo, brand pack, brand color, project identity, social preview, visual identity."
---

# Branding

Create a complete brand identity for a project: logo mark, wordmark lockups, color palette, font selection, a production-ready asset pack, and a brand guide.

## Prerequisites

Verify these tools are installed before starting:

```bash
which inkscape && which magick
```

- **Inkscape** — SVG manipulation, text-to-path conversion, PNG export
  - macOS: `brew install --cask inkscape`
- **ImageMagick v7+** — image compositing, resizing, format conversion
  - macOS: `brew install imagemagick`

## Overview

The workflow has 7 phases. The first 3 are collaborative with the user; the last 4 are mostly automated production work.

1. **Discovery** — understand the project and what the logo should convey
2. **Logo generation** — craft a prompt for an AI SVG tool, user generates it
3. **Font and color selection** — pick a wordmark font and brand color
4. **SVG refinement** — Inkscape: text to paths, viewBox cleanup, lockup creation
5. **Asset pack production** — export all variants, sizes, and formats
6. **Brand guide** — generate a comprehensive HTML brand reference page
7. **Project wiring** — place assets where they're needed (optional)

## Browser-Based Previews

Throughout the collaborative phases, use temporary HTML pages to show the user their options. This is a core technique in this workflow — never ask the user to open SVG files from folders or guess what things look like.

**The pattern:**

1. Generate a self-contained HTML file in the project's `tmp/` directory (e.g., `tmp/brand-fonts.html`)
2. Open it in Chrome: `open -a "Google Chrome" /path/to/file.html`
3. The user reviews and gives feedback
4. Clean up `tmp/` files before committing

**Key rules for preview pages:**
- Use plain HTML and CSS only — avoid JavaScript where possible. If JS is needed, use safe DOM methods (`textContent`, `createElement`) rather than `innerHTML`, which security hooks may block.
- Load Google Fonts via `<link>` tags in the `<head>` for font previews — they render instantly in the browser.
- Inline SVG marks directly in the HTML for lockup previews (no external file references).
- Keep pages self-contained — no external dependencies beyond Google Fonts CDN.

---

## Phase 1: Discovery

Ask the user:

1. **Project name** — exact casing and spelling for the wordmark
2. **What it does** — one sentence, so you understand the domain
3. **Logo vibe** — abstract geometric? lettermark? mascot? isometric? minimal?
4. **Any symbols or metaphors** — things the name evokes (e.g., "Kiso" means "foundation" in Japanese, which led to stacked building blocks)
5. **Color preferences** — warm/cool, any existing colors, or "surprise me"

Don't overthink this — a 2-minute conversation is enough. The AI tool will do the creative heavy lifting.

## Phase 2: Logo Generation

Craft a detailed prompt for the user to paste into an AI SVG generation tool (quiver.ai, recraft.ai, or similar). The prompt should specify:

- The visual concept from discovery
- "SVG format" or "vector" explicitly
- Style keywords (isometric, flat, geometric, minimal, etc.)
- Color guidance if the user has preferences
- "No text" — the wordmark will be added separately with a proper font

Present the prompt to the user. They paste it into the tool, generate options, and either:
- Share the SVG file with you, or
- Save it to a known path

Once you have the SVG, read it to understand its structure (viewBox, dimensions, colors used). This is the **mark** — the icon without text.

**Important:** If the mark SVG has embedded text or fonts, note it — those will be converted to paths in Phase 4.

## Phase 3: Font and Color Selection

### Font

Suggest 4-6 fonts that pair well with the mark's style. Build a **single HTML preview page** that shows all candidates side by side:

- Each font rendered as the project name in bold (700/800) at large size using the proposed brand color
- A second line in regular weight (400) for comparison
- A body text sample ("The quick brown fox...")
- Weight demos (400, 600, 700, 800) if the font supports them
- Brief notes on personality and fit (e.g., "Geometric, modern — closest to current wordmark")

Load fonts via Google Fonts `<link>` tags. Open the page in Chrome for the user to compare.

**After the user picks a font:**

1. Download from the Google Fonts GitHub repo (most reliable source):
   ```bash
   curl -L -o /tmp/FontName.ttf "https://raw.githubusercontent.com/google/fonts/main/ofl/fontname/FontName%5Bwght%5D.ttf"
   ```
   Note: use the `ofl/` path for most Google Fonts. Verify the download with `file /tmp/FontName.ttf` — it should say "TrueType Font data", not "HTML" or "ASCII text".
2. Install locally: `cp /tmp/FontName.ttf ~/Library/Fonts/` (macOS)
3. Save to `brand/fonts/` for the asset pack

### Color

If the user already has a logo with colors, extract them first. Show all colors found in the SVG as chips in a preview HTML page — name each one by its role (e.g., "Hull Navy", "Sail Red").

Then present **brand color candidates** as large clickable-looking cards with:
- A big color swatch showing the hex
- A name and description of its personality
- A recommendation note on the best one

Include a **proposed color schema** section showing how the colors would be used:
- **Primary** — buttons, links, active states
- **Dark/Navy** — sidebar, headings, dark surfaces
- **Accent** — alerts, destructive actions, visual interest
- **Highlight** — info banners, selected states

**Color variant exploration:** If the user wants to try different shades or swap a color (e.g., "that red is too dark"), generate a comparison page with 4-6 variants showing the full mark with each color swapped in. Use `sed` to replace hex values in the SVG for quick iteration — inline each variant SVG directly in the HTML.

**Tailwind color scale:** When the user settles on a brand color, they'll need a full shade scale for Tailwind. Direct them to generate one at:
- **uicolors.app** — excellent OKLCH-based scales
- **kigen.design/color** — alternative generator

The user pastes their hex, gets back a 50-950 scale in OKLCH, and shares it with you to wire into the project.

### Recording color decisions

Record the final colors for the asset pack:
- **Primary**: the main brand color with its Tailwind scale name
- **All logo colors**: hex values and roles (hull, sails, water, etc.)
- **Tailwind scale**: the full 50-950 OKLCH values

## Phase 4: SVG Refinement

This phase produces the master SVGs that everything else is derived from. You need **9 SVG files**:

| Variant | Mark only | Horizontal lockup | Stacked lockup |
|---------|-----------|-------------------|----------------|
| **Color** | mark-color.svg | logo-horizontal-color.svg | logo-stacked-color.svg |
| **Black** | mark-black.svg | logo-horizontal-black.svg | logo-stacked-black.svg |
| **White** | mark-white.svg | logo-horizontal-white.svg | logo-stacked-white.svg |

### Creating lockups

A **lockup** is the mark + wordmark text composed together. Two layouts:
- **Horizontal** — mark on the left, text to the right, vertically centered
- **Stacked** — mark on top, text centered below

Start with the color horizontal lockup:

1. Open the mark SVG, note its dimensions
2. Create a new SVG combining the mark with a `<text>` element using the chosen font
3. Size the text proportionally — the text cap-height should be roughly 40-60% of the mark height for horizontal, and the text width should roughly match the mark width for stacked
4. Set the viewBox to tightly fit the content with minimal padding

**Preview each lockup in Chrome** before converting text to paths. Open the SVG directly — `open -a "Google Chrome" file.svg`. The user should confirm the proportions, spacing, and overall feel before proceeding. Adjust text x position, font-size, and viewBox width based on feedback.

### Text to paths

Google Fonts `@import` doesn't work in Inkscape. The font must be installed locally first (done in Phase 3). Then convert all text to paths so the SVG is self-contained:

```bash
inkscape input.svg --actions="select-all;object-to-path;export-filename:output.svg;export-do"
```

After conversion, verify with `grep -c '<text' output.svg` — should return 0.

### Color variants

- **Black**: replace all fill colors with `#18181b` (zinc-950, not pure black — standard design practice for better readability)
- **White**: replace all fill colors with `#ffffff`
- For lockups, the mark keeps its colors in the "color" variant; text is `#18181b`. In black/white variants, everything is monochrome.

Use `sed` for color replacement — handle both `fill="#hex"` attributes and `fill:#hex` in style attributes:
```bash
sed 's/fill="#[0-9A-Fa-f]\{6\}"/fill="#18181b"/g; s/fill:#[0-9a-fA-F]\{6\}/fill:#18181b/g' input.svg > output.svg
```

### ViewBox cleanup

After compositing, trim the viewBox to fit content tightly:

```bash
inkscape file.svg --actions="select-all;fit-canvas-to-selection;export-filename:file.svg;export-do"
```

Or manually adjust the viewBox after checking element bounding boxes:

```bash
inkscape file.svg --query-all
```

## Phase 5: Asset Pack Production

### Directory structure

```
brand/
├── svg/          9 master SVGs (from Phase 4)
├── png/          rasterized variants at standard sizes
├── favicon/      ico + png sizes + webmanifest
├── social/       platform-specific images
└── fonts/        font files + README
```

### PNG exports

Export from the master SVGs using Inkscape (better SVG rendering than ImageMagick):

**Marks** — export at: 64, 128, 256, 512, 1024px (square, width = height)
```bash
inkscape mark-color.svg --export-type=png --export-filename=../png/mark-color-256.png --export-width=256
```

**Lockups** — export at widths appropriate for the aspect ratio:
- Horizontal: 400, 600, 800px wide
- Stacked: 300, 500px wide

### Favicons

Use the `/favicon` skill if available. Otherwise, generate manually from the mark:

```bash
# PNG sizes for favicons
inkscape brand/svg/mark-color.svg --export-type=png --export-filename=brand/favicon/favicon-16x16.png --export-width=16
inkscape brand/svg/mark-color.svg --export-type=png --export-filename=brand/favicon/favicon-32x32.png --export-width=32
inkscape brand/svg/mark-color.svg --export-type=png --export-filename=brand/favicon/apple-touch-icon.png --export-width=180
inkscape brand/svg/mark-color.svg --export-type=png --export-filename=brand/favicon/android-chrome-192x192.png --export-width=192
inkscape brand/svg/mark-color.svg --export-type=png --export-filename=brand/favicon/android-chrome-512x512.png --export-width=512

# ICO (multi-resolution)
magick brand/favicon/favicon-16x16.png brand/favicon/favicon-32x32.png brand/favicon/favicon.ico
```

Create `brand/favicon/site.webmanifest`:
```json
{
  "name": "PROJECT_NAME",
  "short_name": "PROJECT_NAME",
  "icons": [
    { "src": "/android-chrome-192x192.png", "sizes": "192x192", "type": "image/png" },
    { "src": "/android-chrome-512x512.png", "sizes": "512x512", "type": "image/png" }
  ],
  "theme_color": "#HEX_OF_BRAND_COLOR",
  "background_color": "#ffffff",
  "display": "standalone"
}
```

### Social images

**OG image** (1280x640) — for GitHub social preview, Open Graph tags:
```bash
magick -size 1280x640 xc:white \
  \( brand/svg/logo-horizontal-color.svg -resize 1100x -trim +repage \) \
  -gravity center -composite \
  brand/social/og-image-1280x640.png
```

The `-trim +repage` before `-gravity center` is critical — it strips the SVG's internal whitespace so ImageMagick centers the actual visual content, not the viewBox bounding box. Without this, the logo will appear off-center.

**Platform icons:**
- Discord server icon: 512x512 from the mark
- GitHub avatar: 500x500 from the mark
- npm icon: 256x256 from the mark

```bash
inkscape brand/svg/mark-color.svg --export-type=png --export-filename=brand/social/discord-icon-512.png --export-width=512
inkscape brand/svg/mark-color.svg --export-type=png --export-filename=brand/social/github-avatar-500.png --export-width=500
inkscape brand/svg/mark-color.svg --export-type=png --export-filename=brand/social/npm-icon-256.png --export-width=256
```

### Fonts README

Create `brand/fonts/README.md` documenting the font choice, license, and source:

```markdown
# Brand Font

**[Font Name]** by [Foundry]

- Weight: 700 (Bold) for wordmark
- License: SIL Open Font License
- Source: [GitHub URL]

The full font family archive is included for reference.
```

## Phase 6: Brand Guide

Generate a comprehensive HTML brand guide page at `brand/brand-guide.html`. This is what a designer would deliver as a "brand style guide" or "brand board" — a single-page reference that anyone on the team can open to understand how to use the brand.

The brand guide should include these sections:

### 1. Header
Project name and tagline/description at the top.

### 2. Logo Versions
Show all 9 SVG variants organized in a grid:
- **Color** row: mark, horizontal lockup, stacked lockup (on white background)
- **Black** row: same three (on white background)
- **White** row: same three (on dark background, e.g., `#0f172a`)

Label each with its filename and recommended usage:
- **Mark** — favicons, app icons, social avatars, small spaces
- **Horizontal** — headers, README badges, email signatures
- **Stacked** — splash screens, print, when vertical space allows

Include minimum size guidance: mark should not be displayed smaller than 32px, lockups not smaller than 120px wide.

### 3. Color Palette
Show each brand color as a large swatch with:
- Color name and role (e.g., "Primary — buttons, links, focus rings")
- Hex value
- OKLCH value (if available)
- Tailwind class (e.g., `bg-primary-500`)

If a full Tailwind scale was generated, show the complete 50-950 ramp as a horizontal strip of swatches with labels.

Show all logo-specific colors too (hull, sails, water, etc.) with their hex values.

### 4. Typography
- Font name, foundry, license
- Wordmark weight and letter-spacing
- Preview of the font at the wordmark weight, plus regular weight
- Note the font source (Google Fonts, GitHub repo) and where files are stored in `brand/fonts/`

### 5. Asset Inventory
A table listing every file in the `brand/` directory with:
- Filename
- Dimensions or purpose
- Format

Organized by subdirectory (svg/, png/, favicon/, social/, fonts/).

### Construction notes

- **Self-contained HTML** — inline all SVGs directly, load the brand font via Google Fonts `<link>`. No external file references (the guide should work when opened from any location).
- **No JavaScript** — pure HTML and CSS. This ensures it works everywhere and avoids security hook issues.
- **Clean, professional design** — use the brand colors themselves to style the page. White background, brand-colored headings and accents.
- **Print-friendly** — reasonable layout at standard page widths.

After generating, open in Chrome for the user to review: `open -a "Google Chrome" brand/brand-guide.html`

## Phase 7: Project Wiring (Optional)

This phase is project-specific. Ask the user which of these apply:

### README
```html
<p align="center">
  <a href="PROJECT_URL">
    <img src="brand/svg/logo-horizontal-color.svg" width="280" alt="PROJECT_NAME">
  </a>
</p>
```

GitHub renders SVGs from the repo inline. The `width` attribute prevents it from blowing up to full width. Wrap in `<a>` to link to the project's website.

### Docs site / web app
- Copy favicons to the static assets directory
- Add favicon `<link>` tags to `<head>`
- Add `<meta name="theme-color" content="#HEX">`
- Add mark to the navbar/header

### Tailwind theme
If the user has a Tailwind scale, wire it into the CSS:
```css
@theme {
  --color-primary-50: oklch(...);
  --color-primary-100: oklch(...);
  /* ... */
  --color-primary-950: oklch(...);
}
```

### GitHub
- **Social preview**: repo Settings → Social preview → upload OG image (manual step)
- **Avatar**: only applies if using a GitHub Organization (manual step)

### npm
- Add `"homepage"` to package.json pointing to the docs/website

### Other platforms
- Discord server icon (manual upload)
- 1Password: note which account owns the Discord server

Present manual steps clearly at the end — don't try to automate things that require browser UI interaction.

## Checklist

Before declaring done, verify:

- [ ] 9 master SVGs with text converted to paths (no font dependencies)
- [ ] PNG exports at all standard sizes
- [ ] Favicon set (ico, 16, 32, 180, 192, 512, webmanifest)
- [ ] OG image at 1280x640, visually centered
- [ ] Platform icons (Discord 512, GitHub 500, npm 256)
- [ ] Font files saved with README
- [ ] Brand guide HTML generated and reviewed
- [ ] All assets committed to `brand/` directory
- [ ] Temporary preview files in `tmp/` cleaned up
- [ ] Project wiring completed (if applicable)
- [ ] Manual steps communicated to user
