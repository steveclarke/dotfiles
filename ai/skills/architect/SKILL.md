---
name: architect
description: "Assess and improve codebase architecture via layered analysis and guided restructuring. Triggers on architecture review, structural assessment, design patterns, modularity, coupling, framework alignment."
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
  "project_name": "<project name from user or basename of ROOT>",
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

## Phase 2: Sweep — Broad Architectural Scan

A quick, broad scan across 7 architectural lenses. Uses a single Sonnet
subagent for cost/speed — this is a triage pass, not a deep analysis.

### Step 1: Load Config

```bash
CONFIG=$("$ARCHITECT" config "$SLUG")
```

Extract key fields for the subagent prompt:

```bash
FRAMEWORK=$(echo "$CONFIG" | jq -r '.framework')
PHILOSOPHY=$(echo "$CONFIG" | jq -r '.philosophy')
```

### Step 2: Determine Scope

If a `<target>` was passed, the sweep scopes to that subsystem only. Build a
scope instruction:

- **No target:** `"Scan the entire project at ROOT."`
- **Target is a path** (starts with `/`, `./`, or a directory that exists): `"Focus your scan on ROOT/<target> and its interactions with the rest of the codebase."`
- **Target is a description** (e.g., "the dispatch system"): `"Focus your scan on the subsystem described as: <target>. Identify the relevant files and directories first, then analyze."`

### Step 3: Dispatch Sweep Agent

Dispatch a single subagent using the Agent tool:

```
Agent(model: "sonnet", description: "Sweep: broad architectural scan of {SLUG}")
```

The prompt must be **fully self-contained** — the subagent has no conversation
context. Include everything it needs:

````
You are an architectural reviewer performing a broad sweep of a codebase.
Your job is to triage — identify areas that need deeper analysis, not to
do the deep analysis yourself.

## Project

- **Root:** {ROOT}
- **Framework:** {FRAMEWORK}
- **Philosophy:** {PHILOSOPHY}
- **Full config:** {CONFIG}

## Scope

{scope_instruction}

## Sampling Strategy

Do NOT read every file. Be strategic:

1. **Directory structure first** — run `ls` and `find` (depth-limited) to
   understand the layout
2. **Key entry points** — main config files, route definitions, application
   entry points, schema files
3. **Representative files per layer** — pick 2-3 files from each major
   directory (models, controllers, views, services, composables, etc.)
4. **Boundary files** — files that connect layers or modules (routers,
   registries, factories, dependency injection setup)
5. **Large files** — check file sizes, sample the biggest ones (often
   where coupling and cohesion issues live)

Budget: aim for ~30-50 files sampled total, more for large codebases.

## Architectural Lenses

Evaluate the codebase through each of these 7 lenses:

### 1. Structural Organization
- Directory layout and file grouping — by layer, by feature, or mixed?
- Separation of concerns — is business logic separated from framework plumbing?
- Naming conventions — consistent? Descriptive? Following framework idioms?
- Co-location — are related files near each other or scattered?

### 2. Design Patterns
- GoF patterns in use: adapter, strategy, facade, observer, factory, etc.
- Are patterns applied appropriately or forced where simpler code would do?
- Missing patterns — places where a well-known pattern would reduce complexity
- Over-patterned code — unnecessary abstraction layers, pattern-for-pattern's-sake

### 3. Composition & Inheritance
- Inheritance depth — deep hierarchies are a red flag
- Composable units — are behaviors composed via mixins/modules/composables or
  hardcoded into class hierarchies?
- Mixin/concern sprawl — too many small mixins that fragment understanding

### 4. Coupling & Cohesion
- Module dependencies — who depends on whom? Are there clear layers?
- Boundary clarity — can you change one module without touching three others?
- God objects — classes/modules that know too much or do too much
- Circular dependencies — A depends on B depends on A

### 5. Framework Alignment
- Convention adherence — is the team using the framework the way it was designed?
- Reinvented wheels — building custom solutions for things the framework provides
- Framework-specific anti-patterns (e.g., Rails: SQL in views, callbacks doing
  business logic, skip_before_action sprawl; Vue: mutating props, massive
  computed properties, v-if/v-for on same element)

