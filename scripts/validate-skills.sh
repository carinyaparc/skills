#!/usr/bin/env bash
# Validate Agent Skills in this repo (frontmatter + name/folder match).
# Usage: ./scripts/validate-skills.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

fail=0
shopt -s nullglob

for skill_md in skills/*/SKILL.md; do
  skill_dir="${skill_md%/SKILL.md}"
  skill_name="${skill_dir#skills/}"

  name="$(grep -E '^name:' "$skill_md" | head -1 | sed 's/^name:[[:space:]]*//' | tr -d '"')"
  if [[ -z "$name" ]]; then
    echo "FAIL $skill_name: missing name"
    fail=1
    continue
  fi
  if [[ "$name" != "$skill_name" ]]; then
    echo "FAIL $skill_name: name '$name' must match directory"
    fail=1
    continue
  fi

  if ! grep -q '^description:' "$skill_md"; then
    echo "FAIL $skill_name: missing description"
    fail=1
    continue
  fi

  desc_chars="$(awk '
    /^description:/ { capture=1; sub(/^description:[[:space:]]*/, ""); if (length($0)) total += length($0); next }
    capture && /^[a-z-]+:/ { exit }
    capture { gsub(/^[[:space:]]+/, ""); total += length($0) + 1 }
    END { print total+0 }
  ' "$skill_md" | tr -d '\n')"
  if [[ "${desc_chars:-0}" -gt 1024 ]]; then
    echo "FAIL $skill_name: description ~$desc_chars chars (max 1024)"
    fail=1
    continue
  fi

  echo "ok: $skill_name"
done

if [[ -x skills/tasks/scripts/check-epic-paths.sh ]] && [[ -f skills/tasks/examples/backlog.md ]]; then
  skills/tasks/scripts/check-epic-paths.sh skills/tasks/examples/backlog.md || fail=1
fi

if [[ -f skills.sh.json ]]; then
  python3 -c "import json; json.load(open('skills.sh.json'))" 2>/dev/null || {
    echo "FAIL: skills.sh.json invalid JSON"
    fail=1
  }
fi

# Every skill referenced by skills.sh.json must exist, and every skill on disk
# must be grouped. A rename that misses one leaves a broken index.
if [[ -f skills.sh.json ]]; then
  missing="$(python3 - <<'PY'
import json, os
data = json.load(open('skills.sh.json'))
grouped = {s for g in data.get('groupings', []) for s in g.get('skills', [])}
on_disk = {d for d in os.listdir('skills')
           if os.path.isfile(os.path.join('skills', d, 'SKILL.md'))}
for name in sorted(grouped - on_disk):
    print(f"grouped but missing on disk: {name}")
for name in sorted(on_disk - grouped):
    print(f"on disk but not grouped: {name}")
PY
)"
  if [[ -n "$missing" ]]; then
    echo "FAIL: skills.sh.json out of sync"
    printf '  %s\n' "$missing"
    fail=1
  else
    echo "ok: skills.sh.json in sync with skills/"
  fi
fi

# Every eval and trigger-query file must be valid JSON, and every eval must
# name the skill it belongs to. A stale skill_name after a rename is silent.
for evals in skills/*/evals/evals.json; do
  skill_name="$(basename "$(dirname "$(dirname "$evals")")")"
  if ! python3 -c "import json; json.load(open('$evals'))" 2>/dev/null; then
    echo "FAIL $skill_name: evals.json invalid JSON"
    fail=1
    continue
  fi
  declared="$(python3 -c "import json; print(json.load(open('$evals')).get('skill_name',''))")"
  if [[ "$declared" != "$skill_name" ]]; then
    echo "FAIL $skill_name: evals.json declares skill_name '$declared'"
    fail=1
  fi
done

for tq in skills/*/evals/trigger-queries.json; do
  python3 -c "import json; json.load(open('$tq'))" 2>/dev/null || {
    echo "FAIL: $tq invalid JSON"
    fail=1
  }
