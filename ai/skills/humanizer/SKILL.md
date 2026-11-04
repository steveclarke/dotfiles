---
name: humanizer
description: Finds and removes the habits that mark prose as machine-written (em dashes, "not X but Y", groups of three, bolded list headers, padded closers) in drafts, reports, docs, pages and messages, including the agent's own. Use when asked to humanize, de-AI, clean up or tighten writing, or before handing over any long prose.
---

# Humanizer

A model reads its own draft as fine because every phrase in it was the likeliest one to write. The likeliest phrase is the one readers have seen a thousand times, and it tells them nobody chose the words. This skill lists the habits that survive in frontier-model prose, each with a fix, and a way to catch them in text the agent wrote itself.

Contents: where it sits with the other writing rules, how to run the pass, the habits (19, each with a before and after), and text written for a machine.

## Where it sits with the other writing rules

- Messages Steve sends in his own voice follow the `my-voice` skill. It already bans em dashes, AI words, rule-of-three padding and motivational closers; this pass runs after drafting and never adds a voice of its own.
- Writing to Steve follows global `AGENTS.md`, "Talking to Steve": answer first, plain and few words.
- Docs and skills follow global `AGENTS.md`, "Documents": reference voice, third person, present tense.

The pass removes habits. It adds no personality, opinions, asides or "mess": the target is the plainest version that says what the writer means. Facts stay as the source has them; where a vague claim needs a specific the source does not hold, the rewrite marks the gap rather than inventing one.

## How to run the pass

1. Scan mechanically first, because reading will not catch what the eye expects:
   `grep -niE '—|–|\*\*[^*]+:\*\*|\b(delve|crucial|pivotal|robust|seamless|leverage|landscape|tapestry|testament|underscore|showcase|foster|navigate|realm|elevate|genuinely|honestly|quietly|truly|essentially|load-bearing)\b|not (just|only|merely)|it.s worth|here.s the thing' FILE`
2. Read it sentence by sentence against the list below, asking of each: would a person writing this by hand have typed these exact words?
3. Rewrite the hits, then read the result once more. Fixes breed new tics (every em dash turned into a colon reveal).
4. Return the rewritten text. List the changes only if asked.

## The habits

### Em dashes

The strongest single tell. A comma, a period or parentheses does the job. En dashes used as dashes count too; a range (9–5) is fine.

- Before: The fix was small — one line — but it took a day to find.
- After: The fix was one line, but it took a day to find.

### "Not X, but Y" and its cousins

"It's not just A, it's B", "This isn't about A. It's about B." A contrast nobody proposed.

- Before: This isn't a bug in the parser. It's a gap in the spec.
- After: The spec never says what happens with an empty file.

### Groups of three

Three adjectives, three parallel clauses, three bullets where there are two real points.

- Before: Fast, reliable and easy to maintain.
- After: It deploys in under a minute and nobody has touched it since March.

### The colon or question reveal

"The fix? A single flag." "Here's the thing:" "The result:" A setup line that delays the point.

- Before: The culprit? A stale cache.
- After: A stale cache caused it.

### Punchy fragments

Short sentences stacked for drama.

- Before: It works. Every time. No exceptions.
- After: It has passed every run since the fix.

### Bolded inline headers in lists

`- **Performance:** Performance improved...` repeats the header in the sentence. Bold is for the one thing a skimmer must not miss.

- Before: **Speed:** The new build is faster.
- After: The build takes 40 seconds instead of three minutes.

### Significance and legacy

"marks a pivotal moment", "a testament to", "underscores the importance of", "sets the stage for", where the sentence should say what happened.

- Before: The migration marks a key milestone in the platform's evolution.
- After: All clients now run on the new database.

### Tail clauses in -ing

"..., ensuring that...", "..., highlighting...", "..., making it easy to...". Usually an unproven claim bolted on.

- Before: We added retries, ensuring a seamless experience for users.
- After: We added retries, so a dropped connection no longer fails the import.

### Avoiding "is" and "has"

"serves as", "stands as", "boasts", "features", "offers".

- Before: The page serves as the single source of truth and features a full history.
- After: The page is the record and keeps every past version.

### Inflated vocabulary

delve, crucial, pivotal, robust, seamless, leverage, landscape, realm, navigate (figurative), foster, elevate, empower, streamline, comprehensive, key (adjective), additionally, moreover. The plain word, or nothing, reads better.

- Before: This robust approach lets us leverage the existing cache.
- After: This reuses the existing cache.

### Intensifiers and sincerity markers

genuinely, honestly, truly, really, quietly, deeply, incredibly, "to be clear". They imply the rest was less sincere or less true.

- Before: I genuinely think this quietly solves the problem.
- After: I think this solves the problem.

### Signposting and throat-clearing

"Let's dive in", "It's worth noting that", "It's important to remember", "In short", "At its core", "When it comes to".

- Before: It's worth noting that the API rate-limits at 100 requests.
- After: The API allows 100 requests a minute.

### Hedges stacked on hedges

"could potentially", "may possibly", "it seems likely that it might". One hedge belongs where there is real doubt, with what the doubt is.

- Before: This could potentially cause issues in some cases.
- After: This breaks if two users save in the same second.

### Synonym cycling

One thing given several names. Readers take a new word for a new thing, so the name repeats.

- Before: The importer reads the file. The tool then validates rows, and the utility writes them out.
- After: The importer reads the file, validates the rows and writes them out.

### Summary and pep closers

"In summary...", "Overall, this sets us up for success", "Exciting times ahead", "Hope this helps!", "Let me know if you'd like me to...". The text stops when the content stops; an offer stays only when there is a real next step.

- Before: Overall, these changes position the project well for future growth.
- After: (deleted)

### Chat residue in content

"Great question!", "You're absolutely right", "Certainly!", "Here is the updated document:" left in anything that is not a live reply.

- Before: Here's a summary of the release notes: version 2.3 adds export.
- After: Version 2.3 adds export.

### Structure the text does not need

Headings over three paragraphs, bullets for one idea, a table for two facts, bold every few words, Title Case Headings. Prose serves until the content has real parts.

- Before: ## Overview, then one bullet: "The script backs up the database."
- After: The script backs up the database.

### Passive that hides who

"Mistakes were made", "it was decided". The actor is named when known; passive is fine when the actor is unknown or does not matter.

- Before: It was determined that the config was not validated.
- After: Nobody checked the config before the deploy.

### Symmetry

Every paragraph three sentences, every bullet the same length, each section ending on a one-line takeaway. Length follows the content.

- Before: three bullets of eight words each, the last a takeaway ("This keeps things simple.").
- After: two bullets of whatever length the facts need, no takeaway.

## When the text is for a machine

Tool descriptions, error messages, system prompts and agent briefs lose these habits too, and want nothing added back: one meaning per word, active voice, short sentences, the aim and its reason stated once.