### 6. API & Interface Design
- Internal API consistency — do similar operations have similar interfaces?
- Method signatures — clear parameter names? Reasonable arity? Options hashes
  vs. keyword args?
- Public surface area — is the public API minimal and intentional, or does
  everything leak?

### 7. Duplication & Reuse
- Copy-paste patterns — similar code in multiple places that should be shared
- Inconsistent approaches — the same problem solved differently in different places
- Missing shared code — utilities or patterns that should be extracted

## Output Format

Return your findings as a JSON object. Be concise in notes — this is triage,
not a full report. Include file_pointers so the deep dive knows where to look.

```json
{
  "timestamp": "<current ISO timestamp>",
  "scope": "<'full' or the target description>",
  "files_sampled": <number of files you read>,
  "lenses": {
    "structural_organization": {
      "health": "green|yellow|red",
      "notes": "Brief summary — what you found, why this rating",
      "file_pointers": ["paths/that/illustrate/the/finding"]
    },
    "design_patterns": {
      "health": "green|yellow|red",
      "notes": "...",
      "file_pointers": ["..."]
    },
    "composition_inheritance": {
      "health": "green|yellow|red",
      "notes": "...",
      "file_pointers": ["..."]
    },
    "coupling_cohesion": {
      "health": "green|yellow|red",
      "notes": "...",
      "file_pointers": ["..."]
    },
    "framework_alignment": {
      "health": "green|yellow|red",
      "notes": "...",
      "file_pointers": ["..."]
    },
    "api_interface_design": {
      "health": "green|yellow|red",
      "notes": "...",
      "file_pointers": ["..."]
    },
    "duplication_reuse": {
      "health": "green|yellow|red",
      "notes": "...",
      "file_pointers": ["..."]
    }
  }
}
```

**Health ratings:**
- **green** — no significant issues found, aligns with the project's stated philosophy
- **yellow** — some concerns worth investigating, potential improvements
- **red** — clear structural problems that affect maintainability or scalability

Be honest. Green is fine — not every lens will have issues. Don't manufacture
findings. But don't be afraid of red when it's warranted.

Return ONLY the JSON object, no surrounding text.
````

### Step 4: Process Sweep Results

Parse the JSON returned by the subagent. If the response is not valid JSON,
extract JSON from the response (look for `{` to `}` block) and parse that.

### Step 5: Log the Sweep

```bash
"$ARCHITECT" sweep-log "$SLUG" '<sweep_json>'
```

### Step 6: Update State

```bash
"$ARCHITECT" update-state "$SLUG" "last_sweep=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
```

### Step 7: Check Stop Condition

If `--sweep` was passed, present the sweep results to the user in a readable
format and **stop**:

```
## Architectural Sweep — {project_name}

| Lens | Health | Notes |
|------|--------|-------|
| Structural Organization | :green_circle: | ... |
| Design Patterns | :yellow_circle: | ... |
| ... | ... | ... |

**Flagged for deep dive:** Design Patterns, Coupling & Cohesion
**Files sampled:** N

Run `/architect` (without --sweep) to continue with deep analysis.
```

If `--sweep` was NOT passed, proceed to Phase 3.

---

## Phase 3: Deep Dive — Parallel Lens Analysis

For each lens flagged yellow or red in the sweep, dispatch a dedicated Sonnet
subagent for detailed analysis. All flagged lenses run **in parallel**.

### Step 1: Identify Flagged Lenses

From the sweep results, collect every lens where `health` is `"yellow"` or
`"red"`. If **all lenses are green**, skip Phase 3 entirely — proceed to
Phase 4 with the sweep summary only. Tell the user:

> "All 7 lenses came back green. No deep dives needed — proceeding to
> assessment with the sweep results."

### Step 2: Dispatch Deep Dive Agents

Dispatch ALL flagged lens agents in a single message (parallel execution).
One `Agent(model: "sonnet")` per flagged lens.

For each flagged lens, build the prompt from the lens criteria below and the
sweep data for that lens.

```
Agent(model: "sonnet", description: "Deep dive: {lens_name} analysis of {SLUG}")
```

Each deep dive agent gets a **fully self-contained** prompt:

