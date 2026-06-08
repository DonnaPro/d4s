# API Surface Map

The decision tree for "which DataForSEO tool category and which tool do I need". Pulled from the live MCP server's tool catalogue.

## Top-level split

DataForSEO exposes a single set of MCP tools authenticated via Basic Auth. All tools bill against API credits tied to the account. There is no separate "project API" — all tools are research/data oriented and require no prior account setup on the target domain.

## Tool categories

### SERP (~3 tools)

Real-time SERP results for any keyword and location.

- `serp_organic_live_advanced` — Google organic results for a keyword + location. Returns up to 100 results with rank, URL, title, snippet, featured snippets, PAA, etc.
- `serp_locations` — List valid location codes and location names for use in SERP tools.
- `serp_youtube_organic_live_advanced` — YouTube search results for a keyword.

**When to use:** User wants live SERP data for a keyword, competitor rank checks, SERP feature detection.

---

### DataForSEO Labs (~20 tools, prefix `dataforseo_labs_*`)

Historical and aggregated SEO intelligence on any domain or keyword. Does not require crawling — powered by DataForSEO's own index.

- **Domain-level:**
  - `dataforseo_labs_google_domain_rank_overview` — Traffic, keyword count, and organic metrics for a domain.
  - `dataforseo_labs_google_ranked_keywords` — All keywords a domain ranks for (paginated).
  - `dataforseo_labs_google_competitors_domain` — Competing domains by keyword overlap.
  - `dataforseo_labs_google_domain_intersection` — Shared keywords between two domains.
  - `dataforseo_labs_google_historical_rank_overview` — Domain-level traffic/keyword history over time.
  - `dataforseo_labs_google_relevant_pages` — Top pages on a domain by estimated traffic.
  - `dataforseo_labs_google_subdomains` — Traffic breakdown per subdomain.
  - `dataforseo_labs_google_serp_competitors` — Top-ranking competitors for a set of keywords.
  - `dataforseo_labs_google_keywords_for_site` — Keywords most associated with a domain.
  - `dataforseo_labs_google_historical_serps` — Historical SERP snapshots for a keyword.

- **Keyword-level:**
  - `dataforseo_labs_google_keyword_ideas` — Keyword ideas from a seed keyword.
  - `dataforseo_labs_google_keyword_suggestions` — Autocomplete-based keyword suggestions.
  - `dataforseo_labs_google_related_keywords` — Semantically related keywords.
  - `dataforseo_labs_google_keyword_overview` — Volume, KD, CPC, and SERP features for a keyword.
  - `dataforseo_labs_google_historical_keyword_data` — Historical volume and CPC for a keyword.
  - `dataforseo_labs_google_top_searches` — Top trending searches in a category/location.
  - `dataforseo_labs_google_page_intersection` — Keywords shared between multiple URLs.

- **Utility:**
  - `dataforseo_labs_search_intent` — Classify keywords by intent (informational, navigational, commercial, transactional).
  - `dataforseo_labs_bulk_keyword_difficulty` — KD scores for up to 1000 keywords in one call.
  - `dataforseo_labs_bulk_traffic_estimation` — Estimated organic traffic for a list of URLs.

**When to use:** Domain research, keyword research, competitor analysis, content gap analysis.

---

### Backlinks (~18 tools, prefix `backlinks_*`)

Backlink data for any domain, URL, or IP range.

- **Summary & overview:**
  - `backlinks_summary` — Total backlinks, referring domains, rank, spam score for a target.
  - `backlinks_domain_pages_summary` — Per-page backlink summary for a domain.
  - `backlinks_bulk_ranks` — Domain Authority-equivalent ranks for a list of domains.
  - `backlinks_bulk_spam_score` — Spam scores for a list of domains.
  - `backlinks_bulk_pages_summary` — Backlink summary for a list of pages.

- **Full lists:**
  - `backlinks_backlinks` — Full backlink list for a target (paginated).
  - `backlinks_bulk_backlinks` — Backlinks for multiple targets in one call.
  - `backlinks_referring_domains` — Referring domains list for a target.
  - `backlinks_bulk_referring_domains` — Referring domains for multiple targets.
  - `backlinks_referring_networks` — Referring IP networks/subnets.
  - `backlinks_domain_pages` — Pages on a domain sorted by inbound links.

- **New / lost:**
  - `backlinks_timeseries_summary` — Backlink count over time (timeseries).
  - `backlinks_timeseries_new_lost_summary` — New and lost backlinks timeseries.
  - `backlinks_bulk_new_lost_backlinks` — New/lost backlinks delta for multiple targets.
  - `backlinks_bulk_new_lost_referring_domains` — New/lost referring domains delta for multiple targets.

- **Competitive:**
  - `backlinks_competitors` — Domains competing for the same backlink sources.
  - `backlinks_domain_intersection` — Shared referring domains between two targets.
  - `backlinks_page_intersection` — Shared referring pages between multiple URLs.

- **Anchors:**
  - `backlinks_anchors` — Anchor text distribution for a target.

**When to use:** Link building prospecting, backlink audits, competitor link gap analysis, spam detection.

---

### On-Page (~3 tools, prefix `on_page_*`)

Crawl and audit any URL or set of pages on demand.

