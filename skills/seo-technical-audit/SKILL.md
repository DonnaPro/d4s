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
- User provides: a target domain (e.g. `example.com`). Optional: target country (default `us`), page-sample-limit override (default: 50).

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
   - **Extended security headers.** WebFetch the homepage and 3 sample URLs (top-traffic landing pages from step 3, fall back to homepage + key pages); read response headers and flag any of:
     - `csp_missing` — `Content-Security-Policy` absent.
     - `xframe_missing` — `X-Frame-Options` absent (informational; CSP `frame-ancestors` supersedes).
     - `xcontent_missing` — `X-Content-Type-Options` not set to `nosniff`.
     - `referrer_policy_missing` — `Referrer-Policy` absent.
     - `hsts_no_preload` — `Strict-Transport-Security` present but `preload` directive missing AND domain not on the Chromium HSTS preload list.
   - Map findings via `references/severity-mapping.md` § Security and surface in `evidence/02-issues-by-category/security.md` (and inline into TECH-AUDIT.md's "By category → Security" section).

8. **Modern signals checklist** `mcp__firecrawl-mcp__firecrawl_scrape`
   - DataForSEO's `on_page_instant_pages` does not execute JS and does not expose per-page response headers. This step surfaces what is invisible to it.
   - Pick 5 sample URLs from the analysis set — bias toward high-traffic landing pages and pages already flagged with noindex or canonical issues. For each:
     - **JS-rendered canonical vs initial-HTML canonical (`js_canonical_mismatch`).** Compare `metadata.canonical` (after JS render) against the canonical recorded in step 5. Flag any divergence — per Google's Dec-2025 JavaScript SEO guidance, when a canonical in raw HTML differs from one injected by JS, Google MAY use either, making canonical decisions non-deterministic.
     - **JS-rendered noindex.** Check `metadata.robots` for `noindex` after render. Catches client-side-only `noindex` injection that `on_page_instant_pages` cannot see.
     - **X-Robots-Tag header.** Read response headers from `metadata`. Flag any `noindex` / `nofollow` / `none` directives at the HTTP layer.
     - **Dec-2025 JS-SEO risk detection:**
       - **Risk 1 — Rendering-budget cuts (`js_render_budget`).** Compare initial-HTML body size to rendered-HTML body size. Flag pages where rendered HTML is <50% of initial HTML size after JS execution.
       - **Risk 2 — Hydration mismatch.** Covered above via `js_canonical_mismatch`; any drift is a real-world ranking risk.
       - **Risk 3 — CSR pitfalls (`js_csr_meta_drift`).** Diff initial-HTML `<title>`, `<h1>`, and `<meta name="description">` against the same fields in the JS-rendered DOM. Flag any divergence.
       - **Risk 4 — Soft-404 from JS errors (`js_soft_404`).** Flag rendered pages where body text content is <500 chars but the HTTP response status is 200.
     - Then make one additional call: `firecrawl_scrape` on `/robots.txt` (1 credit). Parse for AI-crawler User-Agent rules — `GPTBot`, `ClaudeBot`, `PerplexityBot`, `Google-Extended`, `ChatGPT-User`, `Bytespider`, `CCBot`. Surface allow/disallow scope per agent.

8b. **CWV field data via CrUX** *(only if google-api.json is present, tier ≥ 0)*
   - `on_page_lighthouse` (step 6) provides lab-only estimates. CrUX returns actual Chrome user p75 metrics — the data Google ranks against.
   - Run `python3 scripts/pagespeed_check.py "https://{domain}" --crux-only --json` for current p75 LCP / INP / CLS / FCP / TTFB.
   - Run `python3 scripts/crux_history.py "https://{domain}" --origin --json` for the 25-week trend per metric (improving / stable / degrading).
   - If CrUX has no field data ("insufficient data"), surface that and continue — low-traffic origins are common.
   - Surface in `TECH-AUDIT.md` as a new section "## Core Web Vitals (field data)" with current p75 + trend per metric, source labelled "CrUX 28-day origin".

8c. **Per-URL indexation status via GSC URL Inspection** *(only if google-api.json is present, tier ≥ 1)*
   - For each of the top 5 traffic pages identified in step 3 (or homepage + key landing pages if no traffic data), run:
     `python3 scripts/gsc_inspect.py "{url}" --site-url "{config.default_property}" --json`
   - Capture `indexStatusVerdict`, `coverageState`, `googleCanonical` (vs `userCanonical`), and `lastCrawlTime` per URL.
   - **Cross-check against per-URL findings.** If GSC reports `INDEXED` but `on_page_instant_pages` flagged `noindex`, the directive may have been added recently — flag for re-check. If GSC reports `EXCLUDED` for a page that appears healthy, that is a hidden indexability issue.
   - **Critical-issue elevation:** any `userCanonical ≠ googleCanonical` divergence on a top-traffic page is added to the Top-10 fix list at Critical severity regardless of `severity-mapping.md`'s default.
   - If the property is not verified in GSC for this account, surface "GSC: {domain} not verified — add it in Search Console" and skip 8c only.
   - Surface in `TECH-AUDIT.md` as a new section "## Indexation reality check (GSC URL Inspection)" with one row per top-5-traffic URL: status / canonical-divergence / last-crawled.
   - See `skills/seo-google/references/cross-skill-integration.md` § "seo-technical-audit" for the full recipe and failure modes.

8d. **IndexNow detection** `WebFetch`
   - Detection logic — IndexNow advertises its key one of three ways. Check in this order:
     1. **robots.txt hint:** look in the already-fetched `/robots.txt` (step 7) for an `IndexNow:` directive or a comment referencing the key file path.
     2. **Response header hint:** scan response headers from the homepage WebFetch (step 7) for `x-indexnow-key`, `x-indexnow`, or `x-indexnow-key-location`.
     3. **Conventional path probe:** WebFetch `/<key>.txt` if a key was hinted in (1) or (2).
   - Map findings via `references/severity-mapping.md` § IndexNow:
     - No key advertised anywhere → `indexnow_no_key` (Low; informational — Bing-only benefit).
     - Key advertised but `/<key>.txt` content ≠ advertised key → `indexnow_key_mismatch` (Medium).
     - Key file present and matches but no recent submissions detected → `indexnow_not_submitted_recently` (Low; informational).
   - Detect last-key-rotation date when possible: WebFetch the key file and read the `Last-Modified` response header.
   - Surface in `evidence/02-issues-by-category/security.md` (or a new `evidence/02-issues-by-category/indexnow.md` if findings are non-trivial) and add a row to the `TECH-AUDIT.md` Modern signals section.

9. **Categorize and prioritize** using `references/severity-mapping.md`
   - Map each issue code to severity, fix, and effort estimate.
   - Aggregate per-URL findings: for each issue type, count the number of affected pages.
   - Score each finding: severity × affected-page-count / effort.
   - Build the top-10 fix list.

10. **Synthesise** `TECH-AUDIT.md`

## Output format

Create a folder `seo-technical-audit-{target-slug}-{YYYYMMDD}/` with:

```
seo-technical-audit-{target-slug}-{YYYYMMDD}/
├── TECH-AUDIT.md                       (synthesised top-10 fix list + category summary — primary deliverable; inlines 01-audit-summary header + the six 02-issues-by-category/* tables under "By category")
├── issues.csv                          (every issue: code, severity, count, fix, effort — load-bearing CSV engineering pastes into Jira)
├── 03-key-pages-issues.md              (top 5 traffic pages, all their issues — load-bearing reference engineering / on-call consult per-URL)
└── evidence/
    ├── 02-issues-by-category/          (raw per-category tables — preserved in case a reader wants the unmerged view)
    │   ├── crawlability.md
    │   ├── indexability.md
    │   ├── security.md
    │   ├── mobile.md
    │   ├── structured-data.md
    │   └── content.md
    ├── 04-robots-sitemap-snapshot.md   (raw fetched files — preserved for reproducibility)
    └── 05-modern-signals.md            (JS-render canonical/noindex divergence, X-Robots-Tag, AI-crawler rules — requires Firecrawl)
```

Top-level: `TECH-AUDIT.md` + `issues.csv` + `03-key-pages-issues.md`. The audit summary header (`01-audit-summary`) is already in TECH-AUDIT.md's header; the six per-category tables (`02-issues-by-category/*.md`) are inlined under TECH-AUDIT.md's "By category" section. The raw category files, robots/sitemap snapshot, and modern-signals dump live under `evidence/` for reproducibility.

`TECH-AUDIT.md` follows this shape:

```markdown
# Technical Audit: {domain}

> Audit date {YYYY-MM-DD} · Pages analyzed: {n} of {total-discovered} discovered · Domain rank: {n} · Est. organic traffic: {n}/mo

## Summary

| Severity | Count |
|---|---|
| Critical | {n} |
| High | {n} |
| Medium | {n} |
| Low | {n} |

> Note: Analysis covers a sample of {n} pages (top by organic traffic). For sites with >50 pages, results represent the highest-traffic section of the site. Full-site analysis requires increasing `--limit`.

## Top 10 fixes (impact × effort)

| Rank | Issue | Severity | Pages | Fix | Effort |
|---|---|---|---|---|---|
| 1 | {issue name} | {severity} | {n} | {one-line fix} | {S/M/L} |
| ... |

## By category

### Crawlability ({n} issues)
- {issue name} ({n} pages) — {fix}
- ...

### Indexability ({n} issues)
- ...

### Security ({n} issues)
- ...

### Mobile ({n} issues)
- ...

### Structured data ({n} issues)
- ...

### Content ({n} issues)
- ...

### Modern signals ({n} findings — Firecrawl)
- {URL} — initial-HTML canonical `{X}` differs from JS-rendered canonical `{Y}` (`js_canonical_mismatch`)
- {URL} — JS-rendered `noindex` not visible to static analysis
- {URL} — `X-Robots-Tag: noindex` at HTTP layer
- {URL} — rendered HTML <50% of initial HTML size (`js_render_budget` — Google may stop rendering before content loads)
- {URL} — title / H1 / meta description differ between initial HTML and post-render DOM (`js_csr_meta_drift`)
- {URL} — rendered body <500 chars but HTTP 200 (`js_soft_404` — likely JS render failure, treated as soft-404 by Google)
- robots.txt — `GPTBot`: {allow / disallow `/path`}, `ClaudeBot`: {…}, `Google-Extended`: {…}, ...
- IndexNow — configured: {Y/N} · key-file: `/<key>.txt` {found / missing / mismatch} · last-key-rotation: {YYYY-MM-DD or "unknown"}

### Security headers (extended — WebFetch)

| Header | Homepage | Sample 1 | Sample 2 | Sample 3 | Issue |
|---|---|---|---|---|---|
| Content-Security-Policy | {present/absent} | … | … | … | `csp_missing` if absent |
| X-Frame-Options | {present/absent} | … | … | … | `xframe_missing` if absent (informational; CSP frame-ancestors supersedes) |
| X-Content-Type-Options | {`nosniff`/absent/other} | … | … | … | `xcontent_missing` if not `nosniff` |
| Referrer-Policy | {present/absent} | … | … | … | `referrer_policy_missing` if absent |
| HSTS preload | {preload directive Y/N · on Chromium preload list Y/N} | … | … | … | `hsts_no_preload` if not on list |

## Lighthouse scores (DataForSEO — lab data, top 5 pages)

| URL | Performance | Accessibility | Best Practices | SEO | LCP | CLS |
|---|---|---|---|---|---|---|
| {url 1} | {0–100} | {0–100} | {0–100} | {0–100} | {n} ms | {n} |
| ... |

Source: DataForSEO `on_page_lighthouse`. Lab data only — see CrUX section below for real-user field data.
(Or: `Lighthouse scores: skipped — pass --no-lighthouse to suppress, or this note means no pages were analyzed.`)

## Core Web Vitals (field data — CrUX)

| Metric | p75 (current) | 25-week trend | Threshold | Status |
|---|---|---|---|---|
| LCP | {n} ms | {improving/stable/degrading} | ≤2500 ms good · ≤4000 ms needs improvement | {pass/warn/fail} |
| INP | {n} ms | … | ≤200 ms good · ≤500 ms needs improvement | … |
| CLS | {n} | … | ≤0.1 good · ≤0.25 needs improvement | … |
| FCP | {n} ms | … | ≤1800 ms good · ≤3000 ms needs improvement | … |
| TTFB | {n} ms | … | ≤800 ms good · ≤1800 ms needs improvement | … |

Source: CrUX 28-day origin. If insufficient field data: "CrUX: insufficient data for {domain} (low-traffic origin)."
(Or: `CWV (field data): not configured — run `bash extensions/google/install.sh` for setup.`)

## Indexation reality check (GSC URL Inspection)

| URL | Status | userCanonical → googleCanonical | Last crawled |
|---|---|---|---|
| {top-traffic URL 1} | {INDEXED|EXCLUDED|...} | {URL} {→ different URL if divergent} | {YYYY-MM-DD} |
| {top-traffic URL 2} | … | … | … |
| ... |

Source: GSC URL Inspection (Tier 1). If property not verified: "GSC: {domain} not verified — add it in Search Console."
(Or: `Indexation reality check: not configured (Tier 1 setup required).`)

## Key-page deep dives

### {URL with most issues}
{n} issues found. Top fixes:
1. ...
2. ...

## Recommended cadence
Re-run this skill monthly to catch regressions, or wire `seo-drift` to baseline + diff between audits.
```

`issues.csv` columns: `category,issue_code,issue_name,severity,affected_pages,suggested_fix,effort,priority_score`

## Tips

- **Sample size matters.** The default 50-page cap means the audit reflects your highest-traffic pages, not the whole site. Increase `--limit` for broader coverage (each additional page is one `on_page_instant_pages` call).
- **Firecrawl is required.** Without it, the skill cannot enumerate the site's pages. Provide `--urls` as a fallback if Firecrawl is unavailable.
- **Lighthouse is optional** but strongly recommended for Core Web Vitals lab baselines. Pass `--no-lighthouse` to skip if speed is a priority.
- The severity scale follows `references/severity-mapping.md` — impact × effort scoring is consistent run-to-run.
- For large sites (>500 pages), focus the sample on key sections: pass `--urls` with a curated list of critical landing pages rather than relying on Firecrawl map discovery.
- Pair with `seo-drift` for regression tracking: this skill is the snapshot, drift is the diff.
- Pair with `seo-sitemap` for orphan/missing-page analysis.
- Don't auto-apply fixes. The skill diagnoses; humans decide which fixes to ship and in what order.
