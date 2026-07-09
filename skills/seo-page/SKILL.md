---
name: seo-page
description: URL-level SEO intelligence — which keywords this page ranks for, traffic captured, position history, SERP context, and AI Search citation status. Produces a keep / refresh / consolidate / kill verdict for one page. Distinct from `seo-technical-audit` (which checks technical health, not keyword/traffic performance) and from `seo-content-brief` (which produces a NEW article from a topic). Use when the user asks "analyze this page", "page SEO performance", "what does this URL rank for", "page traffic", "should I refresh this page", or provides a single URL for analysis.
---
> Example output: [examples/seo-page-notion-keyboard-shortcuts-20260514/PAGE.md](../../examples/seo-page-notion-keyboard-shortcuts-20260514/PAGE.md)

# Page Intelligence

Show what a single URL ranks for, what traffic it captures, where its weak and strong points are, and what to do about it. The deliverable is an opinionated verdict — **KEEP**, **REFRESH**, **CONSOLIDATE**, or **KILL** — anchored in objective signals from DataForSEO's URL-level data.

## Prerequisites

- DataForSEO MCP server connected.
- Claude's `WebFetch` tool available (for the page-level HTML sense-check).
- User provides: (a) a target URL, optionally (b) target market (per `CLAUDE.md` defaults — UK unless the user specifies otherwise), (c) primary topical keyword (auto-inferred from `<title>` + `<h1>` if not supplied).

## Process

1. **Validate target & preflight.** See `skills/seo-firecrawl/references/preflight.md` for the canonical 3-stage preflight (Firecrawl availability, Google APIs). Skill-specific notes:
   - Confirm the URL is fetchable; derive parent domain. If the user supplied a primary keyword, use it; otherwise infer it in step 3.
   - Firecrawl: optional with WebFetch fallback, ~1 Firecrawl credit if available. When available, step 6 recovers `og:*`, `twitter:*`, canonical, robots meta, JSON-LD types, and hreflang count from raw `<head>` — WebFetch returns markdown only and strips those fields. Without Firecrawl, the affected lines in `PAGE.md` emit `(skipped — Firecrawl not installed)`. Pass `--no-firecrawl` to treat Firecrawl as unavailable even when installed.
   - Google APIs: tier 1 (GSC available) unlocks step 4b (GSC URL performance + URL Inspection) after the page-authority step. See `skills/seo-google/references/cross-skill-integration.md` § "seo-page" for the full recipe.

2. **Domain overview** `dataforseo_labs_google_domain_rank_overview` (parent domain) — **run this once; steps 2 and 7 share the single result**
   - Pull keyword count, organic traffic estimate, paid keyword count, paid traffic estimate, top regions.
   - Note: traffic estimates are directional — they don't replace Google Search Console.
   - Cache this payload in `evidence/01-url-overview.md`; step 7 reads it back rather than re-calling.

3. **Ranking keywords** `dataforseo_labs_google_ranked_keywords` (use the `url` param for exact match, `limit: 200`)
   - Pull the keywords the URL ranks for in the target market, with positions.
   - Sort by traffic-weighted score: `volume × CTR-by-position` using a rough CTR heuristic (directional only, not measured for this site): 1=28%, 2=15%, 3=11%, 4=8%, 5=7%, 6=5%, 7=4%, 8=3%, 9=2%, 10=2%, 11+=1%.
   - Take the top 3–5 as the URL's "primary keywords" for SERP work in step 5.

4. **Page authority** `backlinks_summary` + `backlinks_timeseries_summary`
   - Current PA score and its 12-month trajectory.
   - Flag any drop > 5 points in the last 90 days.

