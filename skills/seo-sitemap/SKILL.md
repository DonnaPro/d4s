---
name: seo-sitemap
description: Pull a domain's XML sitemap (and sitemap-of-sitemaps), then compare against Firecrawl-discovered URLs and pages with ranking visibility via DataForSEO. Surfaces (a) sitemap entries not reachable via crawl (orphans from the sitemap), (b) discovered / ranking-visible pages missing from the sitemap (probably an oversight), (c) sitemap entries that are now 404, (d) lastmod inconsistencies. Use when the user asks for "sitemap analysis", "check my sitemap", "sitemap vs crawl", "missing pages", "orphan pages", or "sitemap health".
---
> Example output: [examples/seo-sitemap-notion-so-20260514/SITEMAP.md](../../examples/seo-sitemap-notion-so-20260514/SITEMAP.md)

# Sitemap Analysis

Compare a domain's XML sitemap against Firecrawl-discovered URLs and pages with ranking visibility (via DataForSEO). Surface what the sitemap claims vs what crawlers and DataForSEO's ranking database actually found, in both directions. Note the DataForSEO source is a subset of Google's index (pages that rank for at least one tracked keyword), not the full index.

## Prerequisites

- DataForSEO MCP server connected.
- Claude's `WebFetch` tool available.
- User provides: a target domain. Optional: the sitemap URL if not at `/sitemap.xml` (auto-discovery from `robots.txt` is attempted first).
- **Firecrawl availability check.** If `mcp__firecrawl-mcp__firecrawl_map` is available, Mode-2 (URL discovery via crawl) runs automatically when the sitemap is missing or suspect. Without Firecrawl, the skill runs Mode-1 only and notes the gap if Mode-2 was needed. User may pass `--no-firecrawl` to force Mode-1 only.

## Process

1. **Validate target**
   - Normalise the domain (strip protocol, trailing slash, `www` variant).
   - **Firecrawl availability check.** Check if `mcp__firecrawl-mcp__firecrawl_map` is available. Note for the user whether Mode-2 will run.

2. **Build URL lists** via `WebFetch` (sitemap) + `mcp__firecrawl-mcp__firecrawl_map` (optional Mode-2) + `dataforseo_labs_google_relevant_pages` (pages with ranking visibility)
   - **Mode-1 (default).** Try `https://{domain}/sitemap.xml`. If 404, fetch `/robots.txt` and look for `Sitemap:` directives. For sitemap-of-sitemaps, recursively fetch each child sitemap. Build the canonical URL list from the sitemap XML.
   - **Mode-2 trigger.** Switch on Mode-2 when (a) no sitemap is reachable, (b) the sitemap returns fewer than 10 URLs, or (c) the user explicitly requests `--discover`. Always surface the trigger to the user before running Mode-2.
   - **Mode-2 execution** (requires Firecrawl): call `firecrawl_map(url=domain, limit=500)`. The response is the URL list Firecrawl could discover from the homepage and internal linking. Use this list as the "crawl-discovered" URL set in step 5.
   - **If Mode-2 is needed but Firecrawl is unavailable:** continue with whatever sitemap data Mode-1 returned (possibly empty). Surface clearly in `SITEMAP.md`: `Mode-2 (Firecrawl URL discovery) needed but Firecrawl not installed — crawl-vs-sitemap diffs run on partial data only.`

3. **Pull pages with ranking visibility** `dataforseo_labs_google_relevant_pages`
   - Call with `target={domain}` (set `limit` + filters per CLAUDE.md). Returns the domain's pages that currently rank for at least one keyword **in DataForSEO's database** — i.e. pages with ranking visibility. This is a SUBSET of Google's full index, **not** the complete index: a page can be indexed yet absent here simply because it has no tracked ranking. Treat presence as "has ranking visibility," absence as "no ranking visibility" — never as "indexed" / "deindexed."

4. **Spot-check specific URLs** `on_page_instant_pages` (conditional)
   - For sitemap URLs absent from both the Firecrawl map and the ranking-visibility list, call `on_page_instant_pages` **one URL per call** — this MCP does not batch (one URL each, per CLAUDE.md). Cap the spot-check at ~20 of the highest-value candidates to control call count; each call is a paid DataForSEO call, so note the count toward the budget guard. Captures live HTTP status, canonicalization, and basic on-page signals.
   - Skip this step if the sitemap has fewer than 10 entries (spot-check all via `WebFetch` HEAD requests instead) or if the user passes `--no-spot-check`.

