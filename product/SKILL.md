---
name: product
description: |
  product.md artefact at portfolio, product, or domain scope. Modes: write (draft
  pitch or full strategy), review (critical PM review with verdict), refine
  (post-sprint currency pass). Use when the user mentions product doc, PRD, product
  strategy, critique product.md, or update strategy after sprint. Product write:
  pitch (Phase 0, ≤2 pages) or product stage (Phase 2+). Do NOT include tech stack
  — use solution. Do NOT use for roadmaps — use roadmap.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> <scope or path> [name] [flags]"
---

# Product

One skill for the `product.md` artefact.

## Router

1. **Determine mode** — `write`, `review`, or `refine`.
2. Read [shared.md](shared.md).
3. Read and follow **exactly one** mode prompt:
   - write → [prompts/write.prompt.md](prompts/write.prompt.md)
   - review → [prompts/review.prompt.md](prompts/review.prompt.md)
   - refine → [prompts/refine.prompt.md](prompts/refine.prompt.md)

**write** — `$1` = scope, `$2` = name (if needed), `--stage pitch|product`.

**review** / **refine** — path to `product.md` as first argument after mode;
optional `--context`.

## Mode routing

| User intent | Mode |
| ----------- | ---- |
| Draft PRD, product strategy, pitch | `write` |
| Critique strategy, is this any good | `review` |
| Stale doc, sprint learnings, update baselines | `refine` |

## Cross-mode rules

- **review** challenges quality; **refine** updates currency without re-authoring.
- Wrong thesis → **review**, not **refine**.
- Technical content → **solution**, not product modes.
