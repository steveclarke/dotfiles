# Per-Pass Instructions

Fill in `{pass_instructions}` in the research subagent prompt with the
corresponding section below. Each pass is language-aware — use the subsection
that matches the detected stack.

---

## Pass 1 — DRY / Dedupe

Find code that is duplicated or near-duplicated across files **and where
consolidation would reduce complexity**. Not every duplication is a problem —
two small functions that happen to look alike are fine; five copy-paste copies
of the same 40-line block are not.

Look for:

- Functions/methods with identical or near-identical bodies
- Repeated inline logic (the same 3-5 line sequence in many places)
- Constants or magic values defined in multiple places
- Similar utilities that should live in a shared helper

Do NOT flag:

- Shared patterns that are coincidentally similar but semantically distinct
- Framework boilerplate (route definitions, controller actions, migration files)
- Tests — duplication is often deliberate in tests for clarity

High-confidence: three or more literal copies of the same block, all in the
same layer (e.g. three controllers using the same param filter). Safe to
extract to a helper.

Needs-review: two copies that look similar but might diverge for a reason;
anything where consolidation changes a public API.

---

## Pass 2 — Consolidate Shared Types

### TypeScript/JavaScript

Find type definitions that represent the same shape defined in multiple places.
Candidates: `interface User` defined in three files with identical fields;
`type Status` as a union of string literals repeated inline.

Tools: ripgrep for common type names, `tsc --noEmit` to confirm no type errors
after consolidation.

### Ruby/Rails (Sorbet)

If the project uses Sorbet, look for duplicated `T.type_alias` definitions and
RBI shapes that should live in a shared file.

If the project does not use Sorbet, this pass largely doesn't apply — skip and
report "no type system in use".

### Go

Look for duplicated struct definitions with the same fields. Also interfaces
declared in multiple packages that should live in a shared location (but note
Go's preference for consumer-defined interfaces — don't over-consolidate).

High-confidence: literally identical type definitions in the same package.

Needs-review: similar-but-not-identical types across packages — may be
intentionally distinct.

---

## Pass 3 — Dead Code Removal

### TypeScript/JavaScript

