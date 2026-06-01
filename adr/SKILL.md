---
name: adr
description: |
  ADRs under docs/architecture/decisions/. Modes: plan (register tables), write,
  review. Proposals live in register.md only.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: plan|write|review> [target] [flags]"
---

# ADR

## Paths

| Artefact | Default path |
| -------- | ------------ |
| Register | `docs/architecture/decisions/register.md` |
| ADR document | `docs/architecture/decisions/ADR-{NUMBER}-{short-title}.md` |

## Path resolution

If the user names a different directory or file path in their request, use it
for read/write instead of the defaults. Keep `ADR-####` numbering sequential
within the register the user targets.

## Router

1. Mode: `plan`, `write`, or `review`.
2. Resolve paths (default or user override).
3. [prompts/plan.prompt.md](prompts/plan.prompt.md) | [prompts/write.prompt.md](prompts/write.prompt.md) | [prompts/review.prompt.md](prompts/review.prompt.md).
