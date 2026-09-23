# Unio adapter

Read the current repository instructions before applying these mappings. Unio's
Rails/Nuxt stack and commands belong here, not in the generic director workflow.
Verify the checkout, branch, target base, PR, and live host rather than assuming
an earlier run's state still applies.

## Use the existing phase owner

- Use `unio-spec` or `unio-plan` only when the corresponding artifact needs work.
- Use `unio-implement-a-plan` for documented implementation tasks and review
  packages. Reuse its run workspace and task evidence; put durable product
  decisions in feature docs.
- For an approved UX rethink, use the available Impeccable skill to inspect the
  interface and settle direction before implementation.
- Use `unio-qa` for hands-on acceptance and `unio-walkthrough` for the current
  written guide. Link `qa-walkthrough.md` and the guide from the existing PR.
- When shipping is requested, use the available `ship` workflow. It owns review
  and final gates, including authoritative `unio ci` on committed HEAD and its
  exact-HEAD freshness rules. Use `unio-commit` for commits.

Load the applicable skill rather than duplicating its procedure. If a named skill
is unavailable, inspect the repo's current documented workflow and report a
material capability gap; do not invent its checks or claim they passed.

## Real-surface QA

Take the exact live hostname from this checkout's `outport status`; never hand off
`localhost` or a bare port. Supply sample data for every new control, walk the
requested flows in the browser, and leave the user's browser at the first step.
Commit the QA click path and link it from the PR. Identify checkout and branch in
the final handoff. Show API-only work with Bruno scenarios; it does not need video.

Serialize migrations and shared test-database jobs, and frontend checks sharing
`.nuxt` or generated caches. Give browser work its own tab and named owner. Follow
current 1Password/project instructions for credentials; remote access does not
itself imply Touch ID is required or that sign-in is impossible.

## Written guide and approved video

Keep the written walkthrough current. Record or replace video only at a
milestone Steve explicitly requests or approves after reviews, resulting fixes,
and final checks; this overrides any Unio skill that records automatically. Use `unio-walkthrough` for an approved recording and
`unio-media` only when publication is authorized. Follow the generic
[QA and recording safeguards](qa-and-handoff.md) for data cleanup and media review.
Approval of implementation, shipping, or an earlier video is not approval of a
new recording. Preserve the existing publication unless replacement or deletion
is authorized.
