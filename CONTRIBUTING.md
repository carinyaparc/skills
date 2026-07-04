# Contributing to Space skills

Skills live under `skills/`. Plugin manifests: `.claude-plugin/`, `.cursor-plugin/`.
Repo page groupings: `skills.sh.json` ([customize docs](https://www.skills.sh/docs/customize)).

## Layout

```text
skills/{skill-name}/
├── SKILL.md
├── prompts/
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

## Changing a skill

1. Edit under `skills/{name}/`.
2. Update `description` when routing changes.
3. Add gotchas from real failures.
4. Update `evals/` for high-risk skills.
5. Add `agents/` when a task needs isolated context or parallel review.

## Sub-agents

Follow patterns in `skills/code-review/agents/` and official Claude plugin agents:

- Frontmatter: `name`, `description`, `model`, `color`, `tools`
- Body: **When to invoke**, process, output format
- Parent SKILL.md lists when to spawn them

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
