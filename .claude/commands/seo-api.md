---
name: seo-api
description: DataForSEO API integration guide for developers. Covers the full DataForSEO MCP surface — SERP, DataForSEO Labs (keyword research, domain analysis, competitor research), Backlinks, On-Page, AI Optimization (LLM mentions, ChatGPT scraper), Keyword Data, Business Data, Content Analysis, Domain Analytics, YouTube SERP, and Merchant. For any "how do I…" question about tools, parameters, JSON schemas, rate limits, or authentication. Produces ready-to-paste cURL / Python / TypeScript / MCP-tool-call recipes for common workflows. Distinct from the other SEO skills which produce analysis deliverables (briefs, audits, reports); seo-api produces integration recipes. Use when the user asks "how do I use DataForSEO to do X", "what tool gives me Y", "build a rank tracker", "pull backlinks into BigQuery", "cURL / Python / TypeScript for DataForSEO", "what's the rate limit", "integrate DataForSEO with n8n / Make / Looker", or any direct question about tools, parameters, schemas, or wiring up DataForSEO data pipelines.
---

# DataForSEO API Integration Guide

Help developers ship real integrations against the DataForSEO API via the DataForSEO MCP server. The deliverable is a **code recipe** (ready-to-paste cURL / Python / TypeScript / MCP-tool-call sequence) covering authentication, tool selection, parameter patterns, and retry strategy.

## Prerequisites

- **DataForSEO MCP server connected.** Authentication is handled via `DATAFORSEO_USERNAME` and `DATAFORSEO_PASSWORD` environment variables — the MCP server injects HTTP Basic Auth on every request. No OAuth, no per-call token management.
- **(Optional) `WebFetch`** for fetching deep reference docs at `docs.dataforseo.com` when the request needs prose beyond the tool schema.
- User provides: an integration goal in plain language (e.g., "pull ranked keywords for a domain", "get backlink summary for these 50 domains weekly", "check LLM mentions for my brand"). The skill interviews only when the goal is ambiguous.

## Authentication

DataForSEO uses **HTTP Basic Auth**. Every API call carries a `Base64(username:password)` Authorization header.

```bash
# cURL
curl -u "$DATAFORSEO_USERNAME:$DATAFORSEO_PASSWORD" \
  "https://api.dataforseo.com/v3/dataforseo_labs/google/domain_rank_overview/live" \
  -H "Content-Type: application/json" \
  -d '[{"target": "example.com", "language_code": "en", "location_code": 2840}]'
```

```python
# Python
import requests, base64, os

auth = (os.environ["DATAFORSEO_USERNAME"], os.environ["DATAFORSEO_PASSWORD"])
r = requests.post(
    "https://api.dataforseo.com/v3/dataforseo_labs/google/domain_rank_overview/live",
    auth=auth,
    json=[{"target": "example.com", "language_code": "en", "location_code": 2840}]
)
```

```typescript
// TypeScript
const auth = Buffer.from(`${process.env.DATAFORSEO_USERNAME}:${process.env.DATAFORSEO_PASSWORD}`).toString("base64");
const res = await fetch("https://api.dataforseo.com/v3/dataforseo_labs/google/domain_rank_overview/live", {
  method: "POST",
  headers: { Authorization: `Basic ${auth}`, "Content-Type": "application/json" },
  body: JSON.stringify([{ target: "example.com", language_code: "en", location_code: 2840 }])
});
```

Via MCP: the server reads `DATAFORSEO_USERNAME` / `DATAFORSEO_PASSWORD` from the environment — no auth parameters are passed in tool calls.

## Tool Surface

### SERP
| MCP tool | What it returns |
|---|---|
| `serp_organic_live_advanced` | Live Google organic SERP for a keyword — positions, titles, snippets, URLs, SERP features |
| `serp_locations` | Available location codes for SERP queries |
| `serp_youtube_organic_live_advanced` | Live YouTube SERP for a keyword |
| `serp_youtube_locations` | Available location codes for YouTube SERP |

