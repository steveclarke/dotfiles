---
name: readme-writer
license: MIT
description: "Measure and improve the reading level of any prose — docs, READMEs, emails, proposals, specs, plans. Scores Flesch-Kincaid grade level and top-1000 vocabulary coverage with real scripts instead of estimates. Triggers on 'readability', 'reading level', 'grade level', 'Flesch-Kincaid', 'plain language', 'make this easier to read', 'simplify this writing', 'too dense', 'ESL-friendly', and on 'write readme', 'improve readme', 'readme review', 'documentation writing'."
---

# Readability and README Writing

Two jobs. The common one: **measure and improve reading level in any prose** —
a doc, an email, a proposal, a spec, a plan. The narrower one: **structure a
README**.

## Always Measure — Never Estimate

Syllable counts cannot be eyeballed accurately across a document. Reporting a
Flesch-Kincaid score without running the script is guessing. Run it.

```bash
cat FILE | ruby scripts/flesch_kincaid.rb
```

Works on any text, not just markdown — pipe in an email draft, a section of a
doc, a paragraph pasted into a heredoc.

**Target: grade level 11 or below.** Technical terms inflate the score, and
that's fine — the goal is to keep the *surrounding prose* clear so the technical
content stays accessible.

Revise, then re-measure. Focus revision on:

- Shortening sentences (not dumbing down terminology)
- Replacing complex connectors with simple ones
- Breaking multi-clause sentences into two

Report the before and after scores.

## Vocabulary Coverage

Many readers of technical writing are not native English speakers.

```bash
cat FILE | ruby scripts/vocabulary_profiler.rb
```

Aim to raise the percentage of words in the top 1000 most common English words.
Technical terms lower this number — expected. Keep the non-technical words
simple.

**Do:**
- Use active voice
- Keep noun phrases short and direct
- Limit embedded clauses to one level of nesting
- Use simple "if/then" conditionals
- Make logical connections explicit with transition words (however, therefore, because)
- Spread information across multiple sentences when needed

**Don't:**
- Stack multiple modifiers before nouns ("the recently revised standardized testing protocol")
- Rely on mixed or inverted conditionals ("Had she known...")
- Expect readers to infer relationships between ideas
- Pack too many new concepts into a single sentence
- Assume shared knowledge of idioms or cultural references

## Flow and Transitions

- Start with concepts, then details. Give readers the "why" before the "how"
- Add transitions between major sections so the piece reads as a narrative, not a list of disconnected blocks
- Create logical progression from high-level to detailed

## README Structure

When the document is specifically a README, it flows through these sections:

1. **What and why** — what the package does and why it matters (the "what's in it for me")
2. **Install and use** — how to get started quickly
3. **Configuration** — common options and methods
4. **Contributing** — how to contribute, or a pointer to CONTRIBUTING.md. Notes on the build environment and portability
5. **Project layout** — unusual top-level directories or files, hints for navigating the source

## Formatting

Use GitHub-flavored callout blocks to highlight important information:

> [!CAUTION]
> [!IMPORTANT]
> [!NOTE]
> [!TIP]
> [!WARNING]

- Use **bold** for key concepts on first introduction
- Use `code` for commands, filenames, config keys, and values
- Use concrete, descriptive names for examples ("Invoice Approval" not "Example 1")

## Quality Checklist

- [ ] Flesch-Kincaid grade level **measured with the script**, at or below 11
- [ ] Vocabulary coverage measured; non-technical words kept simple
- [ ] Each section flows naturally into the next
- [ ] Key concepts are bolded on first use
- [ ] Examples use real scenario names, not generic placeholders
- [ ] No corporate buzzwords (comprehensive, robust, seamless, leverage, utilize)
- [ ] Terminology is consistent throughout (same word for same concept)
- [ ] Acronyms and specialized terms are defined on first use
- [ ] Active voice is used wherever possible

## Bibliography

- GNU Coding Standards, https://www.gnu.org/prep/standards/html_node/Releases.html
- Software Release Practice HOWTO, https://tldp.org/HOWTO/Software-Release-Practice-HOWTO/distpractice.html
