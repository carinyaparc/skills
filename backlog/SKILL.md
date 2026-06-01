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

## Artefact

`backlog.md` at portfolio, product, domain, or work-package scope. Epic-level
backlogs decompose strategy into epics; work-package backlogs decompose epics
into stories with EARS + Gherkin acceptance criteria.

## Scope and save path

| Scope               | Meaning                                    | Save path                   |
| ------------------- | ------------------------------------------ | --------------------------- |
| `portfolio`         | Epic-level backlog for the whole portfolio | `product/backlog.md`        |
| `product <name>`    | Epic-level backlog for a sub-product       | `product/{name}/backlog.md` |
| `domain <name>`     | Epic-level backlog for a bounded context   | `domain/{name}/backlog.md`  |
| `work-package <wp>` | Story-level backlog for a work package     | `work/{wp}/backlog.md`      |

- **Portfolio / product / domain** — epic breakdown table and epic detail entries.
- **Work-package** — story list with canonical EARS + Gherkin schema per story.

## Cross-artifact boundaries

Do NOT put in `backlog.md`:

- Architecture patterns or technical rationale → `solution.md`
- Business strategy or positioning → `product.md`
- Phase dates or delivery sequencing prose → `roadmap.md`
- API shapes, schemas, or code fences → `contracts.md`
- Implementation detail for the active epic → `design.md`

## Canonical story schema (work-package scope)

Each story includes: Status, Priority, Estimate, Epic, Labels, Depends on,
Deliverable, Design (section link), Acceptance (EARS), Acceptance (Gherkin).

- Every EARS statement: `WHEN/THE SYSTEM SHALL` or `WHEN … THE SYSTEM SHALL`
- Every Gherkin scenario: `Given / When / Then`
- Every story: at least two EARS statements and one Gherkin scenario

## Supporting files

- Structural scaffold: [template.md](template.md)
- Examples: [examples/domain-backlog.md](examples/domain-backlog.md),
  [examples/wp01-backlog.md](examples/wp01-backlog.md)

## Related skills

- Solution architecture → `solution`
- Roadmap sequencing → `roadmap`
- Product strategy → `product`

## Router

1. **Determine mode** — first argument or explicit user intent:
   - `write` — draft a new or empty backlog
   - `review` — critical quality review; verdict in chat
   - `refine` — grooming session; amend backlog in place
2. Read and follow **exactly one** mode prompt (persona + steps live there):
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