4b. **GSC URL performance + URL Inspection** *(only if google-api.json is present, tier ≥ 1)*
   - Replaces the directional traffic estimate from step 2 with first-party Google data for the exact URL.
   - Pull GSC search analytics for the URL (last 28 days, by query and page):
     `python E:\DonnaProSEO\scripts\gsc_query.py --property "{config.default_property}" --url "{target_url}" --days 28 --json`
   - Pull URL Inspection (real indexation status, canonical Google sees, last crawl date):
     `python E:\DonnaProSEO\scripts\gsc_inspect.py "{target_url}" --site-url "{config.default_property}" --json`
   - If the URL's domain isn't a verified GSC property: surface "GSC: {target_domain} not verified — add it in Search Console" and continue with DataForSEO data only.
   - Surface in `PAGE.md` "## Snapshot": `GSC last 28d: {clicks}/{impressions}/{ctr}% CTR / pos {position}` and `Google sees: {INDEXED|EXCLUDED} · canonical {userCanonical} → {googleCanonical} · last crawled {date}`.
   - **Feed into the verdict heuristic:** `INDEXED` + impressions > 100 + position 4–10 → harden REFRESH (clear quick-win). `EXCLUDED` (any reason) → harden KILL or CONSOLIDATE. `userCanonical ≠ googleCanonical` → flag as critical issue regardless of verdict.
   - See `skills/seo-google/references/cross-skill-integration.md` § "seo-page" for the full recipe.

5. **SERP context** `serp_organic_live_advanced`
   - Cap at **3 live SERP calls** (one per top-3 primary keyword) unless the user explicitly asks for more — each call is paid.
   - For each keyword checked:
     - Top 10 organic results (URL, title, snippet).
     - SERP features present (PAA, image carousel, video, shopping, etc.).
     - AIO presence and citations — is this URL cited in the AIO? (AI overview items are returned in the same response.)

6. **HTML sense-check** `WebFetch` (always) + `mcp__firecrawl-mcp__firecrawl_scrape` (when available)
   - **WebFetch first** (free, instant): extract `<title>`, meta description, all `<h1..h6>`, lang, word count, internal-link count, image count. WebFetch returns markdown so anything in `<head>` beyond `<title>` is lost — the next bullet recovers it.
   - **Firecrawl second** (1 Firecrawl credit; pass `formats: ["rawHtml"]`) — recovers what WebFetch can't see. Pin the format to `rawHtml`; the default `html` is post-processed and silently strips canonical, hreflang, and `<script type="application/ld+json">` blocks on many sites. If those head fields come back zero on a site that obviously has them (any major SaaS homepage), you forgot the `rawHtml` flag — re-run.
     - From `metadata`: `og:title`, `og:description`, `og:image`, `twitter:card`, `viewport`, robots meta, canonical URL.
     - From the returned `rawHtml`: every `<script type="application/ld+json">` block. Parse each as JSON, list detected `@type`s (Article, BreadcrumbList, Organization, Product, etc.). Note any block that fails to parse.
     - hreflang: count `<link rel="alternate" hreflang="…">` occurrences in `rawHtml`.
   - **If Firecrawl unavailable:** the WebFetch portion still runs; populate Page basics' OG / Twitter / canonical / robots / JSON-LD / hreflang lines as `(skipped — Firecrawl not installed)`. Don't infer from markdown.
   - **Sense-check:** does the page actually talk about its top-ranking keyword in title and H1? If a page ranks for keywords it doesn't address textually, that's a strong consolidation signal.

7. **Domain context** — reuse the step 2 payload (no new call)
   - From the step 2 `dataforseo_labs_google_domain_rank_overview` result already saved in `evidence/01-url-overview.md`, read parent DA, total keywords, total traffic. Used to contextualise the page's PA against its domain.

8. **Cannibalization check** `dataforseo_labs_google_relevant_pages`
   - Pull the parent domain's pages ranked by organic traffic. Cap at the top 50 — that's where the cannibalization risk concentrates.
   - For the candidate URL's top-3 traffic-weighted keywords (from step 3), scan the peer-page list: does any other URL on the same domain rank in the top 20 for any of those keywords?
   - **Cannibalization signal:** any peer URL ranking ≤ 20 for the candidate's top-3 keywords. Record peer URL, keyword, peer position vs candidate position, peer traffic.
   - **Efficient approach.** `dataforseo_labs_google_relevant_pages` ranked by traffic surfaces the high-impact peers directly without pulling tens of thousands of rows.
   - If no peer URL competes, this signal is "no cannibalization detected" — pass through to step 9.

