# Spec and plan review

Review the proposal against the user's approved outcome and the actual system.
A spec or plan review does not authorize implementation. Use the repository's
existing specification workflow if the artifact still needs to be written.

Establish the target base branch and revision; do not assume its name or treat
local changes as shipped behavior. For each changed contract:

- Trace producers and live consumers on the base, including consumers outside the
  immediate feature. If they ship separately, explain the intermediate state.
- Verify claims that a model, endpoint, condition, or behavior already exists.
  Cite base evidence separately from local or sibling-branch proposals.
- Inspect relevant unmerged siblings. Identify dependencies, contract conflicts,
  and what can ship independently; do not assume an unmerged contract is available.
- Find the repository precedent for a proposed mechanism. If introducing a new
  mechanism, record the reason existing patterns cannot meet the requirement and
  the resulting cost. Familiarity elsewhere is not evidence of a local convention.

For an execution plan, verify the inputs, output paths, task boundaries, interfaces,
verification commands, and prerequisites an implementer will receive. Distinguish
files to create from required inputs. Identify which gates establish task acceptance
and which remain for integration or delivery.

Freeze the proposal before acceptance review and request findings against that
revision. Record unresolved assumptions as decisions or dependencies with an owner
and next action. Accept only the scope actually reviewed; carry agreed corrections
into the proposal and affected briefs before dispatching implementation.
