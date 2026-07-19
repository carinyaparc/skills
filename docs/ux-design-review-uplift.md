# Review: `ux-design-review` skill

Reviewed against Chromatic (visual/interaction/a11y testing), Deque's axe coverage
research, the official Anthropic `frontend-design` plugin, and this repo's own
post-rebuild `code-review` conventions.

Scope: `skills/ux-design-review/` — SKILL.md, 2 prompts, 5 agents, 5 references.

---

## Verdict

Stronger than `code-review` was at the same point. Live-environment-first with an
explicit degradation ladder, an honest automated/manual accessibility split, and a
coverage statement in the verdict are all things the SaaS tools either fudge or omit.

Three structural problems, all inherited from the pre-rebuild `code-review` design:
self-scored confidence, an unspecified merge, and — unique to this skill and the most
expensive — **the browser gets driven up to three times per review**.

One factual correction: the accessibility coverage figure is wrong, and the framing
around it is the wrong framing.

---

## 1. Already strong

| Strength | Detail |
| -------- | ------ |
| Live-first with a degradation ladder | Five levels, running app → static-only, each with stated coverage loss. Neither Chromatic nor Percy degrades gracefully; they simply require the harness. |
| Automated/manual a11y split | Refuses to claim conformance from a scanner alone. This is the single most common dishonesty in a11y tooling and the skill explicitly forbids it. |
| Coverage statement in the verdict | A PASS states which lenses ran live, which ran static, which did not run. Chromatic's "unstable test" flagging is the nearest equivalent and it is weaker. |
| Accessibility override | A11y at Medium+ confidence is always blocking, mirroring code-review's Security override. The right analogy, correctly drawn. |
| Design-source ladder with a "none" level | Seven levels down to "no design source — judge internal consistency, and say so". Never invents a standard. |
| Screenshots never committed | Small thing, consistently enforced across prompt, references, and fix mode. |

---

## 2. Findings

### 2.1 [blocking] The browser is driven up to three times

**Category:** Cost / consistency | **Severity:** Major | **Confidence:** Confirmed

`accessibility-reviewer`, `interaction-states-reviewer`, and `responsive-reviewer` all
work from the live UI. The skill resolves the *environment* once and shares it — but
each agent then independently navigates, sets up states, resizes, and screenshots.

Driving a browser is the most expensive operation in this skill by an order of
magnitude, and it is stateful. Three agents doing it separately means:

- Triple the navigation and state-setup cost.
- Three sets of screenshots of the same states, at the same viewports, which the merge
  step then has to reconcile.
- **Inconsistent evidence.** Agent A's screenshot of the error state and agent B's are
  not the same render. When they disagree, there is no way to tell which was right.

The skill already believes the right principle — "resolve once, share with every
sub-agent" — and applies it to the environment and the design source. It just does not
apply it to the *evidence*, which is the expensive part.

**Recommendation.** Add a **capture step** between resolution and the lenses. One pass
drives the browser and produces a shared evidence bundle:

```
.ux-review/
  screenshots/{page}-{state}-{viewport}.png
  axe/{page}.json
  console/{page}.log
  a11y-tree/{page}.json
  keyboard/{page}-traversal.json     # tab order, focus target, focus-visible capture
  manifest.json                       # what was captured, what was unreachable and why
```

Lenses then read the bundle instead of the browser. Two consequences worth stating:

- Most lenses stop needing browser access at all, which drops them to a cheaper tier
  and removes a whole class of flake.
- `manifest.json` becomes the honest source for the coverage statement — states that
  could not be reached are recorded once, at capture time, rather than each agent
  guessing.

Keyboard traversal must be *scripted into the capture* (tab sequence, focus target per
stop, focus-visible screenshot per stop), otherwise the accessibility lens still needs
live driving and the win evaporates for the highest-value lens.

---

### 2.2 [blocking] No screenshot determinism guidance

**Category:** Correctness of output | **Severity:** Major | **Confidence:** Confirmed

The skill compares captured screenshots against a design source and raises findings
from the difference. There is no guidance anywhere on making a capture reproducible.

This is precisely the problem Chromatic built an entire named feature for (SteadySnap:
"tracks browser activity, freezes dynamic content, and uses burst capture"), and a
separate feature to handle what it cannot fix (flake filter: unstable renders are
flagged and do not block). A naive capture varies between runs on:

- Animations and transitions caught mid-flight.
- Web fonts not yet loaded — text reflows after capture.
- Dates, relative timestamps, random or seeded data, live counters.
- Carousels, autoplay, video posters, skeleton loaders.
- Scrollbar presence and cursor position.

Every one produces a visual "deviation" that is not a defect. A fidelity lens with no
stabilisation will generate false positives at a rate that destroys trust in the whole
review.

**Recommendation.** Add `references/capture-protocol.md`, applied by the capture step:

- Wait for network idle **and** `document.fonts.ready` before every capture.
- Disable animation and transition globally for capture (inject a CSS override; do not
  rely on `prefers-reduced-motion`, which well-behaved apps honour and others ignore).
