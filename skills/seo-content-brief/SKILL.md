---
name: seo-content-brief
description: Generate a writer-ready SEO content brief from a target domain and topic. Pulls domain overview, competitors, keyword gaps, SERP analysis, related and question keywords, AI Search citations, and existing internal-link sources, then synthesises a complete editorial brief a freelance writer can start from immediately. Use when the user asks for a content brief, blog brief, article outline, editor brief, or wants to capture organic traffic their competitors have.
---

> Example output: [examples/seo-content-brief-vercel-rate-limiting-20260514/BRIEF.md](../../examples/seo-content-brief-vercel-rate-limiting-20260514/BRIEF.md)

# Content Brief

Turn a domain plus a topic intent into a complete content editor brief: target keyword, title options, H2/H3 structure, content gaps the current top results miss, internal linking plan, AI search angle, and estimated traffic potential.

## Prerequisites

- DataForSEO MCP server connected.
- Claude's `WebFetch` tool available (used for top-3 content teardown).
- User has provided: (a) target domain, (b) market: per CLAUDE.md defaults (UK unless user specifies), and optionally (c) a seed topic or intent. If no seed topic is given, discover the best opportunity from the keyword-gap step.
- **Preflight.** See `skills/seo-firecrawl/references/preflight.md` (budget guard, Firecrawl availability, Google APIs) and `CLAUDE.md` (market defaults, cost discipline). Skill-specific notes:
  - Typical DataForSEO calls for this skill: ~7–9 (overview, competitors, gap, one SERP pull, keyword expansion, internal-link pull).
  - Firecrawl: optional with WebFetch fallback (top-3 on-page benchmark only).
  - Google APIs: not used.

## Process

1. **Domain overview** `dataforseo_labs_google_domain_rank_overview`, `dataforseo_labs_google_ranked_keywords`
   - Pull organic traffic, top countries, and top 100 organic keywords in the target market.
   - Save the raw JSON and a human summary.

2. **Competitor discovery** `dataforseo_labs_google_competitors_domain`
   - Identify the top 5 organic competitors by shared keywords in the target market.
   - Save a one-line positioning note per competitor.
   - **Note:** the upstream API does not support `limit`/`offset`, so this call returns the full set (~60KB for popular domains) and the MCP harness writes it to a file. Read that file path, parse the `{data: [...]}` JSON, sort by `common_keywords` desc, and take the top 5.

3. **Keyword gap analysis** `dataforseo_labs_google_domain_intersection`
   - Pull keywords the competitors rank for that the target domain does not.
   - Filter: informational intent, search volume > 1,000/mo, keyword difficulty < 40.
   - Save the filtered gap list sorted by volume.

4. **Pick the best topic cluster**
   - From the gaps, select one topic. Justify the pick with: traffic potential, difficulty, relevance to the target domain's product. Surface reasoning to the user before proceeding.

5. **SERP and keyword deep-dive for the chosen topic**
   - **One** `serp_organic_live_advanced` call — a single call returns the top 10 organic AND all SERP features (AIO, PAA, Featured Snippet, Video). Never re-call for features.
   - `dataforseo_labs_google_related_keywords` (once — covers expansion AND question-based/PAA variations) and `dataforseo_labs_google_keyword_suggestions` for long-tail expansion.
   - `ai_opt_llm_ment_top_domains` to see which brands LLMs cite today for the topic (pairs with the SERP call above — no extra SERP pull needed).

