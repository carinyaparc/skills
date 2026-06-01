---
name: product
description: |
  product.md at docs/product/product.md. Modes: write (pitch or full strategy),
  review (critical PM review), refine (post-sprint currency). Use for product doc,
  PRD, product strategy. Write: pitch (Phase 0, ≤2 pages) or product stage (Phase 2+).
  Do NOT use for roadmaps — use roadmap. Do NOT use for architecture — use solution.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> [--stage pitch|product] [--context <notes>]"
---

# Product

## Artefact

`docs/product/product.md` — strategy document defining _why_, _who_, and _what_.
Readable by a non-technical stakeholder without a glossary.

## Frontmatter

```yaml
type: Product Strategy
```

## Cross-artifact boundaries

Do NOT put in `product.md`:

- File paths, modules, classes, APIs, schemas, tech stack → `docs/architecture/solution.md`
- ADR rationales → `docs/architecture/solution.md` (ADR log section)
- Epic lists or delivery sequencing → `docs/product/roadmap.md`, `docs/product/backlog.md`

Delete the `DRAFTING AIDE` comment block before saving.

## Stage (write mode)

| Stage | When | Format |
| ----- | ---- | ------ |
| `pitch` | Phase 0, pre-foundation | Shape Up, ≤2 pages |
| `product` | Phase 2+, post-walking-skeleton | Extended, ≤5 pages |

## Supporting files

- [template.md](template.md)
- [examples/product.md](examples/product.md)

## Related skills

- `roadmap`, `backlog`, `solution`

## Router

1. Mode: `write`, `review`, or `refine`.
2. Target file: `docs/product/product.md`.
3. One prompt: [prompts/write.prompt.md](prompts/write.prompt.md) | [prompts/review.prompt.md](prompts/review.prompt.md) | [prompts/refine.prompt.md](prompts/refine.prompt.md).

**write** — `--stage pitch|product` (default: ask if unclear).

**review** / **refine** — optional `--context`.
