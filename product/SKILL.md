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

## Artefact

`product.md` — strategy document defining _why_, _who_, and _what_. Readable by a
non-technical stakeholder without a glossary.

## Scope and save paths

| Scope | Meaning | Save path |
| ----- | ------- | --------- |
| `portfolio` | Binds multiple products | `product/product.md` |
| `product <name>` | Single product in a portfolio | `product/{name}/product.md` |
| `product` (single-product workspace) | Single product | `product/product.md` |
| `domain <name>` | Bounded context | `domain/{name}/product.md` |

Domain scope: include `parent_product:` in frontmatter pointing to the owning
product's `product/product.md`.

## Frontmatter

```yaml
type: Product Strategy
scope: portfolio # portfolio | product | domain
```

## Cross-artifact boundaries

Do NOT put in `product.md`:

- File paths, modules, classes, APIs, schemas, tech stack → `solution.md` / `contracts.md`
- ADR rationales → `solution.md §9`
- Deployment topology → `solution.md §8`
- Epic lists or delivery sequencing → `roadmap.md` / `backlog.md`

Delete the `DRAFTING AIDE` comment block before saving.

## Stage (product and domain scope only)

| Stage | When | Format |
| ----- | ---- | ------ |
| `pitch` | Phase 0, pre-foundation | Shape Up, ≤2 pages |
| `product` | Phase 2+, post-walking-skeleton | Extended, ≤5 pages (domain ≤3) |

Portfolio scope has no stage flag.

## Supporting files

- [template.md](template.md)
- [examples/product.md](examples/product.md)

## Related skills

- Roadmap → `roadmap`
- Backlog → `backlog`
- Architecture → `solution`

## Router

1. **Determine mode** — `write`, `review`, or `refine`.
2. Read and follow **exactly one** mode prompt:
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
