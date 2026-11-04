---
name: ship
description: "Lands a branch the way the repo says to: finds the project's own review, check and merge path and follows it. Use on 'ship', 'ship it', 'finalize', 'wrap this up', 'preflight check', 'final review', 'ready to merge', 'prep for PR' or 'create PR'."
---

# Ship

Each project has its own written path for landing work: how it is reviewed, which checks run and when, who merges. This skill finds that path and follows it. It adds no gates of its own.

1. Confirm the branch is not the default branch and holds only this work (`git status`, `git log --oneline origin/HEAD..HEAD`).
2. Read the repo's `AGENTS.md` or `CLAUDE.md` and any review, CI or PR skill it names, including a finalize checklist, and follow that path exactly: its review skill, its check command run on the pushed commit, its PR conventions and who merges.
3. If the repo documents no path, run its documented lint and test commands for the changed code, run `simplify` on the diff, then `/code-review` for correctness, and open the PR.
4. If the diff touches view, template or component files, run Impeccable on them (`audit`, then `polish`) and fix what it finds.
5. Open or update the PR with `gh`, body from a temp file. Never merge or deploy from this skill.
6. Report the PR URL and anything the repo's path left for a person to do.

Where this skill and a repo's instructions disagree, the repo wins.
