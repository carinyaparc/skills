---
name: feature
description: >
  Use when the user wants to implement a story or task in code against approved
  design.md and docs/work/{epic}/tasks.md. Do NOT use for code review (code-review),
  address review feedback (code-review fix), writing tasks (tasks), or design
  (design write).
license: MIT
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Shell
argument-hint: "<mode: implement> <story-id>"
---

# Feature

Implements a story with approved requirements and design, against `design.md`
and `tasks.md`.

## Router

1. Mode is `implement` (default when user says "feature implement").
2. Follow [prompts/implement.prompt.md](prompts/implement.prompt.md).

Pass story id and context after the mode token.
