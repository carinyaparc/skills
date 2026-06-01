---
name: feature
description: |
  Feature delivery modes: implement (story against design+backlog), review
  (branch/PR), refactor (address review feedback without behaviour change). Use
  for implement story, code review, refactor after review.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Shell
argument-hint: "<mode: implement|review|refactor> <story-id|branch|target>"
---

# Feature

## Router

1. Mode: `implement`, `review`, or `refactor`.
2. Read [shared.md](shared.md).
3. Matching prompt under [prompts/](prompts/).
