# Marketplace submission

- Repo: `github.com/omacom/omarchy-plugin-marketplace`. Submission is a GitHub issue using `SUBMISSION.md` verbatim: six headings in order, five checkboxes, title `[Plugin]: Name`. `gh issue create --body-file` works.
- Validation is automatic, under five minutes. The security baseline flags the word `sudo` anywhere (README, error strings) and any file named `Setup.qml` as an installer. Those are `review-required`, not failures; a maintainer accepts them.
- Ids are permanent and global; search `catalog.json` first.
- `preview.png` at the repo root is optional; the site crops it. Check all four edges at zoom for stray borders. Stand-in names only.
- Before submitting: `omarchy plugin validate`, qmllint, tests in CI, a tagged release so the listing shows a version badge, `AGENTS.md` as a real file (no symlinks).
- Security review is a maintainer-run AI agent reading the full tree at the exact commit, separate from the static baseline bot. It blocked Kopia on its first pass for root `AGENTS.md`/`CLAUDE.md`. Load the `omarchy-plugin-security` skill before submitting; it is distilled from every past review comment.
- Exact-SHA binding: validation, baseline and review all bind to one 40-character commit. Any push after validation (even README or preview) makes the review stale. Put every fix on one final commit, then re-validate, then leave HEAD alone until approval.
- Re-validation is triggered by editing the issue body (`gh issue edit <n> --repo omacom/omarchy-plugin-marketplace --body-file ...`); something in the body must change. A comment does not trigger it; reply with the fix SHA as a courtesy.
- A submission with an open blocker and no response for seven days is closed.
- One finding on one of an author's plugins applies to all of them; fix the class across every plugin repo before the re-check.
- `service-management` is flagged for any `systemctl` string, README included. It is a review-required capability, not a finding; say what the one write is in Maintainer notes.
- Expect more than one review round: the reviewer re-reads the whole tree after each fix and raises new findings (Kopia round 2: http credentials to non-loopback hosts, a bare executable on a user-triggered path). Edit the issue body from a scratch copy, not from a file in the repo, or the edit itself is a new commit that makes the review stale.
