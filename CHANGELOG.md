# Changelog

Version numbers match `version` in `.cursor-plugin/plugin.json` and
`.claude-plugin/plugin.json`. Released versions are tagged `vMAJOR.MINOR.PATCH`
when published (tags begin at `v1.1.0`; `1.0.0` and `2.0.0` predate consistent
tagging and exist only as changelog sections). Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Fixed

- **CI was red.** `hooks/lib/ralph-common.sh` carried five `SC2034` shellcheck
  warnings on documented cross-file out-parameters; annotated each with a
  `disable=SC2034` and a reason. `validate_skills.py`'s `check_shellcheck`
  docstring called the check "advisory" while its behaviour hard-failed on
  any warning once shellcheck was installed; fixed the docstring to describe
  the real (and correct) behaviour, and stopped `Report.fail` from silently
  dropping detail lines past 20 — it now says how many were truncated.
- **The ralph-loop completion promise could be fulfilled by the model merely
  mentioning it.** `ralph_extract_promise` matched `<promise>X</promise>`
  anywhere in the text; a turn saying *"I will only output
  `<promise>DONE</promise>` once every task is committed"* satisfied it. The
  tag must now be alone on the message's final line — including when that
  line only looks final because the model opened a fenced code block to show
  or reference the tag and never closed it; an odd count of `` ``` `` markers
  before the tag now disqualifies the match the same way a closed fence
  already did.
- **A stale promise from an earlier iteration, or an earlier finished loop,
  could stop a fresh loop at iteration 1.** `ralph_last_assistant_text`
  scanned the last 100 assistant lines with no turn boundary; a turn that
  delegates every step to a sub-agent ends on tool calls, so the scan could
  reach back past the current turn's start. Scoped detection to the current
  turn using the Stop-hook's own re-fed prompt as the boundary (a genuine new
  user turn every continuation) — recognising that turn whether Claude Code
  represents its plain-text `message.content` as a bare string or as an
  array containing a text block, since either shape is real and only
  recognising one would silently degrade back to the unscoped scan.
- **`engineering-delivery`'s `final_validate` step had no route to
  `create_mr`** — only a failure-path "stop and record" instruction, no
  success-path transition. A run that genuinely passed validation stalled at
  the last step. Added the missing `current_step: create_mr` transition, and
  a new validator check (`check_preset_reachability`) that fails on any
  preset step with no forward transition and no completion-promise emission.
- **`adr` and `tdd` are told to edit files in place but were not granted
  `Edit`.** Added it to both.
- Corrected `loop-protocol.md` and two source comments describing the `done`
  sentinel as "the primary signal on both agents; text scanning is the
  fallback" — it is Cursor's *only* mechanism (its Stop hook receives no
  response text to scan) and Claude's Stop hook has no sentinel to write, so
  text-scanning there is not a fallback, it is the only mechanism available.
- `code-review-fix` and `merge-request-review` named the wrong sibling skill
  in their negative-trigger clauses (`ux-design-review` instead of
  `ux-design-fix`; `merge-request` instead of `merge-request-babysit`),
  including one eval note that certified the broken route.
- `product`, `roadmap`, and `solution` each promised "for reviewing or
  critiquing an existing document, use docs-review instead" — `docs-review`'s
  own eval explicitly declines that (it checks writing quality and
  cross-document consistency, not strategic/architectural soundness). Removed
  the false promise; re-authoring is how these documents get revised.
- Removed the empty `"Epic delivery"` group from `skills.sh.json`.
- Added 14 negative-boundary test cases and 4 mutants covering the
  promise-anchoring and turn-boundary fixes above (`scripts/test-ralph-hooks.sh`,
  `scripts/mutation-test.py`); the CI/shellcheck and preset-reachability fixes
  are independently verified by `shellcheck` and `check_preset_reachability`
  directly, not by mutation testing — this harness only tracks the three
  shell hook files, so it cannot exercise either.

## [3.0.0] - 2026-08-12

### Changed

- Repository moved to [`carinyaparc/skills`](https://github.com/carinyaparc/skills).
- Plugin renamed: `daddia-skills` → `carinyaparc-agent-skills`
  (`Carinya Parc Agent Skills`); author → Carinya Parc.
- **BREAKING: `design` skill renamed → `tdd`, and its artefact
  `docs/work/{work-id}/design.md` → `docs/work/{work-id}/tdd.md`.** The skill
  writes a technical design document; the name now says so. Its modes are
  renamed with it — `--mode walking-skeleton|tdd` → `--mode skeleton|full` —
  because `tdd --mode tdd` was incoherent, and the template's mode key is now
  `mode:` everywhere (the worked example previously declared `level:`).
  `assets/design.template.md` → `assets/tdd.template.md`. The `ralph-loop`
  `engineering-delivery` preset's substitution key is renamed
  `{{DESIGN_PATH}}` → `{{TDD_PATH}}`. Every consumer — `tasks`, `implement`,
  `validate`, `adr plan`, `backlog-refine`, `sprint-planning`, `sprint-retro`,
  `ralph-loop-setup` — now reads `tdd.md` and falls back to a legacy
  `design.md` when only that exists. **Migration:** `git mv
  docs/work/*/design.md` to `tdd.md` at your convenience; until you do, the
  skills still find the old file and `tdd` offers to move it. Re-seed any
  in-flight loop with `/ralph-loop-setup` — an old seed's `--set DESIGN_PATH=`
  is no longer resolved. Note that `tdd` is a *design* skill: test-driven
  development, red/green/refactor, and test authoring remain `implement`.
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
