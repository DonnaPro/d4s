---
name: seo-competitor-pages
description: Generate SEO-optimized "X vs Y" comparison and "alternatives to X" landing pages targeting comparative-intent keywords. Pulls competitor data, comparative-intent SERPs, and existing comparison pages to produce a balanced, structured page draft with feature matrix, schema, and conversion blocks. Distinct from `seo-agency-landing-page` (top-of-funnel demand-gen). Use when the user asks for "comparison page", "vs page", "alternatives page", "X vs Y", "alternative to X", or "competitor comparison page".
---

> Example output: [examples/seo-competitor-pages-linear-vs-jira-20260514/COMPARISON.md](../../examples/seo-competitor-pages-linear-vs-jira-20260514/COMPARISON.md)

# Competitor Comparison & Alternatives Pages

Produce conversion-tuned landing pages targeting comparative-intent keywords ("X vs Y", "alternatives to X", "best X for Y"). The deliverable is a paste-ready page draft with feature matrix, balanced verdict, schema markup, and a CTA flow that converts comparison-stage traffic.

## Page types this skill produces

1. **"X vs Y" head-to-head** — direct comparison between two products/services. Target keyword: `[Product A] vs [Product B]`.
2. **"Alternatives to X"** — listicle-format page positioning the user's product as one of N alternatives to a category leader. Target keyword: `[Competitor] alternatives` or `alternatives to [Competitor]`.
3. **"Best X for Y"** — segmented best-of page targeting a use case or audience. Target keyword: `best [category] for [use case]`.

## Prerequisites

