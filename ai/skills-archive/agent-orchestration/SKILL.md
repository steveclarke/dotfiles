---
name: agent-orchestration
description: Direct a team of agents or take over an existing multi-agent run, preserving user priorities through assignments, review, and handoff. Use when asked to coordinate or oversee agents across one or more workstreams.
---

# Agent Orchestration

Keep one director responsible for the user's requested outcome. Assign bounded
work, inspect evidence, settle routine choices, and carry open commitments
forward. Leading a team does not grant permission to spawn agents, change scope,
or act on external systems. Keep a single-agent path when no team is available.
Do not claim it provides independent review.

Announce this skill and the current phase. Resume completed work from its evidence
rather than restarting because a new agent, skill, or conversation turn begins.

## Establish the run

Read the request, settled decisions, existing work, and current run record.
Verify the actual workspace and, for repository work, checkout and branch. Find the repo's own workflow, checks, and shipping gates. Do not assume a framework,
default branch, or command. Record approved scope, exclusions, open decisions,
active agents and their owned files, evidence, and permission already given. Use an existing run workspace where available; do not impose a spec or
implementation plan on work that does not need one.

Before dispatch, verify assignment paths, commands, and cited precedents.
Separate existing inputs from outputs the agent must create. A missing proposed
output is not a blocker. After a context reset, recover the run record and actual
artifact state before redispatching work.

Read only the references needed for the current phase:

- [Handoffs and transport](references/handoffs.md): assigning work, receiving
  reports, selecting a harness, or recovering agent state.
- [Spec and plan review](references/spec-plan-review.md): evaluating proposed
  behavior, architecture, dependencies, or an execution plan.
- [Implementation and review](references/implementation-review.md): coordinating
  source changes, independent acceptance, fixes, and a shipping workflow.
- [QA and handoff](references/qa-and-handoff.md): real-surface verification,
  written walkthroughs, approved recordings, and final delivery.
- Repository adapter: a repo's own conventions, skills, and shipping gates.
  Adapters kept here: [Unio](references/unio.md). For any other repo, read its
  `CLAUDE.md` or `AGENTS.md` and its documented workflow instead.

## Preserve commitments across interruptions

Save a short open-work list beside the evidence log. Keep open items easy to find. For each user request or promised follow-up, keep the intended outcome,
owner, state, next action, dependency, and return point if interrupted. Track
multiple workstreams without forcing them into one current task.

Tell user directions apart from agent reports. A report updates its assigned
task; it does not replace the user's objective or authorize unrelated work.
Before handling an interruption, save where to return. Only explicit user
direction cancels or replaces a commitment; a newer report cannot displace an
earlier user priority.

Reconcile the list after reports, pauses, or context resets, and before ending a
user-facing turn. Every promise must have evidence of completion, remain assigned,
or have a clear state: blocked, paused, or deferred, with a next action. Assign newly
unblocked work within the granted scope. Then return to the interrupted commitment.
Delegation is not completion: the director owns acceptance and the next step.
Keep this check internal unless it changes the user's decisions.

## Ownership and acceptance

Use the user's chosen harness, model, effort, and team structure. Verify what
actually started. Do not silently replace unavailable settings. Use independent
reviewers for the agreed review scope; cross-vendor review follows the user's
choice and is not proof by vote. Add specialists for a concrete need, not because
a concurrency slot exists.

In a shared checkout, one owner writes product source at a time. Parallel reads
are safe. Give a docs writer a distinct set of files to own. Stage explicit
paths. Run work in sequence when it shares changing services, databases, or build caches.
If writers collide, pause affected work, preserve changes, reconcile ownership,
and establish a stable snapshot before accepting it.

Freeze the artifact under review before acceptance review. Early research can run
beside ongoing edits, but is not acceptance. Give reviewers the requirements,
actual artifact/diff, and evidence without coaching a verdict. Resolve blocking
findings with concrete evidence. Record accepted scope and remaining findings.
Keep downstream QA and shipping gates distinct from a reviewer passing a task.

Record key scope, interface, ownership, permission, and review decisions. Include
the reason and cost if wrong. Resolve routine reversible choices within existing
permission. The workflow controlling the phase owns its retry cap: carry the
attempt count across agent swaps, task renames, and regressions of the same
unresolved failure. Repeated failure needs new evidence and a changed approach.
Raise conflicting caps rather than choosing the one that allows more attempts.

## Evidence and communication

Tie claims to the artifact version and checks actually run. Agent
status, tests, browser checks, and recordings prove different things. Confirm
fresh completion after dispatch; old `DONE` text is not evidence for a new task.
When shipping, let the authoritative ship workflow own exact-HEAD acceptance and
final checks. Do not turn an old review into a new-head pass or start a competing
pipeline.

Keep the written walkthrough current when behavior changes. Video is a separate,
explicitly user-approved milestone after reviews, fixes, and final checks settle
the behavior. Implementation, redesign, shipping, or approval of an earlier video
does not authorize another recording. See the QA reference when that phase applies.

Keep routine coordination in agent channels and evidence files. Group
related findings. Report a phase that finished, a blocker, or a decision the user
must make. Keep the required pace of updates without relaying every reply or poll. A status answer says what is running, what is
stopped, and what comes next. Before final handoff, reconcile all commitments and
verify artifact and publication state; local completion does not imply a push,
merge, deployment, or publication occurred.