### DataForSEO Labs
| MCP tool | What it returns |
|---|---|
| `dataforseo_labs_google_domain_rank_overview` | Domain-level traffic estimates, keyword counts, ETV, backlink metrics |
| `dataforseo_labs_google_ranked_keywords` | All keywords a domain ranks for, with positions, search volume, CPC |
| `dataforseo_labs_google_competitors_domain` | Competitor domains ranked for similar keywords |
| `dataforseo_labs_google_domain_intersection` | Keywords two or more domains share |
| `dataforseo_labs_google_keyword_ideas` | Keyword ideas from a seed list |
| `dataforseo_labs_google_keyword_suggestions` | Keyword suggestions for a seed keyword |
| `dataforseo_labs_google_related_keywords` | Related keywords for a seed keyword |
| `dataforseo_labs_google_historical_rank_overview` | Monthly domain rank history |
| `dataforseo_labs_google_historical_keyword_data` | Monthly keyword metrics history (volume, CPC, competition) |
| `dataforseo_labs_google_historical_serps` | Historical SERP snapshots for a keyword |
| `dataforseo_labs_google_relevant_pages` | Pages from a domain that Google has indexed |
| `dataforseo_labs_google_subdomains` | Subdomain traffic breakdown for a domain |
| `dataforseo_labs_google_serp_competitors` | Domains competing on the same SERP for a keyword |
| `dataforseo_labs_google_page_intersection` | Keywords where specific URLs intersect on the SERP |
| `dataforseo_labs_google_keywords_for_site` | Keywords driving traffic to a domain (similar to ranked_keywords but broader) |
| `dataforseo_labs_google_top_searches` | Top trending searches for a location/category |
| `dataforseo_labs_search_intent` | Search intent classification (informational / transactional / navigational / commercial) for a keyword list |
| `dataforseo_labs_bulk_keyword_difficulty` | Keyword difficulty scores in bulk |
| `dataforseo_labs_bulk_traffic_estimation` | Estimated traffic for a list of domains |

### Backlinks
| MCP tool | What it returns |
|---|---|
| `backlinks_summary` | Domain-level backlink metrics: referring domains, total backlinks, spam score, ranks |
| `backlinks_referring_domains` | Referring domain list with domain authority, anchor counts, link types |
| `backlinks_anchors` | Top anchor text distribution for a domain |
| `backlinks_bulk_ranks` | Domain Authority / Page Authority equivalents for a list of domains |
| `backlinks_bulk_backlinks` | Backlink counts for a list of domains in one call |
| `backlinks_bulk_new_lost_referring_domains` | New and lost referring domains in bulk |
| `backlinks_bulk_referring_domains` | Referring domain counts in bulk |
| `backlinks_bulk_spam_score` | Spam scores for a list of domains |
| `backlinks_bulk_pages_summary` | Page-level backlink metrics in bulk |
| `backlinks_referring_networks` | Referring IP and ASN networks |
| `backlinks_timeseries_summary` | Monthly trend of backlinks and referring domains |
| `backlinks_timeseries_new_lost_summary` | Monthly new vs. lost backlinks and referring domains trend |
| `backlinks_backlinks` | Full backlink list with source/target URLs, anchor, link type, first/last seen |
| `backlinks_competitors` | Domains that share backlink sources with the target |
| `backlinks_domain_pages` | Page-level backlink breakdown for a domain |
| `backlinks_domain_pages_summary` | Summary of pages with backlinks |
| `backlinks_domain_intersection` | Shared referring domains across multiple targets |
| `backlinks_page_intersection` | Referring domains pointing to multiple specific pages |
| `backlinks_available_filters` | Available filter fields for backlinks queries |

### On-Page
| MCP tool | What it returns |
|---|---|
| `on_page_instant_pages` | On-page audit of specific URLs — HTTP status, canonicalization, title, meta description, headings, links, Core Web Vitals signals |
| `on_page_lighthouse` | Full Lighthouse audit for a URL (performance, accessibility, SEO, best practices scores) |
| `on_page_content_parsing` | Parsed page content: clean text, structured data, links, headings |

### AI Optimization (LLM Mentions & AI Search)
| MCP tool | What it returns |
|---|---|
| `ai_opt_llm_ment_search` | Search LLM mentions for a brand, keyword, or domain across AI models |
| `ai_opt_llm_ment_top_domains` | Domains most frequently cited by LLMs for a topic |
| `ai_opt_llm_ment_agg_metrics` | Aggregated LLM mention metrics (mention rate, sentiment, share of voice) |
| `ai_opt_llm_ment_top_pages` | Specific pages most cited by LLMs for a topic |
| `ai_opt_llm_ment_loc_and_lang` | Location and language options for LLM mentions queries |
| `ai_opt_llm_ment_cross_agg_metrics` | Cross-model aggregated LLM mention metrics |
| `ai_optimization_chat_gpt_scraper` | Live ChatGPT responses scraped for a query — returns what ChatGPT says and which sources it cites |
| `ai_optimization_chat_gpt_scraper_locations` | Location options for ChatGPT scraper |
| `ai_optimization_llm_response` | LLM response for a prompt from a specified model |
| `ai_optimization_keyword_data_search_volume` | Search volume for AI-related keyword queries |
| `ai_optimization_llm_mentions_filters` | Available filter fields for LLM mentions |
| `ai_optimization_llm_models` | List of AI models tracked for LLM mention analysis |