- Freeze time and seed data where the app allows it.
- Mask or exclude known-dynamic regions, recording what was masked.
- **Capture twice; if the two differ, the region is unstable.** Mark it and exclude it
  from fidelity findings rather than reporting the difference as a deviation.

Add the corresponding rule to the false-positives list: *a visual difference that does
not reproduce across two captures is flake, not a finding.*

---

### 2.3 [blocking] Findings are self-scored, and the merge is one line

**Category:** Correctness of output | **Severity:** Major | **Confidence:** Confirmed

Both problems are identical to the ones just fixed in `code-review`, and both are worse
here.

**Self-scoring.** Sub-agents attach their own confidence. Same anchoring failure, same
fix: an independent `finding-verifier` at fast tier, one per candidate, that never sees
the raising agent's reasoning. UX has an additional verification move available that
code review does not — re-rendering the state and re-checking — so the verifier here can
often *settle* a finding rather than only rating it.

**Merge.** "Merge agent outputs into one verdict" is the whole specification. Visual
findings overlap far more than code findings do: a card with 12px padding where the
token says 16px is simultaneously a Design Fidelity deviation, a Design System
violation, and a Visual Polish inconsistency. Three lenses, three entries, one defect.

**Recommendation.** Port the merge protocol with UX-specific rules:

- Dedupe key is **component + state + viewport + root cause**, not file and line.
  The same defect at three viewports is one finding with three evidence captures,
  not three findings.
- Category precedence: `Accessibility > Interaction/UX > Responsiveness >
  Design Fidelity > Design System > Visual Polish > Content`.
- Corroboration raises confidence — but only across **independent** evidence. Two
  lenses both reading the same screenshot is one observation counted twice, not
  agreement. This trap is easier to fall into here than in code review, because after
  §2.1 every lens reads the same bundle.

---

### 2.4 [warning] The axe coverage figure is wrong, and the framing is unhelpful

**Category:** Accuracy | **Severity:** Moderate | **Confidence:** Confirmed

`accessibility-checklist.md` states: *"Automated scanners catch roughly a third of WCAG
issues."*

Deque's coverage study — 13,000+ page states, ~295,000 issues — puts it differently.
By WCAG success criteria, 16 of 50 AA criteria are automatable, which is where the
"20–30%" figure comes from and which the skill has roughly right. But **by issue
volume, axe-core catches 57.38%**, because the automatable criteria are the
high-frequency ones (contrast alone is 30% of all issues found).

The deeper problem is that a single fraction is not actionable either way. What a
reviewer needs to know is *which criteria automation will never catch*, and Deque's
data answers that precisely — these had **zero** automated detections across the entire
sample:

| Criterion | Manual | What the scan will never tell you |
| --------- | ------ | --------------------------------- |
| 2.4.3 Focus Order | 100% | Tab order follows visual order |
| 2.4.7 Focus Visible | 100% | A visible focus indicator exists |
| 1.4.11 Non-text Contrast | 100% | UI component and graphic contrast |
| 1.3.2 Meaningful Sequence | 100% | Reading order matches DOM order |
| 2.1.2 No Keyboard Trap | 100% | Focus can escape every widget |
| 1.4.10 Reflow | 100% | No horizontal scroll at 320px |
| 4.1.3 Status Messages | 100% | Changes announced to assistive tech |
| 2.4.4 Link Purpose | 100% | Link text makes sense out of context |

**Recommendation.** Replace the fraction with: the volume figure (57%, cited), and this
named list as the mandatory manual pass. The list *is* the manual checklist — every item
is something the skill already asks for, now with evidence for why it cannot be skipped.
It also lets the coverage statement be specific: "axe clean; focus order, focus
visibility, and reflow verified manually" beats "automated scan passed".

---

### 2.5 [warning] No review state, so every re-run re-drives the browser

**Category:** Capability gap | **Severity:** Moderate | **Confidence:** Confirmed

No incremental mode, no persisted findings, no dismissals. Same gap as `code-review`
had — but the cost is higher here, because a re-run means re-resolving the environment,
re-capturing everything, and re-raising findings the author already argued down.

Chromatic's TurboSnap exists for exactly this: use git history and the dependency graph
to snapshot only what changed, cutting run cost by up to 80%.

**Recommendation.** `.agency/reviews/ux-{branch}.json`, same shape as the code-review
state file plus:

- `design_source_ref` — the Figma node version or mockup file hash the last review
  compared against. If it changed, fidelity findings must be re-derived even where the
  code did not change. **No SaaS tool in this comparison detects design-side drift**;
  they all treat the design as fixed and the code as the variable.
- `accepted_deviations` — deviations the work item declared intentional. Currently
  `design-source-resolution.md` records these per-run, so every run re-litigates them.
- `unreachable_states` — carried forward from the capture manifest, so a state that
  could not be reached last time is retried rather than silently skipped again.

---

### 2.6 [warning] Five agents, three input sources

**Category:** Maintainability | **Severity:** Moderate | **Confidence:** Confirmed

