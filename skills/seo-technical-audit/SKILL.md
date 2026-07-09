---
name: seo-technical-audit
description: Focused one-shot technical SEO audit for a domain. Crawlability, indexability, security, mobile, structured data, JS rendering — single-pass deliverable, not a diff. Distinct from `seo-drift` (which tracks changes over time) and from `seo-page` (which audits keywords/traffic for one URL, not technical health). Use when the user asks "technical audit", "site audit", "audit my site", "crawl issues", "indexation issues", or "technical SEO check".
---

> Example output: [examples/seo-technical-audit-linear-app-20260514/TECH-AUDIT.md](../../examples/seo-technical-audit-linear-app-20260514/TECH-AUDIT.md)

# Technical Audit

A one-shot technical SEO audit for a domain. Discovers URLs via Firecrawl, analyzes each page with DataForSEO's `on_page_instant_pages`, categorizes findings by area (crawlability, indexability, security, mobile, structured data, etc.), severity-sorts within each, and produces a top-10 fix list ranked by impact × effort.

## Prerequisites

- DataForSEO MCP server connected.
- Firecrawl MCP server connected — **required** for URL discovery. Without Firecrawl, the skill cannot enumerate site pages and cannot run. (Pass `--urls "url1,url2,..."` to skip Firecrawl and supply the page list manually.)
- Claude's `WebFetch` tool available (used for sense-checking robots.txt and sitemap presence).
- User provides: a target domain (e.g. `example.com`). Optional: target market (per `CLAUDE.md` defaults — UK unless the user specifies otherwise), page-sample-limit override (default: 50).

## Process

1. **Validate target & preflight.** See `skills/seo-firecrawl/references/preflight.md` for the canonical 3-stage preflight (Firecrawl availability, Google APIs).
   - Normalise domain (strip protocol, trailing slash) before continuing.
   - Firecrawl is **required** for site-wide URL discovery. If unavailable and no `--urls` list was supplied, halt and ask the user to provide a URL list or connect Firecrawl.
   - Google APIs: tier 0 unlocks step 8b (CrUX field data); tier 1 also unlocks step 8c (per-URL GSC Inspection on top 5 traffic pages). See `skills/seo-google/references/cross-skill-integration.md` § "seo-technical-audit" for the full recipe and per-tier branches.
   - **Scale note:** `on_page_instant_pages` is a per-URL call, not a batch crawl. Analysis is capped at **50 URLs** by default (adjust with `--limit N`). For sites with more than 50 pages, the sample is drawn from the highest-traffic pages returned by `dataforseo_labs_google_relevant_pages`, falling back to the first N URLs from Firecrawl discovery if traffic data is unavailable.

2. **Discover URLs** `mcp__firecrawl-mcp__firecrawl_map`
   - Call `firecrawl_map` on `https://{domain}` to enumerate site pages.
   - Request up to 200 URLs (or the user-supplied limit × 4, whichever is larger) so there is a pool to rank by traffic.
   - If `--urls` was provided, skip this step and use the supplied list.

3. **Rank URLs by traffic** `mcp__dataforseo__dataforseo_labs_google_relevant_pages`
   - Call `dataforseo_labs_google_relevant_pages` for the domain to get estimated organic traffic per page.
   - Sort the discovered URLs by traffic descending and take the top N (default 50) as the analysis sample.
   - If `dataforseo_labs_google_relevant_pages` returns no data (new or low-traffic site), use the first N URLs from the Firecrawl map instead.

4. **Domain overview** `mcp__dataforseo__dataforseo_labs_google_domain_rank_overview`
   - Call `dataforseo_labs_google_domain_rank_overview` for the domain to obtain domain rank, estimated organic traffic, referring domains, and backlink counts.
   - These top-line metrics populate the audit summary header.

