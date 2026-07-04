# Changelog

All notable changes to this project are documented here. Version numbers match
Git tags and the `version` field in `.cursor-plugin/plugin.json` and
`.claude-plugin/plugin.json`.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.5.0] - 2026-07-04

### Added

- **ux-design-review** skill (`skills/ux-design-review/`) — the experience
  sibling of code-review: a live-environment-first UX review of implemented
  UI against the discovered design source of truth. Modes: **review**
  (default) and **fix** (action-tier scoped: `blocking` | `warning` | `all`),
  mirroring code-review's router and finding labels.
  - Five trigger-gated sub-agents: `accessibility-reviewer` (WCAG 2.2 AA —
    axe-core scan plus the manual keyboard/focus/semantics pass automation
    cannot cover), `interaction-states-reviewer` (flows, interactive and
    lifecycle states, robustness, console audit), `design-fidelity-reviewer`
    (rendered UI vs Figma via MCP / mockups / tokens),
    `responsive-reviewer` (1440/768/375 viewports, overflow, touch targets,
    dark mode / reduced motion), and `design-system-reviewer` (static pass:
    tokens vs hard-coded values, component reuse, pattern adherence).
  - `references/design-source-resolution.md` — the design-truth ladder:
    explicit argument → work-item link → Figma via MCP → repo mockups →
    tokens/style guide → principles doc → none (judge internal consistency
    and say so).
  - `references/environment-resolution.md` — the runnable-UI ladder
    (running app → dev server → Storybook → static-only) with an explicit
    coverage statement in every verdict; Playwright/Chromium and browser
    MCP driving guidance.
  - `references/accessibility-checklist.md` — condensed WCAG 2.2 AA split
    into automatable vs manual halves; conformance never claimed from a
    scan alone.
  - `references/ux-heuristics.md` — hierarchy, consistency, feedback,
    forgiveness, typography, motion, and copy standards for repos with no
    design source.
  - `references/finding-classification.md` — the code-review three-axis
    model with UX categories; Accessibility findings at Medium+ confidence
    are always blocking.

### Changed

- **code-review** SKILL.md description now routes rendered UI/UX review to
  ux-design-review.
- README, skills.sh.json, and skills-index updated for the new skill.

## [1.4.0] - 2026-07-04

### Changed

- **create-merge-request** skill renamed to **merge-request**, aligning with
  the catalogue's noun-first naming (`product write`, `sprint plan`). The
  default mode is now **create** (`prompts/create.prompt.md`, renamed from
  `run.prompt.md`); `babysit` is unchanged. Invoke with `/merge-request`,
  `/merge-request create`, or `/merge-request babysit`.
- README, skills.sh.json, and skills-index updated for the rename and the
  new skill; typical flow now runs merge-request → merge-request-review →
  validate.

### Added

- **merge-request-review** skill (`skills/merge-request-review/`) — the
  reviewer side of the delivery loop, self-contained and provider-agnostic
  (GitHub, GitLab, Bitbucket via MCP or CLI). Reviews an assigned MR/PR and
  publishes the outcome: labelled inline comments anchored to the diff, an
  approve / approve-with-nits / request-changes / comment verdict, and
  thread resolution across re-review rounds. Supports `--verdict-only` and
  `--no-publish`; always confirms with the user before publishing.
  - `references/review-workflow.md` — pre-review gates, line-level
    checklist, verdict rules, and re-review round handling.
  - `references/comment-guidelines.md` — Conventional Comments-style
    labels, comment anatomy, tone, and blocking discipline.
  - `references/provider-operations.md` — per-provider read and publish
    mechanics: GitHub pending-review flow, GitLab discussions and approval,
    Bitbucket via the Rovo MCP tools.

## [1.3.0] - 2026-07-04

### Changed

- **create-mr** skill renamed to **create-merge-request** and rebuilt on the
  modular pattern introduced for code-review in 1.2.0: a router `SKILL.md`,
  one prompt per mode, self-contained references, and a packaged asset.
- The skill is now self-contained and universal: change context is discovered
  in any repo layout (explicit argument, linked work item, local spec file,
  or `git log` fallback) instead of assuming the `docs/work/{epic}` layout.
