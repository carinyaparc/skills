---
name: roadmap
description: |
  roadmap.md — default docs/product/roadmap.md. Modes: write, review, refine.
  Outcome-based phases with exit criteria. Requires product.md for write mode.
  Do NOT list epics — use backlog.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> [--context <notes>]"
---

# Roadmap

## Artefact

Default path: `docs/product/roadmap.md` — outcome-based phases with exit criteria.

## Path resolution

If the user names a different file path in their request, read and write that
path instead of the default.

## Cross-artifact boundaries

Do NOT put in `roadmap.md`: story AC or epic detail → `docs/product/backlog.md`;
tech stack or architecture → `docs/architecture/solution.md`; business strategy →
`docs/product/product.md`.

## Supporting files

- [assets/roadmap.template.md](assets/roadmap.template.md)

## Related skills

- `product`, `backlog`, `solution`

## Router

1. Mode: `write`, `review`, or `refine`.
2. Resolve target path (default or user override).
3. One prompt under [prompts/](prompts/).