`CONTRIBUTING.md` now states the rule: an agent earns a context window by reading a
distinct **input source**, not by covering a distinct topic. The five UX agents fail it.

| Agent | Actually reads |
| ----- | -------------- |
| accessibility-reviewer | Live UI + axe results |
| interaction-states-reviewer | Live UI |
| responsive-reviewer | Live UI |
| design-fidelity-reviewer | Design source + screenshots |
| design-system-reviewer | Static code (tokens, components) |

Two merges follow, on the same reasoning as `requirements-reviewer` and
`conventions-reviewer`:

**`interaction-states` + `responsive` → `experience-reviewer`.** Same input, same kind
of judgement (does the rendered experience hold up when I vary a dimension), same
evidence type. Splitting them loses the intersection: *the error state at 375px* is
where both lenses meet and neither currently owns it. Overflowing error text on mobile
is the most common real defect in this space and it falls exactly in the gap.

**`design-fidelity` + `design-system` → `conformance-reviewer`.** Both answer "does the
implementation match its declared design truth", and the design-source ladder already
treats mockups and tokens as levels of one resolution rather than separate sources.
Merged, the 12px-vs-`space-400` case becomes one finding with both a screenshot and a
file:line, instead of two findings that the merge step has to recognise as one.

`accessibility-reviewer` stays separate despite sharing the live-UI input: its judgement
is conformance against cited criteria with a compliance floor and its own override rule,
which is a different kind of judgement from heuristic quality.

Result: **3 lenses + verifier**, mirroring code-review's shape.

---

### 2.7 [suggestion] Unstated coverage limits

**Category:** Honesty | **Severity:** Minor | **Confidence:** Confirmed

The skill is unusually honest about coverage, which makes the remaining silences stand
out.

- **Single browser.** Chromatic tests Chrome, Firefox, Safari, and Edge in parallel.
  This skill drives one Chromium. That is a reasonable scope decision, not a defect —
  but it should appear in the coverage statement, not be silently absent.
- **Dark mode and forced-colors.** Named in `responsive-reviewer`'s focus line and in
  one ux-heuristics bullet, but there is no checklist and no capture requirement. If
  the app implements a theme, it doubles the capture matrix; that needs to be a stated
  decision either way.
- **Reduced motion.** Listed as a check, but it now conflicts with §2.2's guidance to
  disable animation for capture. The capture protocol must distinguish *disabling
  animation to stabilise a screenshot* from *verifying the app honours the user's
  preference* — they are opposite operations on the same setting, and doing the first
  silently defeats the second.

---

### 2.8 [suggestion] Repo hygiene

**Category:** Maintainability | **Severity:** Minor | **Confidence:** Confirmed

1. **No evals**, despite five agents and the highest false-positive surface of any
   skill in the repo.
2. **`finding-classification.md` is ~80% duplicated** from code-review's copy — same
   severity table, same confidence table, same matrix, same "who uses what". Only the
   category table and the override differ. It has already drifted: this copy still has
   the `verify further` cell that code-review replaced with `escalate`.
3. **Agent frontmatter** has no `model_tier`, no reading budgets, and blanket `Bash`.
4. **`ux-design-review fix` still uses the old routing**, now inconsistent with
   `code-review-fix`.

---

## 3. Split and flatten

**`ux-design-review` (read) + `ux-design-review-fix` (write). No alias. Both flat.**

Same reasoning as `code-review`: an alias forces the read skill to keep `Write` and to
keep advertising fix behaviour in its description, which defeats both the safety and
the routing benefit.

**Why a separate fix skill rather than reusing `code-review-fix`** — the two write
skills differ in every step that matters:

| | `code-review-fix` | `ux-design-review-fix` |
| --- | --- | --- |
| Verification | typecheck, tests | re-render the state, re-capture, re-run the failed axe rule |
| Needs resolved | nothing | design source **and** live environment |
| Fix routing | inline vs defer to ADR | prefer token swap / library component over local CSS patch |
| Conflict rule | none | accessibility wins over visual; never regress one for the other |
| Regression risk | caught by tests | **caught by nothing** — a spacing change shifts siblings silently |

That last row is the strongest argument. There is no typecheck for "looks right", so
the fix skill needs a neighbour re-check step that has no analogue in code fixing. A
merged skill would carry both toolchains and apply the wrong one half the time.

The read skill keeps `Write(.agency/reviews/**)` for state only, same carve-out as
`code-review`, with the prose constraint as backstop.

---

## 4. Sequence

1. Capture step + `capture-protocol.md` (§2.1, §2.2). Everything else depends on the
   evidence bundle existing.
2. Lens consolidation to 3 + verifier (§2.6, §2.3).
3. Merge protocol (§2.3).
4. Accessibility checklist correction (§2.4). Small, factual, high value.
5. Split and flatten (§3), with trigger evals proving routing both directions.
6. Review state, including design-source drift (§2.5).
7. Coverage limits and hygiene (§2.7, §2.8).
