---
name: branding
description: Creates a project's brand identity end to end - the logo mark (drawn with today's best vector generators), wordmark font, colour palette, master SVGs refined in Inkscape, a full asset pack (PNGs, favicons, social images) and a brand guide page. Use for a logo, brand, brand colour, visual identity, favicon set or social preview image for any project.
---

# Branding

The job is what a brand identity designer delivers to a small software project: one strong mark, a wordmark, a palette with roles, master SVGs, every exported asset the project needs, and a one-page brand guide. The work follows that designer's method, starting from the best marks in the project's field (the `creative-prompt` skill) and judging every option at 16 px and in one colour before anyone else sees it.

Contents: how work is shown, then seven phases (discovery, mark, font and colour, master SVGs, asset pack, brand guide, project wiring) and a closing checklist.

## How work is shown

Steve's rules in global `AGENTS.md`, "The bar", hold here: show one best design, in light mode, and options only when he asks; a second model reviews before he does. So each decision point is one recommended result, finished and rendered, with the runner-ups kept ready in case he asks. He reacts to results, never to prompts, SVG files in folders or descriptions of what something would look like.

Each result is shown as a self-contained HTML page: SVGs inlined, fonts from Google Fonts `<link>` tags, no other outside files. It is published the way the person's instructions say private pages go (for Steve, a Hugo artifact page). Plain HTML and CSS is enough; where script is needed, the DOM is built with `textContent` and `createElement`, because security hooks block `innerHTML`. Working files go in the project's `tmp/` and are removed before commit.

## Tools

Inkscape (text to paths, canvas fitting, SVG to PNG) and ImageMagick 7 (`magick`, compositing and `.ico`). The agent installs whichever is missing. Inkscape renders SVG to PNG more faithfully than ImageMagick, so every PNG comes from Inkscape and ImageMagick only composites.

## 1. Discovery

Most answers are in the conversation and the project itself; the agent asks only for what is missing: the exact name and casing for the wordmark, what the project does in one sentence, who it is for, the feeling the mark should carry, any symbol or meaning the name suggests, and existing colours to keep. Discovery stays short; the mark concepts are the real discovery.

## 2. The mark

Dedicated generators draw the mark. A language model writing SVG coordinates by hand produces simple clip-art, so hand-written SVG is for cleanup only, never for the concept.

1. Find today's best generators. The leaders change month to month, so search for the current best text-to-SVG and vector logo models (human-preference leaderboards such as an SVG arena, recent comparisons, release notes) rather than trusting training data or the examples here. Keep the two or three that return real vector output and that the agent can call itself. As of October 2026 the leaders included Quiver's hosted MCP (`https://app.quiver.ai/mcp`) and Recraft's vector model on fal.ai; check they still lead.
2. Call them directly through their MCP server, API or CLI, never by handing the person a prompt to paste. Check what is connected (`claude mcp list`) and which API keys exist (the password manager or environment). A hosted MCP that needs sign-in asks the person once. When a leader needs an account or key that does not exist, say which, what it costs, and carry on with what is available.
3. Study the best first. Look at the marks of the strongest products in the same field and adjacent ones, and write down what makes them work (one idea, a clear silhouette, how they hold at favicon size). The brief to the generators names that bar.
4. Explore wide, then judge. Run one brief from discovery through each tool, several variations each, in clearly different directions. Render every result and judge it as a design director would: the idea, silhouette, balance, legibility at 16 px, one-colour use, whether it is distinct from the field. Discard the weak ones unseen.
5. Show the best one, finished: on a light page at large size, at 16, 32 and 64 px, in one colour, and beside its wordmark in a plain font. One line says its idea and which tool made it. Iterate on feedback through the same tools, keeping the approved version intact while trying alternatives.
6. Clean up the chosen mark. Inspect its SVG (viewBox, dimensions, colours, embedded text or fonts, stray nodes, embedded raster) and tidy it into clean, editable vector paths. The mark stays separate from the wordmark, which gets a real font next.

## 3. Font and colour

### Font

The wordmark font is the Google Font (for licence and availability) that best fits the mark, shown as the real lockup at the brand colour, at bold and regular weights, with a line of body text. Runner-ups stay ready.

The chosen font file comes from the Google Fonts repo, which is more reliable than the CSS API: `https://raw.githubusercontent.com/google/fonts/main/ofl/<family>/<File>.ttf`, where variable fonts have names like `Inter%5Bopsz,wght%5D.ttf` (listing the folder through the GitHub API gives the exact name). `file` checks the download: a wrong path saves an HTML error page that looks like a font. It is installed locally (`~/Library/Fonts/` on macOS, `~/.local/share/fonts/` then `fc-cache` on Linux), because Inkscape only sees installed fonts, and copied to `brand/fonts/`.

### Colour

When the project already has a logo, every colour in its SVG is pulled out first and named by its role. The recommended palette has four roles:

- Primary: buttons, links, focus and active states
- Dark: headings, sidebars, dark surfaces
- Accent: alerts, destructive actions, points of interest
- Highlight: info banners, selected states