````
You are an architectural analyst performing a deep dive on a specific
structural dimension of a codebase. A broad sweep has already identified
this area as needing investigation. Your job is to produce detailed,
actionable findings.

## Project

- **Root:** {ROOT}
- **Framework:** {FRAMEWORK}
- **Philosophy:** {PHILOSOPHY}
- **Full config:** {CONFIG}

## Your Lens: {LENS_DISPLAY_NAME}

### What the sweep found

- **Health:** {sweep_health}
- **Notes:** {sweep_notes}
- **Key files to start with:** {sweep_file_pointers}

### What to look for

{lens_criteria}

## Analysis Instructions

1. Start with the file_pointers from the sweep — these are your leads
2. Follow the dependency graph outward — what do these files import? What
   imports them?
3. Read the actual code, not just directory listings. You need to see
   implementations to judge quality.
4. Compare against the project's stated philosophy: {PHILOSOPHY}
5. Check for patterns — one instance isn't a finding, repeated instances are

## Output Format

Return your findings as a structured list. Each finding MUST follow this
exact format:

```
Finding: <concise title>
Severity: Low | Medium | High | Critical
Location: <file path(s) — be specific>
What: <description of what you found>
Why it matters: <impact on maintainability, scalability, or developer experience>
Recommendation: <specific, actionable suggestion — not vague advice>
```

Severity definitions:
- **Critical** — actively causing problems now, blocking team velocity, or
  creating risk of bugs/outages. Fix soon.
- **High** — significant structural issue that will compound over time.
  Should be planned.
- **Medium** — real issue but manageable. Worth addressing when touching
  the area.
- **Low** — minor improvement. Address opportunistically.

Be specific. "Consider refactoring" is not a recommendation. "Extract the
fee calculation from MemberPayment into a FeeCalculator service — it's
duplicated in 3 models" is.

If the sweep flagged this lens but your deep analysis finds it's actually
fine, say so. Return an empty findings list with a note explaining why
the flag was a false alarm.

Return ONLY the findings in the format above, no surrounding text. If there
are no findings, return: "No findings — sweep flag was a false positive."
````

#### Lens Criteria Reference

Use the appropriate criteria block for each lens:

**Structural Organization:**
```
- Directory layout: is it by layer (models/, views/, controllers/) or by
  feature (payments/, members/, dispatch/)? Is it consistent?
- File grouping: are related files co-located or scattered?
- Naming: do file names follow a consistent convention? Do they match
  their contents?
- Separation of concerns: is presentation logic in models? Business logic
  in controllers? Framework plumbing in domain code?
- Dead directories: folders with stale or unused code
```

**Design Patterns:**
```
- Identify all GoF patterns in use: adapter, strategy, facade, observer,
  factory, decorator, command, etc.
- For each: is it applied correctly? Does it reduce complexity or add it?
- Look for missing patterns: places where a Strategy would eliminate a
  case statement, where an Adapter would decouple a dependency, where a
  Facade would simplify a complex subsystem
- Look for over-patterning: unnecessary indirection, AbstractFactoryFactory
  syndrome, patterns that add layers without adding value
```

**Composition & Inheritance:**
```
- Map inheritance hierarchies. Flag any deeper than 3 levels.
- Check for "inheritance for code sharing" — should these be modules/mixins/
  composables instead?
- Count mixins/concerns per class. Flag classes with 5+ includes/extends.
- Look for fragmented behavior — where understanding a class requires reading
  8 different concern files
- Check for composition patterns: dependency injection, strategy objects,
  decorator chains
```

**Coupling & Cohesion:**
```
- Map module dependencies — which modules/classes reference each other?
- Look for circular dependencies between modules
- Identify god objects: classes with 10+ public methods, 300+ lines, or
  that are imported everywhere
- Check boundary clarity: could you extract a module into a gem/package
  without touching 20 other files?
- Look for feature envy: methods that use more of another class's data
  than their own
- Check for law of demeter violations: long method chains (a.b.c.d)
```

