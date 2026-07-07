#!/usr/bin/env bats

setup() {
  TOOL="${BATS_TEST_DIRNAME}/../bin/tmux-workspace"
  WORK="$(mktemp -d)"
}

teardown() {
  [[ -n "${WORK:-}" ]] && rm -rf "$WORK"
}

@test "dry-run prints resolved defaults for a plain dir" {
  run "$TOOL" --dry-run "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"target=$WORK"* ]]
  [[ "$output" == *"agent=none"* ]]
  [[ "$output" == *"switch=true"* ]]
  [[ "$output" == *"json=false"* ]]
}

@test "unknown flag exits 2" {
  run "$TOOL" --bogus "$WORK"
  [ "$status" -eq 2 ]
}

@test "missing target dir exits 2" {
  run "$TOOL" --dry-run
  [ "$status" -eq 2 ]
}

@test "nonexistent target dir exits 2" {
  run "$TOOL" --dry-run /no/such/path/here
  [ "$status" -eq 2 ]
}

@test "flags override: --agent claude --no-switch --json" {
  run "$TOOL" --dry-run --agent claude --no-switch --json "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"agent=claude"* ]]
  [[ "$output" == *"switch=false"* ]]
  [[ "$output" == *"json=true"* ]]
}
