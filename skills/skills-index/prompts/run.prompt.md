# Skills index

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
   (e.g. `backlog write`, `tasks write checkout-foundation`, `sprint plan 3`).

## Skill index

| Skill | Description (excerpt) | Artefact | Track | Role | Consumes | Produces |
| --- | --- | --- | --- | --- | --- | --- |
| adr | Plan (register tables), write, or review ADRs | register.md / ADR-NNNN.md | architecture | architect | solution.md | ADR-NNNN.md |
| backlog | Product backlog: write, review, refine epics | docs/product/backlog.md | strategy / discovery / refine | delivery | product.md, roadmap.md, solution.md | backlog.md |
| tasks | Break epic design into tasks with Gherkin AC | docs/work/{epic}/tasks.md | discovery | delivery | design.md, backlog.md | tasks.md |
| implement | Implements a task against design.md and tasks.md | code | delivery | engineer | design.md, tasks.md | code |
| code-review | Code review of a branch or PR; `fix` addresses review feedback without behaviour change | code review / code | delivery | engineer | design.md, tasks.md, review | review / code |
| create-mr | Merge request for current branch | MR description | delivery | engineer | — | MR description |
| design | docs/work/{epic}/design.md: write or review | design.md | discovery | architect | solution.md, backlog.md | design.md |
| docs | Pre-sprint doc review or sprint-end refine-session | doc review / refine-session | refine / discovery | architect | product.md, solution.md | review / refine-session |
| product | product.md: write, review, refine | docs/product/product.md | strategy / refine | pm | — / product.md | product.md |
| sprint | Sprint plan or retrospective | plan.md / retrospective.md | delivery / refine | delivery | tasks.md, backlog.md | plan.md / retrospective.md |
| roadmap | Phased delivery roadmap | docs/product/roadmap.md | strategy / refine | pm | product.md | roadmap.md |
| solution | Architecture solution.md | docs/architecture/solution.md | architecture / refine | architect | product.md | solution.md |
| skills-index | Routes vague requests to the right skill | skill-routing | utility | utility | — | skill-routing |
| validate | Epic validation vs AC and roadmap gates | validation report | delivery | delivery | backlog.md, tasks.md, solution.md | validation |

For end-to-end delivery, suggest the next skill in the flow (product → roadmap → backlog → design → tasks → implement → validate) or ask which phase the user is in.

## Negative constraints

The skills-index response MUST NOT contain:

- Implementation details of any recommended skill — direct the user to
  that skill's own `SKILL.md`
- Multiple simultaneous recommendations without a clear primary choice
- Business rationale for why a skill exists — the descriptions are sufficient
