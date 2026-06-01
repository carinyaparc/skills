---
name: sprint
description: >
  Use when the user wants a sprint plan before the sprint or a retrospective
  after, under work/sprint-{id}/plan.md or retrospective.md. Do NOT use for
  product strategy (product), task Gherkin (tasks), epic doc refine pass (docs
  refine), or epic validation (validate).
license: MIT
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: plan|retrospective> <sprint-id> [--context <notes>]"
---

# Sprint

## Artefacts

| Mode | Default path |
| ---- | ------------ |
| `plan` | `work/sprint-{id}/plan.md` |
| `retrospective` | `work/sprint-{id}/retrospective.md` |

Example: `work/sprint-3/plan.md`, `work/sprint-3/retrospective.md`.

## Path resolution

If the user names a different path under `work/`, use it. Resolve `{id}` from
the argument (e.g. `3`, `sprint-3`, `2026-W14`).

## Router

1. Mode: `plan` or `retrospective`.
2. Resolve sprint folder and output file.
3. [prompts/plan.prompt.md](prompts/plan.prompt.md) | [prompts/retrospective.prompt.md](prompts/retrospective.prompt.md).

## Supporting files

- [assets/sprint-plan.template.md](assets/sprint-plan.template.md)
- [assets/sprint-retrospective.template.md](assets/sprint-retrospective.template.md)

## Related skills

- `tasks`, `backlog`, `design`, `product`, `docs`
