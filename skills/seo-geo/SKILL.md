---
name: seo-geo
description: URL-level Generative Engine Optimization (GEO) analysis. For a specific URL, pulls AI Overview citation data scoped to the URL's primary keywords, identifies which AIO queries cite the URL vs which don't but should, and recommends page-level changes that improve LLM citability. Distinct from `seo-ai-search-share-of-voice` (domain-level, brand vs brand) — this is one URL, deeper. Use when the user asks "GEO for this page", "AIO citation analysis", "AI search readiness for URL", "why isn't this page cited", or "improve LLM citations".
---
> Example output: [examples/seo-geo-notion-share-pages-20260514/GEO.md](../../examples/seo-geo-notion-share-pages-20260514/GEO.md)

# Page-Level GEO (Generative Engine Optimization)

For one URL, surface its AI-search citation footprint and recommend the page-level changes that would improve citability. DataForSEO LLM Mentions covers exactly two platforms — Google AI Overview (`google`) and ChatGPT (`chat_gpt`) — so the citation data here is scoped to those; do not promise Perplexity/Gemini coverage. Different from the domain-level brand-vs-brand share-of-voice — this is page-level diagnosis.

## Prerequisites

- DataForSEO MCP server connected.
- Claude's `WebFetch` tool available.
- User provides: a target URL. Market: per `CLAUDE.md` defaults (UK unless the user specifies another market). Optional: specific keywords to focus on (defaults: the URL's top-5 traffic-weighted keywords from DataForSEO).

## Process

1. **Validate target & preflight.** See `skills/seo-firecrawl/references/preflight.md` for the canonical 3-stage preflight (Firecrawl availability, Google APIs). Skill-specific notes:
   - Confirm URL is fetchable before continuing.
   - Firecrawl: optional, ~1 Firecrawl credit if available (the JSON-LD parse in step 7). Without it, that step emits a `(skipped — Firecrawl not installed; install via extensions/firecrawl/install.sh)` note in `GEO.md` rather than failing the run. The AI-protocol-files step 8 uses free WebFetch, not Firecrawl. Pass `--no-firecrawl` to skip Firecrawl even when available (saves credits).
   - Google APIs: not used.

2. **URL keyword footprint** `dataforseo_labs_google_domain_rank_overview` and `dataforseo_labs_google_ranked_keywords` (URL-filtered)
   - Pull URL's overview (keywords, traffic).
   - Pull all keywords the URL ranks for (set a `limit`, e.g. 100). Sort by traffic-weighted score.
   - Take the top 5 as the GEO investigation set (or use user-supplied keywords).
   - **Zero-keyword fallback:** if the URL ranks for no keywords (new page, thin footprint, or filtered out), don't stop. Either (a) ask the user for the target keywords the page should win, or (b) WebFetch the page's `<title>` + H1 and derive candidate seeds via `dataforseo_labs_google_keyword_suggestions` (with `limit`), then take the top 5 by search volume. Note in `GEO.md` that the investigation set was derived, not from actual rankings.

3. **AIO presence per keyword** `serp_organic_live_advanced`
   - For each keyword, query SERP results including AI Overview items in the response.
   - Flag: AIO present? Is the candidate URL cited?
   - Capture the AIO answer text — it tells you what passage shape Google's models prefer.

4. **AIO leaderboard per keyword** `ai_opt_llm_ment_top_domains`
   - **Gate on step 3:** only run this for keywords where step 3 found an AI Overview present. Skip keywords with no AIO — there is no leaderboard to pull and the call would be wasted spend.
   - For each gated keyword, pull the ranked list of cited sources (set a `limit`, e.g. 20).
   - Identify patterns: domain-level (which sites consistently cited?), passage-level (what structure?).

5. **Page passage-level audit** `WebFetch`
   - Pull the page HTML.
   - Identify "passages" — paragraphs that could be extracted standalone (TL;DR boxes, definition paragraphs, summary sentences after H2s).
   - Score each passage against the citability criteria in `references/citability.md`. This is the citability layer.

6. **Compare candidate to cited sources**
   - For each AIO query where candidate is NOT cited, identify the cited sources.
   - WebFetch 2–3 of them.
   - Extract the cited passage (often a snippet from the AIO answer).
   - Compare passage shape: candidate vs cited. Surface specific structural / content / freshness gaps.

7. **Schema check** `mcp__firecrawl-mcp__firecrawl_scrape`
   - WebFetch in step 5 returned markdown — JSON-LD blocks were stripped before parsing. The schema check requires Firecrawl to recover them.
   - **If Firecrawl available:** scrape the target URL once (1 Firecrawl credit), parse the returned `html` for every `<script type="application/ld+json">` block. Specifically check for: `Article`/`BlogPosting` with valid `author` + `datePublished` + `dateModified`; `FAQPage` if Q&A blocks present; `BreadcrumbList`; `mainEntityOfPage` self-canonical.
   - **If Firecrawl unavailable:** write `Schema check: skipped — Firecrawl required to parse JSON-LD blocks (WebFetch returns markdown only).` into `evidence/06-schema-check.md`, mirror the same line in the GEO.md "Schema check" section. Don't infer from markdown — that's the bug this section closes.
   - Schema isn't a direct citation signal but it correlates strongly with citation rates in Google's AIO.

8. **AI-protocol files** — plain `WebFetch` (free)
   - These are small plain-text/JSON files, so fetch them with `WebFetch` — do NOT spend Firecrawl credits here (see `CLAUDE.md` / preflight: plain-text files always go via WebFetch). Fetch `https://{domain}/llms.txt` and `https://{domain}/.well-known/rsl.json` (and the legacy `/RSL.txt` location as a fallback).
   - For each file: capture HTTP status (200 / 404 / other), full body if present, and a parsed summary (declared content categories, allow/deny scope, attribution requirements).
   - Surface in `evidence/07-ai-protocol-files.md` and in GEO.md as an "AI-protocol files" section. These signal the domain's stance on LLM training and citation — present-and-permissive correlates with higher AIO citation rates.

9. **Synthesise** `GEO.md`

## Output format

Create a folder `output/seo-geo-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-geo-{target-slug}-{YYYYMMDD}/
├── GEO.md                            (synthesised report + recommendations — primary deliverable)
├── 04-page-passages.md               (extracted passages + citability scores — load-bearing reference editors consult)
├── 05-cited-source-comparison.md     (gap vs cited sources — load-bearing reference)
└── evidence/
    ├── 01-url-keyword-footprint.md   (URL overview + top keywords — raw step output)
    ├── 02-aio-by-keyword.md          (AIO presence + citation per keyword)
    ├── 03-leaderboards.md            (full leaderboards per keyword)
    ├── 06-schema-check.md            (JSON-LD audit for GEO-relevant types — requires Firecrawl)
    └── 07-ai-protocol-files.md       (llms.txt + RSL status and content — via WebFetch)
```

Top-level: `GEO.md` + `04-page-passages.md` + `05-cited-source-comparison.md`. The other step files preserve raw API/scrape outputs in `evidence/` for reproducibility — editors and writers don't open them in the normal flow.

`GEO.md` structure: header (URL, date, market, keywords analysed) → Citation footprint table + citation rate → Where the candidate IS cited → Where it is NOT cited (with cited-source patterns) → Page passage-level audit (top/lowest citability passages) → Schema check → AI-protocol files → Recommendations (top 5) → Recommended next step (re-run in 30 days). Load `templates/report.md` for the full mock when writing the deliverable.

## Tips

- Respect rate limit (10 req/s). Step 4 runs only for keywords with an AIO present (gated), so the paid call count is typically well under 10; plus 2–3 WebFetch on cited sources and the free AI-protocol WebFetches.
- Cost: ~1 Firecrawl credit when the extension is installed (target-URL JSON-LD in step 7). AI-protocol files (step 8) use free WebFetch. The schema check degrades gracefully without Firecrawl — it emits an explicit "skipped" note rather than silently dropping.
- **Citation isn't ranking.** A page can rank well organically and still not be cited in AIO. The opposite happens too — cited pages often rank below their citation rate.
- The biggest GEO levers are documented in `references/citability.md`.
- Pair with `seo-ai-search-share-of-voice` for domain-level brand-vs-brand visibility (this skill is page-level).
- Pair with `seo-content-audit` to apply the CITE rubric to the page (which has more citation-readiness items).
- Pair with `seo-schema` to fix schema issues identified in step 7.
- Don't optimize for AIO at the expense of human readability. The two reinforce each other when done right.
