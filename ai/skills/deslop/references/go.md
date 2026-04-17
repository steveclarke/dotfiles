# Go Tooling

## staticcheck — dead code and more

Install:

```bash
go install honnef.co/go/tools/cmd/staticcheck@latest
```

Run for dead code only (U1000 check):

```bash
staticcheck -checks U1000 ./...
```

Run full analysis:

```bash
staticcheck ./...
```

Relevant checks for deslop:

- **U1000** — unused variables/functions/types (pass 3)
- **SA4006** — assigned but never used (pass 3)
- **ST1020-1023** — comment style issues (pass 8-adjacent)

## deadcode — reachability analysis

Go 1.22+ ships with a `deadcode` tool under `x/tools`:

```bash
go install golang.org/x/tools/cmd/deadcode@latest
deadcode ./...
```

This does whole-program reachability analysis from `main`, so it's more
precise than staticcheck's package-local U1000 check. Prefer it for pass 3 on
Go code when available.

## go mod graph — dependency graph

Circular **package** dependencies are impossible in Go — the compiler
refuses. For pass 4 on Go code, shift focus to:

- **Import bloat:** packages transitively pulling in large trees
- **Coupling:** packages that import too many internal packages

```bash
go mod graph | less
go list -f '{{.ImportPath}}: {{.Imports}}' ./...
```

Tools that can help:

- `goda` (https://github.com/loov/goda) for richer dependency analysis
- `go-callvis` for a visual call graph

If no coupling issues stand out, report "no circular deps possible in Go
(compiler-enforced); no notable import bloat detected" and move on.

## go vet + custom vet checks

Run vet as a sanity check after each pass:

```bash
go vet ./...
```

Rarely flags slop patterns directly but will catch structural problems
introduced by an over-aggressive pass.

## Type system (for pass 2 / pass 5)

Go's type system is unusually strict, so `any` (Go 1.18+) and `interface{}`
are the main targets.

**Idiomatic uses of `any`** — leave these alone:

- JSON unmarshaling to unknown shape
- Reflection-based code
- Generic container slots (though generics are now preferred)
- Function parameters that truly accept many types

**Slop uses of `any`** — fix these:

- `any` in a function signature where callers always pass one concrete type
- `map[string]any` where a struct would do
- Type assertions on `any` that then flow into type-specific code

Cross-check with ripgrep before flagging — `any` is a common word in Go code
comments and string literals.

```bash
rg -w "interface\{\}" --type go
rg -w " any " --type go
```

## Go-specific AI slop comments

Common patterns to remove in pass 8:

- `// Function to handle X` — Go conventions already require comments to start
  with the function name, so this is often auto-generated slop
- `// TODO(name): implement` on already-implemented functions
- Overly verbose godoc comments on internal helpers

**Keep** comments that:

- Start with the identifier name (Go convention, enforced by `revive`)
- Explain exported API semantics
- Document non-obvious concurrency or ordering constraints