**Framework Alignment:**
```
- Check convention adherence for the specific framework
- Rails: callbacks doing business logic? N+1 queries? SQL in views?
  skip_before_action sprawl? Models as god objects?
- Vue/Nuxt: mutating props? Giant computed properties? Business logic in
  components instead of composables? v-if/v-for on same element?
- General: are framework-provided solutions being used, or is the team
  building custom versions of built-in features?
- Are there framework anti-patterns that the community has identified?
```

**API & Interface Design:**
```
- Check internal API consistency: do similar operations have similar
  method signatures?
- Look at method arity: methods with 4+ positional parameters are a flag
- Check for boolean parameters that should be separate methods or enums
- Public surface area: are classes exposing methods that should be private?
- Look for inconsistent return types: same kind of method returning
  different shapes in different classes
- Check service object interfaces: do they follow a consistent pattern
  (call/execute/perform)?
```

**Duplication & Reuse:**
```
- Search for copy-paste code: similar logic in multiple files
- Check for inconsistent approaches: the same problem (e.g., date formatting,
  error handling, validation) solved differently in different places
- Identify extraction candidates: code that appears 3+ times and should be
  a shared utility/concern/composable
- Check for "almost the same" code: slight variations that could be unified
  with a parameter
```

### Step 3: Collect Results

Wait for all deep dive agents to complete. For each:

- **Success:** Parse the findings from the response
- **Failure:** Note the lens as incomplete:
  `"Deep analysis incomplete for {lens_name} — re-run to retry."`

Do NOT fail the entire skill if one agent fails. Proceed with partial results.
The user can re-run to retry failed lenses.

### Step 4: Combine Results

Build a combined findings object that includes:

- The sweep summary (all 7 lenses with health ratings)
- Detailed findings from each deep dive
- Any incomplete lenses noted

Store this combined result for Phase 4 to use. This is in-memory — Phase 4
will format it into the assessment artifact.

---

## Phase 4: Assess — Present Findings & Generate Artifact

This phase runs in the **main conversation** (NOT a subagent) because it
requires back-and-forth discussion with the user. The deep dive results feed
in; the assessment artifact comes out.

### Step 1: Merge Deep Dive Results

Combine findings from all deep dive agents into a unified view, organized by
lens. Include green-rated lenses from the sweep (they have no findings, but
their health rating appears in the summary table).

### Step 2: Check for Existing Assessment

```bash
CONFIG=$("$ARCHITECT" config "$SLUG")
ARTIFACT_PATH=$(echo "$CONFIG" | jq -r '.artifact_path')
```

Check whether `$ROOT/$ARTIFACT_PATH` already exists. If it does, this is a
**re-run**:

1. Read the existing artifact
2. Preserve the **Action Plan** section verbatim (this is user-authored content)
3. Load the previous sweep for diffing:
   ```bash
   LAST_SWEEP=$("$ARCHITECT" last-sweep "$SLUG")
   ```
4. Diff current findings against the last sweep:
   - **New findings** — present in current results but not in last sweep
   - **Resolved findings** — present in last sweep but not in current results;
     mark with `[RESOLVED]` in the artifact (append to the finding title)
   - **Unchanged findings** — present in both; leave as-is
5. Present the delta to the user before the full summary:
   > "This is a re-run. Since the last assessment: **N new findings**, **N
   > resolved**, **N unchanged**."

If no existing artifact, proceed as a fresh assessment.

### Step 3: Present Findings

Present findings to the user, starting with the executive summary:

1. **Overall health assessment** — one-sentence verdict
2. **Biggest strengths** — what's working well (cite specific lenses/patterns)
3. **Biggest concerns** — what needs attention (cite specific findings)
4. **Finding counts** — total findings by severity (Critical: N, High: N,
   Medium: N, Low: N)
5. **Lens health table:**

```
| Lens | Health |
|------|--------|
| Structural Organization | Good / Needs Attention / Significant Concerns |
| Design Patterns | ... |
| Composition & Inheritance | ... |
| Coupling & Cohesion | ... |
| Framework Alignment | ... |
| API & Interface Design | ... |
| Duplication & Reuse | ... |
```

Health mapping from sweep ratings:
- `green` → **Good**
- `yellow` → **Needs Attention**
- `red` → **Significant Concerns**

Then present the detailed findings grouped by lens — each finding with its
severity, location, description, impact, and recommendation.

