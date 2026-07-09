---
name: seo-schema
description: Detect existing JSON-LD structured data on a page, validate against Google's rich-result requirements, and generate missing schema markup (Article, Product, LocalBusiness, FAQPage, BreadcrumbList). Produces paste-ready `<script type="application/ld+json">` blocks. Use when the user asks for "schema markup", "structured data", "JSON-LD", "rich results", "schema validation", or "fix the schema on this page".
---
> Example output: [examples/seo-schema-budgetbytes-slow-cooker-chicken-noodle-soup-20260514/SCHEMA.md](../../examples/seo-schema-budgetbytes-slow-cooker-chicken-noodle-soup-20260514/SCHEMA.md)

# Schema Markup

Detect, validate, and generate Schema.org JSON-LD for a page. Output is paste-ready `<script>` blocks the user can drop into their CMS or page template, plus a validation report on what's currently present and what's broken.

## Prerequisites

- **Required for detect/validate paths:** `mcp__firecrawl-mcp__firecrawl_scrape` (raw HTML access). WebFetch returns markdown only — every `<script type="application/ld+json">` block is stripped before the skill ever sees it. Without Firecrawl, the skill can still generate new schema from intent detection (steps 4–6) but cannot detect or validate what's already on the page (steps 2–3, 7).
- Optional: DataForSEO MCP server (used in step 7 for benchmarking competitor schema).
- User provides: a target URL. Optionally a hint about page intent ("this is a product page", "this is a how-to") if the URL pattern doesn't make it obvious.

## Process

1. **Preflight & fetch HTML.** Run the shared preflight — see `skills/seo-firecrawl/references/preflight.md` (Firecrawl availability, budget guard) and `CLAUDE.md` (market defaults, cost discipline). Skill-specific notes:
   - Typical DataForSEO calls: 0 (1 `serp_organic_live_advanced` only if step 7 benchmark runs). Firecrawl: **required** for detect/validate — WebFetch returns markdown only and strips every `<script type="application/ld+json">` block. Google APIs: not used.
   - **Firecrawl available:** scrape the target URL with `mcp__firecrawl-mcp__firecrawl_scrape`. For SPAs pass `waitFor: 2000` (or a main-content CSS selector) so the JS-rendered DOM is captured. Use the response's `html` for step 2 and `metadata` for canonical/robots cross-reference. If JSON-LD appears only after JS render, flag: "JS-rendered schema may not be detected by all crawlers — server-side render JSON-LD where possible."
   - **Firecrawl unavailable (or `--no-firecrawl`):** skip steps 2, 3, and 7 (all need raw HTML). Steps 4–6 still run — "generate-only" mode. Surface in `SCHEMA.md`: `Existing-schema detection: skipped — Firecrawl required (WebFetch returns markdown only).`