5. **Analyze each URL** `mcp__dataforseo__on_page_instant_pages`
   - For each URL in the sample (up to 50), call `on_page_instant_pages`.
   - Capture from each response: HTTP status, canonical tag, meta robots, title tag (presence, length, duplication), meta description (presence, length, duplication), H1 (presence, count), H2–H6 structure, Open Graph tags, hreflang tags, page size, load time estimate, broken internal links, redirect chains, duplicate content signals, schema markup presence, image alt texts, mobile viewport tag.
   - Collect all per-URL findings into a unified issues list.

6. **Lighthouse scores** `mcp__dataforseo__on_page_lighthouse` *(optional add-on)*
   - Run `on_page_lighthouse` on the top 5 traffic pages (or homepage + up to 4 key landing pages if traffic data is unavailable).
   - Capture Performance, Accessibility, Best Practices, and SEO Lighthouse scores plus Core Web Vitals lab estimates (LCP, TBT, CLS).
   - These supplement the field data from CrUX (step 8b) — lab data vs real-user data.
   - Skip this step if the user passes `--no-lighthouse` or if the page count from step 5 is zero.

7. **Sense-check** `WebFetch`
   - Fetch `/robots.txt` and `/sitemap.xml` directly.
   - Confirm the per-URL findings match reality on these critical files (per-URL analysis sometimes lags same-day deploys).
   - **Extended security headers.** Follow the detection recipe in `references/severity-mapping.md` § Security ("Detection (extended security headers)") — WebFetch the homepage + 3 sample URLs and flag `csp_missing` / `xframe_missing` / `xcontent_missing` / `referrer_policy_missing` / `hsts_no_preload`. Map severity/fix from the same section.

