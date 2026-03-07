---
name: branding
description: Create a complete brand identity for a project — logo, colors, fonts, and asset pack. Guides the user through generating a logo with AI tools (quiver.ai), selecting fonts and brand colors, refining SVGs with Inkscape, and producing a full asset pack (SVG variants, PNGs, favicons, social images). Optionally wires assets into a project (README, docs site, GitHub, npm). Use when the user mentions branding, logo, brand assets, brand color, project identity, social preview, OG image, or wants to create a visual identity for a project. Also triggers on "brand pack", "logo for my project", or "set up branding".
---

# Branding

Create a complete brand identity for a project: logo mark, wordmark lockups, color palette, font selection, and a production-ready asset pack.

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

The workflow has 6 phases. The first 3 are collaborative with the user; the last 3 are mostly automated production work.

1. **Discovery** — understand the project and what the logo should convey
2. **Logo generation** — craft a prompt for an AI SVG tool, user generates it
3. **Font and color selection** — pick a wordmark font and brand color
4. **SVG refinement** — Inkscape: text to paths, viewBox cleanup, lockup creation
5. **Asset pack production** — export all variants, sizes, and formats
6. **Project wiring** — place assets where they're needed (optional)

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

Suggest 3-4 fonts that pair well with the mark's style. For each, create a quick SVG preview:

```xml
<svg xmlns="http://www.w3.org/2000/svg" width="400" height="100" viewBox="0 0 400 100">
  <style>@import url('https://fonts.googleapis.com/css2?family=FONT_NAME:wght@700');</style>
  <text x="20" y="70" font-family="'FONT NAME', sans-serif" font-weight="700"
        font-size="60" fill="#18181b">ProjectName</text>
</svg>
```

Open these in the browser for the user to compare. Google Fonts `@import` works for browser preview but NOT for Inkscape — the font must be installed locally for production work.

Once the user picks a font:

1. Find the font on GitHub (most Google Fonts are on github.com/google/fonts or the foundry's repo)
2. Download the actual font files (.ttf or .otf) from a GitHub release — NOT from the Google Fonts CDN (it returns HTML, not font files)
3. Install the font locally: `cp *.ttf ~/Library/Fonts/` (macOS)
4. Save font files to `brand/fonts/` for the asset pack

### Color

Ask the user where they're starting from:

1. **Tailwind palette shade** — simplest path. Suggest options that match the project's vibe with hex values and context (e.g., "rose-500 (#f43f5e) — warm, energetic, stands out on white"). The full shade range is already defined.

2. **Inspiration image or photo** — extract a dominant color using ImageMagick:
   ```bash
   magick image.jpg -resize 1x1! -format "%[hex:u.p{0,0}]" info:
   ```
   Use the extracted hex as a starting point to find the nearest Tailwind shade or generate a custom scale.

3. **Arbitrary hex color** — the user has a specific color in mind. Generate a full shade scale using a Tailwind color generator. Preferred: https://uicolors.app/generate (paid tool, excellent quality). Alternative: https://kigen.design/color. Both take a hex value and produce a 50-950 scale with proper perceptual uniformity. Open the tool in the browser for the user.

4. **Color family or mood** — "warm", "earthy", "corporate blue", "playful". Suggest 3-4 specific colors with hex values and let them pick.

However you get there, record the final color with shade variants for the asset pack:
- **Primary**: the main color (e.g., rose-500 `#f43f5e`)
- **Light**: one shade lighter (e.g., rose-400 `#fb7185`) — for highlights, isometric light faces
- **Dark**: one shade darker (e.g., rose-600 `#e11d48`) — for shadows, isometric dark faces
- **Darker**: two shades darker (e.g., rose-700 `#be123c`) — for deep shadows

For arbitrary hex colors, use the generated scale's 400/500/600/700 values for these roles.

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

### Text to paths

Google Fonts `@import` doesn't work in Inkscape. The font must be installed locally first (done in Phase 3). Then convert all text to paths so the SVG is self-contained:

```bash
inkscape input.svg --actions="select-all;object-to-path;export-filename:output.svg;export-do"
```

After conversion, verify the output — open it and confirm the text renders correctly without any font dependency.

### Color variants

- **Black**: replace all fill colors with `#18181b` (zinc-950, not pure black — standard design practice for better readability)
- **White**: replace all fill colors with `#ffffff`
- For lockups, the mark keeps its colors in the "color" variant; text is `#18181b`. In black/white variants, everything is monochrome.

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

## Phase 6: Project Wiring (Optional)

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
- [ ] All assets committed to `brand/` directory
- [ ] Project wiring completed (if applicable)
- [ ] Manual steps communicated to user
