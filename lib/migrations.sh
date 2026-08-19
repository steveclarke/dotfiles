# Migration runner.
#
# Stow is declarative and idempotent — it can only say "this symlink should
# exist". Migrations cover the other case: a one-time transition on a machine
# (convert a symlink into a real file, move a config, drop a stale path).
#
# Each migration is a script in migrations/ named YYYYMMDDHHMM-slug.sh. They run
# in filename order, once per machine, and the filename is appended to the state
# file on success.
#
# Write every migration to check the current state before acting. The state file
# is machine-local and disappears when a machine is rebuilt, so a migration must
# be safe to re-run against an already-migrated system.

MIGRATIONS_DIR="${DOTFILES_DIR}/migrations"
MIGRATIONS_STATE="${XDG_STATE_HOME:-${HOME}/.local/state}/dotfiles/migrations"

migration_applied() {
  [[ -f "$MIGRATIONS_STATE" ]] && grep -qxF "$1" "$MIGRATIONS_STATE"
}

mark_migration_applied() {
  mkdir -p "$(dirname "$MIGRATIONS_STATE")"
  echo "$1" >> "$MIGRATIONS_STATE"
}

# Echoes the basename of each migration that has not been applied, in order.
pending_migrations() {
  [[ -d "$MIGRATIONS_DIR" ]] || return 0
  local path name
  for path in "$MIGRATIONS_DIR"/*.sh; do
    [[ -f "$path" ]] || continue
    name="$(basename "$path")"
    migration_applied "$name" || echo "$name"
  done
}

list_migrations() {
  banner "Pending migrations"
  local pending
  pending="$(pending_migrations)"
  if [[ -z "$pending" ]]; then
    echo "  (none)"
  else
    echo "$pending" | sed 's/^/  - /'
  fi
  echo
  echo "State: ${MIGRATIONS_STATE}"
}

# Run every pending migration in order. Stops at the first failure so a broken
# migration doesn't get skipped over by the ones behind it.
run_migrations() {
  local pending
  pending="$(pending_migrations)"
  [[ -z "$pending" ]] && return 0

  banner "Running migrations"
  local name
  while IFS= read -r name; do
    echo "--- ${name}"
    if bash "${MIGRATIONS_DIR}/${name}"; then
      mark_migration_applied "$name"
      success "${name}"
    else
      error "Migration failed: ${name}"
      error "Fix it and re-run 'dotfiles migrate'. Later migrations were not run."
      return 1
    fi
  done <<< "$pending"
}
