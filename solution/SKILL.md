---
name: solution
description: |
  solution.md artefact: write (stub or full arc42-lite), review (architecture
  gate), refine (post-sprint currency). Use for solution design, architecture,
  review solution.md, update architecture after sprint. Do NOT use for business
  strategy — use product. Do NOT use for sprint TDD — use design.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> <scope or path> [name] [--stage stub|full] [--context]"
---

# Solution

## Router

1. Mode: `write`, `review`, or `refine`.
2. Read [shared.md](shared.md).
3. One prompt: write | review | refine under [prompts/](prompts/).

**write** — scope, name, `--stage stub|full`. **review** / **refine** — path; optional `--context`.
