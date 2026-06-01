---
name: validate
description: >
  Use when the user wants final epic completion sign-off: every task in
  work/{epic}/tasks.md verified against Gherkin AC and roadmap phase exit
  criteria. Pass epic slug or ID. Do NOT use for PR or branch code review
  (code-review), writing tasks (tasks), or sprint retrospective (sprint). Not
  for drafting backlog or design.
license: MIT
allowed-tools:
  - Read
  - Glob
  - Grep
argument-hint: "<epic-slug|epic-id>"
---

# Validate

## Conventions

Read [../backlog/references/delivery-conventions.md](../backlog/references/delivery-conventions.md)
when resolving `{epic}`.

## Gotchas

- **Code review ≠ validate** — review judges the diff; validate judges epic done-ness vs AC.
- **Resolve slug from backlog** when user passes only an Epic ID.
- **Update tasks.md status** only with evidence; do not invent new AC.
- **Epic status in backlog** updates only when all tasks for the epic are verified.

Follow [prompts/run.prompt.md](prompts/run.prompt.md).
