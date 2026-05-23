---
name: rails-upgrade-assistant
description: Analyzes Rails applications and generates comprehensive upgrade reports with breaking changes, deprecations, and step-by-step migration guides for Rails 7.0 through 8.1.1. Use when upgrading Rails applications, planning multi-hop upgrades, or querying version-specific changes.
---

# Rails Upgrade Assistant Skill v1.0

## How It Works

Three-step process:

1. **Detection Script** — Generate a bash script that scans the codebase for breaking changes with file:line references
2. **User Runs Script** — User executes it, gets `rails_{version}_upgrade_findings.txt`
3. **Reports** — Generate upgrade report and app:update preview based on actual findings (not hypothetical)

---

## Sequential Upgrade Strategy

### ⚠️ Version Skipping is NOT Allowed

Rails upgrades MUST follow this exact sequence:
```
7.0.x → 7.1.x → 7.2.x → 8.0.x → 8.1.x
```

**You CANNOT skip versions.** Examples:
- ❌ 7.0 → 7.2 (skips 7.1)
- ❌ 7.0 → 8.0 (skips 7.1 and 7.2)
- ✅ 7.0 → 7.1 (correct)
- ✅ 7.1 → 7.2 (correct)

If user requests a multi-hop upgrade (e.g., 7.0 → 8.1):
1. Explain the sequential requirement
2. Break it into individual hops
3. Generate separate reports for each hop
4. Recommend completing each hop fully before moving to next

---

## Available Resources

### Core Documentation
- `docs/README.md` - Human-readable overview
- `docs/QUICK-REFERENCE.md` - Command cheat sheet
- `docs/USAGE-GUIDE.md` - Comprehensive how-to

### Version-Specific Guides (Load as needed)
- `version-guides/upgrade-7.0-to-7.1.md` - Rails 7.0 → 7.1
- `version-guides/upgrade-7.1-to-7.2.md` - Rails 7.1 → 7.2
- `version-guides/upgrade-7.2-to-8.0.md` - Rails 7.2 → 8.0
- `version-guides/upgrade-8.0-to-8.1.md` - Rails 8.0 → 8.1

### Workflow Guides (Load when generating deliverables)
- `workflows/upgrade-report-workflow.md` - How to generate upgrade reports
- `workflows/detection-script-workflow.md` - How to generate detection scripts
- `workflows/app-update-preview-workflow.md` - How to generate app:update previews

### Examples (Load when user needs clarification)
- `examples/simple-upgrade.md` - Single-hop upgrade example
- `examples/multi-hop-upgrade.md` - Multi-hop upgrade example
- `examples/detection-script-only.md` - Detection script only request
- `examples/preview-only.md` - Preview only request

### Reference Materials
- `reference/breaking-changes-by-version.md` - Quick lookup
- `reference/multi-hop-strategy.md` - Multi-version planning
- `reference/deprecations-timeline.md` - Deprecation tracking
- `reference/testing-checklist.md` - Comprehensive testing
- `reference/pattern-file-guide.md` - How to use pattern files
- `reference/quality-checklist.md` - Pre-delivery verification
- `reference/troubleshooting.md` - Common issues and solutions

### Detection Script Resources
- `detection-scripts/patterns/rails-72-patterns.yml` - Rails 7.2 patterns
- `detection-scripts/patterns/rails-80-patterns.yml` - Rails 8.0 patterns
- `detection-scripts/patterns/rails-81-patterns.yml` - Rails 8.1 patterns
- `detection-scripts/templates/detection-script-template.sh` - Bash template

### Report Templates
- `templates/upgrade-report-template.md` - Main upgrade report structure
- `templates/app-update-preview-template.md` - Configuration preview

---

## Workflow

### Phase 1: Generate Detection Script

1. Detect current Rails version from `Gemfile.lock`
2. Read `detection-scripts/patterns/rails-{VERSION}-patterns.yml`
3. Read `detection-scripts/templates/detection-script-template.sh`
4. Read `workflows/detection-script-workflow.md`
5. Generate version-specific bash script and deliver to user

### Phase 2: User Runs Script

User runs the script, gets findings. Wait for them to share `rails_{version}_upgrade_findings.txt`.

### Phase 3: Generate Reports

1. Parse findings.txt — extract breaking changes and affected files
2. Read `version-guides/upgrade-{FROM}-to-{TO}.md`
3. Read `workflows/upgrade-report-workflow.md` and `workflows/app-update-preview-workflow.md`
4. Generate **Comprehensive Upgrade Report** with real code from the user's project
5. Generate **app:update Preview** with actual config file diffs

---

## Quality

Before delivering any output, verify against `reference/quality-checklist.md`. Key rules:
- Replace all {PLACEHOLDERS} with actual values
- Use ACTUAL findings from the script, not generic examples
- Include real file:line references and real code from the user's project
- Flag custom code with warnings

---

## Bundled Resources

Load these as needed — don't read everything upfront:

| Directory | When to load |
|-----------|-------------|
| `workflows/` | Before generating detection scripts or reports |
| `version-guides/` | When you need version-specific breaking changes |
| `templates/` | When generating report output |
| `detection-scripts/patterns/` | When building the detection script |
| `examples/` | When user needs clarification on the process |
| `reference/` | For quality checks, troubleshooting, pattern file format |
