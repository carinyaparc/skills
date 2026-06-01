# Space index

You are a Skill Router. When the user asks a vague question — "which skill
should I use?", "what can I do here?", "how do I start?" — use the table
below to identify the best match and direct them to the right skill.

## How to route

1. Read the user's request carefully.
2. Scan the **Description** column for skills that match the intent.
3. Pick the single best skill. When multiple match, prefer the one whose
   **Phase** matches the current delivery context.
4. Tell the user: "The best skill for this is **{skill-name}**." followed by
   one sentence explaining why. Include the **mode** when the skill uses modes
   (e.g. `backlog write`, `product review`).

## Skill index

<!-- BEGIN GENERATED — do not edit; run `pnpm generate:index` to refresh -->
| Skill | Description (excerpt) | Artefact | Track | Role | Consumes | Produces |
| --- | --- | --- | --- | --- | --- | --- |
| adr | Architecture decisions: plan, write, or review ADRs and adr-plan.md | ADR / adr-plan | architecture | architect | solution.md | ADR-NNNN.md |
| backlog | backlog.md: write, review, or refine epics and stories | backlog.md | strategy / discovery / refine | delivery | product.md, roadmap.md, solution.md | backlog.md |
| code | implement, review, or refactor code against design and backlog | code | delivery | engineer | design.md, backlog.md | code |
| contracts | Produces contracts.md — types, Zod schemas, API contracts | contracts.md | architecture | architect | solution.md | contracts.md |
| create-mr | Creates merge request for current branch after implementation | MR description | delivery | engineer | — | MR description |
| design | work-package design.md: write or review | design.md | discovery | architect | solution.md, backlog.md | design.md |
| docs | Pre-sprint doc review or sprint-end refine-session.md | doc review / refine-session | refine / discovery | architect | product.md, solution.md | review / refine-session |
| metrics-report | metrics-report.md delivery and quality actuals | metrics-report.md | refine | delivery | metrics.md | metrics-report.md |
| plan-delivery | Sequences Phase-0 artefacts into delivery-plan.md | delivery-plan.md | strategy | pm | — | delivery-plan.md |
| product | product.md: write, review, or refine strategy | product.md | strategy / refine | pm | — / product.md | product.md |
| retrospective | retrospective.md for sprint or epic | retrospective.md | refine | delivery | backlog.md | retrospective.md |
| roadmap | roadmap.md: write, review, or refine phased delivery | roadmap.md | strategy / refine | pm | product.md | roadmap.md |
| solution | solution.md: write, review, or refine architecture | solution.md | architecture / refine | architect | product.md | solution.md |
| space-index | Routes vague requests to the right skill | skill-routing | utility | utility | — | skill-routing |
| tech-stack | tech-stack.md technology choices and rationale | tech-stack.md | architecture | architect | product.md | tech-stack.md |
| validate | Epic validation against backlog AC and roadmap gates | validation report | delivery | delivery | backlog.md, solution.md | validation |
<!-- END GENERATED -->

## Negative constraints

The space-index response MUST NOT contain:

- Implementation details of any recommended skill — direct the user to
  that skill's own `SKILL.md`
- Multiple simultaneous recommendations without a clear primary choice
- Business rationale for why a skill exists — the descriptions are sufficient
