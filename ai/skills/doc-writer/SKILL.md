---
name: doc-writer
license: MIT
description: Writes and restructures documents people read (specs, guides, plans, READMEs, reports, runbooks, briefs) answer first, with progressive disclosure, and measures reading level with bundled Flesch-Kincaid and common-word scorers. Use when writing, revising or reviewing such a document, or when asked how readable a text is. Not for chat replies, email replies or code comments.
---

# Doc writer

A document is read by someone who wants to act: build the feature, set up the
machine, approve the plan, fix the outage. Agents tend to write the opposite:
background first, every detail at the same depth, one long page, prose scored
by feel. This skill holds what goes wrong and how to check it.

## Name the reader

Choose before writing. A Brief for Steve asks for decisions in one or two
pages; Hugo's `docs/feature-briefs.md` sets its shape. A team explainer opens
each section with what it is and why it matters, then gives the detail. A
design document is for builders: code references and technical depth belong
there. It is never handed to Steve as his reading.

Write for someone with none of the writer's context. Explain each idea where
it first appears. Each section gives enough context to make sense on its own.

## Answer first

The first two lines say what this is and what the reader does with it. A spec
opens with what the feature does and for whom; a guide with what the reader
will have when done and how long it takes; a plan with the decision or approval
it needs. A reader who stops after two lines still knows what to do. Steve's
`docs/bluf.md` in Hugo gives the shape and its sources.

Background, history and how the work got here come last or go to the
discussion record. No opening that restates the request, describes the
document ("This document outlines…") or narrates the process.

## Progressive disclosure

Write in layers: summary, then detail, then reference.

- Summary: the answer and the few facts that change what the reader does.
- Detail: what the reader needs to act, in the order they act on it.
- Reference: what they look up later (field lists, edge cases, error codes,
  full command options), at the end, in an appendix or on its own page.

Justify each section by asking whether the reader needs it to act or only to
look something up. The first kind stays in the flow, the second moves to
reference, and anything that serves neither comes out. Headings read top to
bottom should tell the story on their own.

A document past about two screens of action content splits into an index page
with linked pages, one level deep. The index carries the answer and one line
per linked page saying when to open it. Steve often reads on a phone, so long
tables and wide code blocks belong on reference pages.

## By kind

The usual structure of each kind is assumed; these are the places agents most
often go wrong.

- Spec: behaviour stated as what a person sees and does, with acceptance
  checks a reviewer can run. Decisions made are stated as facts; open
  questions are a short numbered list near the top, each with a recommended
  answer. No implementation diary.
- Guide or runbook: numbered steps, one action each, commands ready to copy,
  and the expected result after any step that can fail. Prerequisites come
  before step 1, not at step 6.
- Plan: the decision or go it needs, then steps sized in agent time, then
  risks only where they would change the decision.
- README: what it does and the quickest working start; the rest links to docs.
- Report: the finding and what it means for the reader, then the evidence,
  with the scope and filters behind any search.

## Voice

Docs are in reference voice (Steve's global `AGENTS.md`, "Documents"). One
term per concept, acronyms defined on first use, and prose a reader with
English as a second language follows: short sentences, active voice, no idioms.

Real technical names stay: database, API, webhook, DNS record, Durable
Object. No coined phrases, buzzwords or clever labels. Describe what happens.

- "Immutable intake evidence" becomes "The form keeps the details first sent."
- "Operation receipts" becomes "A saved record shows whether the change worked."
- "Sealed approval snapshots" becomes "Approval applies to this saved version."
- "Each fact has one writer" becomes "Outport alone changes customer details."

## Measure every draft

Reading level is measured, never estimated. The scorers are in this skill's
`scripts/` folder, installed at `~/.agents/skills/doc-writer/scripts/`. Both
read standard input. Pass `--markdown` for a markdown file, so code blocks,
tables, headings and link targets are not scored as prose; plain text such as
an email goes in without it.

```bash
S=~/.agents/skills/doc-writer/scripts
ruby $S/flesch_kincaid.rb --markdown < doc.md
ruby $S/vocabulary_profiler.rb --markdown < doc.md
```

- Grade level: 9 or below for anything Steve or the team reads. A builder
  design document may use a higher target set by its brief. Technical
  terms raise the score and stay; the score comes down by splitting sentences
  and using plain connectors, not by renaming technical things.
- Common-word coverage: the share of words among the 1000 most common English
  words. It has no fixed target; it rises when the non-technical words are
  kept simple.

Run both on the first draft and the final one, and report both pairs of
numbers with the document: "grade 13.2 → 8.8, common words 41% → 49%".

## Before handing it over

1. Read only the first two lines: they give the answer and the reader's action.
2. Read only the headings: they tell the story in order.
3. Check each section earns its place under "Progressive disclosure".
4. Run the scorers and record the numbers.
5. Run the explain-back test: a fresh reader gets only the page text and the
   reader profile. For each section, they say what it means in plain words
   and list each phrase they cannot explain or that is a coined label.
   Any listed phrase fails. Revise and repeat before handoff. In Hugo,
   `coordinators/bin/readable <file-or-folder>` runs both checks; use
   `--kind team` for an explainer or `--kind design` for builder reference.
   The default is a Brief for Steve. The coordinator still reads it in full.
