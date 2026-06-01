# Contributing to delivery skills

These skills follow the [Agent Skills](https://github.com/agentskills/agentskills) format and [skill-creation best practices](https://github.com/agentskills/agentskills/tree/main/docs/skill-creation).

## Layout

```text
{skill}/
├── SKILL.md              # Metadata + router (keep lean)
├── prompts/              # Mode instructions (progressive disclosure)
├── assets/               # Output templates (*.template.md)
├── examples/             # Reference outputs
├── references/           # Optional deep reference (backlog owns shared conventions)
├── evals/                # Output + trigger test cases
└── scripts/              # Optional mechanical checks
```

Shared delivery rules: [backlog/references/delivery-conventions.md](backlog/references/delivery-conventions.md).

## Changing a skill

1. Update `SKILL.md` **description** when behaviour or routing changes (imperative “Use when…”, near-miss “Do NOT…”).
2. Put procedural detail in `prompts/`, not in `SKILL.md`, unless it applies to every mode.
3. Add **gotchas** when a real run needed a correction the model would repeat.
4. Extend [delivery-conventions.md](backlog/references/delivery-conventions.md) for cross-skill rules (paths, boundaries).
5. Add or update `evals/evals.json` and `evals/trigger-queries.json` for high-risk skills.

## Evaluations

### Trigger accuracy

See [optimizing descriptions](https://github.com/agentskills/agentskills/blob/main/docs/skill-creation/optimizing-descriptions.mdx).

- Edit `evals/trigger-queries.json` (should-trigger + near-miss should-not-trigger).
- Run each query 3×; target >50% trigger rate for positives, <50% for negatives.
- Tune `description` on the train set; hold out ~40% for validation.

### Output quality

See [evaluating skills](https://github.com/agentskills/agentskills/blob/main/docs/skill-creation/evaluating-skills.mdx).

- Edit `evals/evals.json` with realistic prompts and assertions.
- Compare **with skill** vs **without** (or previous version).
- Add assertions after the first run — not before.

## Local validation

```bash
chmod +x scripts/validate-skills.sh backlog/scripts/check-epic-paths.sh
./scripts/validate-skills.sh
backlog/scripts/check-epic-paths.sh backlog/examples/backlog.md
```

Optional: [skills-ref validate](https://github.com/agentskills/agentskills/tree/main/skills-ref) per skill directory when installed.

## Pull requests

- One logical change per PR (skill + its evals).
- Note which skills’ descriptions changed.
- Run `./scripts/validate-skills.sh` before opening.
