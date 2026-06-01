# Backlog — refine mode

Backlog refinement for epic or work-package level.

Read [SKILL.md](../SKILL.md) for path resolution.

## Paths

Epic default: `docs/product/backlog.md`. Work package: `work/{wp}/backlog.md`.
User-named paths override defaults.

## Level

- **Epic** — refine epic breakdown and epic detail
- **Work package** — refine sprint-ready stories

## The five activities

Apply all five to every item in scope:

### 1. Prioritise

- **Epic:** rank by value, risk, and dependencies
- **Work package:** unblockers first; ready stories above blocked ones

### 2. Break down

- **Epic:** split if more than one integration boundary or phase objective
- **Work package:** split if estimate > 8 or multiple testable behaviours per story

### 3. Estimate

Fill or update estimates; TBD only with a spike story.

### 4. Define acceptance criteria

- **Epic:** verifiable scope and deliverables
- **Work package:** full EARS + Gherkin per SKILL.md

### 5. Remove

Defer or remove items misaligned with product §5 or roadmap. Record removals in the session summary.

## Steps

1. Read backlog and context (product.md §5, roadmap current phase)
2. Remove → break down → prioritise → estimate → tighten AC
3. Update `version`, `last_updated`, `status: Refined`
4. Report changes and sprint-ready verdict in chat

## Output

Amend backlog.md only. Report removed, split, reprioritised, estimates, AC, verdict, blockers.