5. **Compute the four diffs**
   - **Missing from sitemap:** URLs in the Firecrawl map OR with ranking visibility in `dataforseo_labs_google_relevant_pages` (status 200, indexable) that don't appear in the sitemap. Probably should be added.
   - **Orphans from sitemap:** URLs in the sitemap that are absent from the Firecrawl map (not reachable via internal links). The sitemap may be the only thing pointing at them — investigate whether they should be linked internally or removed.
   - **Broken sitemap entries:** sitemap URLs that returned non-200 in the `on_page_instant_pages` spot-check or via `WebFetch`. Remove from sitemap or fix the URL.
   - **Lastmod issues:** sitemap entries where (a) all `<lastmod>` dates are identical (lazy generation) or (b) `<lastmod>` is suspiciously old relative to other lastmod dates on the same domain.

6. **Validation**
   - URL count <50,000 per file (sitemap protocol limit). Flag if exceeded.
   - Sitemap referenced in `robots.txt`.
   - Encoding: each URL is XML-safe (ampersands escaped, etc.).
   - HTTPS consistency: sitemap URLs match the canonical protocol.
   - **`<lastmod>` is the only optional tag Google still consumes.** Validate it (step 5). `<priority>` and `<changefreq>` have been **explicitly ignored by Google for years** (per [Google's sitemap docs](https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap) — "Google ignores `priority` and `changefreq` values"). Don't validate them; if present, flag as low-signal noise the user can strip to shrink the sitemap.

7. **Synthesise** `SITEMAP.md`

## Output format

Create a folder `output/seo-sitemap-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-sitemap-{target-slug}-{YYYYMMDD}/
├── SITEMAP.md                       (synthesised report — primary deliverable)
├── recommended-sitemap-diff.md      (proposed changes: add X, remove Y)
└── evidence/
    └── source-data.md               (consolidated raw step output: fetched sitemap content, Firecrawl-discovered URLs if Mode-2 ran, DataForSEO ranking-visibility pages, spot-check results, the four diffs — preserved for reproducibility)
```

Top-level: `SITEMAP.md` + `recommended-sitemap-diff.md`. Raw step data is consolidated into `evidence/source-data.md` with per-step section headers — a reader who needs to replay the diff has all raw inputs in one file.

`SITEMAP.md` opens with a header (domain + snapshot dates), a Mode block (Mode-1 / Mode-2 status), a Health-summary table (sitemap / discovered / ranking-visibility URL counts + the four diff counts with 🔴/🟡 thresholds), a Recommended-changes section (add / remove / investigate-orphan / fix-lastmod), a Validation block, and an Apply pointer. Full skeleton: `templates/report.md`.

## Tips

- This skill is self-contained — no prior audit or project setup required. It builds its URL inventory on-demand from Firecrawl and DataForSEO.
- Re-run after deploys that change page inventory (new content, removed pages, URL restructures).
- Sitemap-of-sitemaps fan-out can be large for big sites — the skill recursively fetches all child sitemaps. For sites with 50+ child sitemaps, fetching dominates runtime.
- `<priority>` and `<changefreq>` are dead signals — Google explicitly ignores both. Don't waste time tuning them; if your sitemap generator emits them, the bytes are pure overhead. `<lastmod>` is still consumed, so keep that one accurate.
- The "investigate orphans" list is often the highest-leverage finding — pages that exist but aren't linked are usually accidentally orphaned, and adding a couple of internal links can revive them.
- Pair with `seo-drift` to track sitemap composition over time (URL count, lastmod patterns).
- The `dataforseo_labs_google_relevant_pages` list is pages with **ranking visibility** in DataForSEO's database, not a full index dump — a subset of what's indexed, but it surfaces pages that rank without being internally linked. Cross-referencing it with the Firecrawl map gives a more complete picture than either source alone; a sitemap URL missing from both means "no ranking visibility and not crawl-reachable," not "deindexed."
