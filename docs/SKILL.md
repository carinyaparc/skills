---
name: docs
description: |
  Pre-sprint alignment (review) or sprint-end documentation pass (refine).
  Default product and solution paths under docs/. Work-package paths under work/.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: review|refine> <work-package-path> [--context <notes>]"
---

# Docs

Sprint-end and pre-sprint passes on product + solution and work-package design.

## Default paths

| Artefact | Default |
| -------- | ------- |
| Product | `docs/product/product.md` |
| Solution | `docs/architecture/solution.md` |
| ADR register | `docs/architecture/decisions/register.md` |
| WP design | `work/{wp}/design.md` |
| Refine session | `work/{wp}/refine-session.md` |

## Path resolution

If the user names different paths in their request, use those instead of the defaults.

## Router

1. Mode: `review` or `refine`.
2. Follow the matching prompt under [prompts/](prompts/).
