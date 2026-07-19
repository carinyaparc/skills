---
name: ux-design-review-fix
description: >
  Use when the user wants to address, action, or fix findings from a UX or
  design review — accessibility failures, interaction and responsive defects,
  design-fidelity deviations, or design-system divergences. Triggers on "fix the
  UX review findings", "address the accessibility issues", "action the design
  feedback", "apply the UX review comments". Optionally scoped to an action tier
  (blocking, warning, all). Makes targeted presentation changes, re-renders and
  re-captures to verify visually, and commits. Do NOT use to perform a UX review
  (ux-design-review), to fix code-review findings (code-review-fix), to
  implement new UI or flows (implement), or to redesign components.
license: MIT
compatibility: Requires git, the project's validation toolchain, and a runnable UI plus Playwright or browser MCP tools for visual verification.
allowed-tools: Read Write Edit Glob Grep Bash
argument-hint: "[blocking|warning|all] [review-output-or-path]"
metadata:
  author: daddia
  version: "1.0"
  owner: web-development
  work_shape: targeted-change
  output_class: code-change
---

# UX design review fix

You are a Senior Frontend Engineer addressing findings from a UX design review. You fix
what the user experiences without changing what the feature does.

This is the write half of the UX review loop. `ux-design-review` produces labelled
findings and changes nothing; this skill consumes those labels and changes code. It does
not re-review. If a finding is wrong, say so rather than implementing it.

## Why this is not `code-review-fix`

The two write skills differ in every step that matters, which is why they are separate
skills rather than one with a mode:

| | `code-review-fix` | this skill |
| --- | --- | --- |
| Verification | typecheck, tests | re-render the state, re-capture, re-run the failed axe rule |
| Needs resolved | nothing | the design source **and** a live environment |
| Fix routing | inline vs defer to ADR | prefer the token or library component over a local CSS patch |
| Conflict rule | none | accessibility wins over visual, always |
| Regression risk | caught by tests | **caught by nothing** — a spacing change shifts siblings silently |

That last row drives the design. There is no typecheck for "looks right", so this skill
carries a neighbour re-check step that has no analogue in code fixing.

## Input

The review output, from `ux-design-review` or a reviewer's comments. Findings from this
repo's review carry an action label and `Category | Severity | Confidence`. Where labels
are absent, infer the tier: an accessibility failure or a broken flow is `blocking`, a
"consider" or "nit" is `suggestion`.

You also need what the review resolved: the design source and a runnable environment.
Re-resolve them per
[../ux-design-review/references/design-source-resolution.md](../ux-design-review/references/design-source-resolution.md)
and
[../ux-design-review/references/environment-resolution.md](../ux-design-review/references/environment-resolution.md)
if the review did not hand them over.

**Without a live environment you cannot verify a visual fix.** Say so and stop, rather
than making changes you cannot check — an unverified visual "fix" is worse than an open
finding, because it looks resolved.

## Scope

Address every finding **at or above** the threshold. Leave the rest untouched and list
them under "Findings Not Addressed".

| Command | Addresses |
| ------- | --------- |
| `ux-design-review-fix` (default) | blocking + warning + suggestion |
| `ux-design-review-fix warning` | blocking + warning |
| `ux-design-review-fix blocking` | blocking only |

`all` is an alias for the default.

## Steps

1. **Read the review in full** before touching any file. Visual fixes interact — a
   spacing change to satisfy one finding often resolves or worsens another.

2. **Triage by label**, dropping those below the threshold. Within scope, work
   **accessibility first, then blocking, then the rest**. Accessibility leads because it
   is the compliance floor and because a visual fix applied first may have to be redone
   to accommodate it.

3. **Route each finding by what the fix requires:**

   | Finding | Route |
   | ------- | ----- |
   | Accessibility failure | Fix inline — always in scope |
   | Hard-coded value where a token exists | Swap for the token |
   | Bespoke element where the library has one | Replace with the library component |
   | Fidelity deviation with a token cause | Fix via the token, not a local override |
   | Fidelity deviation with no token | **Defer** — needs a design-system decision |
   | Pattern or component redesign | **Defer** — goes to the design source owner |
   | Design source itself is wrong (e.g. fails contrast) | **Defer** — raise with the designer, do not implement |

   Prefer the design-system route over a local patch every time. A local CSS override
   that matches the mockup today is the drift the next review will flag.

