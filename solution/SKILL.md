---
name: solution
description: |
  solution.md — default docs/architecture/solution.md. Modes: write (stub or
  full arc42-lite), review, refine. Do NOT use for business strategy — use product.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> [--stage stub|full] [--context <notes>]"
---

# Solution

## Artefact

Default path: `docs/architecture/solution.md` — arc42-lite architecture (stub or full).

## Path resolution

If the user names a different file path in their request, read and write that
path instead of the default.

## Stage (write mode)

| Stage | When | Sections |
| ----- | ---- | -------- |
| `stub` | Phase 0 | §1–§2 only; §3–11 scaffolded |
| `full` | Phase 2+ | All eleven sections |

## Cross-artifact boundaries

Do NOT put in `solution.md`: business strategy → `docs/product/product.md`; story
AC → `work/{wp}/backlog.md`; phase sequencing → `docs/product/roadmap.md`.

## Supporting files

- [assets/solution.template.md](assets/solution.template.md)

## Related skills

- `product`, `backlog`, `design`, `adr`

## Router

1. Mode: `write`, `review`, or `refine`.
2. Resolve target path (default or user override).
3. One prompt under [prompts/](prompts/).

**write** — `--stage stub|full`.
