---
name: seo-competitor-gap-analysis
description: Compare a target domain to its top organic competitors and surface keywords the competitors rank for that the target does not, filtered by intent, volume, and difficulty. Use when the user asks for a competitor gap analysis, keyword gap, organic content gap, missing keyword opportunities, or wants to see what their competitors are ranking for that they are not.
---
> Example output: [examples/seo-competitor-gap-analysis-wix-com-20260514/REPORT.md](../../examples/seo-competitor-gap-analysis-wix-com-20260514/REPORT.md)

# Competitor Gap Analysis

Identify the specific keywords your competitors rank for in the top 20 that your domain does not, ranked by commercial value and realistic capture difficulty.

## Prerequisites

- DataForSEO MCP server connected.
- User provides: (a) target domain, (b) 3 to 5 competitor domains (or ask the skill to auto-discover them), (c) market — per CLAUDE.md defaults (UK unless the user specifies), and optionally filters (min volume, max KD, intent).

## Process

1. **Validate or discover competitors** `dataforseo_labs_google_competitors_domain`
   - If the user did not provide competitors, pull the top 5 organic competitors for the target in the target market.
   - Surface the list to the user and ask them to confirm or override before proceeding.
   - **Note:** the upstream API does not support `limit`/`offset`, so this call returns the full set (~60KB for popular domains) and the MCP harness writes it to a file. Read that file path, parse the `{data: [...]}` JSON, sort by `common_keywords` desc, and take the top 5.

2. **Compute the gap (primary path)** `dataforseo_labs_google_domain_intersection`
   - This is the near-only data path. For **each competitor**, call with `target1={competitor}`, `target2={target}`, `intersections: false` — this returns keywords the **competitor ranks for but the target does not**, already excluding the target's ranking set (no separate target pull, no manual diff needed).
   - Set `item_types: ["organic"]`, `location_name` / `language_code` per CLAUDE.md market, `limit: 1000` (hard ceiling per competitor), `order_by: ["keyword_data.keyword_info.search_volume,desc"]`, and server-side `filters` for the user's min-volume / KD / position constraints (e.g. restrict the competitor's SERP position to the top 20 via a filter on the first-domain SERP element rank).
   - Merge results across the per-competitor calls. A keyword's **competitors-ranking count** = how many per-competitor calls it appeared in — the primary realism signal (step 5).

3. **Optional supporting evidence (demoted — off by default)** `dataforseo_labs_google_ranked_keywords`
   - The step-2 intersection is sufficient for the gap itself. Only if the user wants deeper per-competitor context (full footprints, URLs, positions) pull `dataforseo_labs_google_ranked_keywords` per competitor and/or the target — **cap each pull at the top 1,000 keywords** (`limit: 1000` + server-side filters, never "all ranking keywords any position"). Skip by default to conserve calls.

4. **Filter and segment**
   - Apply user-specified filters on volume, KD, and intent.
   - Segment by intent: informational, commercial, transactional, navigational.
   - Segment by competition: how many of the N competitors rank for each gap keyword.

5. **Score and prioritise**
   - Score each gap keyword: traffic potential (volume × CTR model) + intent weighting + inverse KD.
   - Surface the top 50 opportunities with reasoning per keyword.

6. **Map to content actions**
   - For each top opportunity, recommend: new article, expand existing page, refresh existing page, programmatic template.
   - Flag quick wins: competitors rank with thin content (detected by URL pattern and content-length heuristics).

## Output format

Create a folder `output/seo-competitor-gap-analysis-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-competitor-gap-analysis-{target-slug}-{YYYYMMDD}/
├── REPORT.md                          (synthesised report — primary deliverable)
├── gaps.csv                           (full gap list — load-bearing CSV the writers/planners paste into briefs)
└── evidence/
    ├── 01-competitors.md              (competitor list / discovery — raw step output)
    ├── 02-gap-by-competitor.md        (per-competitor domain_intersection results — the primary gap data)
    └── 03-ranked-keywords.md          (optional: full footprints if step 3 ran — capped top 1,000)
```

Top-level: `REPORT.md` + `gaps.csv`. The step files preserve the raw API outputs in `evidence/` for reproducibility.

`REPORT.md` opens with a header (target · market · competitors analysed), a summary (gap keyword count + traffic potential), the top-50 opportunities segmented by intent (informational / commercial / transactional), a quick-wins table (competitors in positions 5–20 with thin/old content), and recommended next steps. Full skeleton: `templates/report.md`.

`gaps.csv` columns:
`keyword,volume,kd,cpc,intent,competitors_ranking,top_competitor_position,target_position,action,score`

## Tips

- Rate limit: 10 requests per second. The primary path is one `domain_intersection` call per competitor (~4–6 calls total incl. discovery) — no full-keyword-set pulls unless step 3 (optional evidence) runs, and those are capped at the top 1,000 per domain in the step itself.
- The `competitors_ranking` count is the best signal of realism. Keywords ranked by 4 of 5 competitors are validated opportunities; keywords ranked by only 1 may be noise.
- Do not recommend capturing branded competitor keywords unless the user explicitly asks. Pivoting to compete on "competitor brand review" is a viable strategy but only if the user opts in.
- When many gap keywords cluster around a theme, recommend a hub page plus cluster rather than 50 individual articles.
- Chain this skill with `seo-content-brief` and `seo-keyword-cluster` naturally. Mention them in the Recommended next steps section of the output.
