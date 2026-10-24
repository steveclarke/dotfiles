---
name: ship
description: "Land a branch the way this repo says to. Routes to the project's own review and merge path. Triggers on 'ship', 'ship it', 'ready to ship', 'prep for PR', 'create PR', 'ready to merge'."
---

# Ship

Each project has its own written path for landing work: how it is reviewed, which checks run and when, who merges. This skill finds that path and follows it. It adds no gates of its own.

1. Confirm the branch is not the default branch and holds only this work (`git status`, `git log --oneline origin/HEAD..HEAD`).
2. Read the repo's `AGENTS.md` or `CLAUDE.md` and any review, CI or PR skill it names, and follow that path exactly: its review skill, its check command run on the pushed commit, its PR conventions and who merges.
3. If the repo documents no path, run its documented lint and test commands for the changed code, use `simplify` on the diff, use `adversarial-review` for auth, money, migrations or data boundaries, then open the PR.
4. Open or update the PR with `gh`, body from a temp file. Never merge or deploy from this skill.
5. Report the PR URL and anything the repo's path left for a person to do.

Where this skill and a repo's instructions disagree, the repo wins.