### Step 4: Discuss

**Pause for user input** after presenting findings. Do NOT proceed to
recommendations until the user has had a chance to:

- Ask questions about specific findings
- Challenge findings they disagree with
- Add context you may have missed
- Reprioritize based on business reality

This is a conversation, not a dump. Wait for the user to signal they're
satisfied with the findings before moving on.

### Step 5: Build Prioritized Recommendations

After discussion, group all recommendations into three tiers:

- **Quick wins** — hours of work, low risk, high clarity improvement. These
  should be things someone could pick up and do this week.
- **Medium efforts** — days to a week of work, moderate restructuring. May
  require coordination or affect multiple files/modules.
- **Strategic restructuring** — weeks to months, phased approach needed. These
  are bigger architectural shifts that need a plan.

Order within each tier by impact (highest first).

### Step 6: Generate the Assessment Artifact

Build the artifact using the template below. Write it to `$ROOT/$ARTIFACT_PATH`.

#### Assessment Artifact Template

```markdown
# Architecture Assessment — <Project Name>
Generated: YYYY-MM-DD | Framework: Rails 8.x / Nuxt 4.x / etc.

## Summary
2-3 paragraph executive overview. Overall health, biggest strengths,
biggest concerns.

## Findings by Lens

### <Lens Name>
**Health: Good / Needs Attention / Significant Concerns**

#### Finding: <title>
- **Severity:** Low / Medium / High / Critical
- **Location:** app/services/, app/models/
- **What:** Description of what was found
- **Why it matters:** Impact on maintainability, velocity, correctness
- **Recommendation:** What to do about it

(repeat per finding, per lens)

## Prioritized Recommendations
Ordered list grouped into:
- **Quick wins** — hours, low risk, high clarity improvement
- **Medium efforts** — days to a week, moderate restructuring
- **Strategic restructuring** — weeks to months, phased approach needed

## Action Plan
Empty until the user decides what to act on. Populated during Phase 5
with phased implementation strategies. Updated as phases complete.
```

**Notes on the template:**
- Populate `<Project Name>`, date, and framework from the config
- Fill `Summary` from the executive summary presented in Step 3
- Fill `Findings by Lens` from the merged deep dive results
- Fill `Prioritized Recommendations` from Step 5
- Leave `Action Plan` empty on first run; preserve it on re-runs
- Resolved findings are marked by appending `[RESOLVED]` to the finding
  title, e.g., `#### Finding: God object in User model [RESOLVED]`
- Include ALL lenses (even green ones) — green lenses get a Health line
  but no findings beneath them

### Step 7: Commit the Artifact

```bash
cd "$ROOT"
git add "$ARTIFACT_PATH"
git commit -m "docs: architecture assessment — $(date +%Y-%m-%d)"
git push
```

Tell the user where the artifact was committed.

### Step 8: Update State

Parse the committed artifact and update project state:

```bash
PARSED=$("$ARCHITECT" parse-artifact "$SLUG")
FINDINGS_TOTAL=$(echo "$PARSED" | jq -r '.findings_total')
FINDINGS_RESOLVED=$(echo "$PARSED" | jq -r '.findings_resolved')
PLAN_PHASES=$(echo "$PARSED" | jq -r '.action_plan_phases')
PLAN_COMPLETED=$(echo "$PARSED" | jq -r '.action_plan_completed')

"$ARCHITECT" update-state "$SLUG" \
  last_full_run="$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  findings_total="$FINDINGS_TOTAL" \
  findings_resolved="$FINDINGS_RESOLVED" \
  action_plan_phases="$PLAN_PHASES" \
  action_plan_completed="$PLAN_COMPLETED"
```

---

## Phase 5: Plan — Phased Implementation Strategies

This phase is **conversational** (main conversation, not a subagent). It runs
on demand — when the user decides to act on findings, either during the assess
conversation or in a later session.

### Step 1: Load the Assessment

```bash
CONFIG=$("$ARCHITECT" config "$SLUG")
ARTIFACT_PATH=$(echo "$CONFIG" | jq -r '.artifact_path')
```

