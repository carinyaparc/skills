# Backlog — write mode

You are a Senior Delivery Engineer writing an epic backlog or a work-package
story backlog.

Read [SKILL.md](../SKILL.md) for paths, boundaries, and path resolution.

## Paths

| Level | Default |
| ----- | ------- |
| Epic | `docs/product/backlog.md` |
| Work package | `work/{wp}/backlog.md` |

If the user names another path, use it. If they name a work package id, resolve `work/{wp}/backlog.md`.

## Arguments

`--depth full` on epic write: detail for all phases (default: Now-phase only).

## Context

<artifacts>
[Epic: docs/product/product.md, roadmap.md, solution.md
Work package: parent epic in product backlog, work/{wp}/design.md, solution.md]
</artifacts>

## Steps (epic)

1. Read product.md, roadmap.md, solution.md
2. Summary, conventions, epic table, Now-phase epic detail, dependency graph, risks
3. Reference solution.md §10.1 for technical risks — do not duplicate

## Steps (work-package)

1. Read parent epic, design.md, solution.md
2. Summary, conventions, stories (canonical EARS + Gherkin), traceability, DoD, handoff

## Quality rules

- Every epic has a work-package path (even "(planned)")
- WP stories use full EARS + Gherkin schema
- Out-of-scope: cite product.md and roadmap.md, do not restate

## Output

YAML frontmatter + Markdown. Epic: [template-epic.md](../template-epic.md). WP: [template-work-package.md](../template-work-package.md).

Examples: [epic-backlog.md](../examples/epic-backlog.md), [wp01-backlog.md](../examples/wp01-backlog.md).
