---
name: readme-writer
description: Write and revise READMEs and technical documentation for software projects. Scores readability with Flesch-Kincaid and vocabulary profiling. Use when writing, revising, or reviewing a README, README.md, or project documentation. Triggers on "write readme", "improve readme", "readme review", "documentation writing".
license: MIT
---

# README Writer

## README Structure

A good README flows through these sections:

1. **What and why** — What the package does and why it matters (the "what's in it for me" for the reader)
2. **Install and use** — How to get started quickly
3. **Configuration** — Common options and methods
4. **Contributing** — How to contribute, or a pointer to CONTRIBUTING.md. Notes on the build environment and portability
5. **Project layout** — Brief explanation of unusual top-level directories or files, hints for navigating the source

## Writing for a Technical Audience

### Reading Level

Target a **Flesch-Kincaid grade level of 11 or below**. Technical terms will naturally inflate the score — that's fine. The goal is to keep the *surrounding prose* clear and direct so the technical content stays accessible.

After writing or revising, measure with `scripts/flesch_kincaid.rb`:

```bash
cat README.md | ruby scripts/flesch_kincaid.rb
```

Revise until the score is at or below grade 11. Focus revision effort on:
- Shortening sentences (not dumbing down terminology)
- Replacing complex connectors with simple ones
- Breaking multi-clause sentences into two

### ESL-Friendly Writing

Many readers of technical documentation are not native English speakers.

Profile vocabulary coverage with `scripts/vocabulary_profiler.rb`:

```bash
cat README.md | ruby scripts/vocabulary_profiler.rb
```

Aim to increase the percentage of words in the top 1000 most common English words. Technical terms will lower this number — that's expected. Keep the non-technical words simple.

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
- Add transitions between major sections so the document reads as a narrative, not a list of disconnected blocks
- Use phrases like "Now that you have X set up, here's how to configure Y"
- Create logical progression from high-level to detailed

## Formatting

### GitHub-Flavored Markdown

Use callout blocks to highlight important information:

> [!CAUTION]
> [!IMPORTANT]
> [!NOTE]
> [!TIP]
> [!WARNING]

### Disambiguation

- Use **bold** for key concepts on first introduction
- Use `code` for commands, filenames, config keys, and values
- Use concrete, descriptive names for examples ("Invoice Approval" not "Example 1")

## Quality Checklist

Before finalizing, verify:

- [ ] Each section flows naturally into the next
- [ ] Flesch-Kincaid grade level is 11 or below
- [ ] Key concepts are bolded on first use
- [ ] Examples use real scenario names, not generic placeholders
- [ ] No corporate buzzwords (comprehensive, robust, seamless, leverage, utilize)
- [ ] Terminology is consistent throughout (same word for same concept)
- [ ] Acronyms and specialized terms are defined on first use
- [ ] Active voice is used wherever possible

## Bibliography

- GNU Coding Standards, https://www.gnu.org/prep/standards/html_node/Releases.html
- Software Release Practice HOWTO, https://tldp.org/HOWTO/Software-Release-Practice-HOWTO/distpractice.html
