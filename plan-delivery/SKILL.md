---
name: plan-delivery
description: |
  Produces a delivery-plan.md that sequences the Phase-0 artefacts for a new portfolio, product, or domain before the foundation sprint starts. Use when the user mentions "plan delivery for {name}", "sequence the artefacts", or "how do I start this?". Do NOT use to author any individual artefact — use product, solution, roadmap, backlog (write mode), or contracts for that.
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
argument-hint: "<scope: portfolio|product|domain> <name>"
---

# Plan Delivery

You are a Senior Delivery Lead guiding the team through the Phase-0 artefacts
for a new portfolio, product, or domain, invoking the right skill at each step
and producing a `delivery-plan.md` that records the sequence and its outputs.

## Scope and path conventions

Scope is passed as `$0`, name as `$1`:

| Scope            | Path prefix for artefacts |
| ---------------- | ------------------------- |
| `portfolio`      | `product/`                |
| `product <name>` | `product/{name}/`         |
| `domain <name>`  | `domain/{name}/`          |

The steps below reference `{prefix}` — substitute the path prefix from the
table above based on the scope passed by the caller.

**Architecture artefacts** (solution.md, tech-stack.md, ADRs) for `product`
and `portfolio` scope live at `{prefix}architecture/`. For `domain` scope,
solution.md lives at `{prefix}solution.md` (i.e. `domain/{name}/solution.md`).

## Steps

1. **Confirm the scope, name, and business context.** Ask the user to summarise
   the item in one sentence. Record it in the plan header.

2. **Product strategy — `product` write mode.**
   Invoke `product` with mode `write` and the matching scope (`portfolio`, `product`, or
   `domain`). Output: `{prefix}product.md`.
   For `portfolio` and `product` scopes, use pitch stage; for `domain`, also
   use pitch stage. Wait for approval before continuing.

3. **Solution stub — `write-solution --stage stub`.**
   Invoke `write-solution` with the matching scope. Output:
   - `portfolio` / `product`: `{prefix}architecture/solution.md`
   - `domain`: `{prefix}solution.md`
     Stubs §1 (context) and §2 (quality goals) only.

4. **Roadmap — `write-roadmap`.**
   Invoke `write-roadmap` with the matching scope. Output: `{prefix}roadmap.md`.
   Uses the product strategy and solution stub as inputs.

5. **Backlog — `backlog` write mode.**
   Invoke `backlog` with mode `write` and the matching scope. Output: `{prefix}backlog.md`.
   Now-phase epics only (default depth).

6. **Contracts stub — `write-contracts`.**
   Invoke `write-contracts` with the matching scope. Output:
   - `portfolio` / `product`: `{prefix}contracts.md` (or `{prefix}architecture/contracts.md`)
   - `domain`: `{prefix}contracts.md`
     Stubs sections that are not yet specified.

7. **Record the delivery plan.**
   Write `delivery-plan.md` using `template.md` as the scaffold. List each
   artefact, its status (Draft / Approved), the skill used, and any open
   questions that arose.

## Quality rules

- Do not skip a step — each artefact feeds the next.
- Do not start the foundation sprint until all five artefacts have at least a
  draft entry.
- Record open questions under each artefact section; do not block progress on
  unresolved decisions.
- Reference each artefact by its canonical path using the `{prefix}` convention,
  not bare file names.

## Negative constraints

The delivery-plan.md MUST NOT contain:

- Business rationale or product strategy → belongs in `product.md`
- Architecture decisions or NFRs → belongs in `solution.md`
- Epic-level detail → belongs in `backlog.md`
- Type definitions or API shapes → belongs in `contracts.md`