Read the existing assessment artifact at `$ROOT/$ARTIFACT_PATH`. If it doesn't
exist, tell the user: "No assessment found. Run `/architect` first to generate
one." and stop.

### Step 2: Ask What to Tackle

Present the current findings and prioritized recommendations to the user, then
ask which they want to act on:

> "Here are your current findings and recommendations. Which ones do you want
> to plan for? You can pick individual findings, a recommendation tier (e.g.,
> 'all quick wins'), or a combination."

Wait for the user's answer.

### Step 3: Scope Each Choice

For each chosen item, discuss:

- **Scope of the change** — what files, modules, or layers are affected?
- **Risk level** — is this a safe rename/extraction, or does it change behavior?
  Could it break tests? Does it affect public APIs?
- **Dependencies on other changes** — does this need to happen before or after
  another planned change?
- **Estimated effort** — hours, days, or weeks? Factor in test updates.

This is conversational — work through each item with the user. Don't dump a
plan and move on. The user may reprioritize, defer items, or combine related
changes as the discussion unfolds.

### Step 4: Build the Action Plan

Once the user is satisfied with the scoping, build a phased plan in the
`## Action Plan` section of the artifact. Each phase groups related changes
that can be done together:

```markdown
## Action Plan

### Phase 1: <title> [NOT STARTED]
**Target findings:** Finding X, Finding Y
**Scope:** <description of what changes and where>
**Risk:** Low / Medium / High
**Estimated effort:** <timeframe>
**Dependencies:** None / Phase N must complete first

### Phase 2: <title> [NOT STARTED]
**Target findings:** Finding Z
**Scope:** <description>
**Risk:** <level>
**Estimated effort:** <timeframe>
**Dependencies:** <if any>
```

**Phase statuses:**
- `[NOT STARTED]` — planned but not yet begun
- `[IN PROGRESS]` — work has started (set when Phase 6 kicks off)
- `[COMPLETE]` — execution finished and verified

**Ordering:** Put quick wins and low-risk phases first. Strategic restructuring
goes last. Respect dependency ordering — if Phase 3 depends on Phase 1, Phase 1
must come first.

### Step 5: Commit the Updated Artifact

```bash
cd "$ROOT"
git add "$ARTIFACT_PATH"
git commit -m "docs: architecture action plan — $(date +%Y-%m-%d)"
git push
```

Tell the user: "Action plan committed. Run individual phases with
`/architect` and tell me which phase to execute."

### Step 6: Update State

Parse the committed artifact and update project state:

```bash
PARSED=$("$ARCHITECT" parse-artifact "$SLUG")
FINDINGS_TOTAL=$(echo "$PARSED" | jq -r '.findings_total')
FINDINGS_RESOLVED=$(echo "$PARSED" | jq -r '.findings_resolved')
PLAN_PHASES=$(echo "$PARSED" | jq -r '.action_plan_phases')
PLAN_COMPLETED=$(echo "$PARSED" | jq -r '.action_plan_completed')

"$ARCHITECT" update-state "$SLUG" \
  action_plan_phases="$PLAN_PHASES" \
  action_plan_completed="$PLAN_COMPLETED" \
  findings_total="$FINDINGS_TOTAL" \
  findings_resolved="$FINDINGS_RESOLVED"
```

---

## Phase 6: Execute — Invoke Writing Plans for Restructuring

This phase runs on demand — the user explicitly triggers it by saying something
like "let's tackle Phase 1" or "execute the quick wins." It is never automatic.

### Step 1: Identify the Target Phase

Read the assessment artifact. Find the phase the user referenced. If the phase
status is `[COMPLETE]`, tell the user it's already done and ask if they want to
re-run it.

Mark the target phase as `[IN PROGRESS]` in the artifact.

### Step 2: Gather Context

From the artifact, collect:

- The phase title and scope description
- The target findings it addresses (full finding details: location, what,
  why it matters, recommendation)
- Any dependencies — confirm predecessor phases are `[COMPLETE]`

If a dependency is not complete, warn the user:

> "Phase N depends on Phase M, which is still [NOT STARTED]. Do you want to
> proceed anyway, or tackle Phase M first?"

Wait for confirmation.

### Step 3: Invoke Writing Plans

