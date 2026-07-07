# Ralph cancel

Stop an active Ralph loop. The run directory is kept as a record; only the
active loop file and its flags are removed.

## Steps

1. Read `.ralph-loop` to resolve the base directory. If missing, fall back
   to `.ralph`.
2. Check `{base}/loop.md`.
3. **If it does not exist:** report "No active Ralph loop found." and stop.
4. **If it exists:**
   - Read the current `iteration` and, if a `state_file` is declared, the
     `current_task` / `current_step` so the report says where the loop was.
   - Remove the active loop artefacts and pointer file:

     ```bash
     rm -f {base}/loop.md {base}/done {base}/stall .ralph-loop
     ```

   - Keep `{base}/{work-id}/` directories — they are the run record
     (context, state, review outputs) and are what `/ralph setup` reuses
     if the loop is re-seeded later.

## Output

One short confirmation: "Cancelled Ralph loop at iteration N (was on
CHK01-03 / review_fix). Run record kept at {base}/checkout-foundation/." —
or the no-active-loop message.
