#!/usr/bin/env bash
#
# Split Claude Code's settings into a shared file and a machine-local file.
#
# Before: ~/.claude/settings.json was a symlink into this repo, so Claude Code's
# runtime writes (effort level, theme, and the auto mode environment survey —
# internal hostnames, trusted repos, where sensitive data lives) landed in a
# public repo.
#
# After: ~/.claude/settings.json is a real machine-local file holding only the
# keys Claude Code writes. The hand-curated settings move to
# claude/managed-settings.json, symlinked to the system managed-settings path by
# configs/stow.sh.
#
# See claude/README.md.

set -euo pipefail

SETTINGS="${HOME}/.claude/settings.json"

# Keys Claude Code writes at runtime. These stay machine-local. Anything not
# listed here is either curated (now in managed-settings.json) or unknown — and
# unknown keys are kept, so a machine's own customizations survive.
SHARED_KEYS='["env","attribution","permissions","hooks","statusLine","enabledPlugins","extraKnownMarketplaces","spinnerVerbs","includeCoAuthoredBy"]'

if [ ! -L "$SETTINGS" ] && [ ! -e "$SETTINGS" ]; then
  echo "  no ${SETTINGS} — nothing to migrate"
  exit 0
fi

command -v python3 >/dev/null 2>&1 || { echo "python3 required" >&2; exit 1; }

# Being a real file does NOT mean the split already happened — a machine whose
# settings were never stowed as a symlink still has every shared key in there.
# Leaving them would double up against managed settings once the symlink lands:
# arrays concatenate across scopes, so permissions and hooks would appear twice.
# The test that matters is whether shared keys are still present, not the file type.
if [ ! -L "$SETTINGS" ]; then
  if python3 - "$SETTINGS" "$SHARED_KEYS" <<'PY'
import json, sys
shared = set(json.loads(sys.argv[2]))
try:
    with open(sys.argv[1]) as f:
        data = json.load(f)
except (OSError, ValueError):
    sys.exit(0)   # unreadable/invalid — treat as needing work, let the split report
sys.exit(0 if shared & set(data) else 1)
PY
  then
    echo "  real file, still holds shared keys — stripping them"
  else
    echo "  ${SETTINGS} is a real file with no shared keys — already split"
    exit 0
  fi
fi

BACKUP="${SETTINGS}.pre-split.$(date +%Y%m%d%H%M%S)"
# The backup holds the autoMode environment survey — internal hostnames, where
# sensitive data lives. Create it private before anything is written into it.
: > "$BACKUP"
chmod 600 "$BACKUP"

if [ -e "$SETTINGS" ]; then
  # Real file, or a symlink with a live target: read through it either way.
  cp -L "$SETTINGS" "$BACKUP"
  echo "  backed up current settings to ${BACKUP}"
else
  # Dangling symlink. The commit that added this migration also deleted the
  # target, so on any machine that pulls before migrating, the settings are
  # only in git history. Recover them from the commit before the deletion.
  : "${DOTFILES_DIR:="${HOME}/.local/share/dotfiles"}"
  TRACKED="configs/claude/.claude/settings.json"

  DELETED_IN="$(git -C "$DOTFILES_DIR" rev-list -n 1 HEAD -- "$TRACKED" 2>/dev/null || true)"
  if [ -z "$DELETED_IN" ]; then
    echo "  dangling symlink and no history for ${TRACKED} — removing the dead link" >&2
    rm -f "$SETTINGS"
    exit 0
  fi

  if ! git -C "$DOTFILES_DIR" show "${DELETED_IN}~1:${TRACKED}" > "$BACKUP" 2>/dev/null; then
    echo "  could not recover ${TRACKED} from ${DELETED_IN}~1" >&2
    rm -f "$BACKUP"
    exit 1
  fi
  echo "  symlink target was deleted by a pull; recovered settings from ${DELETED_IN}~1"
  echo "  backed up recovered settings to ${BACKUP}"
fi

TMP="$(mktemp)"
python3 - "$BACKUP" "$TMP" "$SHARED_KEYS" <<'PY'
import json, sys

src, dest, shared_keys = sys.argv[1], sys.argv[2], json.loads(sys.argv[3])

with open(src) as f:
    data = json.load(f)

# Drop the keys that now live in managed-settings.json; keep everything else,
# including keys this migration has never heard of.
machine = {k: v for k, v in data.items() if k not in shared_keys}

with open(dest, "w") as f:
    json.dump(machine, f, indent=2)
    f.write("\n")

dropped = sorted(k for k in data if k in shared_keys)
kept = sorted(machine)
print("  moved to managed-settings.json: " + (", ".join(dropped) or "(none)"))
print("  kept machine-local: " + (", ".join(kept) or "(none)"))
PY

rm -f "$SETTINGS"
mv "$TMP" "$SETTINGS"
chmod 600 "$SETTINGS"

echo "  ${SETTINGS} is now a real machine-local file"
