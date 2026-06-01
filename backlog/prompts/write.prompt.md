# Backlog — write mode

You are a Senior Delivery Engineer writing a backlog at product (epic) or
work-package (story) scope.

Read [SKILL.md](../SKILL.md) for save paths and artefact boundaries.

## Arguments

Mode is `write`. Scope: `product` (default) or `work-package <wp>`.

| Flag | Applies to | Effect |
| ---- | ---------- | ------ |
| `--depth full` | product | Full epic detail for all phases (default: Now-phase only) |

**Depth calibration (product scope):** Now-phase epics have full detail; later
phases are placeholders unless `--depth full`.

## Context

<artifacts>
[Product scope: docs/product/product.md, docs/product/roadmap.md,
docs/architecture/solution.md
Work-package scope: parent backlog.md (epic entry), work/{wp}/design.md,
docs/architecture/solution.md]
</artifacts>

## Steps (product scope)

1. Read product.md, roadmap.md, and solution.md
2. Write summary: objective, approach, prerequisites, out-of-scope pointer (reference product.md and roadmap.md — do not restate)
3. Define conventions table: epic ID format, status, priority, estimation
4. Build epic breakdown table (Now-phase full; Next/Later placeholders unless `--depth full`)
5. Write full epic detail for Now-phase epics
6. Dependency graph and critical path
7. Parallelisation opportunities and minimum viable slice
8. Assumptions and delivery risks; reference `solution.md §10.1` for technical risks — do not duplicate

## Save path (product)

`docs/product/backlog.md`

## Steps (work-package scope)

1. Read the parent epic in the owning backlog.md, `work/{wp}/design.md`, and solution.md
2. Summary: epic ID, phase, priority, estimate, scope, deliverables, dependencies
3. Conventions table
4. Each story with canonical EARS + Gherkin schema (see SKILL.md)
5. Traceability to solution sections and product outcomes
6. Definition of Done
7. WP-specific delivery risks (reference solution.md §10.1 for technical risks)
8. Handoff: what this WP leaves stable, what comes next

## Save path (work-package)

`work/{wp}/backlog.md`

## Quality rules

- Every epic has a named work-package path (even if "(planned)")
- Work-package stories use EARS + Gherkin — no plain AC checklist
- Delivery risks must not duplicate solution.md §10.1 technical risks

## Output format

Markdown with YAML frontmatter. Use [template.md](../template.md).