- `on_page_instant_pages` — Crawl a single URL and return on-page SEO signals (title, meta, headings, links, schema, Core Web Vitals hints, etc.).
- `on_page_lighthouse` — Run a Lighthouse audit on a URL (performance, accessibility, SEO, best practices scores).
- `on_page_content_parsing` — Parse and extract structured content from a URL (text, headings, links, images).

**When to use:** Technical SEO audits on a specific URL, content extraction, performance scoring.

---

### AI Optimization (~9 tools, prefix `ai_opt_*` / `ai_optimization_*`)

LLM-engine visibility — how brands and domains appear in ChatGPT and other AI search engines.

- **LLM mention tracking:**
  - `ai_opt_llm_ment_search` — Search for LLM mentions of a brand or keyword across AI engines.
  - `ai_opt_llm_ment_top_domains` — Top domains cited in AI engine responses for a topic.
  - `ai_opt_llm_ment_top_pages` — Top pages cited in AI engine responses.
  - `ai_opt_llm_ment_agg_metrics` — Aggregated mention metrics (visibility score, share of voice) for a domain.
  - `ai_opt_llm_ment_cross_agg_metrics` — Cross-engine comparison of mention metrics.

- **ChatGPT scraping:**
  - `ai_optimization_chat_gpt_scraper` — Submit a prompt to ChatGPT and return the response.
  - `ai_optimization_chat_gpt_scraper_locations` — Valid location options for ChatGPT scraper.
  - `ai_optimization_llm_response` — Get a response from a specified LLM for a prompt.

- **AI keyword data:**
  - `ai_optimization_keyword_data_search_volume` — Search volume data for AI-optimized keywords.
  - `ai_opt_kw_data_loc_and_lang` — Valid location and language combinations for AI keyword data.

**When to use:** GEO (generative engine optimization), brand visibility in AI search, AI answer tracking.

---

### Keyword Data (~5 tools, prefix `kw_data_*`)

Google Ads and Google Trends data for keywords.

- `kw_data_google_ads_search_volume` — Monthly search volume from Google Ads Keyword Planner.
- `kw_data_google_ads_locations` — Valid location codes for Google Ads keyword data.
- `kw_data_dfs_trends_explore` — DataForSEO Trends (Google Trends-equivalent) data for keywords.
- `kw_data_dfs_trends_subregion_interests` — Regional interest breakdown for a keyword trend.
- `kw_data_dfs_trends_demography` — Demographic interest breakdown for a keyword trend.
- `kw_data_google_trends_explore` — Google Trends data for a keyword (raw from Google).

**When to use:** Accurate search volume data, trending keyword detection, regional demand analysis.

---

### Business Data (~1 tool)

- `business_data_business_listings_search` — Search Google Business profiles / local listings for a query + location. Returns NAP data, categories, ratings, website.

**When to use:** Local SEO research, lead generation, citation auditing.

---

### Content Analysis (~3 tools, prefix `content_analysis_*`)

Analyse how a topic or keyword is covered across the web.

- `content_analysis_search` — Find pages mentioning a keyword, with metadata (date, author, domain authority, social shares).
- `content_analysis_summary` — Aggregated content metrics for a keyword (total mentions, top domains, avg word count).
- `content_analysis_phrase_trends` — Volume and trend data for phrases across web content over time.

**When to use:** Content gap research, PR monitoring, topical authority mapping.

---

### Domain Analytics (~2 tools, prefix `domain_analytics_*`)

Technology stack and WHOIS data.

- `domain_analytics_technologies_domain_technologies` — Tech stack detected on a domain (CMS, analytics, hosting, JS frameworks, etc.).
- `domain_analytics_whois_overview` — WHOIS registration data, registrar, expiry, nameservers.

**When to use:** Tech stack research, domain expiry monitoring, competitor tech profiling.

---

### Merchant / Amazon (~3 tools, prefix `merchant_amazon_*`)

Amazon product and seller data.

- `merchant_amazon_products_live_advanced` — Amazon product search results for a query.
- `merchant_amazon_asin_live_advanced` — Full product data for a specific ASIN.
- `merchant_amazon_sellers_live_advanced` — Sellers listing a specific product (by ASIN).
- `merchant_amazon_locations` — Valid location codes for Amazon data.

**When to use:** Amazon SEO research, product competitive analysis, marketplace intelligence.

---

## Quick decision tree

```
"I want live SERP results for a keyword"
  → serp_organic_live_advanced (+ serp_locations to resolve location code)

"I want to research a domain's organic performance"
  → dataforseo_labs_google_domain_rank_overview
  → dataforseo_labs_google_ranked_keywords (full keyword list)
  → dataforseo_labs_google_competitors_domain

"I want to research keywords"
  → dataforseo_labs_google_keyword_ideas / keyword_suggestions / related_keywords
  → dataforseo_labs_bulk_keyword_difficulty (score KD on the list)
  → kw_data_google_ads_search_volume (accurate volume)

"I want to audit a URL"
  → on_page_instant_pages (on-page signals)
  → on_page_lighthouse (performance + SEO scores)

"I want backlink data"
  → backlinks_summary (overview)
  → backlinks_backlinks (full list)
  → backlinks_competitors (link gap)

"I want to track brand visibility in AI engines"
  → ai_opt_llm_ment_search / ai_opt_llm_ment_agg_metrics
  → ai_optimization_chat_gpt_scraper (direct prompt testing)

"I want Amazon product data"
  → merchant_amazon_products_live_advanced (search)
  → merchant_amazon_asin_live_advanced (specific product)
```
