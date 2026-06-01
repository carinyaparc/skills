# Agent Skills for AI-First Product Delivery

Opinionated skills that guide an AI agent through the full product delivery loop — from strategy and architecture to epics, implementation, review, and sprint-end refinement.

Each skill produces one clear artefact (a markdown file or code change). Skills chain together: the agent reads what you already wrote and knows what *not* to put in the wrong document.

## Skills overview

| Stage | Key outcome(s) | Skills |
| ----- | -------------- | ------ |
| Planning | What, why, and when? | **product**, **roadmap**, **backlog** |
| Architecture | How? Structure? Principles? | **solution**, **adr** |
| Discovery | Ready for Development | **design**, **tasks** |
| Delivery | Definition of Done | **feature**, **code-review**, **create-mr** |
| Release | Ready for Release | **review-mr**, **validate** |
| Refine | What did we learn? | **sprint**, **docs** |

## Typical flow

```text
        product → solution → roadmap → backlog
                        ↓
            design → tasks (+ ADR optional)
                        ↓
    feature → code-review → code-review fix → create-mr
                        ↓
          review-mr → validate (epic done?)
                        ↓
            sprint retro, docs (ongoing)
```

## Where files live in your project

Default layout the skills expect (override paths in your prompt if your repo differs):

```text
docs/
├── product/
│   ├── product.md
│   ├── roadmap.md
│   └── backlog.md
├── architecture/
│   ├── solution.md
│   └── decisions/
│       ├── register.md
│       └── ADR-NNNN-{title}.md
└── work/
    ├── checkout-foundation/     # epic — slug from title (max two words)
    │   ├── design.md
    │   ├── tasks.md
    │   └── refine-session.md
    └── sprint-3/
        ├── plan.md
        └── retrospective.md
```

**Epic slug `{epic}`** — kebab-case from the epic title or short title, at most two words (`Checkout Foundation` → `checkout-foundation`). Epic IDs like `CHK01` stay in the backlog table; resolve the slug from that row when invoking skills.

Full path and boundary rules: [delivery conventions](skills/backlog/references/delivery-conventions.md).

## Skill catalogue

Invoke with the mode first: `/tasks write checkout-foundation`, `/sprint plan 3`.

### Planning

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **product** | write, review, refine | Pitch or full `product.md` (_why_, _who_, _what_) | `docs/product/product.md` |
| **roadmap** | write, review, refine | Outcome-based phases with exit criteria | `docs/product/roadmap.md` |
| **backlog** | write, review, refine | Epics and work paths; optional `--stories` for small products | `docs/product/backlog.md` |

### Architecture

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **solution** | write, review, refine | Stub or full arc42-lite `solution.md` | `docs/architecture/solution.md` |
| **adr** | plan, write, review | Proposals in `register.md`; accepted decisions as `ADR-NNNN-{title}.md` | `register.md`, `ADR-NNNN.md` |

### Discovery

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **design** | write, review | `docs/work/{epic}/design.md` (walking-skeleton or TDD) | `docs/work/{epic}/design.md` |
| **tasks** | write, review, refine | `docs/work/{epic}/tasks.md` with Gherkin AC from design | `docs/work/{epic}/tasks.md` |

### Delivery

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **feature** | implement | Implement against approved design and tasks | code |
| **code-review** | review, fix | Review a branch or PR; **fix** addresses findings without behaviour changes | code review / code |
| **validate** | run | Epic completion vs tasks and roadmap gates | validation report |
| **create-mr** | run | Merge request description from the branch | MR / PR |

### Refine

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **sprint** | plan, retrospective | `plan.md` before the sprint; `retrospective.md` after | `docs/work/sprint-{id}/plan.md`, `retrospective.md` |
| **docs** | review, refine | Pre-sprint alignment or sprint-end doc pass on product, solution, and epic design | review / `docs/work/{epic}/refine-session.md` |
| **skills-index** | run | “Which skill should I use?” for open-ended questions | routing |

## Getting started

### Install skills from [skills.sh](https://skills.sh)

```bash
# All skills from this repo
npx skills@latest add daddia/skills

# Or one skill at a time
npx skills@latest add daddia/skills/backlog
```

### Install as a plugin

For the full set in one package — all skills plus review helpers — install the **Space** plugin from this repository:

1. Clone or copy this repo.
2. Place it so `.cursor-plugin/plugin.json` (or `.claude-plugin/plugin.json`) is at the plugin root.
3. In Cursor: `~/.cursor/plugins/local/space/` then reload the window. See [Cursor plugins](https://cursor.com/docs/plugins).

Same skills; the plugin is convenience for local/team use.

### First commands to try

```text
/product write --stage pitch
/roadmap write
/backlog write
/design write checkout-foundation --mode walking-skeleton
/tasks write checkout-foundation
/feature implement CHK01-01
/code-review
/validate checkout-foundation
```

Not sure where to start? Use **skills-index**, or follow the [typical flow](#typical-flow) below.

## License

Copyright (c) 2026 daddia. All rights reserved. Released under the [MIT](LICENSE).
