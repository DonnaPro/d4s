---
name: seo-ai-search-share-of-voice
description: Measure AI Search share of voice for a target domain/brand versus competitors across ChatGPT and Google AI Overviews (the two platforms DataForSEO LLM Mentions supports), using aggregated mention metrics plus sampled prompts, and analyse topic clusters each brand owns. Also runs a single-brand mentions monitor ("when, how often, and on which queries is my brand mentioned"). Domain-level; for one URL use seo-geo. Use when the user asks for AI Search share of voice, LLM visibility tracking, brand mentions in AI/ChatGPT, AEO analysis, AI Overview competitive analysis, or which brands LLMs cite in their category.
---

> Example output: [examples/seo-ai-search-share-of-voice-wix-com-20260427/REPORT.md](../../examples/seo-ai-search-share-of-voice-wix-com-20260427/REPORT.md)

# AI Search Share of Voice

Compare AI-search visibility for a target brand against competitors on the two platforms DataForSEO covers — `chat_gpt` and `google` (AI Overviews) — or monitor a single brand's LLM mentions over time. Never claim Perplexity/Gemini/AI Mode coverage; the data source does not include them.

## Prerequisites

- DataForSEO MCP server connected. LLM Mentions API is pay-as-you-go (no monthly minimum since 2026-07-01).
- Market defaults per `CLAUDE.md` (UK unless the user says otherwise).
- User provides: (a) target domain **and** brand name (both matter — pass the domain as `domain` and the brand as `keyword` targets), (b) for compare mode, competitor domains + brand names. If competitors are omitted, run **monitor mode** (single brand).
- Preflight per `skills/seo-firecrawl/references/preflight.md`. Typical calls: monitor mode ~4–6; compare mode ~6–10 (aggregate endpoints do most of the work — avoid per-domain sampling loops).

## Process

### Mode A — Monitor (single brand: "when / how often / on what queries is {brand} mentioned?")

1. **Aggregate footprint** `ai_opt_llm_ment_agg_metrics` — one call per platform (`chat_gpt`, then `google`), target array containing both `{domain: target.com}` and `{keyword: "{Brand}"}`. Capture mention counts and AI search volume.
2. **Which prompts/pages** `ai_opt_llm_ment_search` — one call per platform, same targets, `limit: 25`, ordered by `ai_search_volume,desc`. Save prompt/page text and cited sources verbatim to `evidence/`.
3. **Topic grouping** — group the returned prompts by theme (pricing, comparisons, tutorials, alternatives, reviews). No extra API calls.
4. Report when (recency fields where present), how often (aggregate counts per platform), and on which queries — plus the 5 highest-volume prompts the brand is *absent* from that it plausibly should own (from category-level queries in step 2, if visible).

### Mode B — Compare (target vs competitors)

1. **Cross-brand aggregates** `ai_opt_llm_ment_cross_agg_metrics` — one call per platform. `targets`: one entry per brand (`aggregation_key` = brand name; `target` = its domain + brand-name keyword). This single call yields the share-of-voice table per platform — do not reconstruct it from per-domain sampling.
2. **Leaderboard context** `ai_opt_llm_ment_top_domains` — one call for the category, to place the target among domains the user didn't list.
3. **Heatmap table** — rows = brands, columns = the two platforms, cells = share %. Highlight leader and worst performer.
4. **Prompt sampling** `ai_opt_llm_ment_search` — only for the target and the top competitor (not every domain), `limit: 15` per platform. Save query text + cited sources for validation.
5. **Topic clustering & gap synthesis** — group sampled prompts by theme; identify 3–5 clusters where the target underperforms despite relevant content; recommend actions (content angles, schema, comparison pages, citations from frequently-cited sources).

## Output format

Folder `output/seo-ai-search-share-of-voice-{target-slug}-{YYYYMMDD}/`:

```
├── evidence/                  # raw API payloads
├── 01-aggregates.md           # agg / cross-agg metrics per platform
├── 02-prompts-{brand}.md      # sampled prompts (sampled brands only)
├── 03-topic-clusters.md       # cluster membership per brand (compare mode)
└── REPORT.md                  # executive summary
```

`REPORT.md`: summary (target share, leader, rank), heatmap table (columns: **ChatGPT | Google AI Overviews** only), who-owns-what by cluster, top-5 actions. In monitor mode: mention counts per platform, top mentioned queries/pages, themes, absence gaps.

## Tips

- Do not hallucinate counts. Zero results = report zero. Small brands (like donnapro.com today) commonly have zero or near-zero LLM mentions — that is itself the finding; recommend a baseline re-run monthly and diff.
- Validate brand-name keyword matches in prompt text (e.g., "Donna" as a person's name is not a DonnaPro mention). Flag ambiguous matches in the evidence file.
- `base_domain` scope is the default; don't narrow to `subdomain` unless asked.
- Platforms are exactly `chat_gpt` and `google`. If the user asks about Perplexity/Gemini, say the data source doesn't cover them rather than substituting.
- Multi-market: run per `CLAUDE.md` reporting groups only on explicit request — each market multiplies the platform calls.