done

# Hook and seeding scripts must at least parse. shellcheck is used when it is
# installed; it is not a hard dependency, so CI without it still validates
# syntax.
for sh in hooks/lib/*.sh hooks/*/*.sh scripts/*.sh; do
  [[ -f "$sh" ]] || continue
  if ! bash -n "$sh" 2>/dev/null; then
    echo "FAIL: $sh has a syntax error"
    bash -n "$sh" 2>&1 | head -3 | sed 's/^/  /'
    fail=1
  fi
done

if command -v shellcheck >/dev/null 2>&1; then
  if shellcheck -x -S warning hooks/lib/*.sh hooks/*/*.sh scripts/*.sh; then
    echo "ok: shellcheck clean"
  else
    echo "FAIL: shellcheck reported issues"
    fail=1
  fi
else
  echo "skip: shellcheck not installed"
fi

# Hook scripts must be executable, or the agent silently fails to run them and
# the loop dies with no diagnostic.
for hook in hooks/claude/stop-hook.sh hooks/cursor/ralph-stop.sh hooks/cursor/ralph-capture.sh scripts/seed-ralph-loop.sh; do
  if [[ -f "$hook" && ! -x "$hook" ]]; then
    echo "FAIL: $hook is not executable (chmod +x)"
    fail=1
  fi
done

# Templates must only use placeholders the seed script can resolve.
if [[ -d skills/ralph-loop/assets ]]; then
  unknown="$(grep -rho '{{[A-Z_][A-Z0-9_]*}}' skills/ralph-loop/assets 2>/dev/null \
    | sort -u | tr -d '{}' \
    | while read -r key; do
        grep -q "add_default $key\|add_kv $key\|\"$key\"" scripts/seed-ralph-loop.sh 2>/dev/null \
          || printf '%s ' "$key"
      done)"
  # Keys supplied by the caller via --set are legitimate and cannot be checked
  # here, so this only reports keys that look structural.
  for structural in PRESET_BODY COMPLETION_BLOCK STATE_BLOCK STUCK_BLOCK TASK_PROMPT CUSTOM_STEPS; do
    if ! grep -q "$structural" scripts/seed-ralph-loop.sh 2>/dev/null; then
      echo "FAIL: template placeholder {{$structural}} is never set by seed-ralph-loop.sh"
      fail=1
    fi
  done
  echo "ok: template placeholders resolvable${unknown:+ (caller-supplied: $unknown)}"
fi

# The Ralph hook and seeding suites are part of validation, not optional extras.
if [[ -x scripts/test-ralph-hooks.sh ]]; then
  if scripts/test-ralph-hooks.sh >/tmp/ralph-hooks.log 2>&1; then
    echo "ok: ralph hook tests ($(awk '/^passed:/{print $2}' /tmp/ralph-hooks.log) assertions)"
  else
    echo "FAIL: ralph hook tests"
    grep -E '^(  - |failed:)' /tmp/ralph-hooks.log | head -20 | sed 's/^/  /'
    fail=1
  fi
fi

if [[ -x scripts/test-seed-ralph-loop.sh ]]; then
  if scripts/test-seed-ralph-loop.sh >/tmp/ralph-seed.log 2>&1; then
    echo "ok: ralph seed tests ($(awk '/^passed:/{print $2}' /tmp/ralph-seed.log) assertions)"
  else
    echo "FAIL: ralph seed tests"
    grep -E '^(  - |failed:)' /tmp/ralph-seed.log | head -20 | sed 's/^/  /'
    fail=1
  fi
fi

for manifest in .claude-plugin/plugin.json .cursor-plugin/plugin.json; do
  if [[ -f "$manifest" ]]; then
    python3 -c "import json; json.load(open('$manifest'))" 2>/dev/null || {
      echo "FAIL: $manifest invalid JSON"
      fail=1
    }
  fi
done

exit "$fail"