### Keyword Data
| MCP tool | What it returns |
|---|---|
| `kw_data_google_ads_search_volume` | Google Ads search volume, CPC, competition for keyword lists |
| `kw_data_google_ads_locations` | Location codes for Google Ads keyword data |
| `kw_data_dfs_trends_explore` | DataForSEO Trends: keyword interest over time |
| `kw_data_dfs_trends_subregion_interests` | Regional interest breakdown for a keyword |
| `kw_data_dfs_trends_demography` | Demographic interest breakdown for a keyword |
| `kw_data_google_trends_explore` | Google Trends interest data for keywords |
| `kw_data_google_trends_categories` | Category list for Google Trends queries |

### Business Data
| MCP tool | What it returns |
|---|---|
| `business_data_business_listings_search` | Local business listings from Google Maps / Business Profiles |

### Content Analysis
| MCP tool | What it returns |
|---|---|
| `content_analysis_search` | Pages on the web mentioning a phrase or brand |
| `content_analysis_summary` | Summary metrics for content mentioning a phrase (domain count, sentiment, traffic estimates) |
| `content_analysis_phrase_trends` | Trend over time for how often a phrase is mentioned across the web |

### Domain Analytics
| MCP tool | What it returns |
|---|---|
| `domain_analytics_technologies_domain_technologies` | Technologies detected on a domain (CMS, analytics, CDN, etc.) |
| `domain_analytics_technologies_available_filters` | Filter options for technology queries |
| `domain_analytics_whois_overview` | WHOIS data for a domain (registrar, expiry, registrant) |
| `domain_analytics_whois_available_filters` | Filter options for WHOIS queries |

### YouTube SERP
| MCP tool | What it returns |
|---|---|
| `serp_youtube_organic_live_advanced` | Live YouTube SERP — video titles, channels, view counts, publish dates |
| `serp_youtube_video_info_live_advanced` | Detailed metadata for a specific YouTube video |
| `serp_youtube_video_comments_live_advanced` | Comments for a YouTube video |
| `serp_youtube_video_subtitles_live_advanced` | Subtitles/transcript for a YouTube video |

### Merchant
| MCP tool | What it returns |
|---|---|
| `merchant_amazon_asin_live_advanced` | Full product details for an Amazon ASIN |
| `merchant_amazon_products_live_advanced` | Amazon product SERP for a search query |
| `merchant_amazon_sellers_live_advanced` | Amazon seller listings for a product |
| `merchant_amazon_locations` | Location codes for Amazon queries |

## Key Integration Patterns

### Domain Overview
Combine domain-level signals into a single view:
1. `dataforseo_labs_google_domain_rank_overview` — traffic, keyword count, ETV, overall ranks
2. `dataforseo_labs_google_ranked_keywords` — full keyword portfolio with positions
3. `backlinks_summary` — referring domains, total links, spam score
4. `dataforseo_labs_google_competitors_domain` — who else competes for the same keyword set

```python
# Domain overview pipeline
domain = "example.com"
location_code = 2840  # US
language_code = "en"

overview = post("/dataforseo_labs/google/domain_rank_overview/live",
    [{"target": domain, "location_code": location_code, "language_code": language_code}])

keywords = post("/dataforseo_labs/google/ranked_keywords/live",
    [{"target": domain, "location_code": location_code, "language_code": language_code, "limit": 1000}])

backlinks = post("/backlinks/summary/live",
    [{"target": domain, "target_type": "domain"}])
```

### Keyword Research
Fan out from a seed term to a full keyword universe:
1. `dataforseo_labs_google_keyword_ideas` — broad related ideas from a seed list
2. `dataforseo_labs_google_keyword_suggestions` — completions and variations
3. `dataforseo_labs_google_related_keywords` — semantically related terms
4. `dataforseo_labs_search_intent` — classify the intent of each keyword before using them
5. `dataforseo_labs_bulk_keyword_difficulty` — score difficulty in bulk before prioritising

