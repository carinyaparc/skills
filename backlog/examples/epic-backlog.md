---
type: Backlog
level: epic
---

# Backlog -- Checkout

- **Product:** `docs/product/product.md`
- **Solution:** `docs/architecture/solution.md`
- **Roadmap:** `docs/product/roadmap.md`

## 1. Summary

**Objective.** Deliver end-to-end order placement: payment form, placement action, and order confirmation.

**Prerequisites (required).** Cart service delivers `CartViewModel` with line items and totals. Payments sandbox in staging. Orders API staging endpoint verified.

**Out of scope.** See `product.md` §5 and `roadmap.md` deferred section.

## 2. Conventions

| Convention | Value |
| ---------- | ----- |
| Epic ID | `CHK{nn}` |
| Story ID | `CHK{nn}-{nn}` (work-package backlog) |
| Priority | P0–P2 |
| Estimation | Fibonacci points |

## 3. Epic breakdown

| Epic | Title | Phase | Priority | Deps | Points | Work package | Status |
| ---- | ----- | ----- | -------- | ---- | ------ | ------------ | ------ |
| CHK01 | Checkout foundation | Now | P0 | - | 13 | `work/checkout/01-foundations/` | Done |
| CHK02 | Payment and placement | Now | P0 | CHK01 | 18 | `work/checkout/02-placement/` | Not started |
| CHK03 | Order confirmation | Now | P0 | CHK02 | 8 | `work/checkout/03-confirmation/` (planned) | Not started |

## 4. Critical path

```text
CHK01 → CHK02 → CHK03
```
