# Changelog

Version numbers match Git tags and `version` in `.cursor-plugin/plugin.json` and
`.claude-plugin/plugin.json`. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

- Repository moved to [`carinyaparc/skills`](https://github.com/carinyaparc/skills).
- Plugin renamed: `daddia-skills` → `carinyaparc-agent-skills`
  (`Carinya Parc Agent Skills`); author → Carinya Parc.

## [2.1.0] - 2026-07-19

### Changed

- **BREAKING: `backlog` removed, merged into `tasks`.** One skill for every
  level: `tasks --product` → epics in `backlog.md`; `tasks {epic}` → stories
  and tasks; `tasks {spec-path}` → both from a spec/RFC/PRD. Flat (no modes);
  gains vertical-slice decomposition, sizing, `[P]` markers, MVP naming.
  `tasks.md` is two-level (stories = statement + AC; tasks = paths + `[S{n}]`).
  Task IDs unchanged.
- **BREAKING: `docs` → `docs-review`.** Read-only; refine/edit removed.
- **BREAKING: `refine` removed** from `product`, `roadmap`, `solution`, `tasks`.
  Use `review` (includes currency pass).
- **BREAKING: `ux-design-review fix` / `code-review fix` removed.** Use
  `*-fix`. Reviews read-only; code-review gains verifier, incremental review,
  learnings, CI ingestion.
- **BREAKING: `sprint` → `sprint-planning` + `sprint-retro`.** Modes dropped.
  Planning: capacity, carry-over, committed-vs-stretch. Retro: numbers, goal
  verdict, routed actions; no `plan.md` edits.
- **BREAKING: `merge-request babysit` → `merge-request-babysit`**;
  `merge-request create` → `merge-request` (`create` is a work-item ID).
  Create scoped to git/gh/glab; babysit keeps Bash + Edit.
- `delivery-conventions.md` → `skills/tasks/references/`; nine skills/docs
  updated. Spec alignment: space-separated `allowed-tools`, `Shell` → `Bash`,
  `metadata` everywhere, single-mode skills flattened.
- `adr plan` optional epic harvests `design.md` (promote/inline/defer).
  `validate-skills.sh` → `validate_skills.py`; workflow → `ci.yml`. Trigger
  phrases and metadata completed (`ralph-loop` excluded).

### Added

- **`backlog-refine`** — grooming and sprint-readiness; must not change task IDs.
- `work-item-schema.md`, `acceptance-criteria.md` (Gherkin + EARS).
- `docs-review`, `ux-design-fix`, `code-review-fix`, `sprint-planning`,
  `sprint-retro`, `merge-request-babysit`.

### Fixed

- CI was dark (chmod on moved script; validate lost `+x` — Python rewrite).
- Stale handoffs (`tasks write`, deleted `backlog`, obsolete modes); ADR
  promotion via `adr plan <epic>`; ralph YAML tools, convention links,
  preset `/merge-request --draft`.

## [2.0.0] - 2026-07-19

- **BREAKING: `ralph` → `ralph-loop` + `ralph-loop-setup`.** State →
  `.claude/loop/` or `.cursor/loop/`. Hooks, isolation, ceiling, presets.
  Fixed loop stalling at iteration 1. **Migration:** cancel 1.x loops, delete
  `.ralph/` / `.ralph-loop`, re-seed with `/ralph-loop-setup`.

## [1.6.0] - 2026-07-04 — Added **ralph** skill and stop hooks.
## [1.5.0] - 2026-07-04 — Added **ux-design-review** (review/fix).
## [1.4.0] - 2026-07-04 — **create-merge-request** → **merge-request**; added **merge-request-review**.
## [1.3.0] - 2026-07-04 — **create-mr** → **create-merge-request**; added `babysit`.
## [1.2.0] - 2026-07-04 — Restructured **code-review** with sub-agents.
## [1.1.0] - 2026-06-02 — **feature** → **implement**; plugin id → `daddia-skills`.
## [1.0.0] - 2026-06-01 — Initial release.