Primary tool: `knip` (https://knip.dev). If not installed, skip and report.

```bash
npx knip --no-gitignore --include files,exports,dependencies
```

Cross-check each flagged item against the whole codebase with ripgrep before
removing. `knip` can miss dynamic imports, string-based module references, and
code referenced only by config files.

Also check: `ts-prune` for an alternative view on unused exports.

### Ruby/Rails

Primary tool: `debride` (https://github.com/seattlerb/debride). If not
installed, skip.

```bash
bundle exec debride app/ lib/
```

Rails has many framework callbacks and metaprogramming patterns that `debride`
will mis-flag. Be especially cautious with:

- Methods called via `send`, `public_send`, or `method_missing`
- Model callbacks (`before_save`, etc.) that appear "unused" but are invoked
  by ActiveRecord
- Controller actions referenced only in `routes.rb`
- Views referenced by naming convention only

Cross-check every debride finding with ripgrep across the whole repo before
flagging as high-confidence.

### Go

Primary tool: `staticcheck -unused` or `deadcode`.

```bash
staticcheck -checks U1000 ./...
# or
deadcode ./...
```

Go is generally good at flagging unused identifiers at compile time — the
compiler already enforces this for package-local variables. Focus on unused
exported identifiers (rarer, harder to detect) and unused files.

Unused exported symbols are always needs-review — they may be part of a
published API.

### High-confidence vs needs-review

High-confidence:
- Symbols with zero references in the codebase AND no dynamic/reflective
  invocation patterns AND not part of a public API
- Files that only export symbols nobody imports

Needs-review:
- Any exported symbol in a library package
- Anything in a test file (may be a fixture or helper used via autoloading)
- Anything that might be called via metaprogramming

---

## Pass 4 — Circular Dependencies

### TypeScript/JavaScript

Primary tool: `madge`.

```bash
npx madge --circular --extensions ts,tsx,js,jsx src/
```

For each cycle, propose a break strategy: move shared types to a third module,
invert a dependency, or extract a common abstraction.

### Ruby/Rails

Primary tool: `packwerk` if the project uses it. Otherwise, look for circular
`require` patterns by inspecting require statements across files. Rails
autoloading hides most import issues so circular deps are less common here.

If the project doesn't use packwerk, report "no boundary tooling configured"
and suggest the user set it up, rather than running a manual analysis.

### Go

```bash
go mod graph
# or
go list -f '{{.ImportPath}}: {{.Imports}}' ./...
```

Go's compiler refuses to build on circular imports, so true cycles are
impossible at the package level. Instead, look for import-chain bloat —
packages that transitively pull in large trees for small uses.

### High-confidence vs needs-review

Every circular dependency fix is **needs-review**. Breaking a cycle means
moving code between modules — a structural change that deserves human eyes.

---

## Pass 5 — Remove Weak Types

### TypeScript

Target: `any`, `unknown` without narrowing, `Function`, `object`, `{}`,
`@ts-ignore`, `@ts-expect-error`, unnecessary type assertions (`as any`, `as
unknown`).

For each occurrence:

1. Read the surrounding code
2. Follow the data flow to infer the actual type
3. Check if a proper type already exists in the project
4. Propose a strong replacement

Special cases:

- `unknown` at API boundaries (user input, external data) is often correct —
  flag these as needs-review
- `any` in test mocks is often fine — low priority
- Third-party library `any` (no types published) — try `@types/*` or declare
  ambient types

### JavaScript (no TypeScript)

This pass doesn't apply. Skip and report "no type system".

### Ruby (Sorbet)

Target: `T.untyped`, `T.unsafe`, missing sigs on public methods.

If no Sorbet, skip and report.

### Go

Target: `interface{}` / `any` used in places where a concrete type would work.

Be careful: `interface{}` is idiomatic for truly dynamic cases (JSON decoding
to unknown shape, reflection). Only flag where a concrete type is obviously
correct.

### High-confidence vs needs-review

High-confidence: the actual type is obvious from usage (e.g. `any` used only
where the value is then treated as a `string`).

Needs-review: boundaries, mocks, cases where narrowing requires runtime checks.

---

## Pass 6 — Remove Defensive try/catch

### All languages

Target: try/catch (or `begin/rescue`, or Go's `if err != nil` pattern) that
exists without a real purpose — swallowing errors, logging and continuing,
returning a default, or "just in case."

Keep:

- Error handlers at system boundaries (user input, external APIs, file I/O)
- Error handlers with specific, documented recovery behavior
- Error handlers that translate exceptions to domain-meaningful errors

Remove:

- `try { x } catch (e) {}` — silently swallowing
- `try { x } catch (e) { console.error(e); return null }` — hiding errors
- `begin; x; rescue => e; end` — same pattern in Ruby
- `if err != nil { return nil }` — Go code that drops errors without wrapping

For Ruby specifically: `rescue StandardError` or bare `rescue` without a
specific exception class is almost always wrong.

For Go: `if err != nil { return err }` is fine (pass-through). What to flag is
code that logs and returns nil, or returns a zero value, hiding the problem.

### High-confidence vs needs-review

High-confidence: empty catch blocks, catches that only log and continue,
catches that swallow and return a falsy default.

Needs-review: catches that do anything else, including retry logic, fallback
values, and error translation.

---

## Pass 7 — Legacy / Deprecated / Fallback Code

Target: code paths marked deprecated, fallback branches for removed features,
backwards-compatibility shims, TODO/XXX/HACK comments referencing removed
concerns, commented-out code.

Look for:

- `@deprecated` JSDoc tags with no migration path left
- `if (process.env.OLD_FLAG)` branches for flags that are no longer set anywhere
- `if (user.legacy_column)` checks for columns that have been removed
- Methods named `*_old`, `*_deprecated`, `*_legacy`, `*_v1`
- Feature flags that have been fully rolled out (check rollout status if available)
- Commented-out blocks (dead, not AI-slop — those go to pass 8)

Before removing:

- Verify the "new" code path is actually in use everywhere (the deprecated path
  might still be the only path for some caller)
- Check for feature flag dashboards / config before declaring a flag dead
- For database columns, verify no code references them before dropping — though
  don't drop the column itself in this pass (schema changes are out of scope)

### High-confidence vs needs-review

High-confidence: commented-out code; branches tied to flags that have zero
references anywhere; `*_old` methods with zero callers.

Needs-review: feature flag removals, any deprecation where the new path isn't
obviously universal.

---

## Pass 8 — AI Slop Comments

This is the most distinctive pass. AI-generated code is littered with comments
that add no value and actively reduce readability.

### Remove

- **In-motion commentary:** "// Now we check if..." "// First, we iterate..."
  "// Next, we return..." — narrating what the code does line-by-line
- **Replacement commentary:** "// Replaced the old fetchUser with this new
  version" "// Updated to handle the new API" — meaningful only during the
  change, useless afterward
- **Stubs and larp:** "// TODO: implement" on a function that IS implemented;
  "// Placeholder" on real code; "// Example" on production code
- **Obvious-code comments:** "// Set user name" above `user.name = name`;
  "// Return result" above `return result`
- **Self-praise:** "// This is a robust implementation" "// Carefully handle
  all edge cases"
- **Version commentary:** "// Updated in PR #123" "// Changed from v1 to v2"
- **Phantom citations:** "// Based on the spec" without reference to what spec

### Keep

- Comments explaining **why** (hidden constraints, workarounds, bug refs)
- Comments explaining **surprising behavior** (timing-dependent, order-sensitive)
- Comments linking to issues, PRs, or external references that are still live
- Docstrings on public APIs (but audit for slop even here — many are also bad)

### High-confidence vs needs-review

High-confidence: all the "remove" categories above when the comment adds zero
information a reader couldn't get from the code.

Needs-review: any comment that might be explaining a subtle reason — better to
preserve unclear comments than destroy load-bearing ones.

### Special handling

Do NOT remove comments in:

- Generated code (autoload banners, codegen markers)
- Third-party vendored code
- Migration files
- License headers