Invoke the `superpowers:writing-plans` skill to create a detailed
implementation plan for the phase:

```
/superpowers:writing-plans
```

Provide the skill with:

- **Goal:** The phase title and scope from the action plan
- **Context:** The full finding details (location, what, why, recommendation)
  for every finding this phase targets
- **Project root:** `$ROOT`
- **Framework and philosophy:** From the architect config

The writing-plans skill handles the rest — task breakdown, TDD, execution.

### Step 4: Update the Artifact After Execution

Once execution completes:

1. Mark the phase as `[COMPLETE]` in the Action Plan:
   ```markdown
   ### Phase 1: <title> [COMPLETE]
   ```

2. Mark each resolved finding with `[RESOLVED]` appended to its title:
   ```markdown
   #### Finding: God object in User model [RESOLVED]
   ```
   Only mark findings as resolved if the execution actually addressed them.
   If a finding was partially addressed, leave it unmarked and add a note.

3. Commit the updated artifact:
   ```bash
   cd "$ROOT"
   git add "$ARTIFACT_PATH"
   git commit -m "docs: architecture phase complete — <phase title>"
   git push
   ```

### Step 5: Update State

```bash
PARSED=$("$ARCHITECT" parse-artifact "$SLUG")
FINDINGS_TOTAL=$(echo "$PARSED" | jq -r '.findings_total')
FINDINGS_RESOLVED=$(echo "$PARSED" | jq -r '.findings_resolved')
PLAN_PHASES=$(echo "$PARSED" | jq -r '.action_plan_phases')
PLAN_COMPLETED=$(echo "$PARSED" | jq -r '.action_plan_completed')

"$ARCHITECT" update-state "$SLUG" \
  action_plan_phases="$PLAN_PHASES" \
  action_plan_completed="$PLAN_COMPLETED" \
  findings_total="$FINDINGS_TOTAL" \
  findings_resolved="$FINDINGS_RESOLVED"
```

Tell the user what was completed and what remains:

> "Phase 1 complete. N findings resolved. M phases remaining in the action plan."

---

## Targeted Invocation — `/architect <target>`

When the user invokes `/architect` with a target (e.g., `/architect app/models`
or `/architect the dispatch system`), the run is scoped to that subsystem.

### How Scoping Works

The target handling is built into the existing phases:

1. **Teach** — Runs normally if needed (values apply to the whole project)
2. **Sweep (Phase 2, Step 2)** — Scope detection already handles targets:
   - Path targets (`app/models`, `src/features/dispatch`) scope the scan to
     that directory tree
   - Concept targets ("the dispatch system") instruct the sweep agent to
     identify relevant files first, then scope
3. **Deep Dive (Phase 3)** — Agents receive the scoped file pointers from
   the sweep, so they naturally focus on the target area
4. **Assess (Phase 4)** — Findings are generated only for the target scope

### Merging into the Main Artifact

The key difference with targeted runs is how results merge into the assessment
artifact:

**If an assessment artifact already exists:**

1. Read the existing artifact
2. For each lens, merge new findings with existing ones:
   - **New findings** from the target scope — append to the appropriate lens
     section. Prefix the finding title with the scope for clarity, e.g.,
     `#### Finding: God object in User model (app/models)`
   - **Existing findings outside the target scope** — preserve unchanged
   - **Existing findings inside the target scope** — replace with new results
     (the fresh analysis supersedes the old one for this area)
3. Re-run the prioritization: integrate new findings into the existing
   recommendation tiers
4. Preserve the Action Plan section verbatim — targeted runs don't modify
   existing plans

**If no assessment artifact exists:**

Create a new one using the standard template. Note in the Summary that this
assessment covers only the targeted area:

```markdown
## Summary
This assessment covers **<target description>** only, not the full codebase.
Run `/architect` without a target for a complete assessment.
```

### Artifact Commit

Same as Phase 4, Step 7:

```bash
cd "$ROOT"
git add "$ARTIFACT_PATH"
git commit -m "docs: architecture assessment — <target> — $(date +%Y-%m-%d)"
git push
```

### State Update

Same as Phase 4, Step 8 — parse the artifact and update state. The state
tracks the aggregate across all runs (full and targeted).
