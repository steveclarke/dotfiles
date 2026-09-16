# Browser capture with Playwright

Use this path for an authorized isolated browser session, not as an assumed
replacement for the user's authenticated profile. Follow the environment's
browser-tool restrictions. If Playwright is unavailable or not permitted,
record the supported browser surface with an available screen recorder.

Reuse the project's Playwright installation and browser setup where possible.
Keep extra dependencies in an isolated runtime rather than the app manifest.
Use Chrome when installed, otherwise a supported installed browser. Choose a
fixed readable viewport, for example 1600×1000, with matching video dimensions.

- Authenticate in an unrecorded context. Transfer storage state only when
  permitted; keep it outside Git and do not expose its contents. Some login
  methods need project-specific session handling beyond storage state.
- Set `recordVideo` when creating the recording context. Keep its exact
  `page.video()` handle. Close the context to finalize capture, then save
  that handle's video. Do not glob for the newest WebM.
- Navigate by visible controls and wait for hydration and meaningful page
  content. Assert the visible result before continuing. Pacing pauses help
  viewers; they do not replace readiness checks.
- Move the pointer smoothly if useful. An optional pointer highlight may
  observe events but must not change application state.
- For drag-and-drop, wait for a stable handle, then hold over the insertion
  indicator before release. OS-composited drag ghosts may be absent in browser
  video; inspect the finished recording.
- Keep cleanup in `finally`; restore only state changed for this demo.

For separate narration, read its manifest before recording. At each scene's
start, note elapsed seconds and copy the matching clip object into the
timeline described in [narration.md](narration.md). Give each scene at least
its audio duration plus a short pause. Longer interactions need longer scenes.
Measure `end` on the same clock immediately before closing the context.

Capture startup/shutdown can skew inferred alignment. Inspect the assembled
result and supply `videoStart` when the exact raw timestamp of the first
scene is known. Re-record mistimed actions instead of inventing success frames.