2. **Detect existing schema** (requires Firecrawl HTML from step 1)
   - From the returned `html`: extract every `<script type="application/ld+json">` block.
   - Parse each as JSON. Report syntax errors.
   - List each detected `@type`.
   - Also detect Microdata (`itemscope`/`itemprop`) and RDFa (`typeof`/`property`) — flag as legacy and recommend migration to JSON-LD (Google's stated preference).
   - **If step 1 degraded:** skip this step. Record `Existing-schema detection skipped` in `01-detected.md`.

3. **Validate against Google's spec**
   - Load `references/google-rich-results.md`.
   - For each detected `@type`, check required and recommended properties.
   - Surface common errors: missing `@context`, dates not in ISO 8601, prices as numbers instead of strings, `availability` as plain text instead of schema.org URL, telephone not in international format.

4. **Detect page intent**
   - From URL pattern (`/blog/`, `/products/`, `/contact/`, `/how-to/`, `/faq/`).
   - From `<title>` and `<h1>` tone.
   - From content signals (numbered list of steps → HowTo; visible Q&A blocks → FAQPage; price + buy button → Product; address + hours → LocalBusiness).
   - If multiple intents detected, generate schema for each.

5. **Generate missing JSON-LD**
   - For each detected intent without matching valid schema, load the relevant template from `templates/`:
     - `article.json` — for editorial/blog content
     - `product.json` — for product/SKU pages
     - `local-business.json` — for brick-and-mortar landing pages
     - `faq-page.json` — for explicit Q&A blocks (gov/health allowlist only — see references/google-rich-results.md)
     - `breadcrumb-list.json` — for any page with breadcrumb navigation
   - Fill template fields from the live HTML (title → headline, h2s → mainEntity questions, etc.).
   - Mark any field that couldn't be auto-filled as `{REPLACE: ...}` so the user knows to complete it.
   - **Don't generate `HowTo`** — Google retired HowTo rich results in September 2023 (mobile + desktop). The schema can still ship for semantic clarity, but expect zero rich-result uplift; flag this in the recommendation rationale rather than treating HowTo as a live option.

6. **Validate generated JSON-LD**
   - Re-run the same validation rubric from step 3 on the generated blocks.
   - Surface any required fields still marked `{REPLACE: ...}`.

7. **Optional: benchmark against top SERP results** `serp_organic_live_advanced` + `mcp__firecrawl-mcp__firecrawl_scrape`
   - Identify the page's primary keyword (from `<title>` or user input).
   - Pull top 10 organic results.
   - **If Firecrawl available:** scrape each of the top 10 (10 Firecrawl credits). For each, parse JSON-LD blocks from the returned `html` and list detected `@type`s. This produces real schema data, not inferences from markdown.
   - **If Firecrawl unavailable:** skip the benchmark — WebFetch's markdown strips all schema blocks, so any "detection" from it would be guesswork. Write `Competitor benchmark skipped — Firecrawl required to read JSON-LD from competitor pages.` into `04-competitor-benchmark.md`.
   - Surface "schema types used by 6+ of the top 10 that this page is missing." High-signal addition list. (Only emitted when benchmark ran.)

8. **Synthesise** `SCHEMA.md`
   - Validation report (existing schema, pass/fail per block).
   - Recommended additions (with rationale linking back to step 4 detection or step 7 benchmark).
   - Generated `<script>` blocks ready to paste.

## Output format

Create a folder `seo-schema-{target-slug}-{YYYYMMDD}/` with:

```
seo-schema-{target-slug}-{YYYYMMDD}/
├── 01-detected.md           (existing schema, validation results)
├── 02-recommended.md        (which types this page should add and why)
├── 03-generated/
│   ├── article.jsonld
│   ├── faq-page.jsonld
│   └── ... (per generated type)
├── 04-competitor-benchmark.md  (only if step 7 ran)
└── SCHEMA.md                (deliverable: paste-ready blocks + install instructions)
```

`SCHEMA.md` follows this shape:

```markdown
# Schema Markup: {URL}   (snapshot {YYYY-MM-DD})

## Currently present
- `Article` — valid ✓
- `BreadcrumbList` — invalid ✗ (missing `position` on item 2)

## Recommended additions
- `FAQPage` — 6 visible Q&A blocks, no FAQ schema. Eligible for FAQ rich results (subject to Google's 2024+ tightening — see references/google-rich-results.md).

## Paste these into the `<head>` of the page
### FAQPage → one `<script type="application/ld+json">` block per generated type

## Validation pass
- All generated blocks parse cleanly ✓; {n} {REPLACE: ...} placeholders remain to fill manually (e.g. article.jsonld → `image`).

## Install
Copy each block → paste into the page `<head>` (or type-gated global template) → test in [Google's Rich Results Test](https://search.google.com/test/rich-results) → submit to GSC if critical.
```

## Tips

- JSON-LD goes in `<head>` or top of `<body>`. Don't bury it.
- Test every generated block in [Google's Rich Results Test](https://search.google.com/test/rich-results) before shipping. The validation in step 3/6 follows the published spec but Google's actual test is authoritative.
- `references/google-rich-results.md` is dated. If it's >6 months old when you run this skill, flag staleness in the output and recommend the user verify against current docs.
- **Don't mark up content that isn't visibly on the page.** Google penalises hidden-content schema. If a page doesn't actually have FAQs visible, don't generate FAQPage schema.
- For Article schema, `image` is required. If the page has no obvious hero image, leave the `{REPLACE: hero image URL}` placeholder rather than guessing.
- The skill makes no DataForSEO calls unless step 7 (competitor benchmark) is requested — that calls `serp_organic_live_advanced` for the primary keyword. Firecrawl costs are separate: 1 credit for the target URL, +10 credits when step 7 runs.
- **Verify after deploy:** once the generated schema is pasted into your CMS and re-deployed, re-run this skill on the same URL — the new run's "Currently present" section reflects the live state and confirms the schema actually rendered (vs sitting in the CMS but not yet pushed). Ad-hoc alternative: invoke `seo-firecrawl` on the URL and grep `META.md` for the expected `@type`s.
