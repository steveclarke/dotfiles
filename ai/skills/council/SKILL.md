---
name: council
description: "Run a decision through 5 AI advisors with peer review and chairman synthesis. For genuine decisions with stakes — not simple questions. Based on Karpathy's LLM Council."
user-invocable: true
argument-hint: "[question or decision to pressure-test]"
---

# LLM Council

Run a question through 5 independent advisors, each thinking from a fundamentally different angle. They review each other's work anonymously. A chairman synthesizes everything into a final recommendation — where they agree, where they clash, and what to do.

Adapted from Andrej Karpathy's LLM Council. He dispatches queries to multiple models with anonymous peer review. We do the same inside Claude using sub-agents with different thinking lenses instead of different models.

## When to Run the Council

The council is for questions where being wrong is expensive.

**Good council questions:**
- "Should I build this as a multi-tenant SaaS or single-tenant first?"
- "Which of these 3 positioning angles is strongest?"
- "I'm thinking of pivoting from X to Y. Am I crazy?"
- "Should I hire for this role or build an automation first?"
- "We're choosing between these two architecture approaches"

**Bad council questions:**
- "What's the capital of France?" (one right answer)
- "Write me a tweet" (creation task, not a decision)
- "Summarize this article" (processing task, not judgment)

If you already know the answer and just want validation, the council will tell you things you don't want to hear. That's the point.

## The Five Advisors

Each advisor is a thinking style, not a persona. They create natural tensions with each other.

### 1. The Contrarian
Actively looks for what's wrong, what's missing, what will fail. Assumes the idea has a fatal flaw and tries to find it. If everything looks solid, digs deeper. Not a pessimist — the friend who saves you from a bad deal by asking the questions you're avoiding.

### 2. The First Principles Thinker
Ignores the surface-level question and asks "what are we actually trying to solve here?" Strips away assumptions. Rebuilds the problem from the ground up. Sometimes the most valuable output is this advisor saying "you're asking the wrong question entirely."

### 3. The Expansionist
Looks for upside everyone else is missing. What could be bigger? What adjacent opportunity is hiding? What's being undervalued? Doesn't care about risk (that's the Contrarian's job). Cares about what happens if this works even better than expected.

### 4. The Outsider
Has zero context about you, your field, or your history. Responds purely to what's in front of them. The most underrated advisor. Catches the curse of knowledge: things obvious to you but confusing to everyone else.

### 5. The Executor
Only cares about one thing: can this actually be done, and what's the fastest path? Ignores theory, strategy, and big-picture thinking. Looks at every idea through the lens of "OK but what do you do Monday morning?" If an idea sounds brilliant but has no clear first step, the Executor will say so.

**Why these five:** Three natural tensions. Contrarian vs Expansionist (downside vs upside). First Principles vs Executor (rethink everything vs just do it). The Outsider sits in the middle keeping everyone honest.

## How a Council Session Works

### Step 1: Frame the Question

When the user triggers the council, do two things before framing:

**A. Scan for context.** The question is often just the tip of the iceberg. Before framing, quickly scan for relevant context:

- `CLAUDE.md` in the project root (business context, preferences, constraints)
- Any `memory/` folder (past decisions, business details)
- Files the user explicitly referenced
- Recent council transcripts (to avoid re-counciling the same ground)
- Other context files relevant to the specific question

Use `Glob` and quick `Read` calls. Don't spend more than 30 seconds. You're looking for the 2-3 files that give advisors enough context for specific, grounded advice instead of generic takes.

**B. Frame the question.** Take the user's raw question AND the enriched context and reframe as a clear, neutral prompt that all five advisors receive:

1. The core decision or question
2. Key context from the user's message
3. Key context from workspace files (business stage, constraints, relevant numbers)
4. What's at stake (why this decision matters)

Don't add your own opinion. Don't steer it. But DO make sure each advisor has enough context for specific answers.

If the question is too vague, ask **one** clarifying question. Just one. Then proceed.

Save the framed question for the transcript.

### Step 2: Convene the Council (5 sub-agents in parallel)

Spawn all 5 advisors simultaneously as sub-agents. Each gets:

