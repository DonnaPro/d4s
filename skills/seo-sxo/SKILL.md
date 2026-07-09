---
name: seo-sxo
description: Diagnose why a page is not ranking by reading the SERP backwards. Identifies the page type Google rewards for the target keyword, scores the candidate page against that pattern from multiple persona perspectives, and recommends the page format that would win the SERP. Use when the user asks "why isn't this page ranking", "page type mismatch", "SXO", "search experience optimization", "intent mismatch", or wants a wireframe.
---

> Example output: [examples/seo-sxo-bigin-com-20260514/SXO-REPORT.md](../../examples/seo-sxo-bigin-com-20260514/SXO-REPORT.md)

# SEO SXO — Search Experience Optimization

Diagnose why a "well-optimized" page doesn't rank. Reads the actual SERP for the target keyword, infers the page type Google is rewarding, scores the candidate page against that pattern from multiple persona perspectives, and recommends the page format that would win the SERP.

> **Acknowledgements:** SXO-as-a-skill framework originated in `claude-seo` by AgriciDaniel (with the original concept credited to Florian Schmitz, Pro Hub Challenge). MIT-licensed both directions; this implementation is independent but the framing is theirs.

## Prerequisites

- DataForSEO MCP server connected.
- Claude's `WebFetch` tool available.
- User provides: (a) target page URL, (b) target keyword the page is meant to rank for. Market: per `CLAUDE.md` defaults (UK unless the user specifies another market).

## Process

1. **Validate inputs.** Both URL and keyword are required. If keyword missing, ask the user — don't infer.

2. **Pull the SERP** — one `serp_organic_live_advanced` call
   - This single call returns the top organic results (URL, title, snippet) **and** all SERP features — AI Overview, People Also Ask, image/video carousels, shopping pack, Twitter pack, Featured Snippet — in the `items` array. Parse `items` by `type` to extract features. Never re-call for feature data you already received.
   - **Insufficient-SERP guard:** if fewer than 5 organic results come back, flag `insufficient SERP data` in `SXO-REPORT.md` and do NOT compute a dominant pattern (too few results to classify reliably). Report the organic count and stop the pattern analysis; persona scoring of the user's page may still run as a caveated partial.

3. **Extract AIO context from SERP results**
   - Check `serp_organic_live_advanced` result items for `type: "ai_overview"` entries.
   - If AIO is present, capture the answer text and citation list.
   - Note which top-10 organic results are also cited in the AIO.

4. **Fetch user's page + top 3 winners** `WebFetch` (always) + `mcp__firecrawl-mcp__firecrawl_scrape` (when available)
   - **WebFetch first** (free): pull markdown for the user's page + top 3 winners. Extract `<title>`, all H-tags, primary content structure (numbered list / table / prose / Q&A), word count, image mentions, comparison-table presence, CTA mentions.
   - **Firecrawl second** (4 Firecrawl credits typical — 1 per page) — recovers what WebFetch can't show:
     - JSON-LD `@type`s per page (Product, FAQPage, BreadcrumbList, Article, Review, ItemList, etc.) — these are **load-bearing** for page-type classification in step 5. WebFetch's markdown can't see schema.
     - `og:title` / `og:image` / `twitter:card` from `metadata`.
     - Real `<title>` length (the markdown first-heading is sometimes wrong).
   - **`--screenshots` flag (opt-in, +4 Firecrawl credits):** when passed, also call `firecrawl_scrape` with `formats: ["screenshot"]` on the user's page + top 3 winners. Save as `screenshots/{page}.png`. Reference in the wireframe (step 8) to ground recommendations in the visual layout, not just the text outline.
   - **If Firecrawl unavailable (or `--no-firecrawl` passed):** WebFetch portion runs. Page-type classification in step 5 falls back to URL/title heuristics + content-structure heuristics only — schema-based classification is skipped. Note in `02-page-type-classification.md`: `Schema-based classification: skipped — Firecrawl required.` Confidence in dominant-pattern detection drops accordingly.

5. **Classify each top-10 result by page type**
   - Use the heuristics in `references/page-type-patterns.md`.
   - For each: assign one of {comparison, alternatives, listicle, how-to, definition, product, editorial, forum, video}.
   - Note signals that informed the classification (URL pattern, title pattern, schema, content structure).

6. **Detect the dominant pattern**
   - Count types in top 10. If one type ≥ 6, that's dominant.
   - If two tie at 4–4, the SERP is "split intent" — both work; commercial vs informational angle determines which to choose.
   - Cross-reference with SERP features: video carousel → expect ≥ 2 video results; PAA → expect informational results; shopping pack → commercial intent dominant; AIO → informational consensus.

7. **Score the user's page** against the dominant pattern × 4 personas
   - Use the rubrics in `references/persona-rubrics.md`.
   - 4 personas: Skimmer, Researcher, Buyer, Validator.
   - 0–10 per persona. Apply the intent-weighting profile (also in persona-rubrics.md) to get a single 0–100 SXO score.

8. **Synthesise verdict and wireframe**
   - If user's page type matches dominant: SXO score reflects how well it executes the pattern. Recommend specific persona-targeted improvements.
   - If user's page type does NOT match dominant: this is the "page-type mismatch" case. Output a wireframe for the dominant page type, anchored in observed patterns from the top 3 winners.
   - Write `SXO-REPORT.md`.

## Output format

Create a folder `output/seo-sxo-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-sxo-{target-slug}-{YYYYMMDD}/
├── 01-serp-snapshot.md            (top 10 + features + AIO)
├── 02-page-type-classification.md (each top-10 result classified)
├── 03-user-page-fingerprint.md    (the candidate page's structure)
├── 04-persona-scores.md           (4 personas × current page)
├── 05-recommendation.md           (verdict + page-type-winning wireframe)
├── screenshots/                   (only if --screenshots ran: candidate.png + winner-1/2/3.png)
└── SXO-REPORT.md                  (executive summary deliverable)
```

`SXO-REPORT.md` structure: SERP profile (page-type counts, dominant pattern, features, intent) → Your page (detected type, match/mismatch, structure) → SXO score /100 with the 4-persona table → Verdict paragraph → MISMATCH wireframe *or* MATCH top-3 persona changes → Raw data pointers. Load `templates/report.md` for the full mock (including the wireframe block) when writing the deliverable.

## Tips

- Respect DataForSEO API rate limits (10 req/s). The single SERP call in step 2 is the primary API call; WebFetch calls in step 4 dominate latency.
- Page-type classification is a heuristic — `references/page-type-patterns.md` documents the signals so users can override. If the heuristic gets a result wrong, edit that file with the correction.
- The 4 personas are opinionated. They come from the framework's original source — don't invent more without good reason.
- The SXO score is directional. An 85/100 doesn't guarantee ranking; a 35/100 strongly suggests the page won't break through. Treat as a diagnostic, not a forecast.
- When the dominant pattern is split-intent (4-4), ship two pages — one per intent — rather than trying to make one page serve both. Google's SERPs reflect this split for a reason.
- The wireframe in MISMATCH mode is a starting point. The user still needs to write the content. This skill diagnoses; `seo-content-brief` produces the writer-ready brief.
