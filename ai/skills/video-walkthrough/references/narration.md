# Narration and MP4 assembly

Keep capture and scene narration separate so changing the words does not
require changing the application. The bundled helpers require Node.js,
FFmpeg, and ffprobe on PATH. Resolve `skill_dir` to this installed skill's
absolute directory; do not assume it lives in the current repository.

## Generate audio

Reuse an installed local speech engine or user-provided audio. The included
`narrate.mjs` uses `kokoro-js@1.2.1`, model
`onnx-community/Kokoro-82M-v1.0-ONNX`, q8 on CPU, voice `af_heart` by default.
The first run downloads model and voice resources. Use an isolated runtime
if dependencies are missing and installations are allowed:

```sh
voice_runtime=$(mktemp -d)
npm install --prefix "$voice_runtime" kokoro-js@1.2.1
```

Write `scenes.json` in an artifact directory:

```json
[
  {"title": "Choose columns", "text": "Open Columns to choose what to see."},
  {"title": "Reorder", "text": "Drag Email beside Name. The line shows where it will land."}
]
```

```sh
node "$skill_dir/scripts/narrate.mjs" \
  /absolute/artifacts/scenes.json /absolute/artifacts/voice \
  "$voice_runtime/node_modules/kokoro-js/dist/kokoro.js"
```

An optional fourth argument chooses another installed Kokoro voice. The
output directory must be new. The helper writes WAV clips and `narration.json`
with each title, text, absolute audio path, and measured duration in seconds.
Listen to a sample for pronunciation before recording the entire flow.
Another engine can supply clips with the same manifest shape; measure actual
audio durations with ffprobe. No particular accent or brand voice is required.

## Timeline

Record scene starts and the end on the same elapsed clock:

```json
{
  "times": [
    {"start": 5.0, "title": "Choose columns", "text": "Open Columns.",
     "file": "/absolute/artifacts/voice/narration-0.wav", "duration": 2.0}
  ],
  "end": 8.0
}
```

Each scene must finish its narration before the next scene starts. `end` is
the end of the captured demonstration on that clock. The helper estimates the
raw-video timestamp of the first scene from raw duration and this clock.
Capture startup/shutdown delays can skew it. To override the estimate, add
`"videoStart": 5.0` with the exact raw-video timestamp of the first scene.

## Assemble

```sh
node "$skill_dir/scripts/assemble.mjs" \
  /absolute/artifacts/timeline.json /absolute/artifacts/raw.webm \
  /absolute/artifacts/render
```

The new output directory contains `walkthrough.mp4` (H.264/AAC), embedded
captions and chapters, `captions.srt`, and `transcript.txt`. The filename is
historical; rename the delivered copy for the actual task. Raw input can be
any video format FFmpeg supports. The helper uses scene audio and discards
raw capture audio: do not use it unchanged when application sound matters.

Caption timing is estimated from sentence lengths, not speech alignment.
Check captions, narration timing, key interactions and the final frame in the
finished MP4. Use ffprobe for streams and duration; fix pacing and re-record
when needed. Keep the source artifacts until the user has reviewed the result.
