---
name: delivery
description: |
  Delivery planning and sequencing. Mode plan: produces delivery-plan.md
  sequencing Phase-0 artefacts for a new portfolio, product, or domain. Use for
  plan delivery, sequence artefacts, how do I start. Do NOT author individual
  artefacts — use product, solution, roadmap, backlog, contracts.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<mode: plan> <scope: portfolio|product|domain> <name>"
---

# Delivery

## Router

1. Mode is `plan` (default when user says "delivery plan" or "plan delivery").
2. Read [shared.md](shared.md) if present.
3. Follow [prompts/plan.prompt.md](prompts/plan.prompt.md).

Pass scope and name after the mode token.
