---
name: seo-subdomain
description: Subdomain ownership map for a domain. Lists subdomains, queries overview/keywords/competitors/backlinks per subdomain, surfaces which subdomains own which topic clusters, where there's fragmentation, and whether consolidation is warranted. Use when the user asks "subdomain analysis", "subdomain ownership", "subdomain SEO", "blog vs main domain", "support vs docs subdomain", or "should I consolidate subdomains".
---
> Example output: [examples/seo-subdomain-notion-so-20260514/SUBDOMAINS.md](../../examples/seo-subdomain-notion-so-20260514/SUBDOMAINS.md)

# Subdomain Analysis

Map a domain's subdomain ecosystem. Which subdomains exist, what each ranks for, where they overlap, and whether the structure is healthy or fragmented. Output: an ownership map (which topic is owned by which subdomain), a fragmentation report, and recommendations for consolidate / split / leave alone.

## Prerequisites

- DataForSEO MCP server connected.
- User provides: a target root domain (e.g. `example.com`). The skill discovers subdomains automatically.
- Optional: `--limit N` to cap the number of subdomains analysed (default: top 10 by ranked keyword count).

## Process

1. **Validate & preflight.** Normalise root domain (no protocol, no `www.`). See `skills/seo-firecrawl/references/preflight.md` (budget guard) and `CLAUDE.md` (market defaults, cost discipline). Skill-specific notes:
   - Cost is **~3 calls per subdomain** (overview + ranked keywords + competitors) **plus 3 shared calls** (1 discovery + 2 bulk backlinks endpoints that cover every subdomain in one call each) ≈ **3N + 3**. At the default top-10 limit that's ~33 calls — over the ~10-call budget-guard threshold, so surface the estimate and confirm before running.
   - Firecrawl: not used. Google APIs: not used.

2. **Discover subdomains** `dataforseo_labs_google_subdomains`
   - List all subdomains of the root domain with keyword count, traffic estimate.
   - Sort by ranked-keyword count descending.
   - Apply `--limit` (default top 10).

3. **Per-subdomain overview** `dataforseo_labs_google_domain_rank_overview`
   - For each subdomain in scope: domain rank, traffic estimate, organic keyword count, top regions.
   - This establishes a baseline for cross-subdomain comparison.

4. **Per-subdomain top keywords** `dataforseo_labs_google_ranked_keywords`
   - For each subdomain: top 100 organic keywords with positions, intent, traffic.
   - Cluster keywords by topic. This skill's grouping is a lightweight per-subdomain ownership map, not a content plan — token-grouping by head term + intent is sufficient here. (For full content-cluster planning use `seo-keyword-cluster`.)
   - Each subdomain gets a list of "owned topics" (clusters where it dominates) and "minor topics".

5. **Per-subdomain competitors** `dataforseo_labs_google_competitors_domain`
   - For each subdomain: top organic competitors by common keywords.
   - Surface: do different subdomains have different competitor sets? (Sign of legitimately separate scopes.) Do they share competitors? (Sign of redundant scopes.)

6. **Backlink profile across subdomains** `backlinks_bulk_referring_domains`
   - This is a **bulk endpoint** — pass **all** subdomains in the `targets` array in **one call** (do not loop per subdomain). Returns the referring-domain count for each subdomain.
   - Surface: do subdomains have meaningfully different referring-domain populations? (If a specific pair needs full referring-domain lists for overlap analysis, pull `backlinks_referring_domains` for just those two — optional, only when a consolidation decision hinges on link-equity overlap.)

7. **Backlink rank distribution** `backlinks_bulk_ranks`
   - Also a **bulk endpoint** — pass all subdomains in one call to compare Domain Rank / authority across the whole set. One call, not per-subdomain.

8. **Detect fragmentation**
   - For each topic-cluster, identify all subdomains ranking for keywords in that cluster.
   - **Fragmentation signal:** ≥ 2 subdomains rank in the top 50 for the same high-volume keyword (cannibalization).
   - **Healthy split:** distinct topic clusters per subdomain, minimal overlap.

9. **Make recommendations**
   - **Consolidate:** if `blog.example.com` and `example.com/blog/` both rank for the same topic cluster but neither dominates — pick one canonical home.
   - **Split:** if a subdomain is ranking for a topic completely off-mission for the root domain, that's a split worth keeping.
   - **Leave alone:** if subdomains have distinct topic ownership and don't cannibalize, don't disturb.
   - **Investigate:** ambiguous cases flagged for human review.

10. **Synthesise** `SUBDOMAINS.md`

## Output format

Create a folder `output/seo-subdomain-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-subdomain-{target-slug}-{YYYYMMDD}/
├── SUBDOMAINS.md                       (synthesised report + recommendations — primary deliverable)
├── 06-topic-ownership-map.md           (cluster × subdomain matrix — load-bearing reference content teams brief from)
├── 07-fragmentation-flags.md           (cannibalization detected — load-bearing reference for consolidation decisions)
└── evidence/
    ├── 01-subdomains-list.md           (dataforseo_labs_google_subdomains — raw step output)
    ├── 02-overview-by-subdomain.md     (per-subdomain overview rows)
    ├── 03-keywords-by-subdomain/
    │   ├── blog-example-com.md
    │   ├── docs-example-com.md
    │   └── ...                          (one per subdomain)
    ├── 04-competitors-by-subdomain.md
    └── 05-backlinks-bulk.md            (backlinks_bulk_referring_domains + backlinks_bulk_ranks — one row per subdomain)
```

Top-level: `SUBDOMAINS.md` + `06-topic-ownership-map.md` + `07-fragmentation-flags.md`. Content teams brief from the ownership map; consolidation decisions cite the fragmentation flags directly. The 01–05 step files preserve raw API outputs in `evidence/`.

`SUBDOMAINS.md` opens with a header (root domain · snapshot · subdomains analysed vs discovered), a subdomain-inventory table (keywords / traffic / backlinks / Domain Rank / top topics owned), a topic-ownership map (cluster × owner × cannibalization), fragmentation flags (per cannibalization finding, with a consolidation recommendation), a recommendations summary (consolidate / split / investigate counts), and risk notes. Full skeleton: `templates/report.md`.

## Tips

- Respect DataForSEO API rate limits (10 req/s). Cost is ~3 per-subdomain calls plus 3 shared calls (discovery + 2 bulk backlinks endpoints) ≈ 3N+3. At `--limit 10` that's ~33 calls; pace sequentially and confirm via the budget guard.
- **`--limit` is your friend.** Sites with hundreds of subdomains (large platforms) don't need every subdomain analysed — top 10 by keyword count covers >90% of organic value usually.
- **Don't conflate "subdomain has lower Domain Rank" with "subdomain is bad."** Subdomains often have lower authority than the root because they accumulate links separately. The question is topic ownership and cannibalization, not rank per se.
- **Consolidation is risky.** A 301 from `blog.example.com` to `example.com/blog/` retains most link equity but can lose 5–15% in transition. Track post-migration with `seo-drift`.
- **Don't recommend consolidation when one subdomain is on a different platform.** If `blog.example.com` is on a different CMS, the engineering cost of consolidation may exceed the SEO benefit. Surface this as a constraint, not a recommendation.
- The topic-ownership matrix is the highest-leverage artifact. Use it to brief content teams on which subdomain should publish what.
- Pair with `seo-page` to deep-dive into specific URLs flagged in cannibalization.
- Pair with `seo-drift` to baseline subdomains before major restructures.
