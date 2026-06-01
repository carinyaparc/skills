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

## Artefact

`solution.md` — arc42-lite architecture (stub or full).

## Scope and save paths

| Scope | Save path |
| ----- | --------- |
| `portfolio` | `architecture/solution.md` |
| `product <name>` | `product/{name}/architecture/solution.md` or `architecture/solution.md` |
| `domain <name>` | `domain/{name}/solution.md` |

## Stage

| Stage | When | Sections |
| ----- | ---- | -------- |
| `stub` | Phase 0 | §1–§2 only; §3–11 scaffolded |
| `full` | Phase 2+ | All eleven sections |

## Related skills

- `product`, `backlog`, `design`, `contracts`

## Router

1. Mode: `write`, `review`, or `refine`.
2. One prompt: write | review | refine under [prompts/](prompts/).

**write** — scope, name, `--stage stub|full`. **review** / **refine** — path; optional `--context`.