6. **Top 3 content analysis** `WebFetch` (always) + `mcp__firecrawl-mcp__firecrawl_scrape` (when available)
   - **WebFetch first** (free, instant): pull markdown for the top 3 ranking URLs. Extract H1/H2/H3 spine, word count per article, shared subtopics, gaps, and prose-level formatting patterns.
   - **Firecrawl second** (3 Firecrawl credits — 1 per top-3 winner) — recovers what WebFetch's markdown can't show:
     - From `metadata`: `<title>` length (the real string, not markdown's first heading), meta description length, `og:title`, `og:description`, `og:image`, `twitter:card`.
     - From the returned `html`: every `<script type="application/ld+json">` block. Parse and list `@type`s per winner (Article, FAQPage, BreadcrumbList, Product, etc.) — these become the "schema baseline" for the new article.
     - On-page signals: hero-image presence, byline structure (`<a rel="author">`, `<meta name="author">`), table count, code-block count.
   - **Classify the brief's template** against the 8-template map in `references/intent-template-map.md`. Cross-reference: (a) the dominant page type across the SERP top-10 (use the heuristics in `skills/seo-sxo/references/page-type-patterns.md`), (b) PAA patterns from step 5, (c) the keyword's intent classification from `dataforseo_labs_google_related_keywords`. Pick one of: `ultimate-guide` / `how-to` / `listicle` / `explainer` / `comparison` / `review` / `best-of` / `landing-page`. If the SERP is split across types, follow the MIXED rule (see Tips). The chosen template determines the recommended H1/H2 outline shape and word-count floor — record both the template and a one-sentence justification in `BRIEF.md`.
   - **If Firecrawl unavailable (or `--no-firecrawl` passed):** WebFetch portion runs unchanged. The brief's "Top 3 winners — on-page benchmark" subsection (see Output) emits `(skipped — Firecrawl required for schema/og:* on competitor pages)`. Template classification still runs from WebFetch + SERP data.

7. **Internal linking plan**
   - `dataforseo_labs_google_ranked_keywords` filtered to the target domain plus WebFetch of 5 high-ranking pages on topically adjacent queries.
   - For each: propose an anchor text and the section of the new post it belongs in.

8. **Synthesise the brief** (see Output Format).

## Output format

Create a folder `output/seo-content-brief-{target-slug}-{YYYYMMDD}/` with the synthesised brief at the top level and step files in `evidence/`:

```
output/seo-content-brief-{target-slug}-{YYYYMMDD}/
├── BRIEF.md                        (writer-ready synthesis — primary deliverable; inlines 01-domain-overview, 02-competitors, 06-internal-links into a "Context" section)
└── evidence/
    ├── 01-domain-overview.md       (dataforseo_labs_google_domain_rank_overview raw — preserved for reproducibility)
    ├── 02-competitors.md           (dataforseo_labs_google_competitors_domain raw)
    ├── 03-keyword-gaps.md          (dataforseo_labs_google_domain_intersection filtered)
    ├── 04-serp-and-keywords.md     (serp_organic_live_advanced + related/question keywords)
    ├── 05-content-analysis.md      (top-3 winners' H-spine + on-page benchmark)
    └── 06-internal-links.md        (target domain pages + proposed anchors)
```

Top-level: `BRIEF.md` only — a freelance writer should not need to open anything else. Step files preserve the raw API/scrape outputs in `evidence/` for reproducibility / to back up the editor brief.

`BRIEF.md` follows the full skeleton in `templates/brief.md` (load it only when writing the deliverable). Structure at a glance:

- Header: proposed title + template type + one-sentence template justification.
- Target keyword (primary + secondaries), 3 title options, meta description draft.
- Suggested structure: H1 + per-H2 "cover/cite" bullets.
- Gaps the current top 3 miss; top-3 on-page benchmark table (Firecrawl — or a skipped note).
- Internal linking plan table, AI Search angle, deliverables, traffic potential, raw-data references.

## Tips

- Respect DataForSEO API rate limit: 10 requests per second. Iterate sequentially, do not fan out across 20 keywords in parallel.
- **Firecrawl cost.** Step 6's competitor benchmark adds 3 Firecrawl credits per run (1 per top-3 winner). Pass `--no-firecrawl` to skip it (the brief still ships, just without the on-page benchmark table).
- If the user only provides a domain and no topic, run step 3 first and present the top 3 gap opportunities before deciding.
- Keep the brief self-contained. A freelance writer should not need to open the raw-data files unless they want to double-check something.
- Do not hallucinate keyword difficulty or volume. If an endpoint returns null, mark the field unknown in the brief rather than guessing.
- If the topic triggers AI Overviews, the AI Search angle section is mandatory, not optional. Growth in this era requires being citable by LLMs.
- If the SERP top-10 has mixed page types (e.g. 4 listicles + 4 comparisons + 2 explainers), treat as MIXED and produce a hybrid brief that explains the consultant's chosen template + why; don't force-pick one when the SERP itself is split. Record `MIXED` in the `Template type` line and use the `Why this template` line to justify the hybrid choice (which template's outline shape you're inheriting and which secondary patterns you're folding in).
