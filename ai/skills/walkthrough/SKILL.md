---
name: walkthrough
description: Create a guided walkthrough of a feature, prototype, workflow, or completed task with a verified step-by-step guide and an optional video. Use for "walk me through this", "show how this works", or a reviewer demo; not a full QA sign-off.
---

# Guided Walkthrough

Show what the work does, why it is useful, and how someone can try it. Support
browser apps, desktop tools, terminal workflows, and noninteractive outputs.
Use the current task as the scope; a walkthrough request does not imply a
new implementation, deployment, or a full test matrix.

## Choose and verify the story

Identify the audience, benefit, and shortest useful path from the request and
project docs. Ask only when a missing choice changes the demonstration.
For a prototype, explain the design choices and identify mocked data.
For completed work, demonstrate the observable result and its limitations.

Discover the current environment from the repository or running application:
launch instructions, URL, worktree, inputs, and authorized account. Read its
local development instructions when starting services. Do not use remembered
ports or record IDs. Choose existing safe example data and inspect it first.
Do not reset databases or seed broad datasets just to improve the story.

Perform the selected flow using the available browser, desktop, or terminal
tools. For authenticated browser work, use the user's normal session when
available and permitted. Observe the result of each action. If the core flow
fails, report it; do not write the guide as though it succeeded.

## Write the guide

Save `walkthrough.md` in the project's established documentation location,
or the user's chosen artifact directory. Include:

- The benefit and what the reader will learn; working feature versus prototype.
- Starting point, prerequisites, and safe example inputs. Reference login
  instructions without putting credentials in the guide.
- Numbered actions with visible labels or exact commands, and the expected
  result of each. Explain what to look for in a noninteractive artifact.
- The scope actually observed and any remaining limitations.
- When recording, short scene narration and a link to the finished video.

Correct the guide to match the observed workflow. Follow the repository's
writing conventions without requiring another project's documentation skill.
Pause for script review only if requested.

## Video and delivery

When a video is requested, use `record-video` if installed. That skill handles
capture, optional narration, assembly, and playback verification. Otherwise
use the available recorder to produce and check a real video, or report the
missing recording capability. A written guide alone does not fulfill a video
request. Do not require a video for every PR unless this repository does.

Link the guide and any recording in the final reply; say what was actually
walked through. For a requested PR handoff, add those links to the PR only
when accessible to its reviewers; a local file path is not a shared watch URL.
Publishing or messaging others requires the user's authorization. Follow the
repository's commit policy and keep raw media and credentials out of Git.
A successful walkthrough is evidence of the demonstrated flow, not QA approval.
