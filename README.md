# Agent Skills for AI-First Product Delivery

Opinionated skills that guide an AI agent through the full product delivery loop — from strategy and architecture to epics, implementation, review, and sprint-end refinement.

Each skill produces one clear artefact (a markdown file or code change). Skills chain together: the agent reads what you already wrote and knows what *not* to put in the wrong document.

## Getting started

Ask your agent:

```text
"Setup daddia skills locally from this repo:
https://github.com/daddia/skills

Clone it and tell me:
- What skills I have and what they do?
- How can I use the new skills?
```

### Install as a plugin

#### Cursor

```bash
git clone https://github.com/daddia/skills.git ~/.cursor/plugins/local/daddia-skills
```

#### Claude Code

```sh
git clone https://github.com/daddia/skills.git ~/.claude/plugins/daddia-skills
claude --plugin-dir ~/.claude/plugins/daddia-skills
```

### Install skills from [skills.sh](https://skills.sh)

```bash
# All skills from this repo
npx skills@latest add daddia/skills

# Or one skill at a time
npx skills@latest add daddia/skills/backlog
```

### Try your first commands

```text
/product write --stage pitch
/roadmap write
/backlog write
/design write checkout-foundation --mode walking-skeleton
/tasks write checkout-foundation
/implement CHK01-01
/code-review
/merge-request CHK01-01
/validate checkout-foundation
```

Not sure where to start? Use **skills-index**, or follow the [typical flow](#typical-flow) below.

## Skills overview

| Stage | Key outcome(s) | Skills |
| ----- | -------------- | ------ |
| Planning | _What, why, and when?_ | **product**, **roadmap**, **backlog** |
| Architecture | _How? Structure? Principles?_ | **solution**, **adr** |
| Discovery | _Ready for Development_ | **design**, **tasks** |
| Delivery | _Definition of Done_ | **implement**, **code-review**, **ux-design-review**, **merge-request** |
| Release | _Ready for Release_ | **merge-request-review**, **validate** |
| Refine | _What did we learn?_ | **sprint**, **docs** |

## Typical flow

```text
        product → solution → roadmap → backlog
                        ↓
            design → tasks (+ ADR optional)
                        ↓
    implement → code-review → code-review fix
          (+ ux-design-review for UI changes)
                        ↓
   merge-request (+ babysit) → merge-request-review
                        ↓
              validate (epic done?)
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
    ├── checkout-foundation/     # epic
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
| **implement** | — | Implement a task against approved design and tasks | code |
| **code-review** | review | Review a branch or PR against design.md and tasks.md acceptance criteria | code review |
| **code-review fix** | fix | Address review findings without behaviour changes | code |
| **ux-design-review** | review, fix | Live-first UX review of implemented UI vs its design source (Figma via MCP, mockups, tokens): fidelity, accessibility (WCAG 2.2 AA), states, responsiveness, design-system conformity | UX review / code |
| **merge-request** | create, babysit | Open an MR/PR on any provider (GitHub, GitLab, Bitbucket) with template-aware description; `babysit` drives it to merge-ready | MR / PR |

### Release

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **merge-request-review** | run | Review an MR/PR as its reviewer and publish inline comments and an approve / request-changes verdict; handles re-review rounds | published review |
| **validate** | run | Epic completion vs tasks and roadmap gates | validation report |

### Refine

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **sprint** | plan, retrospective | `plan.md` before the sprint; `retrospective.md` after | `docs/work/sprint-{id}/plan.md`, `retrospective.md` |
| **docs** | review, refine | Pre-sprint alignment or sprint-end doc pass on product, solution, and epic design | review / `docs/work/{epic}/refine-session.md` |
| **skills-index** | run | “Which skill should I use?” for open-ended questions | routing |

## License

Copyright (c) 2026 daddia. Released under the [MIT License](LICENSE).
