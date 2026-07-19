# Changelog

Version numbers match Git tags and `version` in `.cursor-plugin/plugin.json` and
`.claude-plugin/plugin.json`. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

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

### Added

- `docs-review`, `ux-design-fix`, `code-review-fix`, `sprint-planning`,
  `sprint-retro`, `merge-request-babysit`.

### Fixed

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
