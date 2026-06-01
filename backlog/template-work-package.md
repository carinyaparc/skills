---
type: Backlog
level: work-package
version: '0.1'
owner: <!-- squad -->
status: Draft
last_updated: <!-- YYYY-MM-DD -->
related:
  - docs/product/backlog.md
  - work/{wp}/design.md
  - docs/architecture/solution.md
---

<!--
DRAFTING AIDE — DELETE BEFORE SAVING.
§3 stories with EARS + Gherkin; §4 traceability and DoD.
-->

# Backlog -- {Work package}

## 1. Summary

**Epic:** {EPIC-ID} | **Phase:** | **Priority:** | **Estimate:**

**Scope.**

**Deliverables.**

**Dependencies.**

## 2. Conventions

| Convention | Value |
| ---------- | ----- |
| Story ID | `{EPIC-ID}-{nn}` |
| Acceptance | EARS + Gherkin per SKILL.md |

## 3. Stories

- [ ] **[{EPIC-ID}-01] {Title}**
  - **Status:** Not started | **Priority:** P0 | **Estimate:**
  - **Epic:** {EPIC-ID} | **Labels:** phase:{phase}, type:{type}
  - **Depends on:**
  - **Deliverable:**
  - **Design:** [`./design.md`](design.md)
  - **Acceptance (EARS):**
    - WHEN , THE SYSTEM SHALL .
  - **Acceptance (Gherkin):**

    ```gherkin
    Scenario:
      Given
      When
      Then
    ```

## 4. Traceability and DoD

### Stories to solution sections

| Story | solution.md |
| ----- | ----------- |

### Definition of Done

- [ ] All EARS and Gherkin pass
- [ ] Tests and CI green; review approved; PR merged

## 5. Handoff

<!-- What this WP leaves stable; what comes next -->
