# Keyword Niche Plan: {topic}

> Generated {YYYY-MM-DD} · Market: {location_name}/{language_code} · Seeds: {list}

## Inventory
- Longtail keywords mined: {n}
- Question keywords: {n}
- After filter (min-vol {n}, max-kd {n}): {n}
- Clusters formed: {n}
- Estimated combined monthly volume: {n}
- (Note any seed that returned <20 suggestions and how the seeds/thresholds were widened.)

## Recommended content tier

### Template
**URL pattern:** `/{category}/{slug}/`

**Required fields per page:**
- `{slug}` — URL-friendly identifier
- `{H1}` — page primary heading
- `{TL;DR}` — first 200 words direct answer
- `{primary_keyword}` — target keyword
- `{related_keywords}` — secondary keywords from cluster
- `{unique_attributes}` — list of ≥ 5 differentiating attributes (numbers, names, dates)
- `{related_pages}` — internal-link list (3–5 sibling pages)
- `{schema_type}` — Article/Product/Other
- `{datestamp}` — last-updated date

**Sample pages:** see `06-template-spec.md` for 3 fully-spec'd wireframes.

## Cluster build order (top 10 by priority)

| Rank | Cluster | Volume (combined) | Weighted KD | Dominant page type | Pages to ship |
|---|---|---|---|---|---|
| 1 | {cluster name} | {n} | {kd} | {type} | {n} |
| ... |

## Quality gates (do not ship pages that fail — full definitions in `references/quality-gates.md`)

Always-on:
- [ ] Gate 1 — Unique-data threshold (≥ 5 attributes vs siblings)
- [ ] Gate 2 — Minimum 600 words effective content
- [ ] Gate 3 — `Article` + `BreadcrumbList` schema
- [ ] Gate 4 — ≥ 3 outbound sibling links, ≥ 1 inbound hub link
- [ ] Gate 5 — noindex any variant that fails Gate 1

Programmatic-only (tier ships 50+ pages):
- [ ] Gate 6 — Per-row uniqueness ≥ 30% varying fields
- [ ] Gate 7 — ≥ 5 unique facts vs parent + siblings
- [ ] Gate 8 — ≥ 2 independent data sources per page
- [ ] Gate 9 — Index-bloat circuit-breaker (pause if GSC coverage <60% after first 50)

## Scaling estimate
- Clusters: {n}
- Pages per cluster (median): {n}
- Total pages: {n}
- At {pages/week} cadence: {n weeks} to ship the tier.
- Crawl-budget impact (for sites > 10k pages): noindex strategy keeps thin variants out of the index.

## Risks / monitoring
- **Thin-content penalty:** the quality gates above are the guardrail. Audit at scale via `seo-technical-audit` after first 100 pages ship.
- **Index bloat:** monitor in GSC; if newly indexed pages don't accrue impressions in 60 days, candidate for noindex/consolidate.
- **Cannibalization:** monitor with `seo-subdomain` + `seo-page` after first 50 pages.

## Recommended next step
Build a small pilot — 10 pages from the top cluster — before committing to the full tier. Apply quality gates rigorously to the pilot. Re-audit after 60 days; iterate the template based on which pilot pages indexed and ranked.
