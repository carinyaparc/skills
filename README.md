# Agent Skills for AI-First Product Delivery

Opinionated agent skills for the full delivery loop — product strategy, architecture, backlog, design, implementation, review, and sprint-end refinement.

These skills are the executable form of a structured delivery method:

- **Phase model** — Phase 0 (walking skeleton) → Phase 2+ (TDD)
- **Topic skills with modes** — e.g. `product write`, `backlog review`, `code implement`
- **Artefact references** — `{source}:{path}` URI scheme for cross-repo links
- **EARS + Gherkin** acceptance criteria at story level
- **Negative constraints** — every skill explicitly states what it is *not* for

Designed to compose: each skill consumes upstream artefacts (`product.md`, `solution.md`,
`backlog.md`, `design.md`, code) and produces a single named artefact downstream skills
can read. Routing is description-based; **space-index** handles ambiguous requests.

Skills work with [Cursor](https://cursor.com/docs/skills),
[Claude Code](https://docs.claude.com/en/docs/claude-code/skills), and any
[open agent skills](https://github.com/vercel-labs/skills) consumer.

## Install

Install everything:

```bash
npx skills@latest add daddia/skills
```

Install one skill:

```bash
npx skills@latest add daddia/skills/backlog
```

Source: skills are authored in
[github.com/daddia/space](https://github.com/daddia/space) under
`packages/skills/`. This repo is the public-facing distribution; PRs are welcome
upstream.

## Skill catalogue

Each topic skill uses `prompts/{mode}.prompt.md` for mode-specific instructions.

| Skill | Modes | Artefact |
| ----- | ----- | -------- |
| **product** | write, review, refine | `product.md` |
| **roadmap** | write, review, refine | `roadmap.md` |
| **solution** | write, review, refine | `solution.md` |
| **backlog** | write, review, refine | `backlog.md` |
| **design** | write, review | `design.md` (work package) |
| **docs** | review, refine | review / `refine-session.md` |
| **adr** | plan, write, review | `adr-plan.md`, `ADR-NNNN.md` |
| **code** | implement, review, refactor | code |
| **contracts** | write | `contracts.md` |
| **tech-stack** | write | `tech-stack.md` |
| **plan-delivery** | run | `delivery-plan.md` |
| **validate** | run | validation report |
| **create-mr** | run | MR / PR |
| **retrospective** | write | `retrospective.md` |
| **metrics-report** | write | `metrics-report.md` |
| **space-index** | run | routing |

### Examples

```bash
npx skills@latest add daddia/skills/product
npx skills@latest add daddia/skills/backlog
npx skills@latest add daddia/skills/code
```

Invoke with mode as the first argument, e.g. `/backlog write domain checkout`.

## Planning & strategy

- **plan-delivery** — Sequence Phase-0 artefacts before the foundation sprint.
- **product** — Portfolio, product, or domain `product.md` (pitch or full strategy).
- **roadmap** — Outcome-based phases with exit criteria.
- **backlog** — Epic- or story-level backlog with EARS + Gherkin at WP scope.

## Architecture & design

- **solution** — Stub or full arc42-lite `solution.md`.
- **tech-stack** — Technology choices with rationale.
- **contracts** — Executable contract index for a domain.
- **adr** — Plan, write, and review architecture decision records.
- **design** — Work-package `design.md` (walking-skeleton or TDD).

## Implementation

- **code** — Implement, review, or refactor against `design.md` and `backlog.md`.
- **validate** — Epic completion validation against AC and roadmap gates.
- **create-mr** — Open merge request with generated description.

## Review & refine

Topic skills include **review** and **refine** modes where applicable (see table above).

- **docs** — Pre-sprint alignment review or sprint-end `refine-session.md`.
- **retrospective** — Sprint or epic retrospective.
- **metrics-report** — Delivery and quality actuals.

## Routing

- **space-index** — Pick the right skill and mode for vague requests.

## Compatibility

These skills follow the [open agent skills](https://github.com/vercel-labs/skills)
specification. They install into:

- `.cursor/skills/` (Cursor 2.4+)
- `.claude/skills/` (Claude Code)
- `.agents/skills/` (canonical, picked up by both natively)

## Methodology

Developed alongside [Space](https://github.com/daddia/space) and
[Crew](https://github.com/daddia/crew). See
[`daddia/space/architecture/skills/`](https://github.com/daddia/space/tree/main/architecture/skills).

## License

[MIT](LICENSE)
