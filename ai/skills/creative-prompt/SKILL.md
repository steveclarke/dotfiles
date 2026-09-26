---
name: creative-prompt
description: Build a prompt that gets world-class creative work from an agent (website, app screens, slide deck, motion, graphics, video) and run it end to end. Use when asked for design or creative work that has to look exceptional, to "write a prompt/brief for" such work, or to set up an unattended creative run. Not for routine UI fixes or code-only tasks.
---

# Creative Prompt

An agent given "make it beautiful" makes the average of everything it has
seen. Exceptional work comes from a prompt dense with information the agent
cannot guess, a bar stated as a floor, and a way for the agent to check itself.
The prompt is built with the human first, then handed to a fresh agent that
runs to the finish without checkpoints.

## Roles

| Who | Job |
|---|---|
| Human | Judgement only: audience, the one feeling, the bar, what is fixed, freedom, budget. Reacts to examples |
| Coordinating session | Thinks the process through with the human, writes the prompt, checks the result on screen |
| Reaction-rounds agent | Finds examples, shows them, records reactions, names the principles. Nothing else |
| Build agent (fresh) | Receives the finished prompt and produces the finished work |

## Principles

- **Recognition, not recall.** Many people cannot picture what they want, but
  everyone knows it when they see it. Never ask the human to imagine or
  describe a look. Show options; turn reactions into words.
- **The human recognizes; the AI names.** The AI supplies the design
  vocabulary. Each principle pairs the designer's term with the example it
  came from.
- **No homework for the human.** The agent finds every example. The human only
  reacts.
- **Think before delegating.** Agree the process and the blanks with the human
  before any agent starts. Do not rush to hand off.
- **The bar is a floor.** References are minimums to surpass, measured against
  the best work of any kind, not the best in the category.
- **Test each capability once before the prompt names it** (one generated
  image, one API call).

## Phase 1: build the prompt with the human

1. **Gather the materials.** What exists now, what is fixed, assets (real
   photographs, footage, fonts, logo, content), tools available.
2. **Reaction rounds.** See `references/reaction-rounds.md`. Two or three rounds:
   one across categories, one along a dial (quiet to bold) to find the line,
   one to narrow. Motion gets its own round with clips.
3. **State the principles after each round**, each with its evidence, and have
   the human confirm or correct them.
4. **Fill the blanks only the human can fill**, one at a time, in plain
   questions: who it is for, the one feeling, the bar, what must not change,
   freedom, budget.
5. **Write the prompt** from `references/prompt-template.md`. Read it back
   cold (printed if the human reviews on paper) and correct it.

## Phase 2: the run

1. **Start a fresh agent** in its own tab and worktree. Write the prompt to a
   file in the worktree and point the agent at it; long pasted prompts get
   truncated.
2. **The brief around the prompt carries six things:** the objective, the
   working directory, context the agent cannot find, the skills that cover the
   work (named, "load it first"), what it hands back, and how it knows it is
   done. Check the skill list before writing it.
3. **No checkpoints.** The agent explores, judges against the bar itself, and
   finishes. The human's reactions belong before the prompt, not during the
   build.
4. **Unattended runs avoid commands that stop for approval** (for example
   `rm -rf`, `git reset`). Name them in the prompt and say to work around them.
5. **Watch for the finish.** The agent ends with one line starting `DONE:` or
   `BLOCKED:`; a watch on its pane reports it.

## After the run

- **Check it on screen before the human sees it.** Open the real thing,
  screenshot or record it, look at it. Blank pages, blur, grain and late-loading
  assets must never reach the human first.
- **Reactions become director's notes in exact words** ("slow every zoom to
  0.7x", "bring the background forward, keep contrast 4.5:1"). The AI names
  the change after the human reacts.
- **Follow-ups go to the same agent** (resume its conversation), so it keeps
  what it learned.
- **Polish passes are new prompts** with the same framing: polish, critique,
  overdrive, search and speed.

## Craft and safety rules learned in runs

- **Imagery.** Generated images only as nature fragments (water, rock, texture,
  light). Never generated people, not even distant figures. Never a generated
  place that poses as a real one; locals know. Whole places come from real
  photographs. Check generated nature for local accuracy (a pelican on a
  coast that has none fails).
- **Resolution.** Generated stills are soft at 4K; use real footage for large
  motion.
- **Stills before motion.** Approve one still per scene before animating.
- **Name a style, don't describe one.** A named reference gives pacing, type
  and transitions; without one the model falls back to its default look.
- **Real components for product UI,** from the project's real library.
- **Heavy work** (encoding, renders) is spread over available machines, and an
  agent never stops a process it did not start.
- **Two agents on one piece of work:** one owns the content, the other the
  look. Each commits only its own named paths.
- **Record rules as the human sharpens them,** in the prompt and the log.