### Technical URL Audit
Audit specific URLs without project setup (fully on-demand):
1. Firecrawl `firecrawl_map` — discover all URLs on the site via crawl
2. `on_page_instant_pages` — audit discovered URLs in batches (up to 100 per call) for status, canonicals, meta, headings
3. `on_page_lighthouse` — deep Lighthouse scores for priority URLs (performance, SEO, accessibility)

### Competitive Backlink Analysis
1. `dataforseo_labs_google_competitors_domain` — find main competitors
2. `backlinks_domain_intersection` — shared referring domains between target and competitors
3. `backlinks_competitors` — domains sharing backlink sources with the target (link gap)
4. `backlinks_timeseries_summary` — trend history to spot link building velocity

### AI Search Share of Voice
1. `ai_opt_llm_ment_search` — does the brand appear in LLM responses?
2. `ai_opt_llm_ment_top_domains` — which domains does the LLM cite most for this topic?
3. `ai_opt_llm_ment_agg_metrics` — share of voice, mention rate, sentiment
4. `ai_optimization_chat_gpt_scraper` — what does ChatGPT actually say and which sources does it cite?

### SERP Feature & Ranking Research
1. `serp_locations` — resolve location code for the target market
2. `serp_organic_live_advanced` — live SERP snapshot with all SERP features, positions, and featured snippets
3. `dataforseo_labs_google_serp_competitors` — who else appears on this SERP

## Rate Limits

DataForSEO rate limits vary by endpoint and plan tier. General guidance:

- **Default concurrency:** process requests sequentially or in small batches (≤3 concurrent). Do not fan out hundreds of parallel calls.
- **Batch endpoints:** prefer bulk tools (`backlinks_bulk_ranks`, `dataforseo_labs_bulk_keyword_difficulty`, `on_page_instant_pages` with multiple URLs) over per-URL loops.
- **429 handling:** exponential backoff with jitter — 1s → 2s → 4s → 8s (±20% jitter). Retry up to 5 times.
- **5xx handling:** same backoff as 429. Treat 2-consecutive 5xx as a likely transient outage; wait 30s before resuming.
- **No project management:** DataForSEO has no project-based rank tracking or audit scheduling via MCP. All analysis is on-demand. For recurring workflows, schedule the tool calls externally (cron, n8n, Make).

```python
import time, random

def call_with_retry(fn, *args, max_retries=5, **kwargs):
    delay = 1.0
    for attempt in range(max_retries):
        try:
            return fn(*args, **kwargs)
        except RateLimitError:
            if attempt == max_retries - 1:
                raise
            time.sleep(delay + random.uniform(-delay * 0.2, delay * 0.2))
            delay = min(delay * 2, 60)
```

## Process

1. **Clarify the goal.** Ask 1–3 questions only if the goal is ambiguous. Skip when the user already spelled it out. Useful follow-ups:
   - "Is this a one-off run, a recurring job (daily/weekly), or a long-lived integration?"
   - "Target country / language / device — or worldwide?"
   - "Which domains or keywords are the starting point?"

2. **Map goal to tools.** Identify the tool sequence from the surface map above. For every step, note:
   - The MCP tool name.
   - The underlying REST endpoint (e.g., `POST /v3/dataforseo_labs/google/ranked_keywords/live`).
   - Key required parameters: `target`, `location_code`, `language_code`, `limit`.
   - Whether a prerequisite lookup is needed (e.g., `serp_locations` to resolve a location code by name).

3. **Pick execution mode.** Confirm with the user:
   - **Code mode** — emit ready-to-paste cURL, Python, TypeScript, and MCP-tool-call variants. Default for recurring jobs and anything the developer wants to own.
   - **Live mode** — run the tool calls now and return the data. Default for one-off research questions in the conversation.
   - **Hybrid** — run a quick live lookup (e.g., resolve location codes, confirm the domain has data), then emit code for the full workflow.

4. **Execute or emit** → synthesise `RECIPE.md`.

## Output format

Folder `seo-api-{slug}-{YYYYMMDD}/` where `{slug}` is a kebab-case summary of the goal.

