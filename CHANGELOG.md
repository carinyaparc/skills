# Changelog

Version numbers match Git tags and `version` in `.cursor-plugin/plugin.json` and
`.claude-plugin/plugin.json`. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

- **BREAKING: `backlog` is removed, merged into `tasks`.** One skill now
  decomposes at every level: `tasks --product` writes epics into `backlog.md`,
  `tasks {epic}` writes stories and tasks, and `tasks {spec-path}` writes both
  in one pass from any spec, RFC or PRD. The epic/story split was arbitrary —
  an epic is a big story — and both skills carried duplicate decomposition
  rules, which is why they collided on `--stories`.
- **BREAKING: `tasks` has no modes and is flat.** `write`/`review` dropped;
  `prompts/` deleted. Gains a stated decomposition method (vertical slices over
  horizontal layers, sizing bounds, split triggers, dependency ordering, `[P]`
  markers, MVP naming) which it previously had none of — the old write prompt's
  entire method was "read design.md, draft using the template".
- **BREAKING: `tasks.md` is two-level.** Stories carry the statement, the
  independent test criterion and the Gherkin AC; tasks carry deliverables with
  concrete file paths and an `[S{n}]` label. Task IDs are unchanged, so
  `implement`, `sprint-planning` and `validate` keep working on the same
  identifiers.
- **`delivery-conventions.md` moved** to `skills/tasks/references/`, along with
  `check-epic-paths.sh`, the backlog template and example. Nine skills plus
  `README.md`, `CONTRIBUTING.md` and `validate-skills.sh` referenced the old
  path and were updated.
- **BREAKING: `docs` → `docs-review`.** Read-only review only; refine/edit removed.
- **BREAKING: `refine` removed** from `product`, `roadmap`, `solution`,
  `backlog`, and `tasks`. Use `review` (includes the currency pass).
- **BREAKING: `ux-design-review fix` / `code-review fix` removed.** Use
  `ux-design-fix` / `code-review-fix`. Reviews are read-only; lenses reduced;
  code-review gains independent verifier, incremental review, learnings, CI ingestion.
- **BREAKING: `sprint` → `sprint-planning` + `sprint-retro`.** Modes dropped
  (`sprint-planning 3`, not `sprint plan 3`). Planning: capacity, carry-over,
  committed-vs-stretch. Retro: commitment-vs-actual, goal verdict, routed actions;
  cannot edit `plan.md`.
- **BREAKING: `merge-request babysit` → `merge-request-babysit`**;
  `merge-request create` → `merge-request` (`create` is now a work-item ID).
  Create is scoped to git/gh/glab only; babysit keeps full Bash + Edit.
- Spec alignment: space-separated `allowed-tools`, `Shell` → `Bash`, `metadata`
  on every skill, single-mode skills flattened into `SKILL.md`.
- **`adr plan` takes an optional epic.** `adr plan <epic>` harvests decisions
  already made in `docs/work/{epic}/design.md`, triaging each into promote /
  inline / defer. Without an epic it surveys product and solution as before.
  `design` and `solution review` point at it; `sprint-retro`'s architecture
  track routes to it.
- Trigger phrases added to every description that lacked them; `owner` /
  `work_shape` / `output_class` completed repo-wide. `ralph-loop` excluded from
  both, deliberately.

### Added

- **`backlog-refine`** — backlog grooming (remove → split → prioritise →
  re-estimate → tighten acceptance) and sprint-readiness review of `backlog.md`
  or an epic's `tasks.md`. Carries the recurring grooming pass that a purely
  generative `tasks` should not own, plus the readiness check `tasks review`
  used to do. Forbidden from changing task IDs — they are the contract with
  `implement`, `sprint-planning` and `validate`.
- **`tasks/references/work-item-schema.md`** — epic, story and task definitions
  with the legal value of every field, plus shared priority, type and status
  vocabularies. The old "canonical task schema" named nine fields and defined
  none of them.
- **`tasks/references/acceptance-criteria.md`** — Gherkin rules with an
  observable/not-observable table, and all five EARS patterns with worked
  examples. EARS was referenced four times in the old skill and specified
  nowhere, so `--ears` was unactionable for any model that did not already
  know the notation.
- `docs-review`, `ux-design-fix`, `code-review-fix`, `sprint-planning`,
  `sprint-retro`, `merge-request-babysit`.

### Fixed

- **Restored the ADR promotion path.** When `docs` became read-only
  `docs-review`, its sprint-end pass went with it — the only route from an ADR
  candidate in an epic's `design.md` into the register. `adr plan` read only
  product, solution, and the register, so decisions made during delivery had
  nowhere to go while `solution review` still claimed promotion was `adr`'s job.
- Stale README/`refine` routing; `ralph-loop` `allowed-tools` YAML list;
  broken `delivery-conventions.md` links in `tasks`/`design`;
  ralph preset now uses `/merge-request --draft` (not `create`).

## [2.0.0] - 2026-07-19

- **BREAKING: `ralph` → `ralph-loop` + `ralph-loop-setup`.** State moves from
  `.ralph/` to `.claude/loop/` or `.cursor/loop/`.
- Added shared hook library, session isolation, iteration ceiling, presets,
  seed/test/mutation scripts.
- Fixed loop continuing past iteration 1 (`set -e`, frontmatter `sed`, transcript
  parse, body-line rewrites).
- **Migration:** cancel 1.x loops, delete `.ralph/` and `.ralph-loop`, re-seed
  with `/ralph-loop-setup`.

## [1.6.0] - 2026-07-04

- Added **ralph** skill and plugin-level stop hooks for autonomous epic loops.

## [1.5.0] - 2026-07-04

- Added **ux-design-review** — live UX review of implemented UI (review/fix).

## [1.4.0] - 2026-07-04

- Renamed **create-merge-request** → **merge-request**.
- Added **merge-request-review** — reviewer-side MR/PR review and publish.

## [1.3.0] - 2026-07-04

- Renamed **create-mr** → **create-merge-request**; added `babysit` mode.

## [1.2.0] - 2026-07-04

- Restructured **code-review** with dedicated sub-agents and shared context.

## [1.1.0] - 2026-06-02

- Renamed **feature** → **implement**; plugin id `dskills` → `daddia-skills`.

## [1.0.0] - 2026-06-01

- Initial release: product delivery skills, plugin manifests, and validation CI.
