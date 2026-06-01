# Agent Skills for AI-First Product Delivery

Opinionated agent skills for the full delivery loop — product strategy, architecture, backlog, design, implementation, review, and sprint-end refinement.

These skills are the executable form of a structured delivery method:

- **Phase model** — Phase 0 (walking skeleton) → Phase 2+ (TDD)
- **Topic skills with modes** — e.g. `product write`, `backlog review`, `feature implement`
- **Artefact references** — `{source}:{path}` URI scheme for cross-repo links
- **EARS + Gherkin** acceptance criteria at story level
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
```

Work-package artefacts live under `work/{wp}/` (`design.md`, `backlog.md`, etc.).

Each skill documents default paths under `docs/`. If you name a different path in your prompt, the agent uses that instead.

Skills follow the [Agent Skills](https://github.com/agentskills/agentskills) layout:
`SKILL.md`, `prompts/` for mode instructions, `assets/*.template.md` for artefact
scaffolds, and `examples/` for reference outputs.

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
| **backlog** | write, review, refine | `docs/product/backlog.md` or `work/{wp}/backlog.md` |
| **solution** | write, review, refine | `docs/architecture/solution.md` |
| **design** | write, review | `work/{wp}/design.md` |
| **docs** | review, refine | review / `refine-session.md` |
| **adr** | plan, write, review | `register.md`, `ADR-NNNN.md` |
| **feature** | implement | code |
| **code-review** | run | code review |
| **code-refactor** | run | code |
| **validate** | run | validation report |
| **create-mr** | run | MR / PR |
| **retrospective** | write | `retrospective.md` |
| **space-index** | run | routing |

Invoke with mode first, e.g. `/product write --stage pitch`, `/backlog write work-package checkout-01`. Override paths in natural language when needed (e.g. "write product.md to `docs/acme/product.md`").

## Planning & strategy

- **product** — Pitch or full `product.md`.
- **roadmap** — Outcome-based phases with exit criteria.
- **backlog** — Epic-level under `docs/product/`; stories under `work/{wp}/`.

## Architecture & design

- **solution** — Stub or full arc42-lite architecture.
- **adr** — Proposed rows in `register.md`; full ADRs as `ADR-NNNN-{title}.md`.
- **design** — Work-package `design.md`.

## Implementation

- **feature**, **code-review**, **code-refactor**, **validate**, **create-mr**

## Review & refine

- **docs**, **retrospective**, topic **review** / **refine** modes

## Routing

- **space-index** — Pick skill and mode for vague requests.

## Compatibility

[open agent skills](https://github.com/vercel-labs/skills) — `.cursor/skills/`, `.claude/skills/`, `.agents/skills/`.

## License

[MIT](LICENSE)
