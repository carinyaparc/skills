# Product — shared artefact contract

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