- Works with any git provider — GitHub, GitLab, or Bitbucket (Cloud and
  self-hosted) — through a three-tier tool ladder: MCP tools where available,
  provider CLIs (`gh`, `glab`) otherwise, plain git (GitLab push options,
  push-output create URLs) as a last resort.
- MR/PR descriptions are template-aware: the repo's own template
  (`.github/PULL_REQUEST_TEMPLATE*`, `.gitlab/merge_request_templates/`,
  `.bitbucket/pull_request_template.md`) is discovered and filled; the
  packaged default is used only when the repo defines none.
- Titles follow the repo's detected convention (commitlint config, merged
  MR/PR history) with Conventional Commits as the fallback, and descriptions
  adapt their sections to the size of the change.
- README: removed the unimplemented **review-mr** skill from the Release
  stage and typical flow; `create-merge-request babysit` covers the
  post-creation follow-through.

### Added

- `create-merge-request babysit` mode (`prompts/babysit.prompt.md`) — drives
  an open MR/PR to a merge-ready state: watches CI, fixes objective failures,
  triages review comments, syncs unambiguous merge conflicts, and escalates
  design decisions; capped at three fix-push-check cycles without progress.
- `agents/mr-babysitter.md` — background-spawnable monitor agent for hosts
  with background agent support.
- `references/provider-resolution.md` — provider detection and the
  MCP → CLI → plain-git tool ladder, with per-provider operation matrices.
- `references/template-discovery.md` — per-provider template locations,
  selection among multiple templates, and fill rules.
- `references/description-guidelines.md` — title convention detection,
  two-sentence summary rule, size-adaptive sections, metadata, and body
  mechanics.
- `assets/default-mr-template.md` — packaged default MR/PR description
  template.

### Removed

- `skills/create-mr/` (renamed to `skills/create-merge-request/`; the old
  single-prompt implementation is superseded).

## [1.2.0] - 2026-07-04

### Changed

- **code-review** skill significantly restructured: sub-agents are now each in
  their own dedicated file under `agents/`, trigger conditions are explicit, and
  the skill routes to a single prompt per mode.
- Replaced `tasks-ac-reviewer` agent with `acceptance-criteria-reviewer` (format
  agnostic — works with any tracker or doc format, not just task files).
- `design-drift-reviewer` rewritten to resolve any discovered design/spec doc
  automatically rather than requiring an explicit path.
- `prompts/run.prompt.md` and `prompts/fix.prompt.md` updated to share context
  once up-front and pass it to every sub-agent, eliminating redundant fetches.

### Added

- `agents/acceptance-criteria-reviewer.md` — AC vs diff reviewer.
- `agents/architecture-reviewer.md` — architecture docs/ADR reviewer.
- `agents/best-practices-reviewer.md` — library/framework best-practices reviewer.
- `agents/bug-scan-reviewer.md` — shallow changes-only bug + git-history scanner.
- `agents/guideline-compliance-reviewer.md` — AGENTS.md/CLAUDE.md/rules reviewer.
- `references/context-resolution.md` — how to discover intent, AC, scope, and CI
  signal in any repo/tracker.
- `references/finding-classification.md` — category, severity, confidence, and
  risk matrix for findings.
- `references/quality-checklist.md` — timeless review checklist applied across
  all reviewers.
- `references/security-checklist.md` — condensed security pass reference.

### Removed

- `agents/tasks-ac-reviewer.md` (superseded by `acceptance-criteria-reviewer`).

## [1.1.0] - 2026-06-02

### Changed

- Renamed the **feature** skill to **implement**. Invoke with `/implement {task-id}`
  (e.g. `/implement CHK01-01`) instead of `/feature implement {task-id}`.
- Renamed the plugin identifier from `dskills` to `daddia-skills` in Cursor and
  Claude plugin manifests.
- Updated cross-references across README, skills-index, delivery conventions,
  and related skills to use **implement** and task terminology.

### Added

- **implement** skill (`skills/implement/`) with implementation prompt aligned to
  Task IDs in `docs/work/{epic}/tasks.md`.

### Removed

- **feature** skill directory (replaced by **implement**).

## [1.0.0] - 2026-06-01

### Added

- Initial release of the daddia skills plugin: product delivery skills for
  strategy, architecture, epic design, tasks, implementation, code review,
  validation, and sprint refinement.
- Cursor and Claude plugin manifests, skills.sh catalogue, and validation CI.
