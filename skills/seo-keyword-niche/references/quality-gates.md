# Keyword-niche quality gates (anti-thin-content guardrails)

Used by `seo-keyword-niche` step 9. Gates 1–5 always apply. Gates 6–9 apply *in addition* whenever the proposed tier expects to ship 50+ templated pages. These gates are not negotiable — if a tier can't pass them, the answer is fewer pages, not lower thresholds.

## Always-on gates (1–5)

1. **Unique-data threshold (≥ 5 attributes).** Template fields must produce ≥ 5 unique attributes (counts, prices, names, dates, etc.) per page vs sibling pages in the same cluster. Pages without 5+ unique attributes are duplicates in disguise — skip those keyword variants.
2. **Minimum word count.** 600 words of effective content (excludes navigation, footer, boilerplate).
3. **Schema requirement.** Every templated page gets `Article` (or relevant `@type`) + `BreadcrumbList`.
4. **Internal links.** ≥ 3 outbound links to siblings, ≥ 1 inbound from the category hub.
5. **Index/noindex split.** If a variant doesn't pass the unique-data threshold, generate the page but `noindex` it.

## Programmatic-only gates (6–9) — apply when the tier ships 50+ pages

Programmatic publishing is the highest-risk path for spam-classifier blowback.

6. **Per-row uniqueness threshold (≥ 30% varying fields).** Of the template's content-producing fields (excluding nav/footer boilerplate), at least 30% must hold values that differ from the median sibling page. A 12-field template where 9 fields are identical across pages is templated mush — modern spam systems are well-tuned to catch this. Compute: `varying_fields / content_fields ≥ 0.30` per row vs the cluster median.
7. **Min unique-fact count vs parent + sibling (≥ 5 facts).** Each row carries at least 5 facts that do not appear on the parent hub page or any sibling page in the same cluster. Facts = numbers, dates, named entities, original quotes, photos. Synonym shuffles don't count. Sample 10 rows manually before greenlighting the tier.
8. **Data-source independence.** Don't auto-publish from a single source (one CSV, one API, one scrape). If the page's only differentiator is a row from `cities.csv`, the page is a CSV row dressed as content — likely thin. Combine ≥ 2 independent data sources per page.
9. **Index-bloat circuit-breaker.** After the first 50 pages ship, monitor GSC. If the index-coverage rate drops below 60% (Google indexed <60% of submitted), pause the tier and re-audit. Continuing past this signal compounds bloat across the rest of the tier.

**Crawl-budget honesty.** Sites under 50k pages can usually crawl whatever you ship. Sites >50k must factor in crawl-budget cost: every thin programmatic page steals attention from cornerstone content. If the site is in this band and the unique-fact count is borderline, default to noindex.
