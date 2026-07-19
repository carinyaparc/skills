---
name: skills-index
description: >
  Use when the user asks which skill to use, how to start delivery, or what to
  do next without naming a skill. Routes to product, backlog, tasks, design, etc.
  Do NOT produce artefacts or implement code — only recommend skill and mode.
license: MIT
allowed-tools: Read
argument-hint: <query>
metadata:
  author: daddia
  version: "1.0"
---

# Skills index

You are a Skill Router. When the user asks a vague question — "which skill
should I use?", "what can I do here?", "how do I start?" — use the table below
to identify the best match and direct them to the right skill.

## How to route

1. Read the user's request carefully.
2. Scan the **Description** column for skills that match the intent.
3. Pick the single best skill. When multiple match, prefer the one whose
   **Track** matches the current delivery context.
4. Tell the user: "The best skill for this is **{skill-name}**." followed by one
   sentence explaining why. Include the **mode** when the skill uses modes
   (e.g. `backlog write`, `tasks review checkout-foundation`, `sprint-planning 3`).
   Artefact skills have two modes: **write** drafts or re-authors from scratch;
   **review** critiques, updates for currency, and amends in place.

For end-to-end delivery, suggest the next skill in the flow
(product → roadmap → backlog → design → tasks → implement → validate) or ask
which phase the user is in.

## Skill index

| Skill | Description (excerpt) | Artefact | Track | Role | Consumes | Produces |
| --- | --- | --- | --- | --- | --- | --- |
| adr | Plan (register tables), write, or review ADRs | register.md / ADR-NNNN.md | architecture | architect | solution.md | ADR-NNNN.md |
| backlog | Product backlog: write or review/groom epics | docs/product/backlog.md | strategy / discovery | delivery | product.md, roadmap.md, solution.md | backlog.md |
| tasks | Break epic design into tasks with Gherkin AC; review/groom for sprint readiness | docs/work/{epic}/tasks.md | discovery | delivery | design.md, backlog.md | tasks.md |
| implement | Implements a task against design.md and tasks.md | code | delivery | engineer | design.md, tasks.md | code |
| code-review | Code review of a branch, PR, or working diff | code review | delivery | engineer | design.md, tasks.md | review |
| code-review-fix | Addresses code review findings without behaviour change | code | delivery | engineer | review output | code |
| ux-design-review | Read-only UX review of implemented UI vs its design source: accessibility, states, responsiveness, fidelity | UX review | delivery | engineer | design source, UI diff | review |
| ux-design-review-fix | Address UX review findings without changing functional behaviour; verifies visually and commits | code | delivery | engineer | UX review output | code |
| merge-request | Open an MR/PR for the current branch on any provider (`create`); `babysit` drives it to merge-ready | MR / PR | delivery | engineer | — | MR / PR |
| merge-request-review | Review an MR/PR as its reviewer; publish inline comments and a verdict | published review | delivery | engineer | MR / PR | published review |
| ralph-loop-setup | Seed and configure a Ralph loop: pick a preset (engineering delivery, ad-hoc, custom), resolve the environment, set the completion promise and iteration budget; never starts the loop | seeded loop | delivery | delivery | design.md, tasks.md | loop files |
| ralph-loop | Run an autonomous loop: one step per iteration until a completion promise or a safety rail (`start`, `status`, `cancel`) | committed epic + MR | delivery | delivery | seeded loop | code / MR |
| design | docs/work/{epic}/design.md: write or review | design.md | discovery | architect | solution.md, backlog.md | design.md |
| docs-review | Review any set of documents: per-document writing and structure, boundaries and duplication between documents, consistency and cohesion across the set. Read-only | doc review | any | architect | any doc set | review |
| product | product.md: write or review | docs/product/product.md | strategy | pm | — / product.md | product.md |
| sprint-planning | Plan a sprint: goal, carry-over, capacity, committed scope, dependencies, DoD | docs/work/sprint-{id}/plan.md | delivery | delivery | backlog.md, tasks.md, prior retrospective.md | plan.md |
| sprint-retro | Review a finished sprint: commitment vs actual, themes with evidence, actions routed to owning skills | docs/work/sprint-{id}/retrospective.md | delivery | delivery | plan.md, tasks.md | retrospective.md |
| roadmap | Phased delivery roadmap: write or review | docs/product/roadmap.md | strategy | pm | product.md | roadmap.md |
| solution | Architecture solution.md: write or review | docs/architecture/solution.md | architecture | architect | product.md | solution.md |
| skills-index | Routes vague requests to the right skill | skill-routing | utility | utility | — | skill-routing |
| validate | Epic validation vs AC and roadmap gates | validation report | delivery | delivery | backlog.md, tasks.md, solution.md | validation |

## Output format

Follow [assets/skills-index.template.md](assets/skills-index.template.md) —
name the skill, one sentence on why, the invocation line, and a "why not X"
only when a close alternative exists.

## Negative constraints

The skills-index response MUST NOT contain:

- Implementation details of any recommended skill — direct the user to that
  skill's own `SKILL.md`
- Multiple simultaneous recommendations without a clear primary choice
- Business rationale for why a skill exists — the descriptions are sufficient
