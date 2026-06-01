# Agent Skills for AI-First Product Delivery

Opinionated agent skills for the full delivery loop — product strategy, architecture, backlog, design, implementation, review, and sprint-end refinement.

These skills are the executable form of a structured delivery method:

- **Phase model** — Phase 0 (walking skeleton) → Phase 2+ (TDD)
- **Topic skills with modes** — e.g. `product write`, `backlog review`, `feature implement`
- **Artefact references** — `{source}:{path}` URI scheme for cross-repo links
- **Gherkin** acceptance criteria by default; **EARS** when `--ears` or warranted
- **Negative constraints** — every skill explicitly states what it is *not* for

Designed to compose: each skill consumes upstream artefacts and produces a single
named artefact downstream skills can read. Routing is description-based; **space-index**
handles ambiguous requests.

## Document layout (default)

```text
docs/
├── product/
│   ├── product.md
│   ├── roadmap.md
│   └── backlog.md
└── architecture/
    ├── solution.md
    └── decisions/
        ├── register.md
        └── ADR-NNNN-{title}.md

work/
├── checkout-foundation/     # epic — slug from title (max two words)
│   ├── design.md
│   ├── tasks.md
│   └── refine-session.md
└── sprint-3/
    ├── plan.md
    └── retrospective.md
```

Each skill documents default paths under `docs/` and `work/{epic}/`. Epic folder
`{epic}` is kebab-case from the epic title or short title (max two words). Override paths in your prompt when needed.

Skills follow the [Agent Skills](https://github.com/agentskills/agentskills) layout:
`SKILL.md`, `prompts/` for mode instructions, `assets/*.template.md` for artefact
scaffolds, `examples/` for reference outputs, and `evals/` for trigger and output
test cases. Shared path and boundary rules live in
[backlog/references/delivery-conventions.md](backlog/references/delivery-conventions.md).
See [CONTRIBUTING.md](CONTRIBUTING.md) for authoring and evaluation workflow.

Skills work with [Cursor](https://cursor.com/docs/skills),
[Claude Code](https://docs.claude.com/en/docs/claude-code/skills), and any
[open agent skills](https://github.com/vercel-labs/skills) consumer.

## Install

```bash
npx skills@latest add daddia/skills
npx skills@latest add daddia/skills/backlog
```

Source: [github.com/daddia/space](https://github.com/daddia/space) under `packages/skills/`.

## Skill catalogue

| Skill | Modes | Artefact |
| ----- | ----- | -------- |
| **product** | write, review, refine | `docs/product/product.md` |
| **roadmap** | write, review, refine | `docs/product/roadmap.md` |
| **backlog** | write, review, refine | `docs/product/backlog.md` |
| **tasks** | write, review, refine | `work/{epic}/tasks.md` |
| **solution** | write, review, refine | `docs/architecture/solution.md` |
| **design** | write, review | `work/{epic}/design.md` |
| **docs** | review, refine | review / `work/{epic}/refine-session.md` |
| **adr** | plan, write, review | `register.md`, `ADR-NNNN.md` |
| **sprint** | plan, retrospective | `work/sprint-{id}/plan.md`, `retrospective.md` |
| **feature** | implement | code |
| **code-review** | run | code review |
| **code-refactor** | run | code |
| **validate** | run | validation report |
| **create-mr** | run | MR / PR |
| **space-index** | run | routing |

Invoke with mode first, e.g. `/product write --stage pitch`, `/tasks write checkout-foundation`, `/sprint plan 3`.

## Planning & strategy

- **product** — Pitch or full `product.md`.
- **roadmap** — Outcome-based phases with exit criteria.
- **backlog** — Product backlog (epics); optional `--stories` for small products.

## Architecture & delivery per epic

- **solution** — Stub or full arc42-lite architecture.
- **adr** — Proposed rows in `register.md`; full ADRs as `ADR-NNNN-{title}.md`.
- **design** — `work/{epic}/design.md`.
- **tasks** — `work/{epic}/tasks.md` from design (Gherkin default).

## Implementation

- **feature**, **code-review**, **code-refactor**, **validate**, **create-mr** (consume `tasks.md` for AC)

## Sprint

- **sprint plan** / **sprint retrospective** — under `work/sprint-{id}/`

## Review & refine

- **docs**, topic **review** / **refine** modes

## Routing

- **space-index** — Pick skill and mode for vague requests.

## Compatibility

[open agent skills](https://github.com/vercel-labs/skills) — `.cursor/skills/`, `.claude/skills/`, `.agents/skills/`.

## License

[MIT](LICENSE)
