---
name: video-walkthrough
description: Record a playable video showing actual work or a workflow in a browser, desktop app, or terminal, with optional narration and captions. Use for "show me a video of what you did", "record a demo", or "make a screencast". Not for generating synthetic footage or downloading existing videos.
---

# Record the Work

Deliver an actual playable recording of the requested work. A script,
screenshots, or a description of a proposed video is not the deliverable.
If the work happened before capture began, record a safe demonstration of
the resulting behavior and label it as a replay, not the original execution.
For irreversible work, show its current result without repeating the action.

## Plan a short demonstration

Use the existing task context to choose the result and a few meaningful steps.
Aim for roughly 60–90 seconds unless the task needs another length. A full
written walkthrough is optional; use `walkthrough` if one is requested.
Narrate when explanation helps, honor requests for silent video, and avoid
turning a quick proof into a presentation project.

Check the current repository's launch and automation instructions. Discover
actual URLs, commands, accounts, and data; never assume a framework or port.
Choose the capture method the environment supports:

- **Browser:** use the user's normal browser for authenticated work when
  available and permitted. Record that surface with an available recorder.
  For an isolated local/demo session, Playwright video is an option; read
  [browser recording](references/browser-recording.md) first.
- **Desktop:** use an available OS/window recorder and UI automation. Capture
  the relevant window or region, not unrelated screens or notifications.
- **Terminal:** capture readable commands and actual output with a screen
  recorder, or render a real terminal recording to MP4 using installed tools.
  A text log or terminal cast alone is not a generally playable video.

Tool availability and permission are real constraints. Check capture support
before executing a one-time operation. If the selected tool cannot record,
report that and use a supported recorder within the authorized scope. Do not
claim a video exists or silently substitute slides or generated footage.

## Capture real behavior

Sign in before capture; keep passwords, tokens, private notifications, and
unrelated personal data out of the frame. Use authorized demo records and
state changes. Do not reset data or replay destructive commands for a take.
Wait for meaningful visible results, and leave time for the viewer to read.
Show a real reload or reopening if claiming persistence. Never fabricate a
successful save, sort, or result by editing the DOM or displayed output.

Track the exact recording file from the recorder, not the newest file in a
shared directory. Stop and finalize capture even on failure. Restore only
walkthrough-owned temporary changes without overwriting other users' work.
Retain task scripts and raw artifacts until review so edits are repeatable.

For narration, read [narration and assembly](references/narration.md).
It includes local Kokoro speech generation, a scene timeline, and bundled
MP4/caption/chapter assembly. Other installed voices or user-provided audio
can use the same timeline. Do not silently switch to a paid or external voice
service if local synthesis fails.

## Check and deliver

Produce MP4 with H.264 video and, when narrated, AAC audio for broad playback.
For silent or already mixed capture, transcode directly with FFmpeg if needed;
the bundled assembler is specifically for separate scene narration.
Preserve original audio when it is part of the demonstration.

Check the finished file, not just the capture: opening, key interactions,
readable text, pauses, and final frame. Listen to narration alongside the
actions when playback tools permit. Use `ffprobe` to verify streams and
duration. Estimated captions need inspection before claiming synchronization.
If playback or listening is unavailable, disclose that limit; metadata alone
does not prove that the video looks or sounds right.

Save the checked video in the requested destination, otherwise Downloads if
available or a clearly named local artifact directory. Use a fresh filename
or directory; preserve previous takes unless replacement was requested.
Include captions/transcript when generated and link the video in the final
reply. Open it in the user's player when supported and appropriate; report
only playback you actually observed. State what was demonstrated and checked.

Keep media, auth state, dependencies, and models out of Git. Recording does
not authorize uploading to a hosting service, publishing, or messaging others.
Use the project's sharing workflow only when requested, then verify the watch
link. Do not make a private publishing service a prerequisite for a local video.
