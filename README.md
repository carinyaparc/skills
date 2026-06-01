# Agent Skills for AI-First Product Delivery

Opinionated agent skills for the full delivery loop — product strategy, architecture, backlog, design, implementation, review, and sprint-end refinement.

These skills are the executable form of a structured delivery method:

- **Phase model** — Phase 0 (walking skeleton) → Phase 2+ (TDD)
- **Track / role taxonomy** — strategy, discovery, architecture, delivery, refine
- **Artefact references** — `{source}:{path}` URI scheme for cross-repo links
- **EARS + Gherkin** acceptance criteria at story level
- **Negative constraints** — every skill explicitly states what it is *not* for

Designed to compose: each skill consumes upstream artefacts (`product.md`, `solution.md`,
`backlog.md`, `design.md`, code) and produces a single named artefact downstream skills
can read. Routing is description-based; a built-in router (`space-index`) handles
ambiguous requests.

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
npx skills@latest add daddia/skills/write-product
```

Source: skills are authored in
[github.com/daddia/space](https://github.com/daddia/space) under
`packages/skills/`. This repo is the public-facing distribution; PRs are welcome
upstream.

## Planning & Strategy

These skills sit at the front of the delivery loop — defining what to build, why, and in what sequence.

- **plan-delivery** — Sequence the five Phase-0 artefacts (`product.md`, `solution.md`,
  `roadmap.md`, `backlog.md`, `contracts.md`) for a new portfolio, product, or domain
  before the foundation sprint starts.

  ```bash
  npx skills@latest add daddia/skills/plan-delivery
  ```

- **product** — `product.md` artefact: **write** (pitch or full strategy), **review**, **refine**.

  ```bash
  npx skills@latest add daddia/skills/product
  ```

- **roadmap** — `roadmap.md` artefact: **write**, **review**, **refine**.

  ```bash
  npx skills@latest add daddia/skills/roadmap
  ```

- **backlog** — `backlog.md` artefact with three modes: **write** (draft epics/stories),
  **review** (readiness gate), **refine** (groom). Work-package write produces EARS +
  Gherkin acceptance criteria per story.

  ```bash
  npx skills@latest add daddia/skills/backlog
  ```

## Architecture & Design

Solution architecture, ADRs, contracts, and work-package design.

- **write-solution** — Draft `solution.md` in stub mode (Phase 0, two sections) or full
  arc42-lite mode (Phase 2+, ten sections).

  ```bash
  npx skills@latest add daddia/skills/write-solution
  ```

- **write-tech-stack** — Draft `tech-stack.md` defining technology choices with rationale
  and trade-offs for each subsystem.

  ```bash
  npx skills@latest add daddia/skills/write-tech-stack
  ```

- **write-contracts** — Produce `contracts.md` for a domain as an executable index of types, Zod schemas, API route contracts, and analytics event payloads.

  ```bash
  npx skills@latest add daddia/skills/write-contracts
  ```

- **plan-adr** — Identify the architecture decisions that need ADRs and produce a prioritised `adr-plan.md` before technical design begins.

  ```bash
  npx skills@latest add daddia/skills/plan-adr
  ```

- **write-adr** — Document a consequential architecture decision as an
  `ADR-NNNN.md` file in the ADR register format.

  ```bash
  npx skills@latest add daddia/skills/write-adr
  ```

- **write-wp-design** — Draft a work-package `design.md` in walking-skeleton mode
  (foundation sprint, 2–4 pages) or TDD mode (sprint 2+, 5–10 pages).

  ```bash
  npx skills@latest add daddia/skills/write-wp-design
  ```

## Implementation

Code production and pre-merge surface.

- **implement** — Implement code for a story or task against an approved `design.md` and
  `backlog.md`. Reads design first, then makes targeted changes following existing
  patterns.

  ```bash
  npx skills@latest add daddia/skills/implement
  ```

- **refactor-code** — Targeted code refactoring to address review feedback or improve
  quality without changing behaviour.

  ```bash
  npx skills@latest add daddia/skills/refactor-code
  ```

- **validate** — Final stakeholder validation that an epic is complete against its
  `backlog.md` acceptance criteria. Confirms every EARS and Gherkin holds and phase exit
  criteria in `roadmap.md` are met.

  ```bash
  npx skills@latest add daddia/skills/validate
  ```

- **create-mr** — Create a merge request or pull request for the current branch with a
  generated title, description, labels, and reviewer suggestions.

  ```bash
  npx skills@latest add daddia/skills/create-mr
  ```

## Review

Document and code review skills, role-aware and structured.

- **product** (review mode) — See **product** above.

- **roadmap** (review mode) — See **roadmap** above.

- **review-solution** — Review `solution.md` as a Senior Solution Architect — structural soundness, NFR coverage, section completeness.

  ```bash
  npx skills@latest add daddia/skills/review-solution
  ```

- **review-adr** — Review and finalise a draft Architecture Decision Record. Checks completeness, alternatives considered, and consequences stated.

  ```bash
  npx skills@latest add daddia/skills/review-adr
  ```

- **backlog** (review mode) — See **backlog** above.

- **review-design** — Review a work-package `design.md` for implementation readiness — implementable, APIs and contracts referenced, scope clear.

  ```bash
  npx skills@latest add daddia/skills/review-design
  ```

- **review-docs** — Review `product.md` and `solution.md` for completeness and alignment before development begins. Flags gaps and drift between documents.

  ```bash
  npx skills@latest add daddia/skills/review-docs
  ```

- **review-code** — Comprehensive code review of changes in a branch or PR — quality, correctness, security, and compliance with `design.md` and `backlog.md` acceptance criteria.

  ```bash
  npx skills@latest add daddia/skills/review-code
  ```

## Refine

Sprint-end and cadence skills that close the loop and roll learnings forward.

- **product** (refine mode) — See **product** above.

- **roadmap** (refine mode) — See **roadmap** above.

- **refine-solution** — Refine `solution.md` after a sprint or phase to reflect what was
  built — update building-block view, runtime, decisions taken.

  ```bash
  npx skills@latest add daddia/skills/refine-solution
  ```

- **backlog** (refine mode) — See **backlog** above.

- **refine-docs** — Document the sprint-end refinement session: promote work-package
  ADR candidates into `solution.md`, archive superseded design sections, capture every
  decision in `refine-session.md`.

  ```bash
  npx skills@latest add daddia/skills/refine-docs
  ```

- **write-retrospective** — Draft a `retrospective.md` capturing what went well, what
  didn't, and what to change, for a sprint or epic.

  ```bash
  npx skills@latest add daddia/skills/write-retrospective
  ```

- **write-metrics-report** — Produce a `metrics-report.md` capturing actuals for delivery
  metrics (velocity, cycle time, PR merge rate) and quality metrics for a sprint or
  phase.

  ```bash
  npx skills@latest add daddia/skills/write-metrics-report
  ```

## Routing

Meta-skill that helps the agent pick from the rest.

- **space-index** — Identify the right skill for a vague or open-ended request. Use when
  the user asks "which skill should I use?", "what can I do?", or "how do I start
  this?". Presents a CI-generated table of every stable skill so the agent can route to
  the correct one.

  ```bash
  npx skills@latest add daddia/skills/space-index
  ```

## Compatibility

These skills follow the [open agent skills](https://github.com/vercel-labs/skills)
specification. They install into:

- `.cursor/skills/` (Cursor 2.4+)
- `.claude/skills/` (Claude Code)
- `.agents/skills/` (canonical, picked up by both natively)
- And any other host that reads agent skill directories.

Routing is description-based: agents pre-load every installed skill's `name` and
`description` and pick the right skill per request. Skills declare daddia-specific
metadata (`track`, `role`, `stage`, `consumes`, `produces`) which is ignored by agents
but used by daddia's authoring tools for views, profiles, and routing evals.

## Methodology

These skills express a delivery method developed alongside
[Space](https://github.com/daddia/space) (the workspace platform) and
[Crew](https://github.com/daddia/crew) (the autonomous delivery runtime). The skills
work standalone — install one, get value. Used together with Space, you get profile
bundles, an authoring toolkit, and an automated workspace lifecycle.

For a deeper look at the artefact model, phase model, and skill anatomy, see
[`daddia/space/architecture/skills/`](https://github.com/daddia/space/tree/main/architecture/skills).

## License

[MIT](LICENSE)
