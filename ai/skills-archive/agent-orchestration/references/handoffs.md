# Handoffs and reports

Use a short dispatch plus files. A fresh agent should not need the entire chat.
Do not force a tiny task into a large template; retain the fields that establish
scope, ownership, and acceptance.

## Task brief

```text
Task and goal:
Workspace / artifact revision (checkout, branch, and task BASE for code):
Read first: request or brief, relevant artifacts, binding constraints
Own: exact files or a bounded surface
Do not touch: peers' files and excluded behavior
Interfaces: producers/consumers and settled decisions
Checks: meaningful commands or real-surface paths
Report: path and director destination
Authority: permitted commits/pushes/restarts/data changes; unresolved approvals
```

The assigned agent must report material scope/interface changes before taking them.
Director decisions go into the ledger and relevant brief, not just a transient
terminal message. Name a point of coordination when another task shares state.

## Progress and completion

Use `DONE`, `DONE_WITH_CONCERNS`, `NEEDS_CONTEXT`, or `BLOCKED` for an agent's
assigned task, not the entire run. Reports include:

- Artifact revision or BASE..HEAD, changed files, and committed/published state.
- Verification commands, actual counts/results, and environment limitations.
- Deviations, unresolved decisions, and cross-task effects.
- Report/artifact paths and the next owner.

Send a final report and interim messages only for a material blocker, decision,
interface change, or requested checkpoint. Put detailed evidence in the report
file rather than repeating it in chat. The director consolidates user-facing
updates; peers should not flood the user with acknowledgements. Do not
repeatedly poll the director for routine permission already covered by the
assignment.

## Independent review

Provide requirements, the actual artifact or diff, worker evidence, and relevant
conventions. Identify the artifact revision; for code, state both BASE and HEAD.
Do not use `HEAD~1` when a task contains several commits. The worker's report is
evidence to inspect, not a verdict to adopt.

Ask for separate compliance and quality verdicts. Each finding identifies a
location, trigger, consequence, and evidence or a discriminating test. Flag an
uncertainty as unverified rather than presenting it as a demonstrated failure.
A no-rerun review must say that the test results came from the implementer.

A fix review addresses each original finding and checks for breakage introduced
by the fix. Deferred suggestions remain visible, but do not silently expand the
assigned work. Reviewers do not edit the implementer's files concurrently.

## Minimal ledger

```text
Current phase / owner / artifact revision (task BASE and HEAD for code)
Task state: implementation, review, fix, accepted
Evidence: check + outcome + artifact revision; browser/artifact report
Finding: severity + trigger + owner + disposition
Ruling: choice — reason — cost if wrong
Authorization: scope + user instruction reference
Next action and any awaited input
```

Keep the open-work commitments from the core skill beside this evidence log,
including the return point for interrupted work. A reviewer returning PASS does
not complete QA, publication, or final CI; a resumed director must see what remains.

## Transport and lifecycle

Name the actual model and effort in each assignment and verify what started.
Follow the user's chosen harness and topology. Quota changes affect future
assignments; do not restart a productive agent merely to change vendor.

When Herdr is explicitly requested, load its available skill, verify the
environment, and discover live IDs. Use its agent commands and preserve the user's
focus. Otherwise use available authorized native delegation. Do not impersonate a
harness with another tool or call a background process an independent reviewer.
If a requested transport is unavailable, report that boundary without silently
substituting another.

### Herdr layout: one workspace per piece of work

A Herdr workspace is one piece of work. Everything that belongs to it lives in
that workspace as tabs: the director, each worker agent, the dev stack, a log
tail. The user switches workspaces to switch work, and never has to hunt for a
related agent somewhere else.

- Never create a second workspace for a run. Start each agent in a new tab of
  the director's workspace (`herdr tab create --workspace "$HERDR_WORKSPACE_ID"`).
  This holds even when the code is in another repository or worktree: pass that
  path as `--cwd`.
- The workspace label names the work in plain words ("Outport Video Library").
  If the director's workspace still carries a repo name or an old topic, rename
  it when the run starts.
- Tab labels name the role inside that work: `director`, `codex impl`,
  `dev stack`, `review`.
- An agent moved in from elsewhere comes with `herdr pane move <pane> --new-tab
  --workspace <id>`; it keeps running.

Pick one short prefix for the run, six characters or fewer, that a person
recognizes at a glance (`vidlib`, `leave`, `ft139`). The agents list is a
narrow, flat list across every workspace, and agent names must be unique, so
the prefix is what groups a run's agents together there.

- Agent name: `<prefix>-<role>`, with a short role: `vidlib-dir`,
  `vidlib-impl`, `vidlib-rev`.
- Agent title, the first line of its row: `<prefix> <role>`, such as
  `vidlib impl`. This is the agent's own terminal title, which Herdr's rename
  commands do not change. Set it inside the agent as the first thing after
  `agent start`, before the brief: send `/rename <prefix> <role>` to a Codex or
  Claude Code agent, then read `terminal_title_stripped` from `herdr agent get`
  to confirm. An agent left untitled names itself after its first task.
- Pane label: the same text as the title.
- The director's own title cannot be set from outside; give the user the exact
  `/rename <prefix> director` line to run.

When a worker finishes or gets blocked, raise
`herdr notification show "<prefix>: <what happened>" --sound done` so the user
does not have to watch tabs. A rename changes the name a running watch polls;
re-arm the watch after renaming.

Reports must reach a busy director without waiting for it to become idle. In
Herdr, use `agent prompt` without `--wait`; do not send raw terminal keystrokes
into the director's UI. Peers may resolve interface questions together but must
copy conclusions to the director; they cannot silently change scope or ownership.

Prefer the worker's direct report as the completion signal. A fallback watch must
observe fresh state after this dispatch, not old `DONE` text in scrollback. A
watch ending because the director closed its tab is cleanup, not a new blocker.
Poll active work at a useful cadence (roughly 30–60 seconds when needed). Read the
actual blocked UI before interpreting status: queuing a prompt is not answering
an approval dialog. Apply the transport's approval rules and existing user
authorization; never answer unrelated prompts or enable blanket bypasses.

After saving reports, close completed agent tabs created by this run when no
longer useful, respecting session preferences. Use fresh context for a new
substantial task or a fix approach that has become stuck; retain a specialist
only while continuity helps. Preserve local evidence while follow-ups depend on
it, and archive durable decisions before cleanup required by another workflow.
