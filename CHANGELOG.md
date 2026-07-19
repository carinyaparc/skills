# Changelog

All notable changes to this project are documented here. Version numbers match
Git tags and the `version` field in `.cursor-plugin/plugin.json` and
`.claude-plugin/plugin.json`.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

Mode simplification. Artefact skills drop from three modes to two: `write` and
`review`.

### Changed

- **BREAKING: `refine` mode is removed** from `product`, `roadmap`, `solution`,
  `backlog`, and `tasks`. Use `review`. The split never held: `review` was
  already amending documents in place, and `refine` was already applying
  judgement about what was stale. Callers had to guess which one they wanted
  before knowing what the document needed, and the two prompts had drifted into
  contradicting each other on the same question (roadmap `review` said it does
  not advance phase statuses; roadmap `refine` said it does not judge
  sequencing — so nobody owned "this phase shipped and the plan is now
  optimistic").
- **`review` absorbs the currency pass.** Each review prompt now runs in two
  passes: reconcile the document against delivery evidence, then apply the
  critical criteria. The currency pass is skipped when the caller supplies no
  post-change evidence, which makes the same mode correct pre- and post-sprint.
- **BREAKING: `docs` has no modes.** Merging `review` and `refine` left one
  mode, so the skill is flattened into `SKILL.md` and `prompts/` is deleted,
  consistent with the other single-mode skills. It now runs an alignment half
  and a sprint-end half, each conditional on what the context supports.
  Argument is just `<epic>`.
- **Personas follow the mode.** `write` is the practitioner (Product Manager,
  Solution Architect, Business Analyst, Delivery Lead); `review` is the senior
  or lead (Senior Product Manager, Lead Solution Architect, Senior Delivery
  Lead, Lead Software Architect). `design review` and `tasks write` had no
  persona at all and now do.
- **`docs` gained `Edit`** in `allowed-tools` — it amends documents in place but
  declared only `Write`.

### Fixed

- **Broken conventions links.** `tasks/prompts/{review,write}.prompt.md` and
  `design/prompts/write.prompt.md` linked `../backlog/references/delivery-conventions.md`,
  which resolves to `skills/tasks/backlog/...` from inside `prompts/`. Corrected
  to `../../backlog/...`.

---

UX design review rebuild. `ux-design-review` is split into a read-only reviewer and a
separate writing fixer, flattened, consolidated from five lenses to three, and given a
single shared capture step in place of three independent browser sessions.

### Changed

- **BREAKING: `ux-design-review fix` is removed.** Use the new `ux-design-fix`
  skill. No alias, for the same reason as `code-review fix`: an alias forces the read
  skill to keep `Write` and to keep advertising fix behaviour in its description.
- **The fix skill is `ux-design-fix`, not `ux-design-review-fix`.** It is not only the
  write half of a review — it takes a review verdict *or* a direct instruction ("the
  summary card padding is off", "the modal breaks on mobile"). Naming it after the
  review would have implied a dependency it does not have, and left ad-hoc UI changes
  with no home: `implement` requires an epic, a design, and acceptance criteria, none of
  which exist for "the spacing is wrong". The boundary is stated on both sides —
  `implement` builds UI that does not exist, `ux-design-fix` changes UI that does.
  Direct mode captures a baseline **before** editing, since no review recorded one;
  without it the neighbour re-check that catches shifted siblings is guesswork.
- **`ux-design-review` is read-only.** Writes only the capture bundle (`.ux-review/`,
  gitignored) and review state (`.agency/reviews/`). Cannot modify source or styles.
- **The browser is driven once, not three times.** `accessibility`, `interaction-states`,
  and `responsive` each independently navigated, set up states, resized, and
  screenshotted the same UI. A new **capture step** produces one shared evidence bundle
  — screenshots across state × viewport, axe results, console, accessibility tree, and a
  scripted keyboard traversal record — which every lens then reads. This removes triple
  cost, and removes inconsistent evidence: when two lenses disagreed there was
  previously no way to tell which render was the truth.
- **Lenses consolidated from five to three**, per the one-agent-per-input-source rule:
  - `interaction-states-reviewer` + `responsive-reviewer` → **`experience-reviewer`**.
    Same evidence, same judgement, and splitting them lost the intersection: the error
    state at 375px, where the most common real defect lives and neither lens owned it.
  - `design-fidelity-reviewer` + `design-system-reviewer` → **`conformance-reviewer`**.
    A card with 12px padding where the design says 16px and a token exists is one
    defect; merged it returns as one finding with a screenshot *and* a `file:line`.
  - `accessibility-reviewer` stays separate: conformance against cited criteria with a
    compliance floor is a different kind of judgement from heuristic quality.
- **Confidence is rated independently.** Lenses attach a prior; the new
  `finding-verifier` rates each candidate without seeing the raising lens's reasoning.
  Unlike code review, it may re-render one state to settle a finding outright.
- **Accessibility coverage claim corrected.** The checklist said automation catches
  "roughly a third" of WCAG issues. Deque's coverage study (13,000+ page states,
  ~295,000 issues) puts it at 16 of 50 AA criteria but **57.38% by issue volume**.
  Replaced with the volume figure plus the list of criteria with *zero* automated
  coverage — 2.4.3, 2.4.7, 2.1.2, 1.4.11, 1.3.2, 1.4.10, 4.1.3, 2.4.4, 2.4.6, 1.3.3 —
  which is what a reviewer can actually act on.
- Risk matrix: high-severity / low-confidence now **escalates** as
  `[warning] unverified` rather than dropping, matching `code-review`.
- Agent tools constrained; `metadata.model_tier` and reading budgets added. No sub-agent
  runs at `deep` — the capture step removed browser driving from every lens.

### Added

- **`ux-design-review-fix` skill** — accessibility first, fixes via tokens and library
  components rather than local patches, re-renders and re-captures to verify, and
  re-checks neighbours for shift. Kept separate from `code-review-fix` because there is
  no typecheck for "looks right": its verification, its required resolutions, its fix
  routing, and its conflict rule all differ.
- **`references/capture-protocol.md`** — the evidence bundle, plus screenshot
  determinism: fonts loaded, network idle, animation disabled, time and data frozen,
  and **paired capture** so a region that differs between two captures is marked
  unstable and excluded rather than reported as a deviation. Also resolves the
  reduced-motion trap: disabling animation to stabilise a capture and verifying the app
  honours `prefers-reduced-motion` are opposite operations on the same setting.
- **`references/merge-protocol.md`** — dedupe on component + state + viewport + root
  cause, so the same defect at three viewports is one finding with three captures.
  Corroboration must be genuinely independent, which matters more here than in code
  review because every lens now reads the same bundle.
- **Incremental review** with **design-side drift detection** —
  `.agency/reviews/ux-{branch}.json` records the design source ref, so a review can tell
  the author "the design moved, your code didn't". No SaaS tool in the comparison set
  does this; they all treat the design as fixed.
- **`accepted_deviations` persisted**, so declared-intentional deviations stop being
  re-litigated every run.
- Coverage statement now names what was **not** covered: other browsers, themes, and
  unreachable states.
- `evals/evals.json` and `evals/trigger-queries.json` for both skills, with negative
  routing cases in both directions, including `code-review-fix` vs `ux-design-review-fix`.
- `docs/ux-design-review-uplift.md` — the evaluation this rebuild implements.

---

Spec alignment pass across all skills against the Agent Skills specification
(agentskills.io/specification), plus flattening of every remaining single-mode
skill.

### Changed

- **`allowed-tools` is now a space-separated string** on every skill, per the
  spec. The YAML-list form was non-conformant and silently ignored by clients
  that parse the field as a string.
- **`Shell` replaced with `Bash`** in `allowed-tools` — `Shell` is not a real
  tool name, so those skills were declaring a permission that never resolved.
  Affects `implement`, `merge-request`, `merge-request-review`,
  `ralph-loop-setup`, `ux-design-review`.
- **`metadata` block added** (`author`, `version`) to every skill, matching the
  pattern already used by `code-review` and `code-review-fix`.
- **`implement` and `validate` gained the tools they actually use** — `Edit`
  for `implement`, `Write`/`Edit` for `validate`, which updates `tasks.md` and
  `backlog.md` in its Phase 6 but declared read-only tools.
- **Single-mode skills are flat.** `implement`, `merge-request-review`,
  `skills-index`, and `validate` each had exactly one prompt file behind a
  one-line router. The prompt is now inlined in `SKILL.md` and the `prompts/`
  directory is deleted — one file to read instead of two, no indirection on a
  branch that never forks. Multi-mode skills keep `prompts/`.
- **`skills-index` output now points at its own template.**
  `assets/skills-index.template.md` existed but nothing referenced it.

---

Code review rebuild. `code-review` is split into a read-only reviewer and a
separate writing fixer, flattened to a single `SKILL.md`, and given the
independent verification and merge protocol it was missing.

### Changed

- **BREAKING: `code-review fix` is removed.** Use the new `code-review-fix`
  skill. No alias is kept: an alias would force `code-review` to keep `Write` in
  `allowed-tools` and keep advertising fix behaviour in its description, which
  is exactly the ambiguity and blast radius the split removes. `code-review` now
  names `code-review-fix` as the next step in its output without being able to
  invoke it.
- **`code-review` is read-only.** Tools are constrained to
  `Write(.agency/reviews/**)`; it cannot modify source, tests, config, or docs,
  and cannot commit or comment on a provider.
- **Both skills are flat.** `prompts/run.prompt.md` and `prompts/fix.prompt.md`
  are folded into their `SKILL.md`. A single-mode skill's prompt is
  unconditionally loaded, so the indirection only cost a guaranteed second read
  and duplicated the sub-agent list across two files. `CONTRIBUTING.md` now
  documents the rule: `prompts/` only for multi-mode skills.
- **Confidence is now rated independently.** Sub-agents attach a *prior*; the new
  `finding-verifier` agent rates each candidate without seeing the raising
  agent's reasoning, name, or prior, and its rating replaces it. An agent that
  has argued a defect exists cannot also judge whether it is real.
- **Sub-agents rationalised from eight to six** — five lenses plus the verifier.
  An agent earns its own context window by reading a distinct *input source*, not
  by covering a distinct topic. Two pairs failed that test and were merged:
  - `acceptance-criteria-reviewer` + `design-drift-reviewer` →
    **`requirements-reviewer`**. Both compared the diff against the same resolved
    requirements, differing only in direction (missing vs extra). Merged, the
    lens can connect an uncovered criterion to an unmapped hunk — usually the
    same problem, previously reported as two.
  - `guideline-compliance-reviewer` + `prior-review-comments-reviewer` →
    **`conventions-reviewer`**. Both answer "what does this team require that
    this code does not do", and both must quote a source. One reads written
    rules, the other rules that were only ever said in a review comment.
- **No sub-agent runs at the `deep` tier.** `architecture-reviewer` moves from
  `deep` to `standard`. Every lens has a bounded context and an explicit reading
  budget, which is a standard-tier job by construction; depth belongs in the
  parent's synthesis, where the whole picture comes together.
- Sub-agent fan-out is capped by a review effort estimate (S/M/L) instead of
  running every lens on every diff. Security-sensitive and data paths force L
  regardless of diff size.
- `merge-protocol.md` corroboration rule extended to catch same-source
  double-counting *within* the two merged lenses, not only across agents.
- `best-practices-reviewer` trigger narrowed to a changed manifest/lockfile or a
  newly introduced import. It is the only lens that reaches the network, and the
  old "touches a library" trigger fired on nearly every diff.
- Agent tools constrained from blanket `Bash` to the specific commands each needs.
- Risk matrix: the high-severity / low-confidence cell now **escalates** as
  `[warning] unverified` rather than silently dropping. A possible critical
  defect is worth a human's attention even on thin evidence.

### Added

- **`code-review-fix` skill** — consumes labelled findings at an action-tier
  threshold, makes behaviour-preserving changes, runs the project's validation
  suite, commits in logical units, and updates review state. Can dispute a
  finding with evidence rather than implementing it.
- **`references/merge-protocol.md`** — dedupe key, category precedence, max
  severity, and corroboration. Independent lenses agreeing was previously
  discarded; it is now the strongest confidence signal available.
- **`finding-verifier` agent** (fast tier, one per candidate finding) — argues
  against each finding before rating it. The highest-leverage use of the fast
  tier: it is what makes one verifier per finding affordable, and independent
  verification is worth more than a larger model rating its own work.
- **Prior-review-comment mining**, as Part B of `conventions-reviewer` — review
  comments on prior PRs touching the same files, where a team's unwritten
  standards actually live. Capped at Possible confidence, since it reasons by
  analogy from a comment about different code.
- **Data Integrity category** and a "Data and contracts" checklist section —
  migration reversibility, backfill safety, lock windows, contract compatibility.
  Rated against recoverability, since a bad migration outlives its deploy.
- **Incremental review** — `.agency/reviews/{branch}.json` records findings and
  status, so a re-run reviews the delta and never re-raises a dismissed finding.
- **Learnings** — `.agency/review-learnings.md`, scoped by glob, ranked below
  written guidelines, capturing why a finding was rejected.
- **CI output ingestion** — existing check logs, SARIF, and scanner artefacts are
  read and reconciled. Scanner findings that fail the input-provenance test are
  explicitly rebutted rather than forwarded.
- **`metadata.model_tier`** (`fast`/`standard`/`deep`) on every agent, with
  `model: inherit` retained so runners without model selection still work.
- Reading budgets on every sub-agent.
- `evals/evals.json` and `evals/trigger-queries.json` for both skills, with
  negative routing cases in both directions.

## [2.0.0] - 2026-07-19

Ralph loop rebuild. The loop stopped after its first iteration; the cause was
in the hook plumbing, not the design. This release fixes that, splits the
command surface, moves loop state, and generalises the templates beyond
software delivery.

### Fixed

- **The loop now continues past iteration 1.** Four defects, each independently
  fatal:
  - Both stop hooks ran an unguarded `cat .ralph-loop | head | tr` pipeline as
    their first command under `set -euo pipefail`. A missing or unreadable
    pointer file made the pipeline return non-zero, `set -e` killed the script
    before it printed anything, and both agents read a silent non-zero exit as
    "allow the stop".
  - Frontmatter was parsed with `sed -n '/^---$/,/^---$/'`, whose range
    restarts at every `---`. The shipped template had four, so 108 lines of
    prompt body were parsed as frontmatter. Any body line beginning
    `iteration:` or `max_iterations:` produced a multi-line value, failed
    numeric validation, and deleted the loop file.
  - The Claude transcript parse took `tail -1` of the assistant lines. Claude
    Code writes each content block as its own JSONL line, so a turn ending on
    a tool call, the normal case for a loop delegating to sub-agents, had no
    text block and the completion promise was never seen.
  - `sed "s/^iteration: .*/"` rewrote every matching line in the file,
    including inside the prompt body.
- Cursor `loop_limit` set to an explicit integer rather than `null`.
- Promise comparison is literal, so a promise containing `*` or `[` no longer
  pattern-matches and ends the loop early.

### Added

- `hooks/lib/ralph-common.sh` — shared decision logic. The two stop hooks
  previously duplicated ~120 lines and had already diverged; only the Cursor
  one used its project-dir variable.
- **Session isolation.** `session_id` in the frontmatter stops a loop
  conscripting every other session open in the same project.
- **Hard ceiling** of 200 iterations, applied even to `max_iterations: 0`.
- **Completion sentinel** as the primary promise signal on both agents, with
  text scanning as the fallback.
- `scripts/seed-ralph-loop.sh` — deterministic seeding. Placeholder
  substitution moved out of the agent; unresolved placeholders are now a hard
  error rather than a corrupt loop file.
- `scripts/test-ralph-hooks.sh` (103 assertions) and
  `scripts/test-seed-ralph-loop.sh` (66 assertions), wired into
  `validate-skills.sh`.
- `scripts/mutation-test.py` — reintroduces each historical defect and asserts
  the suite catches it. 22 mutants killed, 3 documented as equivalent.
- **Presets.** `engineering-delivery`, `ad-hoc`, and `custom`, with a generic
  core template that owns the guardrails so a preset cannot weaken them.
- `references/preset-authoring.md`, including a worked non-engineering example.
- `validate-skills.sh` now checks skills.sh.json sync, eval JSON and
  `skill_name`, shell syntax, hook executability, template placeholders, and
  runs both Ralph suites. shellcheck runs when installed.

### Changed

- **BREAKING: `ralph` split into `ralph-loop` and `ralph-loop-setup`.**
  `/ralph setup` is now `/ralph-loop-setup`; `/ralph start|status|cancel` are
  now `/ralph-loop start|status|cancel`.
- **BREAKING: loop state moved** from `.ralph/` to `.claude/loop/` or
  `.cursor/loop/`, with per-run directories and an `archive/`. The
  `.ralph-loop` pointer file and the `--ralph-dir` flag are gone: each hook
  resolves its own base directory.
- `cancel` archives the run directory instead of leaving it in place.
- `ralph-loop-setup` proposes `tasks × 6 + 10` iterations for an epic rather
  than the flat default of 50, which a 12-task epic would exceed.
- Hooks use `set -uo pipefail`, not `set -euo pipefail`, with explicit error
  handling throughout.

### Migration

Loops seeded by 1.x cannot be resumed. Cancel any in-flight loop, delete
`.ralph/` and `.ralph-loop`, then re-seed with `/ralph-loop-setup`.

## [1.6.0] - 2026-07-04

### Added

- **ralph** skill (`skills/ralph/`) — an autonomous Ralph loop (Ralph Wiggum
  technique) that drives a whole epic through delivery, one task per
  iteration: `implement → code-review → fix (budget 3) → ux-design-review
  (UI only, fix budget 2) → validate_and_commit → task-progress`, then a
  one-time final phase (epic-level review on the strongest model, full
  branch validation, `/validate`, `/merge-request create --draft`). Modes:
  **setup** (seed `.ralph/{epic}/` + `.ralph/loop.md` from templates —
  never starts the loop), **start**, **status**, **cancel**. Also supports
  simple ad-hoc prompt-repetition loops (`setup --prompt`).
  - `references/loop-protocol.md` — the canonical step machine, budgets,
    and guardrails (one step per iteration, fresh sub-agent per skill step,
    state in files).
  - `references/environment-resolution.md` — resolve branch, fast/full
    validation commands, tracker actions (Jira / GitHub / GitLab / none),
    and UI signals once at setup.
  - `references/prompt-authoring.md` — completion promises, completion
    criteria, self-correction, escape hatches.
  - Templates under `assets/`: `loop.template.md` (frontmatter + step
    machine), `context.template.md`, `loop-state.template.md`.
- **Plugin-level hooks** (`hooks/`) — a self-contained loop engine, so no
  external Ralph plugin is needed (disable `ralph-loop-plugin` /
  `ralph-wiggum` if installed):
  - Cursor: `hooks.json` + `ralph-stop.sh` (re-feeds `.ralph/loop.md` as a
    `followup_message`) + `ralph-capture.sh` (detects
    `<promise>TEXT</promise>`).
  - Claude Code: `claude/hooks.json` + `claude/stop-hook.sh` (`decision:
    block` with promise detection from the session transcript), wired via
    the `hooks` field in `.claude-plugin/plugin.json`.
  - Safety rails in both engines: `max_iterations`, and a stall guard that
    stops the loop when the declared state file is unchanged for 3
    consecutive iterations.

### Changed

- README, skills.sh.json, skills-index, and CONTRIBUTING updated for the
  new skill and the plugin-level `hooks/` layout.

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
