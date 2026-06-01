---
name: roadmap
description: |
  roadmap.md at docs/product/roadmap.md. Modes: write, review, refine. Use for
  delivery roadmap, sequence phases, review roadmap. Outcome-based phases with exit
  criteria. Do NOT list epics — use backlog. Requires docs/product/product.md first
  for write mode.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> [--context <notes>]"
---

# Roadmap

## Artefact

`docs/product/roadmap.md` — outcome-based phases with exit criteria (not epic lists).

## Cross-artifact boundaries

Do NOT put in `roadmap.md`: story AC or epic detail → `docs/product/backlog.md`;
tech stack or architecture → `docs/architecture/solution.md`; business strategy →
`docs/product/product.md`.

## Supporting files

- [template.md](template.md)

## Related skills

- `product`, `backlog`, `solution`

## Router

1. Mode: `write`, `review`, or `refine`.
2. Target file: `docs/product/roadmap.md`.
3. One prompt under [prompts/](prompts/).
