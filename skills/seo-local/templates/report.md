# seo-local deliverable templates

Load this file only when writing the final deliverable. It holds the output-folder layout and the `LOCAL-SEO-REPORT.md` shape.

## Output folder layout

Create `output/seo-local-{domain-slug}-{YYYYMMDD}/` with:

```
output/seo-local-{domain-slug}-{YYYYMMDD}/
├── LOCAL-SEO-REPORT.md         (PRIMARY: verdict, scores, top fixes, limitations)
├── local-keywords.csv          (load-bearing: per-keyword local-pack + organic positions)
├── nap-inconsistencies.csv     (load-bearing: only emitted if discrepancies found)
└── evidence/
    ├── 01-homepage-snapshot.md     (Firecrawl raw HTML extracts: NAP, schema, GBP signals)
    ├── 02-nap-page-samples.md      (per-page NAP extracts across 5 sample URLs)
    ├── 03-serp-context.md          (raw serp_organic_live_advanced per keyword)
    ├── 04-reviews.md               (per-platform review-page snapshots, only if user provided URLs)
    └── 05-citation-sample.md       (raw WebSearch results per directory check)
```

`local-keywords.csv` columns: `keyword,country,location,local_pack_present,target_in_pack,target_pack_position,target_organic_position,top_pack_competitor_1,top_pack_competitor_2,top_pack_competitor_3,aio_present`

`nap-inconsistencies.csv` columns: `source,name,address,phone,page_or_schema_path,canonical_value,divergence_note`

## LOCAL-SEO-REPORT.md shape

```markdown
# Local SEO Report: {domain}

> Snapshot dated {YYYY-MM-DD} · Market: {market} · Region: {region} · Primary keyword: "{keyword}"

## Snapshot
- Business type: {Brick-and-Mortar | SAB | Hybrid}
- Industry vertical: {Restaurant | Healthcare | Legal | Home Services | Real Estate | Automotive | Generic}
- Pages sampled for NAP: {n}
- Local keywords tracked: {n}
- Local pack present on {n}/{m} keywords; target in pack on {p}/{m}
- Review platforms audited: {Google, Yelp, ... | not provided}
- GSC last 28d local-intent queries: {n} queries / {clicks} clicks / {impressions} impressions  *(or `not configured`)*

## Verdict: {STRONG | NEEDS WORK | WEAK}

{One-sentence summary anchored in dimension scores below}

## Dimension scores (0–10)

| Dimension | Score | Top finding |
|---|---|---|
| GBP integration on page | {n}/10 | {one-line} |
| NAP consistency | {n}/10 | {one-line} |
| Local on-page (title/H1/contact/service pages) | {n}/10 | {one-line} |
| Local-pack rank | {n}/10 | {one-line} |
| Reviews & citations | {n}/10 | {one-line} |
| **Composite** | {n}/10 | — |

## Top fixes

### Critical
1. {Specific fix anchored in a finding above. Example: "NAP discrepancy: footer shows '(212) 555-1234' but JSON-LD shows '+1-212-555-9999'. Pick one canonical phone, fix the wrong one." Cite the page/schema source.}

### High
- {fix}

### Medium
- {fix}

### Low
- {fix}

## Local-pack rank summary
- "{keyword 1}": local pack {present/absent}, target {in pack at #n / not in pack}, organic position {n}.
- "{keyword 2}": …
- (Full data: `local-keywords.csv`)

## Reviews health (if audited)
- Google: {n} reviews, {rating} avg, last review {n} days ago, owner response rate {p}%.
- Yelp: …
- Trustpilot: …

## Citation sample
- Google Business: {detected / not detected via site:google.com "..." search}
- Yelp: …
- Facebook: …
- {Tier-1 / vertical-specific per references/local-citation-sources.md}: …

(Caveat: this is a sample, not a comprehensive citation audit. For definitive coverage, use Whitespark / BrightLocal / Yext.)

## Schema status
- LocalBusiness JSON-LD: {present and valid / present but missing recommended properties / invalid / absent}
- Recommended next step: run `seo-schema {homepage_url}` for paste-ready LocalBusiness markup with the correct industry subtype.

## Limitations
This skill could NOT assess:
- **Geo-grid local-pack rank by lat/long.** Requires a Maps API (e.g. DataForSEO Maps geo-grid endpoint) not covered in this skill's scope. Workaround: pay for Local Falcon, GMB Crush, or BrightLocal Local Search Grid.
- **Comprehensive citation audit.** WebSearch sampling covers ~8 directories; full audits cover 50+. Use Whitespark, BrightLocal, or Yext.
- **GBP Insights data.** Requires GBP API access scoped to the listing owner. Ask the listing owner to export Insights and share.
- **Real-time local-pack rank tracking over time.** This skill is a snapshot. Pair with `seo-drift` for diff snapshots.
```
