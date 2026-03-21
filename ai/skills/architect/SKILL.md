---
name: architect
description: "Assess and improve the architecture of a codebase through layered analysis and guided restructuring. Use when the user wants to evaluate codebase structure, design patterns, modularity, composition, coupling, or framework alignment. Triggers on 'architect', 'architecture review', 'is this well-architected', 'structural assessment', 'evaluate the architecture'."
argument-hint: "[--teach] [--sweep] [<target>]"
---

# Architect

Evaluate whether a codebase is well-organized at the structural level. Works
through layered analysis: discover values, broad sweep, deep dive, assessment,
and optional planning/execution.

This is NOT code review (correctness), code simplification (cleanup), or part of
`/ship` (pre-PR pipeline). Those skills look at code quality and changes.
`/architect` looks at how the codebase is organized — modularity, coupling,
composition, framework alignment, and structural coherence.

## Invocation

| Command | Behavior |
|---------|----------|
| `/architect` | Full run: teach (if needed) > sweep > deep dive > assess |
| `/architect --teach` | Re-run values discovery |
| `/architect --sweep` | Broad sweep only, skip deep dives |
| `/architect <target>` | Focus on a subsystem (e.g., "the dispatch system", `app/models`). Runs Teach if needed, then scopes sweep and deep dive to the target area only. Updates the main assessment artifact. |

## Phases

1. **Teach** — Values discovery (first run per project). Conversational.
2. **Sweep** — Quick broad scan across 7 architectural lenses.
3. **Deep Dive** — Parallel analysis on lenses flagged during sweep.
4. **Assess** — Present findings, discuss with user, generate artifact.
5. **Plan** — Phased implementation strategies (on demand).
6. **Execute** — Invoke writing plans for restructuring (on demand).

## Parse Arguments

Parse `$ARGUMENTS` for flags and target:

- `--teach` — force re-run values discovery, even if config exists
- `--sweep` — broad sweep only, skip deep dives
- Everything else is treated as `<target>` — a subsystem to focus on (path or description)

Multiple flags can combine: `--teach` with a target re-discovers values then
scopes to that subsystem.

## Project Detection

```bash
ARCHITECT="$HOME/.claude/skills/architect/scripts/architect.sh"
PROJECT_INFO=$("$ARCHITECT" detect)
SLUG=$(echo "$PROJECT_INFO" | jq -r '.slug')
ROOT=$(echo "$PROJECT_INFO" | jq -r '.root')
CONFIGURED=$(echo "$PROJECT_INFO" | jq -r '.configured')
```

If `SLUG` is empty, stop with: "Not in a git repository. `/architect` needs a
git repo to work with."

## Phase 1: Teach — Values Discovery

This phase is **conversational**. Ask one question at a time. Wait for the
answer before moving on. Do not dump all questions at once.

**Skip condition:** If `CONFIGURED` is `true` AND `--teach` was NOT passed,
skip this phase. Load existing config instead:

```bash
CONFIG=$("$ARCHITECT" config "$SLUG")
```

Then proceed to Phase 2 (Sweep).

**If `--teach` was passed:** Run this phase even if config exists. The new
config will overwrite the old one (uses `--force`).

### Step 1: Auto-detect Framework

Scan the project root for framework indicators:

- `Gemfile` with `rails` — **Ruby on Rails**
- `package.json` with `nuxt` — **Nuxt.js**
- `package.json` with `vue` — **Vue.js**
- `package.json` with `next` or `react` — **Next.js / React**
- `go.mod` — **Go**
- `pyproject.toml` or `requirements.txt` with `django` — **Django**
- `pyproject.toml` or `requirements.txt` with `flask` or `fastapi` — **Flask / FastAPI**
- `Cargo.toml` — **Rust**
- `mix.exs` with `phoenix` — **Phoenix (Elixir)**

Present the finding: "I'm detecting this as a **[framework]** project. Is that
right, or should I know more about the stack?"

Wait for confirmation before continuing. If the user corrects, use their answer.

### Step 2: Discover Architectural Philosophy

Based on the detected framework, present 3-4 schools of thought. These frame
how the skill evaluates architecture — there's no single "right" answer, and
the user's preference shapes what counts as a finding vs. a design choice.

**For Ruby on Rails:**

> I'd like to understand your architectural philosophy. Here are the common
> schools of thought for Rails — which resonates, or is it a mix?
>
> 1. **The Rails Way (DHH)** — Convention over configuration. Concerns for
>    shared behavior. Fat models are fine. Majestic monolith. The framework
>    is the architecture.
> 2. **Sandi Metz's OOP** — Small objects, single responsibility. Composition
>    over inheritance. Dependency injection. Classes under 100 lines, methods
>    under 5 lines (aspirational, not dogma).
> 3. **Hexagonal / Clean Architecture** — Ports and adapters. Domain logic
>    independent of the framework. Dependency inversion. Rails at the edges,
>    pure Ruby in the core.
> 4. **Pragmatic mix** — Take what works from each. No dogma. The codebase
>    serves the team, not a philosophy.

