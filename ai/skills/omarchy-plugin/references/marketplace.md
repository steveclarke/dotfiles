# Marketplace submission

- Repo: `github.com/omacom/omarchy-plugin-marketplace`. Submission is a GitHub issue using `SUBMISSION.md` verbatim: six headings in order, five checkboxes, title `[Plugin]: Name`. `gh issue create --body-file` works.
- Validation is automatic, under five minutes. The security baseline flags the word `sudo` anywhere (README, error strings) and any file named `Setup.qml` as an installer. Those are `review-required`, not failures; a maintainer accepts them.
- Ids are permanent and global; search `catalog.json` first.
- `preview.png` at the repo root is optional; the site crops it. Check all four edges at zoom for stray borders. Stand-in names only.
- Before submitting: `omarchy plugin validate`, qmllint, tests in CI, a tagged release so the listing shows a version badge, `AGENTS.md` as a real file (no symlinks).