9. **Synthesise verdict**
   - Apply the verdict heuristic (see Tips) to produce KEEP / REFRESH / CONSOLIDATE / KILL.
   - For REFRESH, identify the top 3 specific changes (e.g., "add an H2 on 'alternatives' which 7 of 10 SERP winners use").
   - Write `PAGE.md` (output spec below).

## Output format

Write to `output/seo-page-{target-slug}-{YYYYMMDD}/` (per `CLAUDE.md` output conventions). Structure:

- **`PAGE.md`** — primary deliverable: synthesised verdict + plan.
- **`keywords.csv`** — full enriched ranking-keyword list (columns: `keyword,volume,kd,position,intent,traffic_estimate,url`); the auditable trail.
- **`04-serp-context.md`** — per-keyword SERP top-10 + AIO for the primary keywords.
- **`evidence/`** — raw per-call dumps (01 url/domain overview, 02 keywords, 03 authority, 05 page snapshot, 06 cannibalization).

`PAGE.md` covers: Snapshot · Page basics · What this page wins · Almost-wins · What this page misses · Same-domain cannibalization · AI Search angle · Verdict (KEEP/REFRESH/CONSOLIDATE/KILL) with reasoning and — if REFRESH — top 3 changes.

Load `templates/report.md` for the full folder layout and the exact `PAGE.md` shape when writing the deliverable.

## Tips

- Respect DataForSEO API rate limit. The (up to 3) SERP queries in step 5 should be paced sequentially.
- Verdict heuristic:
  - **KEEP**: PA stable or up; traffic stable or up; top 3 keywords held in their positions; AIO citations present where AIO appears.
  - **REFRESH**: any of (PA dropped >5 in 90 days; traffic dropped >20%; a top-3 keyword fell to position 11+; AIO citations missing while competitors get cited). **Hardens** when GSC data (step 4b) shows `INDEXED` + impressions > 100 + average position 4–10 (clear quick-win territory).
  - **CONSOLIDATE**: cannibalization detected (step 8) — a peer URL on the same domain ranks ≤ 20 for one or more of the candidate's top-3 keywords. CONSOLIDATE harden when the peer outranks the candidate AND captures higher traffic; otherwise CONSOLIDATE recommendation is "merge into the candidate" rather than "kill the candidate."
  - **KILL**: PA <10 AND traffic <50/mo AND no top-10 keyword AND no internal links pointing to it. **Hardens** when JSON-LD schema is also absent (Firecrawl detected zero blocks) — the page has no signals for any crawler, organic or AI. **Also hardens** when URL Inspection (step 4b) returns `EXCLUDED` for any reason.
  - **GSC canonical mismatch (any verdict):** if step 4b detects `userCanonical ≠ googleCanonical`, flag this as a critical issue in `PAGE.md` regardless of the verdict — it points at indexing instability that the verdict on its own can't resolve.
- Don't invent reasons. Anchor every claim in `PAGE.md` to a number from the raw data files.
- When between KEEP and REFRESH, default to REFRESH — small refreshes compound.
- The `keywords.csv` is the auditable trail. If a stakeholder questions the verdict, walk them through the CSV row by row.
- For pages with very low data (new pages, <5 ranking keywords), the verdict is unreliable. Flag as "insufficient data — re-run after 60 days" rather than forcing a verdict.
- **`backlinks_timeseries_summary` all-zeros caveat:** if the endpoint returns zero rank values for every date in the history window, treat as "insufficient history" — don't claim a drop or recommend REFRESH based on it. Often happens for very high-authority pages where the metric is saturated, or for URLs that haven't accumulated enough longitudinal data. Cross-check with `backlinks_summary` (current value) — if current authority is meaningful but history is flat-zero, flag the gap explicitly in `PAGE.md` rather than synthesising a trajectory.
