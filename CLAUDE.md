# DonnaPro SEO — Project Defaults

## Site
- Target domain: `donnapro.com`
- Brand name: `DonnaPro` (also match "Donna Pro" in mention analysis)

## Target markets and locations

Primary market (default when the user names no market): **United Kingdom** — `location_name: "United Kingdom"`, `location_code: 2826`, `language_code: en`. Never default to United States unless the user explicitly asks.

Full target-market list with DataForSEO codes:

| Market | location_name | location_code | Primary language |
|---|---|---|---|
| United Kingdom | United Kingdom | 2826 | en |
| Germany | Germany | 2276 | de |
| Switzerland | Switzerland | 2756 | de (also fr, it) |
| Austria | Austria | 2040 | de |
| Belgium | Belgium | 2056 | nl (also fr) |
| Denmark | Denmark | 2208 | da |
| Finland | Finland | 2246 | fi |
| France | France | 2250 | fr |
| Ireland | Ireland | 2372 | en |
| Italy | Italy | 2380 | it |
| Luxembourg | Luxembourg | 2442 | fr (also de) |
| Netherlands | Netherlands | 2528 | nl |
| Norway | Norway | 2578 | no |
| Spain | Spain | 2724 | es |
| Sweden | Sweden | 2752 | sv |
| USA | United States | 2840 | en |
| Canada | Canada | 2124 | en |
| Australia | Australia | 2036 | en |
| Dubai (UAE) | United Arab Emirates | 2784 | en |
| Global | see note below | — | en |

"Global": DataForSEO has no worldwide location for most endpoints. When a global view is requested, aggregate the reporting groups below (or run UK + US as proxies and label them as such — never present a single-country run as "global").

## Reporting groups (multi-market stats)

When the user asks for stats "across markets" or a market breakdown, report these groups separately:

- **Europe:** United Kingdom, Germany, Switzerland — each separate; all other European targets (AT, BE, DK, FI, FR, IE, IT, LU, NL, NO, ES, SE) combined as "Rest of Europe".
- **Rest of world:** USA, Canada, Australia — each separate. Dubai/UAE only when explicitly requested.

Before fanning a paid call out across many markets, confirm scope with the user — a full 7-bucket breakdown multiplies API cost ~7×.

## DataForSEO cost discipline

Applies to every skill; individual skills must not contradict these rules.

- **Pay-as-you-go, no minimums.** Since 2026-07-01 ALL DataForSEO APIs — including Backlinks and LLM Mentions (AI Optimization) — are pure pay-as-you-go with no monthly minimum. Do not warn about the old $100/month minimum; it no longer exists. Backlinks and LLM-mentions steps are first-class, not optional extras.
- **Always set `limit` and server-side `filters`** on Labs/Backlinks/LLM-mentions calls. Never pull thousands of rows to filter client-side.
- **Prefer purpose-built endpoints over manual fan-out:** `dataforseo_labs_google_domain_intersection` and `backlinks_domain_intersection` replace per-domain pulls + manual intersection; `backlinks_bulk_*` endpoints take many targets in one call.
- **Never repeat a paid call for data already returned or saved** in the run's evidence files. One `serp_organic_live_advanced` call returns organic results AND all SERP features — never re-call for features.
- **`on_page_instant_pages` is one URL per call** in this MCP setup (no batching). Sample accordingly.
- **Budget guard:** before any run estimated at more than ~10 paid calls, state the estimated call count and ask the user to confirm (default N). See `skills/seo-firecrawl/references/preflight.md`.
- Rate limit: 10 requests/second — pace loops sequentially.

## LLM mentions (brand visibility in AI search)

Supported platforms in this MCP: `chat_gpt` and `google` (AI Overviews) only — do not promise Perplexity/Gemini/AI Mode data. To answer "when / how often / on which queries is DonnaPro mentioned": use `ai_opt_llm_ment_agg_metrics` (how often, aggregated), `ai_opt_llm_ment_search` (which prompts/pages, with `limit` and filters), and `ai_opt_llm_ment_cross_agg_metrics` (DonnaPro vs competitors). Target both the domain `donnapro.com` and keyword `DonnaPro`.

## Output conventions

- Every skill run writes to `output/{skill}-{target-slug}-{YYYYMMDD}/` at the repo root (`output/` is git-ignored). Raw API payloads go in an `evidence/` subfolder; the human deliverable is `REPORT.md` (or the skill's named deliverable).
- Report templates live in each skill's `templates/` folder — load them only when writing the final deliverable.

## Environment notes

- Google APIs (GSC, GA4, PageSpeed…) are NOT configured on this machine — skills must use their degraded/DataForSEO-only paths and note it, never fail the run.
- Windows host: invoke helper scripts as `python E:\DonnaProSEO\scripts\<name>.py` (not `python3`, not relative paths).
- Finished articles for donnapro.com are delivered as WordPress-ready HTML using the `dp-` component system.