4. **Push back where warranted.** A finding is not automatically correct. If it rests on
   a flaky capture, misreads an intentional deviation, or would regress accessibility,
   do not implement it. Record it under "Findings Disputed" with evidence.

5. **Read every file you will modify** before changing it.

6. **Make targeted changes.** One finding, one change, smallest diff.

7. **Verify visually.** There is no typecheck for "looks right":
   - Re-render the affected state at the viewports the review used.
   - Re-capture, following
     [../ux-design-review/references/capture-protocol.md](../ux-design-review/references/capture-protocol.md)
     — same determinism rules, or your "after" is not comparable to the review's
     "before".
   - Put the new capture beside the review's original and confirm the finding is
     resolved.
   - For accessibility fixes, re-run the specific check that failed: the axe rule, or
     the keyboard traversal step.

8. **Re-check neighbours.** A spacing or token change shifts siblings. Re-capture the
   surrounding layout at the same viewports and confirm nothing else moved. This is the
   step that catches the regressions no test will.

9. **Run the project's validation suite.** Discover the commands from AGENTS.md or
   CLAUDE.md, else the CI config: format, lint, typecheck, build, tests. All must pass.

10. **Review the full diff** with `git diff` before committing.

11. **Commit in logical units** tied to the findings: `fix(ui): what and why`.

12. **Update review state.** If `.agency/reviews/ux-{branch}.json` exists, mark each
    finding `fixed`, `deferred`, or `dismissed` with the reason. Add anything the author
    confirmed as intentional to `accepted_deviations`, so the next review stops raising
    it.

## Quality rules

- Preserve functional behaviour. UX fixes change presentation and affordances, never
  what the feature does.
- **Accessibility never regresses to satisfy a visual finding.** Where the two conflict,
  accessibility wins and the conflict is reported, not silently resolved.
- Read before writing.
- One finding, one change.
- Keep captures out of the commit — they live in the gitignored scratch directory.
- Do not introduce new UI, states, or flows.

## Must not

- Redesign components or flows — pattern-level change goes back to the design source
  owner as a follow-up.
- Suppress accessibility tooling — axe rules, a11y lint plugins — to make a finding
  disappear. Fix the cause or escalate.
- Fork the design system. Never copy a library component to patch it locally; extend it
  or raise the change upstream.
- Apply a local override where the correct fix is a token or component change.
- Commit while any validation check is failing.
- Commit captures or screenshots.
- Re-review the UI or raise new findings. Note anything you spot as a follow-up in the
  summary; do not fix it under cover of this pass.

## Output format

<example>
## UX Review Fix Summary

**Branch:** feat/checkout-summary
**Scope:** warning (blocking + warning)
**Findings addressed:** 1 blocking, 2 warnings

### Changes Made

- `src/components/PaymentForm.tsx` [modified]
  - Blocking (Accessibility, WCAG 2.4.7): added visible focus ring via the
    `focus-ring` token
- `src/components/SummaryCard.tsx` [modified]
  - Warning (Design Fidelity): replaced hard-coded 12px padding with `space-400`
  - Warning (Design System): swapped the bespoke badge for `<Badge>` from the library

### Findings Not Addressed (below threshold)

- Suggestion: empty-cart copy reads as an error — out of scope for `fix warning`

### Findings Deferred

- Fidelity: header uses a 14px size the scale does not provide — needs a design-system
  decision, raised as PROJ-014

### Findings Disputed

- Warning: "summary card misaligned at 768" — the review's capture was of an unstable
  region (`.order-timer` animating). Re-captured twice: alignment is correct. Marked
  dismissed in review state.

### Verification

- Re-rendered: payment form (375, 1440), summary card (1440) — captures in `.ux-review/`
- Neighbour re-check: cart list and totals unchanged at both viewports
- Axe re-scan on /checkout: 0 violations. Keyboard traversal: focus visible at all 9 stops
- Format / lint / typecheck / build / tests: pass

### Review state

`.agency/reviews/ux-feat-checkout-summary.json` updated: 3 fixed, 1 deferred,
1 dismissed.
</example>
