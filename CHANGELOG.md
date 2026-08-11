# Changelog

Version numbers match Git tags and `version` in `.cursor-plugin/plugin.json` and
`.claude-plugin/plugin.json`. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

- Repository moved to [`carinyaparc/skills`](https://github.com/carinyaparc/skills).
- Plugin renamed: `daddia-skills` → `carinyaparc-agent-skills`
  (`Carinya Parc Agent Skills`); author → Carinya Parc.
- **BREAKING: `review` mode removed from `product`, `roadmap`, `design`, and
  `solution`.** Each is now write-only; use `docs-review` to review or
  critique an existing artefact. `prompts/write.prompt.md` folded into each
  skill's `SKILL.md`; `prompts/` removed. `adr` is unaffected — it keeps its
  own `plan`, `write`, and `review` modes.
- **BREAKING: epic-only arguments → any work item.** `tasks`, `design`,
  `validate`, `backlog-refine`, `ralph-loop-setup`, `implement`, and `adr`
  (plan mode) now accept any work item ID — epic, story, task, bug, or
  spike — and resolve its source system (Linear, Jira, GitHub/GitLab issues,
  or filesystem) and type before acting. A story ID decomposes into
  sub-tasks instead of stories; any work item can get its own `design.md`.
  `docs/work/{epic}/` → `docs/work/{work-id}/` everywhere. When Linear or
  Jira resolves, its native key is the canonical ID — no parallel internal
  ID is generated — and a `TASKS.local.md` pointer is written at the repo
  root to cache the detection (add it to `.gitignore`). Internal IDs
  (`{PREFIX}{nn}`) remain filesystem-only fallback. Ambiguity in system, ID,
  or type is never guessed — every affected skill asks. The old `type`
  label vocabulary (`feature`, `integration`, `scaffold`, `migration`,
  `chore`, `fix`) is removed; `work-item-schema.md` gains `bug` and `spike`
  as first-class work item types instead.
  **Also breaking:** the `ralph-loop` `engineering-delivery` preset's
  substitution key renamed `{{EPIC}}` → `{{WORK_ID}}`, and its commit
  trailer `Epic:` → `Work-item:`; `design.template.md` and
  `tasks.template.md` frontmatter renamed `epic`/`epic_id` →
  `epic_slug`/`work_id`. **Migration:** re-seed any in-flight loop with
  `/ralph-loop-setup` (an old seed's `--set EPIC=` is no longer resolved);
  regenerate or hand-edit the frontmatter of any `design.md`/`tasks.md`
  written before this change.
- **BREAKING: `.agency/reviews/` → `docs/reviews/` and
  `docs/work/{work-id}/reviews/`.** `code-review` and `ux-design-review` now
  track incremental review state in a single shared file per skill —
  `docs/reviews/code-review.local.json` and
  `docs/reviews/ux-design-review.local.json`, each holding one entry per
  branch — instead of one `.agency/reviews/{branch}.json` file per branch.
  Each run also writes a numbered, human-readable verdict to
  `docs/work/{work-item}/reviews/{skill}-{nn}.local.md` (falling back to
  `docs/reviews/{skill}-{branch}.local.md` when no work item resolves).
  `code-review`'s learnings file moved from `.agency/review-learnings.md` to
  `docs/reviews/review-learnings.local.md` (gitignored via `*.local.md`).
  `code-review-fix` and `ux-design-fix`
  read and update the same shared JSON file. `.ux-review/` (the gitignored
  capture/screenshot bundle) is unaffected. **Migration:** delete any
  `.agency/` directory; the next `code-review` or `ux-design-review` run
  starts a fresh, full review. `*.local.json` added to `.gitignore`.

### Added

- `skills/tasks/references/work-item-resolution.md` — source system
  detection, the `TASKS.local.md` pointer, canonical ID rules, and the
  ask-first checklist shared by every skill above.
- `skills/tasks/assets/tasks-local.template.md` — the `TASKS.local.md`
  pointer file template.

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

## [1.6.0] - 2026-07-04

— Added **ralph** skill and stop hooks.

## [1.5.0] - 2026-07-04

— Added **ux-design-review** (review/fix).

## [1.4.0] - 2026-07-04

— **create-merge-request** → **merge-request**; added **merge-request-review**.

## [1.3.0] - 2026-07-04

— **create-mr** → **create-merge-request**; added `babysit`.

## [1.2.0] - 2026-07-04

— Restructured **code-review** with sub-agents.

## [1.1.0] - 2026-06-02

— **feature** → **implement**; plugin id → `daddia-skills`.

## [1.0.0] - 2026-06-01

— Initial release.
