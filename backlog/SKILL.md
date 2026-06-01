---
name: backlog
description: |
  backlog.md artefact at portfolio, product, domain, or work-package scope.
  Modes: write (draft epics/stories), review (readiness gate with verdict),
  refine (groom: prioritise, break down, estimate, AC, remove). Use when the
  user mentions backlog, epics, stories, groom, "review the backlog", "is this
  backlog ready", or "write the backlog for {domain}". Domain write defaults to
  Now-phase detail — use --depth full for all phases. Do NOT use for solution
  architecture — use solution. Do NOT use for roadmaps — use roadmap.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> <scope: portfolio|product|domain|work-package> <name> [flags]"
---

# Backlog

One skill for the `backlog.md` artefact. Modes differ by persona and workflow.

## Router

1. **Determine mode** — first argument or explicit user intent:
   - `write` — draft a new or empty backlog
   - `review` — critical quality review; verdict in chat
   - `refine` — grooming session; amend backlog in place
2. Read [shared.md](shared.md) for scope paths, artefact boundaries, and schema.
3. Read and follow **exactly one** mode prompt (persona + steps live there):
   - write → [prompts/write.prompt.md](prompts/write.prompt.md)
   - review → [prompts/review.prompt.md](prompts/review.prompt.md)
   - refine → [prompts/refine.prompt.md](prompts/refine.prompt.md)

Pass scope, name, and flags after the mode token (see each prompt for flag details).

## Mode routing

| User intent | Mode |
| ----------- | ---- |
| Draft, decompose, epic list, new backlog | `write` |
| Ready for sprint?, quality review, critique | `review` |
| Groom, re-prioritise, stale backlog, add AC | `refine` |

## Cross-mode rules

- **write** creates; **review** gates; **refine** grooms. Do not groom during review or review during refine.
- Review blocking findings are resolved via **refine**, not by expanding review into grooming.
- Refinement does not invent strategy — misalignment → `product` review or planning.
