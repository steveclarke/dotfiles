# Design language

The bar for "done" is: sits next to a first-party panel and a stranger cannot tell which is which.

Structure (top to bottom)
1. `PanelHero`: tinted icon, title that names the state in plain words ("Backups are healthy", "Screens are on Linux desktop"), META LINE IN CAPS with dot separators, one detail line, one trailing control (gear or refresh).
2. `PanelSeparator`, then `PanelSectionHeader` in caps naming the action or the content ("SEND SCREENS TO", "LAST 7 DAYS · ONE CELL PER HOUR").
3. Content: `CursorSurface` rows (glyph, label, right-slot status), `InfoPair` key/value rows (key dim, value right-aligned, secondary in dim after a dot), meters as 5 px rounded tracks, heatmaps as plain Rectangles in a Grid.
4. Actions right-aligned as `PanelActionButton`s, glyph + verb ("Back up now", "Open web UI"). The failed state swaps them for the recovery verbs ("Try again", "Open log").
5. Optional keyboard footer in muted caption: `j/k select · enter … · esc close`.

State
- State lives in the glyph colour, never in a dot: foreground healthy, `Qt.darker(fg, 1.4)` running or unset, `bar.urgent` failed or stale (with a "!" suffix in the bar).
- Bar text is opt-in; icon only is the default. A number that just cycles (minutes since an hourly job) is noise.
- "Not set up" is dim, never urgent. A fresh install must not shout.
- Failed and stale are different: failed has an error, stale has an absence. Warn colour in the panel for stale, urgent for failed; both urgent in the bar.

Error boxes
- 1 px border in the state colour, bold first sentence saying what is wrong, second sentence the next step, then the exact command to check in dim caption. "Can't reach the repository. storage refused the SFTP connection. Check the NAS is up, then try again."
- No "Error:" prefix, no exception text as the headline.

Copy
- Every string a sentence with a next step. Section titles name the action. Name things by what they do, not by the mechanism.

Tokens
- `Style.space(n)`, `Style.spacing.{rowGap 8, rowPaddingX 12, controlHeight 28, panelGap 14}`, `Style.font.{caption 10, bodySmall 11, body 12, subtitle 13, title 14, heading 16, display 24}`, `Style.cornerRadius`.
- `Color.{foreground, background, accent, urgent, muted}`; prefer the injected `bar.foreground` / `bar.urgent` inside widgets. There is no warning role; derive it from the theme's `color3` if a warn tone is needed.

Prototype CSS to start from: light Catppuccin Latte `--bg #eff1f5 --fg #4c4f69 --dim #6c6f85 --line #ccd0da --accent #1e66f5 --ok #40a02b --warn #df8e1d --bad #d20f39`, panel border 2 px accent, padding 18, width 460.
