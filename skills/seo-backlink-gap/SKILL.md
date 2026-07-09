---
name: seo-backlink-gap
description: Find referring domains that link to multiple competitors but not to your site, then enrich with authority, anchor samples, and outreach angle per row. Produces a prospect list an outreach team can start emailing tomorrow. Use when the user asks for backlink gap analysis, link building opportunities, competitor backlink intersection, link prospecting, or wants referring domains they are missing.
---

> Example output: [examples/seo-backlink-gap-linear-app-20260514/REPORT.md](../../examples/seo-backlink-gap-linear-app-20260514/REPORT.md)

# Backlink Gap

Produce an actionable link-prospecting list: domains linking to your top competitors but not to you, filtered by authority and relevance, enriched with anchor samples and a suggested outreach angle.

## Prerequisites

- DataForSEO MCP server connected. All DataForSEO APIs (incl. Backlinks) are pay-as-you-go with no monthly minimum — see `CLAUDE.md`.
- Claude's `WebFetch` tool available (used for prospect scoring and topical relevance checks).
- User provides: (a) target domain, (b) 3 to 5 competitor domains, and optionally (c) minimum Domain Rank (default: 25), (d) dofollow-only (default: true), (e) minimum intersection count (default: linked by at least 2 of the N competitors).

## Process

1. **Validate target & preflight.** See `skills/seo-firecrawl/references/preflight.md` (budget guard, Firecrawl availability, Google APIs) and `CLAUDE.md` (market defaults, cost discipline). Skill-specific notes:
   - Typical DataForSEO calls: ~3–4 (1 intersection + 1 bulk-ranks + up to a small batch of anchor pulls, capped at the top 25). Well under the budget-guard threshold.
   - Firecrawl: optional (WebFetch fallback for prospect topical-relevance checks). Google APIs: not used.

2. **Find the gap in one call** `backlinks_domain_intersection`
   - This is the primary data path — it replaces per-competitor pulls + manual intersection. Set:
     - `targets`: the competitor domains (up to 20).
     - `exclude_targets`: `[{target domain}]` — the endpoint returns referring domains that link to the competitors but **not** to the target, so the exclusion is done server-side (no separate baseline pull of the target's own backlinks needed).
     - `filters`: `[["dofollow","=",true],"and",["rank",">",{min_domain_rank}]]` (defaults: dofollow true, rank > 25). Dofollow + rank are the two levers; drop/relax either in step 3 if the result is empty.
     - `limit`: 100. `order_by`: `["rank,desc"]`.
   - From the response, retain rows whose intersection count meets the minimum (default: links to ≥2 of the N competitors).
   - Optionally pull `backlinks_summary` on the target once, purely for report context (its existing referring-domain count) — cheap, skip if not needed.

3. **Empty / thin intersection handling.**
   - If the call returns 0 (or fewer than ~5) rows — common when competitors are young or share few backlinks — do **not** conclude "no gap" yet. Widen before giving up: (a) lower the `rank` threshold, (b) drop the `dofollow` filter, (c) add more or closer competitors, (d) relax min-intersection to 1. Re-run the single call with the relaxed filters.
   - Record in `REPORT.md` which relaxations were applied and that the prospect-quality bar was correspondingly lowered.

4. **Enrichment (top 25 candidates only)** `backlinks_bulk_ranks`, `backlinks_anchors`
   - Cap enrichment at the top 25 candidates by rank to control call count. `backlinks_domain_intersection` already returns Domain Rank, so only call `backlinks_bulk_ranks` (one call, all 25 targets) if you need fresher/rescaled ranks.
   - For anchor samples, call `backlinks_anchors` on each candidate (top 3 anchors) — top 25 only. Classify by link type: editorial, resource list, directory, forum/UGC.

5. **Relevance scoring**
   - Score each candidate on: (a) topical overlap (use domain homepage title/meta via WebFetch), (b) Domain Rank, (c) intersection count, (d) link-type preference.
   - Suggest an outreach angle per row: local fit, topical fit, competitive parity, resource-list inclusion, broken link, etc.

6. **Produce the prospect list** (see Output Format).

## Output format

Create a folder `output/seo-backlink-gap-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-backlink-gap-{target-slug}-{YYYYMMDD}/
├── prospects.csv          # machine-readable output
├── REPORT.md              # primary deliverable
└── evidence/
    └── intersection-raw.md   # raw backlinks_domain_intersection response + any relaxations applied
```

`REPORT.md` opens with the filters applied (dofollow / min Domain Rank / min intersection, plus any step-3 relaxations), a Top-25 prospects table (domain · DR · links-to count · sample anchor · link type · angle · score), an outreach brief (batch by link type), and counts. Full skeleton: `templates/report.md`.

`prospects.csv` columns:
`rank,referring_domain,domain_rank,links_to_count,links_to_competitors,sample_anchor,link_type,outreach_angle,score`

## Tips

- The gap itself is a single `backlinks_domain_intersection` call regardless of competitor count (up to 20 targets) — no per-competitor fan-out. The only loop is anchor enrichment on the top 25, paced under the 10 req/s rate limit.
- Do not include subdomains of already-linked domains in the prospect list. If news.example.com links to the target but blog.example.com links only to competitors, treat as already-linked unless the user asks otherwise.
- The "Angle" column is the most important output for outreach. Keep it specific: "Their 'best X tools' list from 2024 is out of date and doesn't include you" beats "topical fit".
- Exclude obvious spam/low-quality domains even if they pass Domain Rank thresholds. Use the WebFetch step to sanity-check any prospect scoring above 80.
- If the target already outranks all competitors for branded terms, prioritise non-branded editorial placements over parity directories.
