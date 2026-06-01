# Backlog — shared artefact contract

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
