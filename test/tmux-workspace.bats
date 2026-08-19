#!/usr/bin/env bats

setup() {
  TOOL="${BATS_TEST_DIRNAME}/../bin/tmux-workspace"
  WORK="$(mktemp -d)"
}

teardown() {
  [[ -n "${WORK:-}" ]] && rm -rf "$WORK"
  tmux kill-session -t "=${sesh:-}" 2>/dev/null || true
}

@test "dry-run prints resolved defaults for a plain dir" {
  run "$TOOL" --dry-run "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"target=$WORK"* ]]
  [[ "$output" == *"agent=none"* ]]
  [[ "$output" == *"git_window=false"* ]]
  [[ "$output" == *"switch=true"* ]]
  [[ "$output" == *"json=false"* ]]
}

@test "--git opts the lazygit window back in" {
  run "$TOOL" --dry-run --git "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"git_window=true"* ]]
}

@test "--no-git beats a config that turns the git window on" {
  export TMUX_WORKSPACE_CONFIG="$WORK/global.toml"
  printf '[session]\ngit_window = "true"\n' > "$WORK/global.toml"
  run "$TOOL" --dry-run --no-git "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"git_window=false"* ]]
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
  grep -qx 'dev_cmd=' <<<"$output"
}

@test "--name overrides the derived name" {
  run "$TOOL" --dry-run --name custom-sesh "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"name=custom-sesh"* ]]
}

@test "sanitize_name reduces disallowed chars and collapses hyphens" {
  run bash -c 'source "$1"; sanitize_name "a\"b, c:d"' _ "$TOOL"
  [ "$status" -eq 0 ]
  [ "$output" = "a-b-c-d" ]
}

@test "explicit --name is sanitized (no raw quotes reach the session name)" {
  run "$TOOL" --dry-run --name 'a"b:c' "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"name=a-b-c"* ]]
}

@test "an all-punctuation name falls back to workspace" {
  run "$TOOL" --dry-run --name '...' "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"name=workspace"* ]]
}

tw_kill() { tmux kill-session -t "=$1" 2>/dev/null || true; }

@test "build creates agent/cli/dev windows, no git by default" {
  sesh="twtest-$$-a"
  tw_kill "$sesh"
  run "$TOOL" --no-switch --no-git --name "$sesh" "$WORK"
  [ "$status" -eq 0 ]
  run tmux list-windows -t "=$sesh" -F '#{window_name}'
  [[ "$output" == *"agent"* ]]
  [[ "$output" == *"cli"* ]]
  [[ "$output" == *"dev"* ]]
  [[ "$output" != *"git"* ]]
  tw_kill "$sesh"
}

@test "build adds a git window when GIT_WINDOW is true" {
  sesh="twtest-$$-g"
  tw_kill "$sesh"
  export TMUX_WORKSPACE_CONFIG="$WORK/global.toml"
  printf '[session]\ngit_window = "true"\n' > "$WORK/global.toml"
  run "$TOOL" --no-switch --name "$sesh" "$WORK"
  [ "$status" -eq 0 ]
  run tmux list-windows -t "=$sesh" -F '#{window_name}'
  [[ "$output" == *"git"* ]]
  tw_kill "$sesh"
}

@test "duplicate session name errors" {
  sesh="twtest-$$-d"
  tw_kill "$sesh"
  "$TOOL" --no-switch --no-git --name "$sesh" "$WORK"
  run "$TOOL" --no-switch --no-git --name "$sesh" "$WORK"
  [ "$status" -eq 1 ]
  [[ "$output" == *"already exists"* ]]
  tw_kill "$sesh"
}

@test "invalid agent errors" {
  run "$TOOL" --no-switch --name "twtest-$$-x" --agent gpt "$WORK"
  [ "$status" -eq 2 ]
}

@test "--json emits session and pane ids for present windows" {
  sesh="twtest-$$-j"
  tw_kill "$sesh"
  run "$TOOL" --no-switch --no-git --json --name "$sesh" "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"\"session\":\"$sesh\""* ]]
  [[ "$output" == *"\"agent\":\"%"* ]]
  [[ "$output" == *"\"cli\":\"%"* ]]
  [[ "$output" == *"\"dev\":\"%"* ]]
  [[ "$output" != *"\"git\":"* ]]
  # the emitted agent pane id must be a real pane in the session
  pane="$(echo "$output" | sed -n 's/.*"agent":"\(%[0-9]*\)".*/\1/p')"
  run tmux display-message -p -t "$pane" '#{session_name}'
  [ "$output" = "$sesh" ]
  tw_kill "$sesh"
}

@test "--no-switch without --json prints an attach hint" {
  sesh="twtest-$$-h"
  tw_kill "$sesh"
  run "$TOOL" --no-switch --no-git --name "$sesh" "$WORK"
  [ "$status" -eq 0 ]
  [[ "$output" == *"tmux attach -t $sesh"* ]]
  tw_kill "$sesh"
}