- DataForSEO MCP server connected.
- Claude's `WebFetch` tool available.
- User provides: (a) the user's brand/product (the page's hero), (b) target competitor(s) — at least one, optionally up to 5 for an alternatives page, (c) page type (auto-detected from the keyword if user doesn't specify), (d) market — per CLAUDE.md defaults (UK unless the user specifies).

## Process

1. **Validate & determine page type**
   - From the user's input, detect: vs / alternatives / best-of.
   - If page type unclear, ask the user. Don't guess silently.

2. **Pull competitor context** `dataforseo_labs_google_competitors_domain`
   - For the user's domain, list top organic competitors by `common_keywords` overlap.
   - Validate that the user's named competitor is in the list (or close).

3. **Keyword overlap between the brands (primary)** `dataforseo_labs_google_domain_intersection`
   - This is the primary keyword-comparison path. Call with `target1={user's domain}`, `target2={competitor}`, `location_name`/`language_code` per CLAUDE.md, `limit` + server-side `filters`:
     - `intersections: true` → keywords **both** brands rank for (shared battleground, feeds the feature-matrix dimensions).
     - `intersections: false` (run per direction) → keywords **one** brand owns that the other doesn't (the "when to choose X" evidence).
   - Optional supporting evidence (demoted, off by default): per-brand `dataforseo_labs_google_ranked_keywords` (top 100, `limit` + filters) only if the user wants full footprints beyond the intersection.

4. **Pull comparative SERPs** `serp_organic_live_advanced` and `dataforseo_labs_google_related_keywords`
   - For "X vs Y" / "alternatives to X" / "best X for Y" target keyword(s):
     - Top 10 organic results — who else ranks for this comparative keyword?
     - PAA questions (these become FAQ section content).
     - Featured snippet (if present, capture the answer pattern).

5. **Fetch existing comparison pages** `WebFetch` (always) + `mcp__firecrawl-mcp__firecrawl_scrape` (when available)
   - **WebFetch first** (free): pull the top 3 SERP winners' markdown. Extract H2 outline, feature-matrix dimensions, verdict pattern, CTA placement.
   - **Firecrawl second** (3 Firecrawl credits — 1 per winner) — recovers what WebFetch markdown can't show:
     - Schema types from `<script type="application/ld+json">` blocks (`Product` ×N, `BreadcrumbList`, `FAQPage`, `Review`, `AggregateRating`).
     - `og:title` / `og:description` / `og:image` / `twitter:card` from `metadata`.
     - `<title>` and meta description lengths from real HTML.
   - **If Firecrawl unavailable:** WebFetch portion runs unchanged. The "schema types" line in `evidence/04-existing-pages-teardown.md` reads `(skipped — Firecrawl required for JSON-LD)`. Schema generation in step 7 falls back to a default `Product + BreadcrumbList + FAQPage` template instead of mirroring whatever the winners use.
   - This anchors the draft in observed-rewarded-pattern.

5b. **Bulk competitor scrape** `mcp__firecrawl-mcp__firecrawl_scrape` (optional, opt-in)
   - When user passes `--bulk-scrape <urls>` or supplies a list of competitor URLs to compare directly (beyond the SERP top-3), Firecrawl-scrape each URL.
   - For each URL, extract: `<title>`, `og:*`, `twitter:*`, JSON-LD `@type`s, hero-image presence, pricing-block detection (regex on prose for `$N/mo`, `€N/mo`, etc.), CTA count, comparison-table presence, free-tier-mention boolean.
   - Output `competitor-elements.csv` — one row per competitor URL × these signals.
   - Cost: 1 Firecrawl credit per URL. Surface estimate before running; refuse >50 URLs without `--confirm-cost`.

6. **Build feature matrix**
   - Dimensions inferred from the top SERP winners (e.g., "Pricing", "Free tier", "Integrations", "Support tiers", "Best for").
   - Cells: ✓ / ✗ / partial / "TBD — confirm with PM" placeholders for fields you can't auto-infer.
   - Where DataForSEO data informs a cell (e.g., "ranks for X enterprise keywords"), pull the number.

7. **Synthesise** the page draft (`COMPARISON.md` for vs; `ALTERNATIVES.md` / `BEST-OF.md` for the other types — same evidence, different skeleton from `templates/`)
   - Hero (target keyword in H1, balanced positioning).
   - TL;DR / verdict box in first 200 words.
   - Feature matrix.
   - Section per major dimension (each H2 = one dimension).
   - PAA-derived FAQ (top 3–5 questions from step 4).
   - Verdict / recommendation.
   - CTA flow.
   - Schema-ready JSON-LD: `Product` (×N) + `BreadcrumbList` + `FAQPage` (if real Q&A).

## Output format

Create a folder `output/seo-competitor-pages-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-competitor-pages-{target-slug}-{YYYYMMDD}/
├── COMPARISON.md                     (the page draft — primary deliverable; named ALTERNATIVES.md / BEST-OF.md for those page types)
├── 05-feature-matrix.md              (inferred dimensions × brands — load-bearing reference for PMs/writers)
├── schema.jsonld                     (paste-ready Product + Breadcrumb + FAQ — load-bearing artefact for engineering)
├── 05b-competitor-elements.csv       (only if --bulk-scrape ran: competitor URL × on-page-element grid)
└── evidence/
    ├── 01-competitor-context.md      (dataforseo_labs_google_competitors_domain — raw step output)
    ├── 02-keyword-overlap.md         (dataforseo_labs_google_ranked_keywords for each brand — raw step output)
    ├── 03-comparative-serp.md        (top 10 + PAA for the target keyword — raw step output)
    └── 04-existing-pages-teardown.md (top-3 SERP winners' structure + schema/og — Firecrawl-recovered)
```

Top-level: `COMPARISON.md` + `05-feature-matrix.md` + `schema.jsonld`. The 01–04 step files preserve raw API/scrape outputs in `evidence/`. `05b-competitor-elements.csv` only appears when `--bulk-scrape` was passed.

Three page-type skeletons live in `templates/`, one per page type this skill produces — load the one matching the detected type:
- `templates/comparison.md` — "X vs Y" head-to-head (hero → TL;DR verdict → at-a-glance matrix → dimension sections → when-to-choose-each → PAA FAQ → CTA → schema).
- `templates/alternatives.md` — "Alternatives to X" listicle (positions the user's product as one of N, numbered).
- `templates/best-of.md` — "Best X for Y" segmented by use case / audience.

All three carry the same feature-matrix, PAA-FAQ, and schema-pointer quality bar as the comparison skeleton. Deliverable filename matches the type: `COMPARISON.md` / `ALTERNATIVES.md` / `BEST-OF.md`.

## Tips

- **Balance is conversion.** Pages that pretend the user's product is always better lose trust and rankings. Honest assessments outperform partisan ones.
- Respect rate limit. Step 5 (fetching top 3 SERP winners) takes 3 WebFetch calls + earlier MCP queries.
- Cost: ~8 DataForSEO calls typically (competitor context + the domain_intersection comparison + comparative SERP/PAA pulls; per-brand ranked-keyword pulls are optional evidence, off by default), +3 Firecrawl credits for the schema/og benchmark in step 5, +1 Firecrawl credit per URL in step 5b (opt-in only). Pass `--no-firecrawl` to skip both Firecrawl steps.
- **Schema:** use `Product` for both products in a vs page, plus `BreadcrumbList`, plus `FAQPage` if the FAQ section is real Q&A (not a manufactured one).
- For "alternatives to X" pages, position the user's product as one of N (typically 5–10), not as #1. Numbered listicles convert better than self-promotional alternatives pages.
- For "best X for Y" pages, segment by use case explicitly — "best for solo developers" vs "best for enterprise teams" — this lets you win multiple long-tail variants.
- Run `seo-page` on the published page after 30 days to track ranking trajectory.
- Pair with `seo-content-audit` to E-E-A-T-check the draft before publishing.
- The PAA-derived FAQ in step 4 is gold — those are the questions users are actually searching, and answering them in-page raises citation-readiness for AIO.
- Don't auto-publish. Hand the draft to a writer/PM for fact-checking and brand-voice tuning.