The agent generates a 50 to 950 OKLCH scale for the primary (and any colour the project's UI will use as a Tailwind colour), with 500 at or near the chosen hex, and checks text contrast on the light and dark steps. When a colour is questioned ("that red is too dark"), the full mark is shown with the best replacement swapped in, variants ready.

The guide records the final values: each colour's name, role, hex and OKLCH, and the full scales.

## 4. Master SVGs

Everything later derives from nine master SVGs:

| | Mark only | Horizontal lockup | Stacked lockup |
|---|---|---|---|
| Colour | `mark-color.svg` | `logo-horizontal-color.svg` | `logo-stacked-color.svg` |
| Black | `mark-black.svg` | `logo-horizontal-black.svg` | `logo-stacked-black.svg` |
| White | `mark-white.svg` | `logo-horizontal-white.svg` | `logo-stacked-white.svg` |

A horizontal lockup has the mark left and the wordmark right, vertically centred; a stacked lockup has the mark above and the wordmark centred below. The colour horizontal lockup comes first: the wordmark's cap height around 40 to 60 percent of the mark's height (stacked: wordmark width close to the mark's), tight viewBox, little padding. The lockups are shown for approval of proportion and spacing while the text is still editable.

Gotchas:

- Inkscape ignores Google Fonts `@import` and silently substitutes another font. Install the font first, then convert all text to paths (`object-to-path` on everything) so the SVGs need no font. Afterwards `grep -c '<text'` must return 0, and the render must still show the real font.
- Black variants use `#18181b` (zinc-900), not pure black; white variants use `#ffffff`. In the colour lockups the mark keeps its colours and the wordmark is `#18181b`; black and white variants are fully one colour.
- Colour swaps by text replacement must catch every form: `fill="#..."`, `fill:#...` inside `style`, `stroke` in both forms, three-digit hex, named colours and gradient stops. Render each variant after swapping to see nothing was missed.
- After compositing, fit the canvas to the drawing (`fit-canvas-to-selection`) or set the viewBox from `inkscape --query-all`, or every export carries the dead space.

## 5. Asset pack

```
brand/
├── svg/       the nine masters
├── png/       marks at 64, 128, 256, 512, 1024 (square);
│              horizontal lockups at 400, 600, 800 wide; stacked at 300, 500 wide
├── favicon/   favicon.ico (16 + 32), favicon-16x16.png, favicon-32x32.png,
│              apple-touch-icon.png (180), android-chrome-192x192.png,
│              android-chrome-512x512.png, site.webmanifest (name, icons,
│              theme_color = primary hex, background_color, display standalone)
├── social/    og-image-1280x640.png (horizontal lockup centred on white),
│              github-avatar-500.png, discord-icon-512.png, npm-icon-256.png
└── fonts/     the font files and a README: family, foundry, weight used, licence, source URL
```

Gotchas:

- When compositing an SVG onto a canvas with ImageMagick (the OG image), trim it and reset its page (`-trim +repage`) before centring, or ImageMagick centres the viewBox rather than the drawing and the logo sits off-centre.
- A mark that holds at 512 px can turn to mush at 16. When it does, a simplified favicon version of the mark is drawn rather than shrinking the full one.
- Look at the favicon, OG image and avatars once rendered; a file existing does not mean it looks right.

## 6. Brand guide

`brand/brand-guide.html` is the brand board a designer hands over: one page anyone on the team can open to use the brand correctly. Self-contained (SVGs inline, the brand font by Google Fonts link), no script, styled in the brand's own colours on white, readable when printed. It holds:

- The name and one-line description.
- All nine logo versions in a grid, colour and black rows on white and the white row on a dark surface, each labelled with its file name and use: the mark for favicons, app icons, avatars and small spaces; horizontal for headers, READMEs and email signatures; stacked for splash screens, print and tall spaces. Minimum sizes: mark 32 px, lockups 120 px wide.
- The palette: a large swatch per colour with name, role, hex, OKLCH and Tailwind class, the full 50 to 950 ramps, and the mark's own colours.
- Typography: family, foundry, licence, source, the wordmark weight and letter-spacing, samples at the wordmark and regular weights, and where the files live.
- The asset inventory: every file in `brand/` by folder, with its size or purpose and format.

A second model reviews it before it is shown.

## 7. Project wiring

The agent asks which of these apply, then does them:

- README: the horizontal lockup at the top, centred, linked to the project's site, with a `width` attribute (around 280), because GitHub otherwise renders an SVG at full width.
- Website or app: favicons in the static assets with their `<link>` tags, `<meta name="theme-color">` set to the primary, the webmanifest, and the mark in the header.
- Tailwind: the scales as `--color-primary-50` through `--color-primary-950` in the `@theme` block.
- npm: `homepage` in `package.json`.

Some steps need a person in a web UI: the GitHub social preview (repo Settings, Social preview), an organisation avatar, a Discord server icon. They are listed at the end with the file to upload for each.

## Checklist

- Nine master SVGs, no `<text>` left, each rendered and checked
- PNGs at every size listed, favicon set with webmanifest, OG image visibly centred, platform icons
- Fonts with their README
- Brand guide reviewed by a second model, then shown
- Everything committed under `brand/`, `tmp/` previews removed
- Wiring done, manual steps listed with their files
