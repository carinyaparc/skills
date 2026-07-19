---
name: docs
description: >
  Use for cross-document alignment passes over product, solution, and
  docs/work/{epic}/design.md — pre-sprint (are these documents complete,
  consistent, and aligned before implementation?) and sprint-end (triage ADR
  candidates, archive superseded design, record a session summary). Triggers on
  "review the docs", "are the docs aligned", "sprint-end doc pass", "triage ADR
  candidates". Writes docs/work/{epic}/refine-session.md when run at sprint end.
  Do NOT use for sprint retrospective (sprint), epic validation against AC
  (validate), writing backlog (backlog), initial architecture (solution), or
  code review (code-review).
license: MIT
allowed-tools: Read Write Edit Glob Grep
argument-hint: "<epic> [--context <notes>]"
metadata:
  author: daddia
  version: "1.0"
  owner: architecture
  work_shape: review-and-gate
  output_class: decision-support
---

# Docs

You are a Lead Solution Architect performing a cross-document alignment pass on
product, solution, and epic design.

Read [../backlog/references/delivery-conventions.md](../backlog/references/delivery-conventions.md)
when resolving `{epic}`. Resolve `{epic}` from the argument or the backlog.

This skill runs at two points in the cycle and adapts to which one applies:

- **Pre-sprint** — the documents must be complete, consistent, and aligned
  before implementation begins.
- **Sprint-end** — the epic's design has produced ADR candidates and superseded
  sections that must be triaged, and a session summary recorded.

Run both halves when the context supports both. Run only the alignment half when
no epic work has completed yet.

## Default paths

| Artefact       | Default                                  |
| -------------- | ---------------------------------------- |
| Product        | `docs/product/product.md`                |
| Solution       | `docs/architecture/solution.md`          |
| ADR register   | `docs/architecture/decisions/register.md` |
| Epic design    | `docs/work/{epic}/design.md`             |
| Session record | `docs/work/{epic}/refine-session.md`     |

If the user names other paths, use them.

## Alignment pass

1. Read product.md and solution.md (and the ADR register if architectural
   decisions are in play).
2. **product.md** — goals, success metrics, out-of-scope, and open questions are
   all present and tracked.
3. **solution.md** — §1 matches product; quality goals stated; building blocks
   named; data model complete; API shapes in §6–§7 or explicitly stubbed;
   testing approach outlined.
4. **Alignment** — every product goal has solution coverage; flag orphan
   components that serve no product goal.
5. **Amend in place** — fix unambiguous gaps, or insert `<!-- TODO -->` naming
   what is missing. Do not rewrite wholesale.

## Sprint-end pass

Run when the epic has completed work:

1. Read `docs/work/{epic}/design.md` and triage its ADR candidates.
2. For each candidate: **promote** (write it via **adr**), **inline** (fold into
   solution.md where it is not a standalone decision), or **defer** (record with
   a reason).
3. Update solution.md §9 (ADR log) and §10 (risks, debt, open questions).
4. Archive superseded design sections with
   `<!-- ARCHIVED: superseded by ... -->`. Do not delete.
5. Write `docs/work/{epic}/refine-session.md` using
   [assets/refine-session.template.md](assets/refine-session.template.md).

## Gotchas

- **Sprint retro** is `sprint retrospective`, not this skill.
- **Task AC** stays in `tasks.md` — this pass does not rewrite Gherkin.
- **ADR candidates** are promoted to the register via **adr**, never written
  inline into solution.md.

## Negative constraints

A docs pass MUST NOT:

- Change business strategy → **product** skill
- Add implementation detail or code → `design.md` or `solution.md` §6–§7
- Add story AC → `docs/work/{epic}/tasks.md`
- Delete superseded design content — archive it with an HTML comment
- Re-narrate design content in the session record — cite sections instead
- Rewrite any document wholesale — that is the owning skill's **write** mode

## Output

Amend the documents in place. Report blocking versus non-blocking findings, the
ADR candidates promoted, inlined, or deferred, and the path of the session
record if one was written.
