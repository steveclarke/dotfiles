# Implementation and review

Use the repository's implementation workflow and review packages when available.
Before coding, compare planned producer/consumer interfaces, shared files, and
assumptions with the real repository. Run a relevant baseline when needed to
distinguish pre-existing failures from task regressions.

## A bounded task

1. Assign requirements, exact ownership, interfaces, and a verification contract
   using [the handoff contract](handoffs.md). Record task BASE before dispatch.
2. Finish the implementation batch and focused checks. Freeze a committed
   BASE..HEAD snapshot for acceptance review; inspect the report and actual diff.
   Full review cannot run while its source is changing. Parallel interface
   research is useful but does not satisfy this gate.
3. Obtain independent verdicts on compliance and quality within the requested
   review scope. Require a location, trigger, consequence, and evidence for a
   blocking finding. Adjudicate disagreements after review rather than coaching
   the reviewer away from finding a problem.
4. Batch actionable fixes into one assignment. Freeze the resulting snapshot and
   re-review the fix range for original findings and new breakage. Keep optional
   cosmetic suggestions outside correctness loops and preserve the phase's retry
   count across fix assignments.
5. Record accepted changes, verification with its commit, and residual findings.
   Check off a plan item only when its actual acceptance gate is satisfied. Carry
   cross-task findings into the next affected brief.

Name an owner for browser inspection and service restarts. A restart invalidates
assumptions held by an active browser reviewer; agree when inspection can resume.
Serialize checks that mutate a shared database or generated build state. If a new
change invalidates a reviewed snapshot, record the changed scope and obtain the
review required for it rather than transferring the prior verdict automatically.

## Shipping

When shipping is requested, the director owns completion of the repository's
shipping workflow on a clean, committed tree after writers stop. Supply the whole
PR diff, not only the latest task. Let that workflow own cleanup, review/finalize
ordering, exact-HEAD readiness, retry limits, and any opt-in review modes. Do not
create a second CI pipeline or duplicate an existing PR.

Report evidence at its actual scope. A documentation-only follow-up does not by
itself require rerunning an unrelated broad suite, but an exact-HEAD gate must
follow its own freshness rules. A passing review does not complete QA, authorize
merge/deployment, or establish that publication succeeded. Use
[QA and handoff](qa-and-handoff.md) for those remaining deliverables.
