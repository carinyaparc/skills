# Carinya Parc Agent Skills for Digital Product Delivery

Opinionated skills that guide an AI agent through the full product delivery loop — from strategy and architecture to epics, implementation, review, and sprint-end refinement.

Each skill produces one clear artefact (a markdown file or code change). Skills chain together: the agent reads what you already wrote and knows what *not* to put in the wrong document.

**Any work item, not just epics.** `tasks`, `tdd`, `validate`, `backlog-refine`, and `ralph-loop-setup` accept any work item ID — an epic, a story, a bug, or a spike — from Linear, Jira, GitHub/GitLab issues, or plain markdown. The agent resolves the source system and type first (asking you when it's ambiguous, never guessing) and decomposes or acts accordingly: `/tasks JIRA-123` on a story writes sub-tasks; `/tasks CHK01` on an epic writes stories and tasks. See [work item resolution](skills/tasks/references/work-item-resolution.md).

## Getting started

Ask your agent:

```text
"Setup Carinya Parc skills locally from this repo:
https://github.com/carinyaparc/skills

Clone it and tell me:
- What skills I have and what they do?
- How can I use the new skills?
```

### Install as a plugin

#### Cursor

```bash
git clone https://github.com/carinyaparc/skills.git ~/.cursor/plugins/local/carinyaparc-agent-skills
```

#### Claude Code

```sh
git clone https://github.com/carinyaparc/skills.git ~/.claude/plugins/carinyaparc-agent-skills
claude --plugin-dir ~/.claude/plugins/carinyaparc-agent-skills
```

### Install skills from [skills.sh](https://skills.sh)

```bash
# All skills from this repo
npx skills@latest add carinyaparc/skills

# Or one skill at a time
npx skills@latest add carinyaparc/skills/code-review
npx skills@latest add carinyaparc/skills/sprint-planning
npx skills@latest add carinyaparc/skills/ux-design-review
```

### Try your first commands

```text
/product --stage pitch
/roadmap
/tasks --product
/tdd checkout-foundation --mode skeleton
/tasks checkout-foundation
/implement CHK01-01
/code-review
/code-review-fix
/merge-request CHK01-01
/validate checkout-foundation
```

Not sure where to start? Use **skills-index**, or follow the [typical flow](#typical-flow) below.

## Skills overview

| Stage | Key outcome(s) | Skills |
| ----- | -------------- | ------ |
| Planning | _What, why, and when?_ | **product**, **roadmap**, **tasks** |
| Architecture | _How? Structure? Principles?_ | **solution**, **adr** |
| Discovery | _Ready for Development_ | **tdd**, **tasks**, **backlog-refine** |
| Delivery | _Definition of Done_ | **implement**, **code-review**, **code-review-fix**, **ux-design-review**, **ux-design-fix**, **merge-request**, **ralph-loop** |
| Release | _Ready for Release_ | **merge-request-review**, **merge-request-babysit**, **validate** |
| Refine | _What did we learn?_ | **sprint-planning**, **sprint-retro**, **docs-review** |

## Typical flow

```text
        product → solution → roadmap → backlog
                        ↓
             tdd → tasks (+ ADR optional)
                        ↓
    implement → code-review → code-review-fix
   (+ ux-design-review → ux-design-fix for UI changes)
                        ↓
   merge-request (+ babysit) → merge-request-review
                        ↓
              validate (work item done?)
                        ↓
        sprint-retro, docs-review (ongoing)
```

Or run the whole delivery stage autonomously: `/ralph-loop-setup {work-id}`
then `/ralph-loop start` loops implement → code-review → code-review-fix →
ux-design-review → commit per task, then a final review, validation, and the
merge request — one step per iteration until the completion promise is
genuinely true.

The loop is not limited to software. It ships three presets:
`engineering-delivery` (the flow above), `ad-hoc` (repeat one prompt until
done), and `custom` (your own steps). See
[preset authoring](skills/ralph-loop/references/preset-authoring.md) for a
worked non-engineering example.

The ralph-loop skills are driven by this plugin's own stop hooks (`hooks/`),
shipped for both Cursor and Claude Code. Loop state lives in `.claude/loop/`
or `.cursor/loop/`. If you also have a standalone Ralph loop plugin installed
(e.g. `ralph-loop-plugin` or `ralph-wiggum`), disable it — two stop hooks
firing per turn would conflict.

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
    ├── checkout-foundation/     # epic (or a tracker key, e.g. JIRA-123/)
    │   ├── tdd.md
    │   └── tasks.md
    └── sprint-3/
        ├── plan.md
        └── retrospective.md
```

**Work item ID `{work-id}`** — resolved per [work-item-resolution.md](skills/tasks/references/work-item-resolution.md). When Linear or Jira is configured, `{work-id}` is the tracker's own key (`JIRA-123`, `ENG-45`) and skills write a `TASKS.local.md` pointer at your repo root so they don't re-detect it every time — add that file to `.gitignore`. With no tracker, `{work-id}` is an internal ID (`CHK01`) and the epic's folder name is a kebab-case slug of its title, at most two words (`Checkout Foundation` → `checkout-foundation`); resolve the slug from the backlog row when invoking skills. A story, bug, or spike given its own TDD or breakdown gets its own `docs/work/{work-id}/` folder alongside its parent epic's, not nested inside it.

Full path and boundary rules: [delivery conventions](skills/tasks/references/delivery-conventions.md).

## Skill catalogue

`adr` is the only skill left with modes; it takes the mode first
(`/adr plan CHK01`). The rest take their argument directly
(`/tasks checkout-foundation`, `/sprint-planning 3`).

### Product Strategy

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **product** | — | Pitch or full `product.md` (_why_, _who_, _what_); review via `docs-review` | `docs/product/product.md` |
| **roadmap** | — | Outcome-based phases with exit criteria; review via `docs-review` | `docs/product/roadmap.md` |

### Architecture

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **solution** | — | Stub or full arc42-lite `solution.md`; review via `docs-review` | `docs/architecture/solution.md` |
| **adr** | plan, write, review | Proposals in `register.md`; accepted decisions as `ADR-NNNN-{title}.md` | `register.md`, `ADR-NNNN.md` |

### Discovery

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **tdd** | — | Technical design document at `docs/work/{work-id}/tdd.md` for any work item — epic, story, bug, or spike (`skeleton` or `full`); review via `docs-review`. Not test-driven development — that is `implement` | `docs/work/{work-id}/tdd.md` |
| **tasks** | — | Decompose any work item: a product into epics, an epic into stories and tasks with Gherkin AC, a story into sub-tasks, or a spec/RFC/PRD into both. Resolves Linear/Jira/GitHub/filesystem first | `docs/product/backlog.md`, `docs/work/{work-id}/tasks.md`, or the tracker directly |
| **backlog-refine** | — | Groom an existing backlog or judge sprint readiness: reprioritise, split, re-estimate, defer. Amends in place and reports a verdict | `backlog.md`, `tasks.md` |

### Delivery

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **implement** | — | Implement a task against approved design and tasks | code |
| **code-review** | — | Review a branch, PR, or working diff against its acceptance criteria and declared scope. Read-only: writes a verdict, never source | code review |
| **code-review-fix** | — | Address findings from a code review without changing observable behaviour; runs the project's validation suite and commits | code |
| **ux-design-review** | — | Live-first UX review of implemented UI vs its design source (Figma via MCP, mockups, tokens): accessibility (WCAG 2.2 AA), states, responsiveness, fidelity, design-system conformity. Read-only: drives the browser once, writes a verdict and captures, never source | UX review |
| **ux-design-fix** | — | Change how existing UI looks or behaves — from a UX review verdict or a direct instruction. Fixes via tokens and library components, re-renders to verify, re-checks neighbours, commits | code |
| **merge-request** | — | Open an MR/PR on any provider (GitHub, GitLab, Bitbucket) with a template-aware description. Never modifies source | MR / PR |
| **ralph-loop-setup** | (interview) | Seed and configure a Ralph loop: choose a preset (engineering delivery, ad-hoc, custom), resolve the environment, set the promise and iteration budget; writes the loop files, never starts them | seeded loop |
| **ralph-loop** | start, status, cancel | Run an autonomous loop: one step per iteration, plugin hooks re-feed the prompt until the completion promise is genuinely true or a safety rail fires | committed work item + MR |

### Release

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **merge-request-review** | — | Review an MR/PR as its reviewer and publish inline comments and an approve / request-changes verdict; handles re-review rounds | published review |
| **merge-request-babysit** | — | Drive an open MR/PR to merge-ready: watch CI, fix objective failures, triage review threads, sync conflicts. Never merges | merge-ready MR |
| **validate** | — | Work item completion vs tasks and, for an epic, roadmap gates | validation report |

### Refine

| Skill | Modes | Description | Artefact |
| ----- | ----- | ----------- | -------- |
| **sprint-planning** | — | Plan a sprint: goal, carry-over, capacity, committed scope, dependencies, DoD | `docs/work/sprint-{id}/plan.md` |
| **sprint-retro** | — | Review a finished sprint: commitment vs actual, themes with evidence, actions routed to owning skills | `docs/work/sprint-{id}/retrospective.md` |
| **docs-review** | — | Review any set of documents: writing and structure per document, boundaries and duplication between them, consistency and cohesion across the set. Read-only | doc review |
| **skills-index** | — | “Which skill should I use?” for open-ended questions | routing |

## License

Copyright (c) 2026 Carinya Parc. Released under the [MIT License](LICENSE).
