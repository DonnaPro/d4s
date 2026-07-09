# Local scoring: review-health thresholds & verdict heuristic

Used by `seo-local` step 7 (review aggregation) and step 10 (synthesise verdict). Kept out of `SKILL.md` so the thresholds live in one place.

## Review-health thresholds (step 7 aggregate signals)

- **Velocity:** ≥1 new review in the last 18 days = healthy (Sterling Sky 18-day rule, as of 2026-01 — re-verify). >21 days since the last review = "review cliff" risk; treat as a leading indicator of an upcoming local-pack rank drop.
- **Volume:** <10 Google reviews flags below the commonly-cited "magic threshold".
- **Star rating:** 4.5+ matches consumer filtering thresholds (BrightLocal reported 31% of consumers only consider 4.5+ businesses, as of 2026 — re-verify).
- **Owner-response rate on Google:** <50% on the most recent 10 reviews = engagement gap.

## Verdict heuristic (step 10)

Score the 5 local dimensions 0–10 each, then take the composite and apply:

- **STRONG:** composite ≥7/10, NAP consistent across all sampled pages, target in local pack on the majority of keywords, valid LocalBusiness schema with industry-correct subtype, ≥10 Google reviews with healthy velocity.
- **NEEDS WORK:** composite 4–6.9/10, OR 1+ NAP discrepancy, OR target out of the local pack on the majority of keywords. The "Top fixes" section is the deliverable here — most local-SEO audits land in this bucket.
- **WEAK:** composite <4/10, OR no LocalBusiness schema and no NAP visible on the page, OR target absent from the local pack on every tracked keyword. Substantial work required across multiple dimensions.

If the most recent review is >21 days old, flag the review-velocity issue as **Critical** regardless of star rating.
