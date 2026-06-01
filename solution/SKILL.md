---
name: solution
description: |
  solution.md at docs/architecture/solution.md. Modes: write (stub or full arc42-lite),
  review, refine. Use for solution design, architecture, review solution. Do NOT use
  for business strategy — use product. Do NOT use for sprint TDD — use design.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> [--stage stub|full] [--context <notes>]"
---

# Solution

## Artefact

`docs/architecture/solution.md` — arc42-lite architecture (stub or full).

## Stage (write mode)

| Stage | When | Sections |
| ----- | ---- | -------- |
| `stub` | Phase 0 | §1–§2 only; §3–11 scaffolded |
| `full` | Phase 2+ | All eleven sections |

## Cross-artifact boundaries

Do NOT put in `solution.md`: business strategy → `docs/product/product.md`; story
AC → work-package `backlog.md`; phase sequencing → `docs/product/roadmap.md`.

## Related skills

- `product`, `backlog`, `design`, `adr`

## Router

1. Mode: `write`, `review`, or `refine`.
2. Target file: `docs/architecture/solution.md`.
3. One prompt under [prompts/](prompts/).

**write** — `--stage stub|full`.
