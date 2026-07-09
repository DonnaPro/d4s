# seo-page deliverable templates

Load this file only when writing the final deliverable. It holds the full output-folder layout and the `PAGE.md` shape.

## Output folder layout

Create `output/seo-page-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-page-{target-slug}-{YYYYMMDD}/
├── PAGE.md                       (synthesised verdict + plan — primary deliverable)
├── keywords.csv                  (full keyword list with positions — load-bearing CSV the auditor walks through row-by-row)
├── 04-serp-context.md            (top 10 + AIO for top 3–5 keywords — load-bearing reference for SERP-driven REFRESH discussions)
└── evidence/
    ├── 01-url-overview.md        (raw dataforseo_labs_google_domain_rank_overview)
    ├── 02-keywords.md             (raw dataforseo_labs_google_ranked_keywords filtered)
    ├── 03-authority.md            (backlinks_summary + backlinks_timeseries_summary)
    ├── 05-page-snapshot.md        (HTML extracts)
    └── 06-cannibalization.md      (peer pages on the same domain competing for the top-3 keywords)
```

Top-level: `PAGE.md` + `keywords.csv` + `04-serp-context.md`. The other step files preserve raw API/HTML extracts in `evidence/` for reproducibility — auditors lean on the CSV and SERP context, not the per-call dumps.

## PAGE.md shape

```markdown
# Page Intelligence: {URL}

> Snapshot dated {YYYY-MM-DD} · Market: {market} · Primary keyword: {keyword}

## Snapshot
- Ranking keywords: {n}
- Estimated monthly organic traffic: {n}
- Page authority: {PA} ({↑/↓ trajectory over 90 days})
- Primary topic: {topic}
- AIO citations: {n} of {checked} primary-keyword AIOs cite this URL
- GSC last 28d: {clicks} clicks / {impressions} impressions / {ctr}% CTR / avg position {n}  *(or `not configured` / `property not verified`)*
- Google sees: {INDEXED|EXCLUDED|...} · canonical {userCanonical} {→ googleCanonical if differ} · last crawled {YYYY-MM-DD}

## Page basics
- `<title>`: {value}
- meta description: {value | absent}
- `og:title`: {value | absent | skipped — Firecrawl required}
- `og:description`: {value | absent | skipped}
- `og:image`: {url | absent | skipped}
- `twitter:card`: {summary | summary_large_image | absent | skipped}
- `<link rel="canonical">`: {URL | self-referential | absent | skipped}
- meta robots: {index,follow | noindex,nofollow | absent | skipped}
- JSON-LD types detected: {Article, BreadcrumbList, Organization | none | skipped}
- hreflang variants: {n | skipped}

## What this page wins
- {keyword} — position {n}, ~{volume} monthly searches, ~{traffic} monthly clicks.
- ... (top 3–5)

## Almost-wins (page-2 refresh opportunities)
- {keyword} — position {n}, ~{volume} monthly searches. The top 3 SERP winners all do {pattern} that this page doesn't.
- ... (top 3 examples)

## What this page misses
- {keyword} — competitors {comp1}, {comp2} rank in top 5; this page is absent.
- ...

## Same-domain cannibalization
- {peer URL} — ranks position {n} for "{keyword}" (candidate ranks position {m}). Peer estimated traffic: {n}/mo.
- ... (only list rows where a peer URL ranks <= 20 for one of the candidate's top-3 keywords; if none, write "No same-domain cannibalization detected on top-3 keywords.")

## AI Search angle
- {n} of {checked} AIO queries on the URL's keywords cite this page.
- The AIOs that DON'T cite this page tend to cite {pattern} (e.g., comparison tables, step-by-step how-tos).
- Recommended GEO move: {one specific change}.

## Verdict: {KEEP | REFRESH | CONSOLIDATE | KILL}

Reasoning: {1-2 sentences anchored in objective signals from above}.

### If REFRESH — top 3 changes
1. {Specific change}
2. {Specific change}
3. {Specific change}

## Raw data
- keywords.csv — full enriched ranking-keyword list
- 04-serp-context.md — per-keyword SERP top-10 with AIO
- evidence/05-page-snapshot.md — HTML extracts
```

`keywords.csv` columns: `keyword,volume,kd,position,intent,traffic_estimate,url`
