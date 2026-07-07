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

@test "toml_get reads a value under a section, ignoring comments and other tables" {
  cfg="$WORK/config.toml"
  cat > "$cfg" <<'EOF'
# comment
[session]
default_agent = "codex"   # inline comment
agent_mode = "fable"

[worktree]
root = "~/src/foo-worktrees"
EOF
  run bash -c 'source "$1"; toml_get "$2" session default_agent' _ "$TOOL" "$cfg"
  [ "$status" -eq 0 ]
  [ "$output" = "codex" ]
}

@test "toml_get returns nothing for a missing key or missing file" {
  run bash -c 'source "$1"; toml_get "/no/file" session default_agent' _ "$TOOL"
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}

@test "repo .worktree.toml overrides global config" {
  export TMUX_WORKSPACE_CONFIG="$WORK/global.toml"
  printf '[session]\ndefault_agent = "claude"\n' > "$WORK/global.toml"
  git -C "$WORK" init -q
  printf '[session]\ndefault_agent = "codex"\n' > "$WORK/.worktree.toml"
  run "$TOOL" --dry-run "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"agent=codex"* ]]
}

@test "global config applies when no repo config and no flag" {
  export TMUX_WORKSPACE_CONFIG="$WORK/global.toml"
  printf '[session]\ndefault_agent = "claude"\n' > "$WORK/global.toml"
  run "$TOOL" --dry-run "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"agent=claude"* ]]
}

@test "explicit --agent beats config" {
  export TMUX_WORKSPACE_CONFIG="$WORK/global.toml"
  printf '[session]\ndefault_agent = "claude"\n' > "$WORK/global.toml"
  run "$TOOL" --dry-run --agent none "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"agent=none"* ]]
}

@test "derive_name sanitizes spaces and dots to hyphens" {
  run bash -c 'source "$1"; derive_name "/tmp/My Feature.v2"' _ "$TOOL"
  [ "$status" -eq 0 ]
  [ "$output" = "My-Feature-v2" ]
}

@test "dev_cmd auto-discovers an executable bin/dev" {
  mkdir -p "$WORK/bin"
  printf '#!/usr/bin/env bash\n' > "$WORK/bin/dev"
  chmod +x "$WORK/bin/dev"
  run "$TOOL" --dry-run "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"dev_cmd=bin/dev"* ]]
}

@test "dev_cmd empty when no bin/dev and no config" {
  run "$TOOL" --dry-run "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"dev_cmd="$'\n'* ]] || [[ "$output" == *$'dev_cmd=\n'* ]] || [[ "$output" == *"dev_cmd="* ]]
}

@test "--name overrides the derived name" {
  run "$TOOL" --dry-run --name custom-sesh "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"name=custom-sesh"* ]]
}