```
seo-api-{slug}-{YYYYMMDD}/
├── RECIPE.md                       (primary deliverable)
├── code/
│   ├── curl.sh                     (cURL one-liners + multi-step bash)
│   ├── python.py                   (idiomatic requests-based script)
│   ├── typescript.ts               (fetch-based script)
│   └── mcp-calls.md                (MCP-tool-call sequence)
└── evidence/
    ├── 01-preflight.md             (MCP connectivity check, location/language codes resolved)
    └── 02-execution-log.md         (every tool call run in live mode, with args + status — omit in pure code mode)
```

`RECIPE.md` follows this shape:

```markdown
# {Integration Title}: {target}

> Run dated {YYYY-MM-DD} · Mode: {code | live | hybrid}

## Goal

{1–2 sentences. What was asked, what's being shipped.}

## Tool map

| Step | MCP tool | REST endpoint | Key parameters |
|------|----------|---------------|----------------|
| 1    | `dataforseo_labs_google_domain_rank_overview` | `POST /v3/dataforseo_labs/google/domain_rank_overview/live` | target, location_code, language_code |
| ...  | ... | ... | ... |

## Auth & setup

{Show the Basic Auth pattern for cURL / Python / TypeScript. Reference the DATAFORSEO_USERNAME / DATAFORSEO_PASSWORD env vars.}

## Recipe

### Option A — cURL
(see `code/curl.sh`)

### Option B — Python
(see `code/python.py`)

### Option C — TypeScript
(see `code/typescript.ts`)

### Option D — MCP tool calls
(see `code/mcp-calls.md`)

## Rate limit & retry strategy

- Batch where possible using bulk endpoints.
- 429: exponential backoff (1s → 2s → 4s → 8s ±20% jitter), max 5 retries.
- 5xx: same backoff. Two consecutive 5xx → pause 30s.
- No project management via MCP — schedule recurring runs externally.

## What you still need to do

{Concrete next steps. E.g., "Run python.py daily via cron at 06:00 UTC", "Store results in your data warehouse", "Wire the output into your reporting dashboard".}

## When to escalate to another skill

- `seo-content-brief` — turn keyword research into editor briefs.
- `seo-page` — evaluate a specific URL.
- `seo-drift baseline` — snapshot a domain before the integration starts running.
- `seo-technical-audit` — interpret on-page audit output.
- `seo-ai-search-share-of-voice` — competitive read on LLM visibility.
```

## Tips

- **No project setup required.** Every DataForSEO tool works on-demand against any domain or keyword — there is no concept of "creating a project" or "registering a domain" before querying.
- **location_code is required for most Labs and SERP tools.** Use `serp_locations` or `kw_data_google_ads_locations` to resolve a country name to its integer code (e.g., US = 2840). Hardcode common codes in your scripts; don't look them up on every run.
- **language_code is usually a two-letter string** (e.g., `"en"`, `"de"`, `"fr"`). Check tool schemas for the exact format — a few endpoints use `language_name` instead.
- **Bulk over loops.** `on_page_instant_pages` accepts up to 100 URLs per call. `backlinks_bulk_ranks` accepts up to 1000 domains. Always batch rather than issuing one call per item.
- **Failed requests don't consume credits** on most DataForSEO endpoints. Don't over-engineer retry logic for 4xx responses from bad input — fix the input instead.
- **Large result sets.** For `dataforseo_labs_google_ranked_keywords` on high-traffic domains, the full keyword list can be thousands of rows. Use `limit` and `offset` for pagination, or use the async task endpoints (POST task, GET result) for very large exports.
- **MCP tool descriptions carry the input schema.** Check the tool description for required vs. optional fields before calling. The descriptions do not carry per-call pricing — consult `docs.dataforseo.com` for cost details.
- **WebFetch for deep docs.** If a tool's schema alone doesn't answer the question (e.g., "what does `ranked_serp_element` mean in the response?"), fetch `https://docs.dataforseo.com/v3/dataforseo_labs/google/ranked_keywords/live/` for the full response schema with field descriptions.

## Works well with

- **Predecessors:** none — entry point for any DataForSEO integration question.
- **Successors (when the integration starts producing data):**
  - `seo-content-brief` — keyword data → editor briefs.
  - `seo-page` — individual URL analysis and keep/refresh/consolidate/kill decisions.
  - `seo-drift baseline` — snapshot before the integration starts, so regressions are detectable.
  - `seo-technical-audit` — interpret on-page audit findings.
  - `seo-ai-search-share-of-voice` — LLM visibility and competitive AI search analysis.
