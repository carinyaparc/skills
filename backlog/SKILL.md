---
name: backlog
description: |
  backlog.md — epic default docs/product/backlog.md; work-package default
  work/{wp}/backlog.md. Modes: write, review, refine. Epic write defaults to
  Now-phase detail — use --depth full for all phases.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> [epic|work-package <wp>] [flags]"
---

# Backlog

## Artefact paths

| Level | Default path |
| ----- | ------------ |
| Epic (product backlog) | `docs/product/backlog.md` |
| Work package (stories) | `work/{wp}/backlog.md` |

## Path resolution

If the user names a different file path in their request, read and write that
path instead of the default for the level they are working on.

For work-package mode, the user may supply a work-package id (e.g. `checkout-01`)
and the agent resolves `work/{wp}/backlog.md`, or they may supply the full path.

## Cross-artifact boundaries

Do NOT put in `backlog.md`:

- Architecture patterns or technical rationale → `docs/architecture/solution.md`
- Business strategy or positioning → `docs/product/product.md`
- Phase dates or delivery sequencing prose → `docs/product/roadmap.md`
- API shapes, schemas, or code fences → `docs/architecture/solution.md`
- Implementation detail for the active epic → `work/{wp}/design.md`

## Canonical story schema (work-package)

Each story includes: Status, Priority, Estimate, Epic, Labels, Depends on,
Deliverable, Design (section link), Acceptance (EARS), Acceptance (Gherkin).

- Every EARS statement: `WHEN/THE SYSTEM SHALL` or `WHEN … THE SYSTEM SHALL`
- Every Gherkin scenario: `Given / When / Then`
- Every story: at least two EARS statements and one Gherkin scenario

## Supporting files

- [template-epic.md](template-epic.md)
- [template-work-package.md](template-work-package.md)
- [examples/epic-backlog.md](examples/epic-backlog.md)
- [examples/wp01-backlog.md](examples/wp01-backlog.md)

## Related skills

- `solution`, `roadmap`, `product`

## Router

1. Mode: `write`, `review`, or `refine`.
2. Epic backlog unless the user targets a work package (`work-package <wp>` or path under `work/`).
3. One prompt under [prompts/](prompts/).

Pass `--depth full` on epic write for all phases.
