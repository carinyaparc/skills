---
name: design
description: |
  work-package design.md: write (walking-skeleton or TDD) or review (implementation
  readiness). Use for technical design, TDD, review design before sprint. Cite
  solution.md — do not re-narrate. Do NOT use for product strategy — use product.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review> <work-package-path or path-to-design.md> [flags]"
---

# Design

## Artefact

Work-package `design.md` (walking-skeleton or TDD).

| Mode | Flag |
| ---- | ---- |
| write | `--mode walking-skeleton\|tdd` |
| review | path to design.md |

Default save path: `work/{wp}/design.md`. If the user names another path under
`work/`, use it.

## Supporting files

- [assets/design.template.md](assets/design.template.md)

## Router

1. Mode: `write` or `review`.
2. [prompts/write.prompt.md](prompts/write.prompt.md) or [prompts/review.prompt.md](prompts/review.prompt.md).
