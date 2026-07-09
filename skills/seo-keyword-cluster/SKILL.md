---
name: seo-keyword-cluster
description: Build a content cluster plan from seed keywords — intent-grouped clusters, pillar+spokes architecture with H1/H2 suggestions per spoke, prioritised build order, and an internal-linking map. Plans a content tier across many articles (vs `seo-content-brief` which produces a single article from a topic; vs `seo-page` which audits one existing URL). Use when the user asks for keyword clustering, topical map, pillar content strategy, content cluster plan, or content calendar from a keyword list.
---

> Example output: [examples/seo-keyword-cluster-headless-cms-20260514/PLAN.md](../../examples/seo-keyword-cluster-headless-cms-20260514/PLAN.md)

# Keyword Cluster

Transform seed keywords into a prioritised cluster plan: each cluster grouped by search intent and theme, with volume totals, a pillar concept, spoke articles, and suggested H1/H2 for each spoke.

## Prerequisites

- DataForSEO MCP server connected.
- User provides: (a) 3 to 20 seed keywords, (b) market — per CLAUDE.md defaults (UK unless the user specifies), and optionally (c) minimum volume threshold (default: 100/mo), (d) maximum KD (default: 60).

## Process

1. **Expand seeds** `dataforseo_labs_google_related_keywords`, `dataforseo_labs_google_keyword_suggestions`
   - For each seed, pull related + long-tail suggestion variants in the target market (set `limit` + filters per CLAUDE.md).
   - Target at least 100 candidate keywords per seed; de-duplicate across seeds.

2. **Question-based expansion** `dataforseo_labs_google_related_keywords`
   - Pull question-intent keywords for the top 5 seeds.
   - These usually become spoke articles with PAA/featured-snippet potential.

3. **Clean and filter**
   - Remove keywords below min volume and above max KD.
   - Strip branded terms the target does not own.
   - Tag each keyword with detected intent: informational, commercial, transactional, navigational.

4. **Cluster by SERP overlap** `serp_organic_live_advanced`
   - Group keywords by how Google actually ranks them — shared top-10 organic URLs — not by text similarity. Token-overlap clustering manufactures cannibalisation; see `references/serp-overlap-methodology.md` for the full algorithm and anti-pattern callouts.
   - **Budget guard before running.** Compute `estimated_credits = num_candidate_keywords × per_keyword_cost` where `per_keyword_cost = 3` (SERP-standard, default) or `10` (SERP-advanced, only if downstream needs AIO/PAA). Standard is sufficient for clustering. If `estimated_credits > 500`, surface the figure to the user and offer two paths: (a) proceed with SERP-standard, (b) trim the candidate set by raising the min-volume / lowering the max-KD thresholds in step 3 and re-running. If the user already requested SERP-advanced and the estimate exceeds 500, additionally offer SERP-standard as a cheaper fallback.
   - **Fetch SERPs** (one call per unique candidate keyword, cached for the session) — see `references/serp-overlap-methodology.md` § "Caching". Total SERP fetches = number of keywords, not number of pairs.
   - **Pairwise overlap scoring.** For each pair within an intent pre-group (see `references/serp-overlap-methodology.md` § "Pre-Grouping" for the optimisation that avoids full O(N²)), count shared URLs in the top 10 organic. Apply thresholds: 7-10 shared = same post (merge keywords), 4-6 = same cluster, 2-3 = interlink across clusters, 0-1 = separate clusters or exclude.
   - **Form clusters** from the connected components in the 4-6+ overlap graph. Target 5 to 12 clusters. Each cluster gets a name, primary keyword, secondary keywords, total volume, weighted KD.
   - Classify each cluster as pillar-worthy (broad, high volume, informational) or spoke-only (narrow, specific).

5. **Pillar plus spokes architecture**
   - For each pillar cluster, nominate 3 to 7 spoke articles (each one from a sub-cluster or question).
   - For each spoke, draft an H1 and 3 to 5 H2s.
   - Map internal-link structure: pillar links to all spokes, spokes link back to pillar, spokes cross-link where topically adjacent.

6. **Prioritise**
   - Applied **after** clusters are formed via SERP-overlap in step 4 — the formula scores already-grouped clusters, it does not influence which keywords cluster together.
   - Score each cluster: volume (40%) + inverse KD (30%) + commercial intent weighting (30%).
   - Output a prioritised build order.

7. **Quality scorecard** (post-synthesis validation)
   - After `PLAN.md` is written, run the 4-metric quality scorecard against the produced plan and warn the user if any metric fails. The four gates + thresholds:
     - **Cannibalisation** (zero tolerance): no two clusters share ≥ 40% SERP overlap.
     - **Orphan** (zero tolerance): every spoke is linked from its pillar.
     - **Coverage**: each pillar covers ≥ 70% of its cluster's high-volume keywords.
     - **Anchor diversity**: no single anchor used > 40% of internal links within a cluster.
   - Full definitions, computation, and the pass/fail output protocol (append to `PLAN.md`; write a standalone `06-quality-scorecard.md`; annotate the verdict header on failure) live in `references/quality-scorecard.md`. A failed cannibalisation gate means re-merge the clusters and re-run from step 5.

## Output format

Create a folder `output/seo-keyword-cluster-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-keyword-cluster-{target-slug}-{YYYYMMDD}/
├── 01-seed-expansion.md
├── 02-filtered-keywords.md
├── 03-cluster-assignment.md      (SERP overlap matrix + cluster groupings)
├── 06-quality-scorecard.md       (evidence) — 4-metric gate result; written every run
├── keywords.csv
└── PLAN.md
```

`PLAN.md` opens with a header (topic + `(needs review …)` if step 7 flagged failures), market, and seeds; a summary (keywords analysed / clusters / combined volume / pillars+spokes / clustering method); a build order (per-cluster pillar + spoke articles with H1/H2s and priority scores); an internal-linking map; the quality scorecard (all-pass line or red/yellow/green table); and a raw-data pointer. Full skeleton: `templates/report.md`.

`keywords.csv` columns:
`keyword,volume,kd,cpc,intent,cluster,role_in_cluster`

## Tips

- Respect DataForSEO API rate limit: 10 requests per second. With 20 seeds and 3 expansion endpoints, this is ~60 calls; pace sequentially.
- The dominant cost driver is the SERP-overlap pass in step 4: ≈ 3 credits per candidate keyword in SERP-standard mode (default), ≈ 10 credits in SERP-advanced. A typical 40-keyword candidate set is ≈ 120 credits standard / ≈ 400 credits advanced. Step 4's budget guard surfaces this estimate to the user before fetching any SERPs and offers a cheaper-fallback path if the estimate exceeds 500 credits.
- Do not lump different intents into the same cluster even if the keywords are semantically similar. "Best X" (commercial) and "What is X" (informational) deserve separate content.
- Pillar pages fail when they try to rank for too narrow a query. The primary keyword of a pillar cluster should have volume > 1,000/mo and be broad enough to justify a 3,000+ word article.
- The priority score is a starting point, not a mandate. Ask the user to review the top 3 clusters before committing a quarter of content.
- **Cluster merging is now SERP-driven, not text-driven.** If two clusters share ≥ 40% SERP overlap with each other, the step-7 cannibalisation gate flags them — re-merge those clusters and re-run from step 5.
