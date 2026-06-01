#!/usr/bin/env bash
# Validate Agent Skills in this repo (frontmatter + name/folder match).
# Usage: ./scripts/validate-skills.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

fail=0

for skill_md in */SKILL.md; do
  skill_dir="${skill_md%/SKILL.md}"

  name="$(grep -E '^name:' "$skill_md" | head -1 | sed 's/^name:[[:space:]]*//' | tr -d '"')"
  if [[ -z "$name" ]]; then
    echo "FAIL $skill_dir: missing name"
    fail=1
    continue
  fi
  if [[ "$name" != "$skill_dir" ]]; then
    echo "FAIL $skill_dir: name '$name' must match directory"
    fail=1
    continue
  fi

  if ! grep -q '^description:' "$skill_md"; then
    echo "FAIL $skill_dir: missing description"
    fail=1
    continue
  fi

  # Rough length check: lines from description until next top-level frontmatter key
  desc_chars="$(awk '
    /^description:/ { capture=1; sub(/^description:[[:space:]]*/, ""); if (length($0)) total += length($0); next }
    capture && /^[a-z-]+:/ { exit }
    capture { gsub(/^[[:space:]]+/, ""); total += length($0) + 1 }
    END { print total+0 }
  ' "$skill_md" | tr -d '\n')"
  if [[ "${desc_chars:-0}" -gt 1024 ]]; then
    echo "FAIL $skill_dir: description ~$desc_chars chars (max 1024)"
    fail=1
    continue
  fi

  echo "ok: $skill_dir"
done

if [[ -x backlog/scripts/check-epic-paths.sh ]] && [[ -f backlog/examples/backlog.md ]]; then
  backlog/scripts/check-epic-paths.sh backlog/examples/backlog.md || fail=1
fi

exit "$fail"
