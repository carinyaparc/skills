#!/bin/bash

# Ralph loop Stop hook (Claude Code).
# Blocks session exit while a loop is active and feeds the loop prompt back
# as the next turn's input. Promise detection reads the last assistant
# message from the session transcript (Claude Code has no response hook).
#
# Claude Code Stop hook API:
#   Input:  { "transcript_path": "<path>", ... }
#   Output: { "decision": "block", "reason": "<prompt>", "systemMessage": "<msg>" }
#           to continue, or exit 0 with no output to allow the stop.
#
# State files (seeded by the ralph skill, shared with the Cursor hooks):
#   .ralph/loop.md   active loop file: YAML frontmatter + prompt body
#   .ralph/stall     stall-guard tracking (hash + consecutive-unchanged count)

set -euo pipefail

HOOK_INPUT=$(cat)

RALPH_DIR=".ralph"
LOOP_FILE="$RALPH_DIR/loop.md"
DONE_FLAG="$RALPH_DIR/done"
STALL_FILE="$RALPH_DIR/stall"

STALL_LIMIT=3

cleanup() {
  rm -f "$LOOP_FILE" "$DONE_FLAG" "$STALL_FILE"
}

# No active loop - allow exit
if [[ ! -f "$LOOP_FILE" ]]; then
  exit 0
fi

# Parse loop file frontmatter
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$LOOP_FILE")
ITERATION=$(echo "$FRONTMATTER" | grep '^iteration:' | sed 's/iteration: *//')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep '^max_iterations:' | sed 's/max_iterations: *//')
COMPLETION_PROMISE=$(echo "$FRONTMATTER" | grep '^completion_promise:' | sed 's/completion_promise: *//' | sed 's/^"\(.*\)"$/\1/')
STATE_FILE=$(echo "$FRONTMATTER" | grep '^state_file:' | sed 's/state_file: *//' | sed 's/^"\(.*\)"$/\1/' || true)

if [[ ! "$ITERATION" =~ ^[0-9]+$ ]]; then
  echo "Ralph loop: loop file corrupted (iteration: '$ITERATION'). Stopping." >&2
  cleanup
  exit 0
fi

if [[ ! "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "Ralph loop: loop file corrupted (max_iterations: '$MAX_ITERATIONS'). Stopping." >&2
  cleanup
  exit 0
fi

# Done flag (defensive; normally the promise is detected below)
if [[ -f "$DONE_FLAG" ]]; then
  echo "Ralph loop: completion promise fulfilled at iteration $ITERATION."
  cleanup
  exit 0
fi

# Max iterations reached
if [[ $MAX_ITERATIONS -gt 0 ]] && [[ $ITERATION -ge $MAX_ITERATIONS ]]; then
  echo "Ralph loop: max iterations ($MAX_ITERATIONS) reached. Run '/ralph status' to inspect progress."
  cleanup
  exit 0
fi

# Check the last assistant message for the completion promise
TRANSCRIPT_PATH=$(echo "$HOOK_INPUT" | jq -r '.transcript_path // empty')

if [[ -n "$TRANSCRIPT_PATH" ]] && [[ -f "$TRANSCRIPT_PATH" ]] && [[ "$COMPLETION_PROMISE" != "null" ]] && [[ -n "$COMPLETION_PROMISE" ]]; then
  LAST_LINE=$(grep '"role":"assistant"' "$TRANSCRIPT_PATH" | tail -1 || true)
  if [[ -n "$LAST_LINE" ]]; then
    LAST_OUTPUT=$(echo "$LAST_LINE" | jq -r '
      .message.content |
      map(select(.type == "text")) |
      map(.text) |
      join("\n")
    ' 2>/dev/null || echo "")
    if [[ -n "$LAST_OUTPUT" ]]; then
      PROMISE_TEXT=$(echo "$LAST_OUTPUT" | perl -0777 -pe 's/.*?<promise>(.*?)<\/promise>.*/$1/s; s/^\s+|\s+$//g; s/\s+/ /g' 2>/dev/null || echo "")
      if [[ -n "$PROMISE_TEXT" ]] && [[ "$PROMISE_TEXT" = "$COMPLETION_PROMISE" ]]; then
        echo "Ralph loop: completion promise '$COMPLETION_PROMISE' fulfilled at iteration $ITERATION."
        cleanup
        exit 0
      fi
    fi
  fi
fi

# Stall guard: if a state file is declared and it has not changed for
# STALL_LIMIT consecutive iterations, the loop is spinning without progress.
if [[ -n "${STATE_FILE:-}" ]] && [[ "$STATE_FILE" != "null" ]] && [[ -f "$STATE_FILE" ]]; then
  CURRENT_HASH=$(cksum "$STATE_FILE" | awk '{print $1}')
  PREV_HASH=""
  PREV_COUNT=0
  if [[ -f "$STALL_FILE" ]]; then
    PREV_HASH=$(awk '{print $1}' "$STALL_FILE")
    PREV_COUNT=$(awk '{print $2}' "$STALL_FILE")
    [[ "$PREV_COUNT" =~ ^[0-9]+$ ]] || PREV_COUNT=0
  fi
  if [[ "$CURRENT_HASH" == "$PREV_HASH" ]]; then
    COUNT=$((PREV_COUNT + 1))
  else
    COUNT=1
  fi
  if [[ $COUNT -ge $STALL_LIMIT ]]; then
    echo "Ralph loop: no progress in $STALL_LIMIT consecutive iterations (state file unchanged: $STATE_FILE). Stopping so a human can inspect. Run '/ralph status' for details."
    cleanup
    exit 0
  fi
  echo "$CURRENT_HASH $COUNT" > "$STALL_FILE"
fi

# Extract prompt text (everything after the closing --- of the frontmatter)
PROMPT_TEXT=$(awk '/^---$/{i++; next} i>=2' "$LOOP_FILE")

if [[ -z "$PROMPT_TEXT" ]]; then
  echo "Ralph loop: no prompt text found in loop file. Stopping." >&2
  cleanup
  exit 0
fi

# Increment iteration atomically
NEXT_ITERATION=$((ITERATION + 1))
TEMP_FILE="${LOOP_FILE}.tmp.$$"
sed "s/^iteration: .*/iteration: $NEXT_ITERATION/" "$LOOP_FILE" > "$TEMP_FILE"
mv "$TEMP_FILE" "$LOOP_FILE"

if [[ "$COMPLETION_PROMISE" != "null" ]] && [[ -n "$COMPLETION_PROMISE" ]]; then
  SYSTEM_MSG="Ralph iteration $NEXT_ITERATION | To stop: output <promise>$COMPLETION_PROMISE</promise> ONLY when genuinely true - do not lie to exit."
else
  SYSTEM_MSG="Ralph iteration $NEXT_ITERATION | No completion promise set - loop runs until max_iterations."
fi

jq -n \
  --arg prompt "$PROMPT_TEXT" \
  --arg msg "$SYSTEM_MSG" \
  '{
    "decision": "block",
    "reason": $prompt,
    "systemMessage": $msg
  }'

exit 0
