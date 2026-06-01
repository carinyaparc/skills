---
name: docs
description: |
  Documentation pass modes: review (pre-sprint product+solution alignment) or
  refine (sprint-end session, refine-session.md). Use for review docs before dev,
  refine docs after sprint, promote ADR candidates. Not for single-artefact
  review — use product or solution modes.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: review|refine> <epic-id or work-package-path> [flags]"
---

# Docs

Sprint-end and pre-sprint documentation passes on `product.md` + `solution.md`
and work-package design artefacts. Produces reviews or `refine-session.md`.

## Router

1. Mode: `review` or `refine`.
2. Follow the matching prompt under [prompts/](prompts/).
