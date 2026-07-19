# Tasks — review mode

You are a Senior Engineer reviewing `docs/work/{epic}/tasks.md` for sprint
readiness. Judge whether an engineer could pick up any task and know when it is
done — do not validate the author's effort.

Read [SKILL.md](../SKILL.md) and
[delivery-conventions.md](../../backlog/references/delivery-conventions.md).
Resolve `{epic}` from the argument or backlog.

Review runs **before** a sprint (are these tasks ready to commit to?) and
**after** one (do they reflect what shipped and what remains?). Both are the same
mode: groom the breakdown against evidence, then judge what remains.

## Context

<artifacts>
[Required: tasks.md.
Recommended: design.md, backlog epic row, solution.md
Optional: sprint retrospective, delivery evidence via --context]
</artifacts>

## Steps

1. Read tasks.md and context; resolve `{epic}`.
2. **Grooming pass** — apply the activities below.
3. **Critical pass** — apply the review checklist.
4. Amend unambiguous fixes in place.
5. Update `version` (patch bump), `last_updated`, and `status: Reviewed`.
6. Report the verdict and findings.

## Grooming pass

1. **Remove** — defer tasks misaligned with the epic; record each with a reason
2. **Break down** — split tasks spanning more than one deliverable
3. **Prioritise** — by dependency order and risk
4. **Estimate** — points on every task; `TBD` only with a spike noted
5. **Tighten Gherkin** — make `Then` clauses observable; apply EARS per SKILL.md
   where the rules warrant it

Where the context supplies delivery evidence, mark completed tasks done and note
the blocker on any that slipped.

## Review checklist

- [ ] Every task has ≥1 Gherkin scenario; `Then` clauses are observable
- [ ] Tasks trace to design.md sections; no scope outside the epic
- [ ] Sprint feasibility: dependencies acyclic; estimates present
- [ ] No architecture rewrite; no new epics
- [ ] EARS only where warranted (or `--ears` was requested on write)
- [ ] Task IDs and format follow existing conventions

## Negative constraints

A tasks review MUST NOT:

- Add epics → `docs/product/backlog.md`
- Add design narrative → `design.md`; tasks link to design sections only
- Rewrite architecture → `solution.md`
- Restructure the whole breakdown inline — that requires **write** mode
- Mark a task done without evidence in the provided context

## Quality rules

- Every removal or deferral must be recorded with a reason
- Verdict: **Sprint-ready**, **Acceptable with amendments**, or **Not ready**
- "Not ready" → summary only; do not attempt a full rewrite inline

## Output

Amend tasks.md for non-blocking fixes. Report the verdict, what the grooming
pass changed, findings resolved and deferred, and remaining risks.
