---
name: backlog
description: |
  backlog.md: epic-level at docs/product/backlog.md; work-package at work/{wp}/backlog.md
  (domain paths coming later). Modes: write, review, refine. Use for backlog, epics,
  stories, groom. Domain write defaults to Now-phase — use --depth full for all phases.
  Do NOT use for solution — use solution. Do NOT use for roadmaps — use roadmap.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> <scope: product|work-package> [name] [flags]"
---

# Backlog

## Artefact paths

| Scope | Save path |
| ----- | --------- |
| `product` (default) | `docs/product/backlog.md` — epic-level |
| `work-package <wp>` | `work/{wp}/backlog.md` — story-level (unchanged until domain layout) |

Epic backlogs decompose strategy into epics; work-package backlogs decompose epics
into stories with EARS + Gherkin acceptance criteria.

## Cross-artifact boundaries

Do NOT put in `backlog.md`:

- Architecture patterns or technical rationale → `docs/architecture/solution.md`
- Business strategy or positioning → `docs/product/product.md`
- Phase dates or delivery sequencing prose → `docs/product/roadmap.md`
- API shapes, schemas, or code fences → `docs/architecture/solution.md`
- Implementation detail for the active epic → `design.md`

## Canonical story schema (work-package scope)

Each story includes: Status, Priority, Estimate, Epic, Labels, Depends on,
Deliverable, Design (section link), Acceptance (EARS), Acceptance (Gherkin).

- Every EARS statement: `WHEN/THE SYSTEM SHALL` or `WHEN … THE SYSTEM SHALL`
- Every Gherkin scenario: `Given / When / Then`
- Every story: at least two EARS statements and one Gherkin scenario

## Supporting files

- [template.md](template.md)
- [examples/domain-backlog.md](examples/domain-backlog.md)
- [examples/wp01-backlog.md](examples/wp01-backlog.md)

## Related skills

- `solution`, `roadmap`, `product`

## Router

1. Mode: `write`, `review`, or `refine`.
2. Scope: `product` (default) or `work-package <wp>`.
3. One prompt under [prompts/](prompts/).

Pass `--depth full` on product-scope write for all phases.
