# JavaScript / TypeScript Tooling

## knip — dead code detection

Run it with `npx --yes` — no install required, no changes to the project's `package.json`:

```bash
npx --yes knip
npx --yes knip --include files,exports,dependencies,binaries
npx --yes knip --reporter json  # machine-readable
```

`--yes` auto-accepts the npx download prompt so it runs non-interactively. First run populates the npm cache; subsequent runs are near-instant. **Do not** `npm install --save-dev knip` for a deslop run — this is a one-off deep-clean, not a permanent project dep.

Config lives in `knip.json`, `knip.jsonc`, or the `knip` key in `package.json`.

**Common pitfalls:**

- Knip respects `.gitignore` but can miss dynamic imports like `import(\`./${mod}\`)`
- Symbols referenced only in config files (webpack, vite, etc.) may be flagged falsely
- Test fixtures in `__tests__/` are often flagged — verify before removing

**Before removing a knip-flagged export**, cross-check with ripgrep:

```bash
rg --type ts --type tsx --type js --type jsx "exportName"
```

If ripgrep finds nothing outside the declaration, it's safer to remove.

## madge — circular dependency detection

Run with `npx --yes` — no install needed:

```bash
npx --yes madge --circular src/
npx --yes madge --circular --extensions ts,tsx src/
npx --yes madge --circular --json src/  # machine-readable
```

For each cycle, madge prints the import chain. To break a cycle:

1. Identify the "weaker" dependency (the one more likely to be a leaky abstraction)
2. Extract shared types/interfaces to a third module that both sides import
3. Or invert control — pass the dependency in instead of importing it

## ts-prune — unused exports

Alternative to knip for export-only analysis:

```bash
npx --yes ts-prune
```

Less comprehensive than knip but faster for a quick scan.

## TypeScript type checking

After any type-related pass (2, 5), run:

```bash
npx tsc --noEmit
```

Or if the project has a dedicated type-check script:

```bash
npm run typecheck
```

## ESLint

Most projects have ESLint rules that catch slop patterns. If the project uses
ESLint, run it after each pass to catch regressions:

```bash
npx eslint . --fix  # DO NOT use --fix in an auto-apply pass; use manually after
```

Never run `--fix` as part of the deslop flow — its changes are out of scope
for whatever pass you're on and will muddy commits.
