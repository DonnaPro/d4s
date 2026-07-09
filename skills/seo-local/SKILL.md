---
name: seo-local
description: Local SEO audit for brick-and-mortar, service-area, and multi-location businesses. Covers Google Business Profile signals on the website, NAP consistency across page and schema, local-pack rank tracking, citation samples on Tier-1 directories, and reviews on Google / Yelp / Trustpilot. Distinct from `seo-page` (URL-level keywords, no local layer) and from `seo-schema` (which generates LocalBusiness markup — this skill defers to it). Use when the user asks "local SEO", "GBP", "Google Business Profile", "NAP", "local pack", "citations", "near me", "service area", or "multi-location SEO".
---

> Example output: [examples/seo-local-sweetgreen-com-20260514/LOCAL-SEO-REPORT.md](../../examples/seo-local-sweetgreen-com-20260514/LOCAL-SEO-REPORT.md)

# Local SEO

Score a local business's website against the signals that drive local-pack and "near me" visibility — GBP integration on the page, NAP consistency, on-page local intent, citation footprint on Tier-1 directories, review-platform presence, and local-pack rank for the business's primary keywords. Deliverable is one prioritised fix list, anchored in observable signals.

> Adapted from [`AgriciDaniel/claude-seo`](https://github.com/AgriciDaniel/claude-seo)'s `seo-local` skill (MIT). Concept and dimension structure mirror the upstream; backend rewired to DataForSEO + Firecrawl + Google APIs.

## Prerequisites

- DataForSEO MCP server connected (used for local-pack rank, business listings data, domain context).
- Claude's `WebFetch` tool available (used for sense-check fallback when Firecrawl is unavailable).
- User provides: (a) a target domain or homepage URL, (b) at least one primary local keyword (e.g. `"dentist Manchester"`, `"plumber near me"`), (c) target market (per `CLAUDE.md` defaults — UK unless the user specifies otherwise) and ideally city/region for local-pack scoping. Optional: GBP listing URL, Yelp/Trustpilot URLs for review scraping.

## Process

1. **Validate target & preflight.** See `skills/seo-firecrawl/references/preflight.md` for the canonical 3-stage preflight (Firecrawl availability, Google APIs). Skill-specific notes:
   - Normalise the target (strip protocol from domain; confirm homepage is fetchable). Confirm at least one local keyword was provided — if none, infer from `<title>` + `<h1>` of the homepage; if still ambiguous, ask the user before continuing.
   - Firecrawl: optional with WebFetch fallback, ~6–9 Firecrawl credits if available (hard cap 12). When available, steps 4 (GBP-on-page audit), 5 (NAP extraction), and 7 (review scraping) run on the homepage + 5 sample pages + provided review URLs. Without Firecrawl those steps degrade to WebFetch-only — schema/JSON-LD detection and `tel:` / address element extraction become best-effort prose inspection. Pass `--no-firecrawl` to force WebFetch-only.
   - Google APIs: tier 1 (GSC) unlocks step 8b (GSC local query performance) after the local-pack rank step; tier 2 (GA4) additionally unlocks step 8c (GA4 organic-by-landing-page enrichment). See `skills/seo-google/references/cross-skill-integration.md` for the full enrichment contract.

2. **Business-type detection**
   - Read homepage + `/contact` + footer prose (WebFetch markdown is enough for this).
   - Classify as one of:
     - **Brick-and-Mortar** — visible street address, "Visit us at", embedded Maps iframe.
     - **Service Area Business (SAB)** — no street address, "serving {region}", "we come to you", `areaServed` in schema without `address.streetAddress`.
     - **Hybrid** — both signals present (e.g. showroom + service area).
   - This determines which checks apply downstream. SAB skips embedded-map and physical-address consistency. Record in `LOCAL-SEO-REPORT.md` "Snapshot".

3. **Industry-vertical detection**
   - From URL patterns (`/menu`, `/practice-areas`, `/listings`, `/inventory`), `<title>`, page prose, infer one of: Restaurant / Healthcare / Legal / Home Services / Real Estate / Automotive / Generic.
   - This routes citation-source recommendations and schema-subtype recommendations later — load `references/local-citation-sources.md` for the vertical's Tier-1 directories.

4. **GBP signals on the page** `mcp__firecrawl-mcp__firecrawl_scrape` (with `formats: ["rawHtml"]`)
   - Scrape homepage + `/contact` (or whichever page has the most local intent).
   - From `rawHtml` extract:
     - Embedded Google Maps iframe (`<iframe src="https://www.google.com/maps/embed?...">`) — record place ID if present.
     - Reviews widget / GBP rich snippet markup.
     - `aggregateRating` JSON-LD block (presence is the strongest signal that the site wants stars in SERPs).
     - Business hours visibility on page (open-at-search-time correlates with rank — Whitespark's #5 factor).
     - Click-to-call: count of `<a href="tel:...">` elements.
     - GBP profile link: any `<a href>` to `https://g.page/...` or `https://maps.app.goo.gl/...` or `https://www.google.com/maps/place/...`.
   - **If Firecrawl unavailable:** WebFetch markdown can detect a `tel:` link in some renderings but loses iframes and JSON-LD. Mark Maps embed / aggregateRating / GBP profile-link detection as `(skipped — Firecrawl required)`.

5. **NAP consistency** `mcp__firecrawl-mcp__firecrawl_scrape` on homepage + 5 sample pages
   - Sample pages: homepage, `/contact`, `/about`, plus 2 service or location pages (pick from sitemap or top traffic pages).
   - For each, extract:
     - **Visible NAP from rendered prose.** Address pattern (street + city + region + postal), phone (`tel:` href + display format), business name (logo alt, footer, schema `name`).
     - **NAP from JSON-LD.** Parse every `<script type="application/ld+json">` block. Pull `name`, `address.streetAddress`, `address.addressLocality`, `address.addressRegion`, `address.postalCode`, `telephone`.
   - **Compare across the 6 page samples + schema.** Any divergence (different phone format on the contact page vs homepage; "Suite 200" missing from one footer; schema phone in international format while page shows local format) → record in `nap-inconsistencies.csv`.
   - **Brick-and-mortar only:** if a Maps iframe is present, attempt to read the embedded address from the iframe URL (the place ID and address are URL-encoded). Compare to page/schema NAP. SAB skips this.
   - If `nap-inconsistencies.csv` is empty after the scan, write `nap-inconsistencies.csv` as a one-line file with header only and note "NAP consistent across {n} pages and schema" in `LOCAL-SEO-REPORT.md`.

6. **Local-pack rank tracking** `serp_organic_live_advanced` with country/region filters
   - For each user-provided local keyword (or the 1–3 inferred from homepage):
     - Call `serp_organic_live_advanced` with the user's country and the most specific region/city the API supports (use `serp_locations` first to confirm a valid location code if the user supplied a city).
     - Capture: top 10 organic, local-pack presence (yes/no), the 3 businesses in the local pack if shown (name, rating, review count), AIO presence.
     - Cross-check: is the target domain in the top 10 organic? Is the target business name in the local pack?
   - **Save the parsed result per keyword to `local-keywords.csv`** (columns: `keyword,country,location,local_pack_present,target_in_pack,target_pack_position,target_organic_position,top_pack_competitor_1,top_pack_competitor_2,top_pack_competitor_3`).
   - Note the local-pack-ads caveat: the DataForSEO SERP response returns the AI/ads-modified pack as Google serves it. If the local pack shows ads, record that — local-pack ad density rose sharply on mobile local searches (Sterling Sky reported a jump from ~1% to ~22% of mobile US local searches across 2025–2026, as of 2026-01 — re-verify and note it is US-measured).

7. **Reviews scraping** `mcp__firecrawl-mcp__firecrawl_scrape` on user-provided review URLs
   - **Inputs (user-provided, optional).** GBP listing URL (`https://www.google.com/maps/place/...`), Yelp business URL, Trustpilot business URL, BBB profile URL.
   - **For each provided URL:** scrape with `formats: ["rawHtml"]`. From the parsed DOM, extract: total review count, average rating, date of most recent review (review velocity proxy), count of owner responses on the most recent 10 reviews.
   - **Aggregate signals:** apply the review-health thresholds in `references/local-scoring.md` (velocity / volume / star rating / owner-response rate).
   - **If user provides no review URLs:** skip step 7 entirely. Note in `LOCAL-SEO-REPORT.md`: "Review platforms: not provided. To audit review health, re-run with `--reviews 'gbp_url,yelp_url,trustpilot_url'`." Don't try to discover them — review-URL discovery is a different problem (and the Maps API path is the one we don't have).

8. **On-page local-SEO audit** (reuse existing `seo-technical-audit` output if available)
   - **Reuse the existing site audit if one is recent (<30 days, see `seo-technical-audit`).** Don't create a new audit just for local — the audit data already covers title-tag issues, missing schema, mobile usability, etc.
   - From the audit, surface the issues that bear on local SEO specifically:
     - Title / H1 missing primary city or service term.
     - Missing or invalid `LocalBusiness` JSON-LD.
     - Mobile usability issues (mobile = where "near me" happens).
     - Schema validation errors (broken `aggregateRating`, malformed `address`).
   - **Defer schema fixes to `seo-schema`.** This skill does NOT generate JSON-LD. If LocalBusiness schema is missing or broken, the deliverable says "Run `seo-schema` for paste-ready LocalBusiness markup with the correct industry subtype" — that's `seo-schema`'s job and reimplementing it here would duplicate work.

8b. **GSC local query performance** *(only if google-api.json is present, tier ≥ 1)*
   - Pull GSC search analytics for the target property, last 28 days, dimension=query, filtered to local-intent patterns:
     `python E:\DonnaProSEO\scripts\gsc_query.py --property "{config.default_property}" --days 28 --json`
   - Client-side filter the queries for: contains `near me`, contains a city/region known for the business, or ends in a place-name. Surface top 10 by impressions.
   - If a city-bearing query has impressions >100 and average position >10, that's a local-pack reach gap — flag in `LOCAL-SEO-REPORT.md` "Top fixes" with the GSC numbers as supporting evidence.
   - If property not verified for this account: surface "GSC: {target_domain} not verified — add it in Search Console" and continue.
   - See `skills/seo-google/references/cross-skill-integration.md` for failure modes.

8c. **GA4 organic by landing page** *(only if google-api.json is present, tier ≥ 2)*
   - Pull GA4 top organic landing pages, last 28 days:
     `python E:\DonnaProSEO\scripts\ga4_report.py --report top-pages --days 28 --json`
   - For multi-location sites, surface per-location-page sessions. If one location page captures 80%+ of organic traffic while peer location pages capture <5%, that's location-page quality variance worth flagging (probable doorway-page or thin-content risk on the underperformers).
   - Single-location sites: just record the homepage's organic sessions as one row in the snapshot.

9. **Business listings check** `business_data_business_listings_search`
   - Search for the business name in the target city/region to retrieve the Google Business Profile listing.
   - Capture: business name, address, phone, categories, rating, review count, hours, and whether the listing is claimed.
   - Cross-reference with the NAP extracted in step 5 — any divergence is a critical NAP inconsistency.
   - **Empty-result branch (do NOT error):** if `business_data_business_listings_search` returns no listing for the business, record a **Critical** top fix — "GBP unclaimed or undiscoverable: no Google Business Profile found for '{business name}' in {region}. Claim/create the listing at business.google.com" — and continue the run. A missing GBP is itself the finding, not a failure.
   - Record in `LOCAL-SEO-REPORT.md` "GBP listing data" section.

9b. **Citation-presence sample (best-effort)** `WebSearch` (no API key cost)
   - For each Tier-1 directory in the vertical's list (load `references/local-citation-sources.md`), check whether the business has a listing using `site:{directory} "{business_name}"` queries via WebSearch.
   - **Cap at 8 directories.** For UK targets (the default market) use the Tier-1 UK set (Yell, Thomson Local, 192.com, plus Google/Yelp/Facebook/Apple/Bing) and skip BBB — it is North-America-only; for US/CA targets use BBB. Add 2 vertical-specific directories from the reference. Anything beyond is diminishing returns and the user can run their own audit.
   - Record in `LOCAL-SEO-REPORT.md` "Citations" section: detected / not detected per directory, plus the URL of the listing if found.
   - **Caveat to surface:** WebSearch hits are a *sample*, not a comprehensive audit. A "not detected" doesn't prove absence — it proves the listing didn't surface for that specific query. Recommend a paid citation-audit tool (Whitespark, BrightLocal, Yext) for definitive coverage.

10. **Synthesise** `LOCAL-SEO-REPORT.md`

   - Score the 5 local dimensions (0–10 each) and apply the verdict heuristic + review-health thresholds from `references/local-scoring.md`. List top fixes (Critical / High / Medium / Low) and record limitations.

## Output format

Write to `output/seo-local-{domain-slug}-{YYYYMMDD}/` (per `CLAUDE.md` output conventions). Structure:

- **`LOCAL-SEO-REPORT.md`** — primary deliverable: Snapshot · Verdict (STRONG/NEEDS WORK/WEAK) · 5 dimension scores + composite · Top fixes (Critical/High/Medium/Low) · Local-pack rank summary · Reviews health · Citation sample · Schema status · Limitations.
- **`local-keywords.csv`** — per-keyword local-pack + organic positions (load-bearing).
- **`nap-inconsistencies.csv`** — only emitted if discrepancies found (load-bearing).
- **`evidence/`** — raw dumps (01 homepage snapshot, 02 NAP page samples, 03 SERP context, 04 reviews, 05 citation sample).

Load `templates/report.md` for the full folder layout, both CSV column specs, and the exact `LOCAL-SEO-REPORT.md` shape when writing the deliverable.

## Tips

- Respect DataForSEO API rate limit. Pace the per-keyword `serp_organic_live_advanced` calls sequentially.
- Verdict heuristic and review-health thresholds live in `references/local-scoring.md` — apply them at step 10; don't re-derive the cutoffs here.
- Don't generate LocalBusiness schema in this skill. **Always** defer to `seo-schema` for that — it has the rich-results validation and industry-subtype routing this skill doesn't replicate.
- Don't generate review URLs from search results. If the user didn't provide a Yelp/Trustpilot/BBB URL, skip review scraping and tell the user to provide URLs in a re-run. Discovering review URLs from a domain is unreliable.
- For multi-location sites with >5 locations, audit one location page per region rather than one per location — the local audit pattern repeats per location, so a sample establishes the baseline. If location-page quality variance is the suspected issue, pair with `seo-content-audit` on a sample of location pages.
- AI-search local context (ChatGPT, Perplexity, AI Overviews) is **not** this skill's job — pair with `seo-geo` (URL-level GEO) or `seo-ai-search-share-of-voice` (domain-level brand visibility) for AI-search local visibility.
- The 18-day review velocity rule (Sterling Sky, as of 2026-01 — re-verify) is the most actionable single number from review-platform analysis. If the most recent review is >21 days old, that's a leading indicator of upcoming local-pack rank drop — flag as Critical regardless of star rating. (Full thresholds: `references/local-scoring.md`.)
- Citation directories per vertical: load `references/local-citation-sources.md`. The list is curated to the directories that move the needle (Tier 1 + vertical-specific), not the long tail.
- Pair with `seo-technical-audit` if site-wide technical-SEO issues surface in step 8 — this skill scopes to local-relevant findings, not the full audit.