8. **Modern signals checklist** `mcp__firecrawl-mcp__firecrawl_scrape`
   - DataForSEO's `on_page_instant_pages` does not execute JS and does not expose per-page response headers. This step surfaces what is invisible to it.
   - **JS-rendering + X-Robots-Tag checks:** follow the detection recipe in `references/severity-mapping.md` § JS Rendering ("Detection") — pick 5 sample URLs and flag `js_canonical_mismatch`, JS-rendered `noindex`, `X-Robots-Tag` HTTP-layer directives, `js_render_budget`, `js_csr_meta_drift`, and `js_soft_404`. Map severity/fix from the same section. (These are the four JS-rendering risks — rendering-budget cuts, hydration/canonical mismatch, CSR meta-drift, and soft-404 — that static analysis can't see.)
   - **AI-crawler rules:** make one `firecrawl_scrape` call on `/robots.txt` (1 credit). Parse for AI-crawler User-Agent rules — `GPTBot`, `ClaudeBot`, `PerplexityBot`, `Google-Extended`, `ChatGPT-User`, `Bytespider`, `CCBot`. Surface allow/disallow scope per agent.

8b. **CWV field data via CrUX** *(only if google-api.json is present, tier ≥ 0)*
   - `on_page_lighthouse` (step 6) provides lab-only estimates. CrUX returns actual Chrome user p75 metrics — the data Google ranks against.
   - Run `python E:\DonnaProSEO\scripts\pagespeed_check.py "https://{domain}" --crux-only --json` for current p75 LCP / INP / CLS / FCP / TTFB.
   - Run `python E:\DonnaProSEO\scripts\crux_history.py "https://{domain}" --origin --json` for the 25-week trend per metric (improving / stable / degrading).
   - If CrUX has no field data ("insufficient data"), surface that and continue — low-traffic origins are common.
   - Surface in `TECH-AUDIT.md` as a new section "## Core Web Vitals (field data)" with current p75 + trend per metric, source labelled "CrUX 28-day origin".

8c. **Per-URL indexation status via GSC URL Inspection** *(only if google-api.json is present, tier ≥ 1)*
   - For each of the top 5 traffic pages identified in step 3 (or homepage + key landing pages if no traffic data), run:
     `python E:\DonnaProSEO\scripts\gsc_inspect.py "{url}" --site-url "{config.default_property}" --json`
   - Capture `indexStatusVerdict`, `coverageState`, `googleCanonical` (vs `userCanonical`), and `lastCrawlTime` per URL.
   - **Cross-check against per-URL findings.** If GSC reports `INDEXED` but `on_page_instant_pages` flagged `noindex`, the directive may have been added recently — flag for re-check. If GSC reports `EXCLUDED` for a page that appears healthy, that is a hidden indexability issue.
   - **Critical-issue elevation:** any `userCanonical ≠ googleCanonical` divergence on a top-traffic page is added to the Top-10 fix list at Critical severity regardless of `severity-mapping.md`'s default.
   - If the property is not verified in GSC for this account, surface "GSC: {domain} not verified — add it in Search Console" and skip 8c only.
   - Surface in `TECH-AUDIT.md` as a new section "## Indexation reality check (GSC URL Inspection)" with one row per top-5-traffic URL: status / canonical-divergence / last-crawled.
   - See `skills/seo-google/references/cross-skill-integration.md` § "seo-technical-audit" for the full recipe and failure modes.

8d. **IndexNow detection** `WebFetch`
   - Follow the detection recipe in `references/severity-mapping.md` § IndexNow ("Detection") — three-step key discovery (robots.txt hint → response-header hint → `/<key>.txt` probe) plus last-key-rotation date from the key file's `Last-Modified` header.
   - Map findings to `indexnow_no_key` / `indexnow_key_mismatch` / `indexnow_not_submitted_recently` per the same section.

9. **Categorize and prioritize** using `references/severity-mapping.md`
   - Map each issue code to severity, fix, and effort estimate.
   - Aggregate per-URL findings: for each issue type, count the number of affected pages.
   - Score each finding: severity × affected-page-count / effort.
   - Build the top-10 fix list.

10. **Synthesise** `TECH-AUDIT.md`

## Output format

Write to `output/seo-technical-audit-{target-slug}-{YYYYMMDD}/` (per `CLAUDE.md` output conventions). Structure:

- **`TECH-AUDIT.md`** — primary deliverable: summary severity table, top-10 fix list (impact × effort), By-category breakdown (incl. Modern signals + extended security headers), and the optional Lighthouse / CrUX / GSC-indexation sections when their data is available.
- **`issues.csv`** — every issue (columns: `category,issue_code,issue_name,severity,affected_pages,suggested_fix,effort,priority_score`); the load-bearing CSV engineering pastes into Jira.
- **`03-key-pages-issues.md`** — top 5 traffic pages with all their issues.
- **`evidence/`** — raw per-category tables (`02-issues-by-category/*`), robots/sitemap snapshot (04), and modern-signals dump (05).

Load `templates/report.md` for the full folder layout and the exact `TECH-AUDIT.md` shape (including all optional-section tables) when writing the deliverable.

## Tips

- **Sample size matters.** The default 50-page cap means the audit reflects your highest-traffic pages, not the whole site. Increase `--limit` for broader coverage (each additional page is one `on_page_instant_pages` call).
- **Firecrawl is required.** Without it, the skill cannot enumerate the site's pages. Provide `--urls` as a fallback if Firecrawl is unavailable.
- **Lighthouse is optional** but strongly recommended for Core Web Vitals lab baselines. Pass `--no-lighthouse` to skip if speed is a priority.
- The severity scale follows `references/severity-mapping.md` — impact × effort scoring is consistent run-to-run.
- For large sites (>500 pages), focus the sample on key sections: pass `--urls` with a curated list of critical landing pages rather than relying on Firecrawl map discovery.
- Pair with `seo-drift` for regression tracking: this skill is the snapshot, drift is the diff.
- Pair with `seo-sitemap` for orphan/missing-page analysis.
- Don't auto-apply fixes. The skill diagnoses; humans decide which fixes to ship and in what order.
