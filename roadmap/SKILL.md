---
name: roadmap
description: |
  roadmap.md artefact at portfolio, product, or domain scope. Modes: write (draft
  phased roadmap), review (credibility gate), refine (post-sprint reality). Use
  when the user mentions delivery roadmap, sequence phases, review roadmap, or
  update roadmap after sprint. Outcome-based phases with exit criteria. Do NOT
  list epics — use backlog write. Requires product.md first for write mode.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> <scope or path> [name] [--context]"
---

# Roadmap

## Artefact

`roadmap.md` — outcome-based phases with exit criteria (not epic lists).

## Scope and save paths

| Scope | Save path |
| ----- | --------- |
| `portfolio` | `product/roadmap.md` |
| `product` (single-product) | `product/roadmap.md` |
| `product <name>` | `product/{name}/roadmap.md` |
| `domain <name>` | `domain/{name}/roadmap.md` |

## Cross-artifact boundaries

Do NOT put in `roadmap.md`: story AC or epic detail → `backlog.md`; tech stack → `solution.md`; business strategy → `product.md`; metric definitions → `metrics.md`.

## Supporting files

- [template.md](template.md)

## Related skills

- `product`, `backlog`, `solution`

## Router

1. Determine mode: `write`, `review`, or `refine`.
2. Follow exactly one: [prompts/write.prompt.md](prompts/write.prompt.md), [prompts/review.prompt.md](prompts/review.prompt.md), [prompts/refine.prompt.md](prompts/refine.prompt.md).

**write** — `$1` scope, `$2` name. **review** / **refine** — path to roadmap.md; optional `--context`.
