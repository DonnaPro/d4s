---
name: seo-ads
description: Paid-search competitive landscape for a domain or keyword. Pulls DataForSEO's PPC data — domain ad keyword footprint, ad copy patterns, who else bids on the same keywords, SERP shopping/ad-pack visibility — and produces a competitive ads brief plus a recommended bid-keyword shortlist. Use when the user asks "paid search analysis", "competitor ads", "PPC competitive", "ad copy intelligence", "shopping pack", "who bids on this keyword", or "paid keyword footprint".
---
> Example output: [examples/seo-ads-hostinger-com-20260514/ADS.md](../../examples/seo-ads-hostinger-com-20260514/ADS.md)

# Paid-Search Intelligence (Ads)

Map a domain's paid-search footprint and the competitive landscape around its target keywords. Output: a brief on what the brand is bidding on, who else bids on the same terms, ad-copy patterns the leading competitors use, SERP ad+shopping presence per keyword, and a recommended bid-keyword shortlist.

## Prerequisites

- DataForSEO MCP server connected.
- User provides: (a) a target domain OR a target keyword (skill detects which), (b) market — per CLAUDE.md defaults (UK unless the user specifies).

## Process

1. **Validate input & preflight.** Determine domain mode (analyse a brand's paid footprint) or keyword mode (analyse the bidding landscape for one keyword). Then run the shared preflight — see `skills/seo-firecrawl/references/preflight.md` (budget guard, Google APIs) and `CLAUDE.md` (market defaults, cost discipline). Skill-specific notes:
   - Typical DataForSEO calls: domain mode ~5–7 (Labs paid pulls + up to 5 SERP calls); keyword mode ~3. Firecrawl: not used. Google APIs: not used.

2. **Domain mode** `dataforseo_labs_google_ranked_keywords` (with paid traffic filter)
   - Pull paid keywords the target domain bids on: keyword, search volume, CPC, paid position, landing URL. Set `limit` + server-side filters per CLAUDE.md.
   - **Labs does NOT return ad copy.** `ranked_keywords` is aggregated metric data, not live ad creative — there is no headline/description in the response. Ad copy comes only from the live SERP (step 4); layer it onto the top keywords from there.
   - Sort by traffic-weighted score (`volume × CTR-by-paid-position × bid-share`).

3. **Intent enrichment** `dataforseo_labs_google_related_keywords`
   - For the keyword(s) in scope, pull related questions.
   - Identifies question-phrased intent variants worth bidding on (often cheaper, higher conversion).

4. **Live SERP pull** `serp_organic_live_advanced` — one call per keyword, serving BOTH advertiser/ad-copy extraction AND paid-feature analysis
   - Run on the target keyword (keyword mode) or the top 5 keywords (domain mode). **One call per keyword returns everything** — do not call the SERP twice for the same keyword. From each response extract:
     - **Advertisers + ad copy:** every domain bidding, its ad position, and its ad headline + description + URL (this is the only source of live ad creative — see step 2). Surface the top ~10 advertisers.
     - **Ad-pack composition** from the same payload: `tads` (top ads above organic), `bads` (bottom ads below organic), `sads` (shopping ads / Google Shopping pack), `mads` (map-pack ads); plus image pack / local pack, which displace ad inventory.
   - **Zero-ads handling.** Many B2B / informational keywords have no ads at all. If a keyword's SERP returns no `tads`/`bads`/`sads`, record it as **"no paid presence"** and move on — do NOT retry, vary the query, or treat empty as an error. A clean "no advertisers bid on this" is a valid, useful finding.

5. **Ad copy pattern analysis** (from step 4 data)
   - Cluster ad headlines + descriptions by recurring patterns.
   - Identify: USP language used by leaders, pricing/discount mentions, audience segmentation, CTA verbs.
   - Highlight outliers (advertisers doing something different).

6. **Paid-keyword gap (domain mode)** `dataforseo_labs_google_ranked_keywords` with paid traffic filter
   - Pull the user's domain's paid keywords.
   - For each top competitor (from step 2 or `dataforseo_labs_google_competitors_domain`): pull their paid keywords.
   - Diff: paid keywords competitors bid on that the user's domain doesn't.
   - This becomes the highest-leverage portion of the bid-keyword shortlist (step 7).
   - Skip in keyword mode (no domain to gap against).

7. **Recommended bid-keyword shortlist**
   - For domain mode: paid-keyword gap from step 6 + adjacent question-intent variants.
   - For keyword mode: question-intent and long-tail variants that are likely cheaper than the head term.
   - Each row: keyword, est. CPC, est. volume, who else bids, why-recommended.

8. **Synthesise** `ADS.md`

## Output format

Create a folder `output/seo-ads-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-ads-{target-slug}-{YYYYMMDD}/
├── ADS.md                              (synthesised brief — primary deliverable; inlines paid footprint, bidding landscape, SERP ad/shopping pack, ad copy patterns, paid keyword gap)
├── recommended-keywords.csv            (bid-keyword shortlist — load-bearing CSV the PPC team pastes into bid tooling)
└── evidence/
    ├── 01-paid-footprint.md           (domain mode: brand's paid keywords — raw step output)
    ├── 02-bidding-landscape.md        (keyword mode: advertisers on the keyword — raw step output)
    ├── 03-question-variants.md        (dataforseo_labs_google_related_keywords enrichment)
    ├── 04-serp-ad-shopping-pack.md    (SERP feature inventory per keyword)
    ├── 05-ad-copy-patterns.md         (clustered headline/description patterns)
    └── 06-paid-keyword-gap.md         (domain mode: paid traffic diff vs competitors)
```

Step files 01, 02, 04, 05, 06 are inlined as sections in `ADS.md`; the copies in `evidence/` preserve the raw step outputs for reproducibility.

`ADS.md` opens with a header (target · snapshot date · market · mode), a footprint summary, a top-10 paid-keyword table (domain mode) or bidding-landscape table (keyword mode) with ad-copy excerpts, ad-copy patterns, a SERP-feature inventory (marking "no paid presence" keywords), the recommended bid-keyword shortlist, and constraints/caveats. Full skeleton: `templates/report.md`.

`recommended-keywords.csv` columns: `keyword,volume,cpc_estimate,position_target,intent,competitor_count,why_recommended`

## Tips

- Respect the 10 req/s rate limit. Domain mode: ~5–7 DataForSEO calls (Labs paid pulls + up to 5 SERP calls). Keyword mode: ~3. One SERP call per keyword serves both advertiser extraction and ad-pack analysis — never re-query the same keyword's SERP.
- **CPC estimates lag.** DataForSEO's CPC data is not real-time auction data; treat as ±30% directional.
- Ad copy often reveals competitor positioning before product launches do — periodic review (quarterly) catches strategic shifts.
- Question-intent variants often have lower CPC and higher conversion than head terms. The shortlist in step 8 prioritises these.
- Pair with `seo-keyword-niche` for organic content opportunities derived from paid keyword research.
- Pair with `seo-competitor-pages` if the bidding landscape reveals "X vs Y" / "alternatives" intent — those keywords convert best as comparison pages, not paid ads.
- Don't recommend paid keywords without context. The shortlist is a starting point for the PPC team, not an autopilot.
