# Contributing to Space skills

Skills live under `skills/`. Plugin manifests: `.claude-plugin/`, `.cursor-plugin/`.
Repo page groupings: `skills.sh.json` ([customize docs](https://www.skills.sh/docs/customize)).

## Layout

```text
skills/{skill-name}/
├── SKILL.md
├── prompts/          # only when the skill has >1 mode (see below)
├── assets/
├── examples/
├── references/       # optional
├── evals/            # evals.json + trigger-queries.json
├── agents/           # optional sub-agents (code-review, validate)
└── scripts/          # optional

agents/               # plugin-level agents (eval-grader)
hooks/                # plugin-level hooks: Cursor (hooks.json + ralph-*.sh),
                      # Claude Code (claude/hooks.json + claude/stop-hook.sh)
```

Shared rules: [skills/backlog/references/delivery-conventions.md](skills/backlog/references/delivery-conventions.md).

### `prompts/` or flat?

**Use `prompts/` only when a skill has more than one mode.** Then each mode's
prompt loads on demand and the router in `SKILL.md` earns its indirection.

**Write a single-mode skill flat, in `SKILL.md`.** A router with one destination
is not a router: `SKILL.md` is loaded, immediately says "read the prompt", and
costs a guaranteed second read on every invocation. Unlike `references/`, the
prompt is not conditional, so the indirection buys nothing and duplicates
whatever both files describe. `code-review`, `code-review-fix`, and
`ralph-loop-setup` are flat for this reason.

Keep `SKILL.md` under 500 lines per the
[Agent Skills spec](https://agentskills.io/specification). The dividing line for
what stays inline is **unconditional vs conditional**: procedure, output format,
and gating rules run every time and belong in `SKILL.md`; checklists and
discovery detail are consulted situationally and belong in `references/`.

## Changing a skill

1. Edit under `skills/{name}/`.
2. Update `description` when routing changes.
3. Add gotchas from real failures.
4. Update `evals/` for high-risk skills.
5. Add `agents/` when a task needs isolated context or parallel review.

## Sub-agents

Follow patterns in `skills/code-review/agents/` and official Claude plugin agents:

- Frontmatter: `name`, `description`, `model`, `color`, `tools`,
  `metadata.model_tier`
- Body: **When to invoke**, process, budget, scoring, output format
- Parent SKILL.md lists when to spawn them, with an explicit trigger per agent

**Model tiers.** Declare `metadata.model_tier` (`fast`, `standard`, `deep`) and
keep `model: inherit`. Hardcoding Anthropic model names breaks runners that do
not know them; the tier is advisory, so a runner without model selection
inherits and still works. Mechanical predicates, summarisation, and verification
are `fast`; judgement against a bounded context is `standard`; whole-system
reasoning is `deep`.

**Budgets.** Give every agent an explicit reading ceiling. An agent without one
will read the codebase, which is how a parallel review burns its context on
duplicate discovery.

**Tools.** Constrain to what the agent actually needs — `Bash(git diff:*)` rather
than `Bash`. The spec supports constrained forms and they document intent.

## Evaluations

- `evals/evals.json` — output quality (with vs without skill)
- `evals/trigger-queries.json` — description triggering
- Grade runs with plugin `agents/eval-grader.md`

## Local validation

```bash
chmod +x scripts/validate-skills.sh skills/backlog/scripts/check-epic-paths.sh
./scripts/validate-skills.sh
```

## Pull requests

- Run `./scripts/validate-skills.sh`
- Update `skills.sh.json` if adding a skill that should appear in a curated group
