---
name: creative-prompt
description: Get world-class work from agents on anything - what people see or go through (a website, app screens, a journey like sign-up or sharing, a form, a notification, a deck, motion, graphics, video, copy) and what people live in without seeing (software architecture, code organization, an API, a folder and file layout, a document, a plan). Use before briefing or building any of it, to "write a prompt/brief for" such work, or to set up an unattended run.
---

# Creative Prompt

Agents left alone make the average of everything they have seen, sized to what
a human team could ship. Exceptional work comes from three things: the best
work in the world as the starting point, a prompt dense with what the agent
cannot guess, and an agent that knows it can go further than it thinks. This
holds for any work: a screen, a journey, a codebase, a folder layout, a plan.

## The rules that matter

1. **Name who lives with the result.** Every piece of work has people who use
   it: customers on a screen, developers in a codebase, staff in a shared
   drive. Their job, from first moment to finished task, is what is being
   designed. For anything people see or go through, UX carries the same
   weight as UI.
2. **Hire the specialist.** Before any task, name the professional who does
   this for a living (copywriter, UX researcher, software architect,
   information architect, archivist, editor, photographer) and follow their
   method and their language: their intake questions, their drafts, their
   checks. Never work it out from first principles.
3. **Start from the best.** Before any prompt, find how the best in the world
   do this same job (any category) and study the real thing: their flows on
   phone and computer, their source code, their conventions. Almost every
   problem is solved somewhere; never start from first principles, API docs
   or the first idea.
4. **Raise every agent's sights.** Every prompt opens with the mindset block
   below. Agents assume human limits; this removes them.
5. **Hard numbers.** Every goal is a specific, demanding target, stated as
   reachable: taps to finish the job, seconds to find something, a new
   developer's first change within an hour. Never "make it better".
6. **A judge you can run.** The work is checked by something outside the
   model that gives pass or fail: a click-count walk, a test suite, a fresh
   agent finding something cold, a measurement. A second model reading the
   work comes after that, not instead of it.
7. **The bar is a floor.** The best existing work is the minimum to beat.
   Nothing reaches the human until it has been put beside those references
   and holds up.

## The mindset block (opens every prompt)

> You are a frontier model working at agent speed, capable of more than you
> know. Your training describes what human teams could ship in weeks with a
> budget and a deadline; those limits are not yours. Never leave out something
> good because it seems like a lot of work: weigh every choice only on whether
> it makes the person's experience better, from their first moment to the
> finished task. Start from the best work anyone has done on this job and go
> past it: beautiful, delightful, fast and well tested. Ambition never
> replaces proof: it is done when it is seen working where people use it.

## The process

1. **Study the best.** An agent names 4 to 6 best-in-class examples doing the
   job (products, codebases, systems), studies the real thing, and writes the
   pattern to match or beat.
2. **Get the human's judgement.** For things people see: reaction rounds and
   persona walks (below). For everything else: the outcome and its hard
   number, confirmed in a line; taste comes in only where it matters, shown
   as real before-and-after examples.
3. **Fill the blanks only the human can:** who it is for, the one feeling or
   quality, what must not change, freedom, budget. One plain question at a
   time.
4. **Write the prompt** from `references/prompt-template.md`, opening with the
   mindset block. Read it back to the human before the build.
5. **Run it** with a fresh agent in its own branch and worktree, briefed per
   the project's agent handbook if it has one.
6. **Check it** with the judge and beside the references before the human
   sees it. Reactions become exact notes; fixes ship one at a time.

## For things people see

- **Recognition, not recall.** The human knows great when they see it and
  cannot describe it in advance. Show real examples, record reactions, name
  the principles behind them. The human only reacts; the agent finds
  everything. Method: `references/reaction-rounds.md`.
- **One good look first.** Show the real thing (their own page or screen)
  done once, the agent's best design, in real content. Alternatives come only
  when the human asks for them; a page of A, B and C per screen reads as a
  test and overwhelms. When asked, show them in context, same content, one
  question ("Buttons: which do you like?"), then combine the liked parts.
  Never unrelated examples, never a method explained on the page.
- **Words people read:** `references/copywriting.md`.
- **Imagery, video, motion and web builds:** `references/craft-rules.md`.