**For Vue/Nuxt:**

> 1. **Composition-first** — Composables for everything. Thin components.
>    Logic lives in composables, components are just templates and wiring.
> 2. **Component-centric** — Components own their logic. Props down, events
>    up. Local state preferred. Composables only for truly shared behavior.
> 3. **Store-driven** — Pinia stores are the source of truth. Components
>    render store state. Business logic lives in stores and actions.
> 4. **Pragmatic mix** — Whatever fits the feature. No single pattern.

**For Go:**

> 1. **Standard library purist** — Minimal dependencies. `net/http` over
>    frameworks. Flat package structure. Interfaces discovered, not planned.
> 2. **Domain-Driven Design** — Packages by domain, not by layer. Internal
>    packages for isolation. Explicit dependency injection.
> 3. **Hexagonal / Clean Architecture** — Ports and adapters. Framework at
>    the edges. Domain core has no external dependencies.
> 4. **Pragmatic mix** — Use what works. Follow Go idioms, not imported patterns.

For other frameworks, present analogous options — framework-idiomatic vs.
OOP/composition-focused vs. clean architecture vs. pragmatic. Use the same
conversational tone.

Wait for the user's answer. Store their choice.

### Step 3: Discover Key Values

Based on the chosen philosophy, ask 3-5 focused questions about specific
preferences. These calibrate how aggressively the skill flags structural
issues. Ask **one at a time**.

Pick from these based on relevance to the framework and chosen philosophy:

- **Coupling tolerance:** "How do you feel about coupling to the framework?
  Is it fine for domain logic to use ActiveRecord/Pinia/etc. directly, or do
  you prefer a separation layer?"

- **File size comfort:** "What's your comfort level with file size? Are you
  okay with 200-300 line classes/components, or do you prefer to break things
  up smaller?"

- **Abstraction appetite:** "How do you feel about abstractions like service
  objects, form objects, interactors, or composables? Use them freely, or
  only when the pain is obvious?"

- **Test architecture:** "How do you think about test organization? Mirror
  the source tree? Separate by type (unit/integration)? Test behavior or
  implementation?"

- **Naming conventions:** "Any strong opinions on naming? Do you follow a
  specific convention for services, jobs, components, etc.?"

Tailor the questions to the framework — don't ask about ActiveRecord coupling
in a Go project. 3 questions is fine if the answers are clear. 5 is the max.

### Step 4: Ask for Artifact Location

The assessment produces a markdown artifact stored in the project repo. Ask
where it should go:

> "Where should I store the architecture assessment in this repo? A common
> convention is `project/architecture-assessment.md` — does that work, or do
> you have a different preference?"

Store the path relative to the project root.

### Step 5: Handle Slug Collisions

Before saving, check if the detected slug already has a config pointing to a
**different** `project_root`:

```bash
EXISTING_CONFIG=$("$ARCHITECT" config "$SLUG" 2>/dev/null || echo "")
```

If `EXISTING_CONFIG` is non-empty, extract its `project_root`:

```bash
EXISTING_ROOT=$(echo "$EXISTING_CONFIG" | jq -r '.project_root')
```

If `EXISTING_ROOT` differs from `ROOT`, there's a collision — two different
repos happen to have the same directory name. Ask:

> "There's already a config for slug `[slug]` pointing to `[existing_root]`.
> This project is at `[root]`. What slug should I use for this one?"

Use the user's answer as the slug going forward.

### Step 6: Save Config

Build a JSON config object with the collected values and save it:

```bash
"$ARCHITECT" init "$SLUG" '{
  "project_root": "<ROOT>",
  "framework": "<detected framework>",
  "philosophy": "<chosen philosophy>",
  "values": {
    "coupling_tolerance": "<answer>",
    "file_size_comfort": "<answer>",
    "abstraction_appetite": "<answer>",
    "test_architecture": "<answer>",
    "naming_conventions": "<answer>"
  },
  "artifact_path": "<chosen path>",
  "created_at": "<ISO timestamp>"
}' --force
```

Only include values keys that were actually asked and answered. The `--force`
flag ensures re-running `--teach` overwrites cleanly.

Confirm to the user: "Got it. Config saved for **[slug]**. Moving to the
sweep phase."

Update state to record teach is complete:

```bash
"$ARCHITECT" update-state "$SLUG" "teach_complete=true" "teach_date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
```

---

*Phases 2-6 (Sweep, Deep Dive, Assess, Plan, Execute) are defined in
subsequent sections of this skill file.*
