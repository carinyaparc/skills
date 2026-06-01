---
name: product
description: |
  product.md — default docs/product/product.md. Modes: write (pitch or full
  strategy), review, refine. Use for product doc, PRD, product strategy.
  Do NOT use for roadmaps or architecture.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: write|review|refine> [--stage pitch|product] [--context <notes>]"
---

# Product

## Artefact

Default path: `docs/product/product.md` — strategy document (_why_, _who_, _what_).
Readable by a non-technical stakeholder without a glossary.

## Path resolution

If the user names a different file path in their request, read and write that
path instead of the default.

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
2. Resolve target path (default or user override).
3. One prompt under [prompts/](prompts/).

**write** — `--stage pitch|product` (default: ask if unclear).

**review** / **refine** — optional `--context`.
