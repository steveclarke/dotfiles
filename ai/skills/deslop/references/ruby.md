# Ruby / Rails Tooling

## debride — dead method detection

Install:

```bash
gem install debride
# or add to Gemfile: gem 'debride', group: :development
```

Run:

```bash
debride app/ lib/
debride --rails app/
```

`--rails` is important on Rails projects — it accounts for common framework
patterns (controller actions, callbacks) and reduces false positives.

**False positive traps in Rails:**

- **Controller actions referenced only in `routes.rb`** — debride may not see
  them as called
- **Model callbacks** (`before_save :my_callback`) — invoked by ActiveRecord,
  may appear unused
- **Methods called via `send`, `public_send`, `method_missing`** — debride
  can't resolve these
- **View helpers** — referenced via naming convention in templates
- **Jobs / mailers** — invoked via `SomeJob.perform_later`, may look unused
- **Methods used in tests only** — debride by default may or may not scan
  tests depending on config

**Always cross-check with ripgrep before removing:**

```bash
rg "method_name"
rg -F "method_name"  # for names with regex chars
```

If ripgrep finds only the definition, it's safer to remove. Still prefer
**needs-review** over **high-confidence** for any public method.

## packwerk — package boundary enforcement

If the project uses packwerk, it already enforces boundaries. Run:

```bash
bin/packwerk check
```

Violations in `packwerk_todo.yml` files are known issues. Treat the current
violations as the baseline — don't try to fix all of them in this pass.

For circular dependency detection specifically, packwerk's `package.yml`
declarations are the source of truth for which packages may depend on which.

If packwerk isn't set up, skip the circular-dependency pass entirely for Ruby
code and report "no boundary tooling configured". Don't try to do it manually —
Rails autoloading makes manual analysis unreliable.

## Sorbet — type system

If the project uses Sorbet (`sorbet/config` exists):

```bash
bundle exec srb tc
```

Targets for pass 5 (weak types):

- `T.untyped` in method signatures
- `T.unsafe(...)` calls
- Missing `sig` on public methods
- Overly broad types (`T.any(String, Integer)` where one is actually never used)

If the project does NOT use Sorbet, skip passes 2 and 5 for Ruby code and
report "no type system in use".

## Rubocop

Most Rails projects have Rubocop configured. Rules to be aware of:

- `Lint/UnusedMethodArgument` — catches unused params (pass 3-adjacent)
- `Lint/RescueException` — catches overly broad rescues (pass 6-adjacent)
- `Style/Documentation` — can conflict with pass 8 (AI slop comments) if the
  rule requires comments on all classes

**Do not run `rubocop -a` or `-A`** during the deslop flow. Rubocop's
auto-corrects will muddy the per-pass commits.

## Rails-specific slop patterns

### Common AI slop in Rails code

- **Boilerplate callback comments:** `# before_save callback to validate user`
  above `before_save :validate_user`
- **Meaningless rescues:** `rescue => e; Rails.logger.error(e); nil` — silent
  failure, remove in pass 6
- **Redundant strong params:** `params.require(:foo).permit(:bar)` duplicated
  across controllers — candidate for pass 1 (DRY)
- **Legacy column fallbacks:** `user.new_field || user.old_field` after
  migration — pass 7

### Rails deprecations to respect

- Before removing any method with `@deprecated` / `ActiveSupport::Deprecation`,
  check the app's Rails version — the "deprecated" path may still be the only
  path in the current version.
