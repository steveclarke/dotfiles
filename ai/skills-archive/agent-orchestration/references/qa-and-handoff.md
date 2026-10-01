# QA and handoff

## Prepare the real surface

Discover the live target from the workspace's service tooling and verify it is
serving the intended checkout and revision. Use the repository's QA procedure,
with sample data sufficient for each new control. For API-only work, exercise
representative client scenarios and provide reproducible requests/results.

Verify the target database before destructive setup and obtain authorization for
that exact target unless already given. Preserve other workspaces and environments.
Existing seeded data may suffice; do not reset again by habit.

Record which role and path were exercised. A temporary development session can
support a permission test when explicitly authorized and allowed by the tools;
it does not establish that interactive sign-in works. Never weaken production
authentication to make local QA convenient. Remove fixture sessions and secret
files afterward without printing cookie or token values.

If browser input is denied, explain the actual tool boundary and use an allowed
path. Do not reinterpret an approval rejection as a product failure or evade it
through another tool. Follow the applicable credential procedure without exposing
secrets.

## Match tests to failure modes

A rich editor deserves a real typing/formatting path, not just an API-driven
mutation of its document. Compare untouched source and rendered output when
fidelity matters. Exercise external HTML and internal editor clipboard paths
when a parser change affects them, and label synthetic clipboard coverage.

Dependency-resolution changes need a cold development mount as well as tests.
Test runners and development bundlers can load packages differently. Clear only
relevant generated caches when authorized, and make the durable correction in
source configuration rather than calling cache deletion the fix.

For responsive web UI, inspect desktop and mobile together; use real viewport
inspection when available and label iframe or simulated evidence accurately. Verify the
controls stay reachable with long content, errors, read-only state, and unsaved
work. Keep the visual review bounded under its design skill.

## Handoff evidence

Exercise the real interaction path when browser parsing, bundling, DOM input, or
editor libraries are involved. A passing programmatic test does not prove that
path works; a fix that breaks mounting or startup fails acceptance. Read-only
fixtures prove the permissions exercised, not an authentication journey bypassed.
For a requested redesign, inspect the actual interface under the applicable design
workflow, preserve verified behavior unless change is approved, and update the
written walkthrough.

State what changed, what was verified and at which revision, remaining exclusions
or blockers, the actual workspace/branch and live surface, and relevant artifact
or PR links. Verify push/publish completion and remote revision when applicable;
report clean/dirty state accurately. Publication, messages to others, merge, and
deployment retain their own authorization boundaries.

## Approve the recording milestone

Keep the written walkthrough and real-surface evidence current as behavior changes.
The core skill's video gate overrides any workflow that records
automatically. Do not assemble narration while the demonstrated behavior is still
changing. Keep existing recordings unless replacement is authorized, and identify
material mismatches in the written guide. Read the remaining recording sections
only when that milestone is explicitly approved.

## Recording cleanup

Use a snapshot of only the rows the recording will modify. After each successful
write, retain the returned row identity and relevant values/update timestamp as
that recording's last write.

Before restoration or deletion, read the current row and compare it with that
last write. If it differs, stop cleanup of that row and any dependent restoration,
and report a conflict: another edit may have occurred. Continue independent
cleanup that is already authorized. Do not overwrite it and merely log the conflict afterward.
Restore only recording-owned changes, retain history, and verify the result.
Do not delete an override that existed before recording.

## Review the actual media

Narration length is not UI timing. Inspect the opening action, each transition,
key result, and final saved state in the assembled artifact. Hold important
results in view long enough to read. Check both media streams and captions;
caption extraction alone does not prove on-screen display or sync.

Fix a poor recording in the recording script rather than changing product data
or faking results. Keep earlier versions until the replacement is verified. A
later redesign updates the written guide; make a new video only at an explicitly
approved milestone. Keep the old publication unless replacement/deletion is
authorized.

When publication is authorized, use the approved media path and include captions
when present. Verify the
watch page plays and the caption control works. Link the reviewed recording in
the feature guide and PR. Do not claim the final frame shows a preview if saving
correctly clears it; show the true saved state.