1. Their advisor identity and thinking style
2. The framed question
3. Clear instruction: respond independently. Do not hedge. Do not try to be balanced. Lean fully into your assigned perspective. Your job is to represent your angle as strongly as possible. The synthesis comes later.

Each advisor produces 150-300 words. Substantive but scannable.

**Sub-agent prompt template:**

```
You are [Advisor Name] on an LLM Council.

Your thinking style: [advisor description from above]

A user has brought this question to the council:

---
[framed question]
---

Respond from your perspective. Be direct and specific. Don't hedge or try to be balanced. Lean fully into your assigned angle. The other advisors will cover the angles you're not covering.

Keep your response between 150-300 words. No preamble. Go straight into your analysis.
```

### Step 3: Peer Review (5 sub-agents in parallel)

This is the step that makes the council more than just "ask 5 times." It's the core of Karpathy's insight.

Collect all 5 advisor responses. **Anonymize them as Response A through E** (randomize which advisor maps to which letter — no positional bias).

Spawn 5 new sub-agents. Each reviewer sees all 5 anonymized responses and answers three questions:

1. Which response is the strongest and why? (pick one)
2. Which response has the biggest blind spot and what is it?
3. What did ALL responses miss that the council should consider?

That last question is the most valuable. Every time the council runs, the peer review catches something no individual advisor saw.

**Reviewer prompt template:**

```
You are reviewing the outputs of an LLM Council. Five advisors independently answered this question:

---
[framed question]
---

Here are their anonymized responses:

**Response A:**
[response]

**Response B:**
[response]

**Response C:**
[response]

**Response D:**
[response]

**Response E:**
[response]

Answer these three questions. Be specific. Reference responses by letter.

1. Which response is the strongest? Why?
2. Which response has the biggest blind spot? What is it missing?
3. What did ALL five responses miss that the council should consider?

Keep your review under 200 words. Be direct.
```

### Step 4: Chairman Synthesis

One agent gets everything: the original question, all 5 advisor responses (de-anonymized), and all 5 peer reviews.

The chairman produces the final council output:

**Chairman prompt template:**

```
You are the Chairman of an LLM Council. Synthesize the work of 5 advisors and their peer reviews into a final verdict.

The question brought to the council:
---
[framed question]
---

ADVISOR RESPONSES:

**The Contrarian:**
[response]

**The First Principles Thinker:**
[response]

**The Expansionist:**
[response]

**The Outsider:**
[response]

**The Executor:**
[response]

PEER REVIEWS:
[all 5 peer reviews]

Produce the council verdict using this exact structure:

## Where the Council Agrees
[Points multiple advisors converged on independently. High-confidence signals.]

## Where the Council Clashes
[Genuine disagreements. Present both sides. Explain why reasonable advisors disagree.]

## Blind Spots the Council Caught
[Things that only emerged through peer review. Things individual advisors missed that others flagged.]

## The Recommendation
[A clear, direct recommendation. Not "it depends." A real answer with reasoning.]

## The One Thing to Do First
[A single concrete next step. Not a list. One thing.]

Be direct. Don't hedge. The whole point of the council is to give the user clarity they couldn't get from a single perspective.
```

### Step 5: Present the Verdict

Display the chairman's verdict directly in the conversation. This is the primary output.

Then save the full transcript as `council-transcript-[YYYY-MM-DD-HHMM].md` in the current working directory. The transcript includes:
- The original question
- The framed question
- All 5 advisor responses
- All 5 peer reviews (with anonymization mapping revealed)
- The chairman's full synthesis

This transcript is the artifact. If the user wants to run the council again after making changes, the previous transcript shows how the thinking evolved.

## Important Notes

- **Always spawn all 5 advisors in parallel.** Sequential spawning wastes time and lets earlier responses bleed into later ones.
- **Always anonymize for peer review.** If reviewers know which advisor said what, they'll defer to certain thinking styles instead of evaluating on merit.
- **The chairman can disagree with the majority.** If 4 out of 5 say "do it" but the 1 dissenter's reasoning is strongest, the chairman should side with the dissenter and explain why.
- **Don't council trivial questions.** If there's one right answer, just answer it.
- **Token budget awareness.** This skill spawns 11 sub-agents (5 advisors + 5 reviewers + 1 chairman). It's thorough but expensive. Worth it for real decisions, overkill for minor ones.
