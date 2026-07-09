# Integration Patterns

Five canonical recipes the `seo-api` skill draws from. Each one is ready to adapt — the skill adjusts variable names, target domains, and credentials but doesn't need to re-derive the shape.

## Pattern 1 — Domain competitive overview

**Goal:** Pull organic performance, top keywords, and direct competitors for any domain in one workflow.

**Tools used:** DataForSEO Labs.
**Credits:** Low — a few hundred credits total.

### MCP-tool-call sequence

```text
1. dataforseo_labs_google_domain_rank_overview   // traffic, KW count, organic metrics
2. dataforseo_labs_google_ranked_keywords        // top ranking keywords (page 1)
3. dataforseo_labs_google_competitors_domain     // top competing domains
4. dataforseo_labs_google_domain_intersection    // keyword overlap with top competitor
```

### Python skeleton

```python
import os, requests, base64

USERNAME = os.environ["DATAFORSEO_USERNAME"]
PASSWORD = os.environ["DATAFORSEO_PASSWORD"]
CREDS = base64.b64encode(f"{USERNAME}:{PASSWORD}".encode()).decode()
HEADERS = {"Authorization": f"Basic {CREDS}", "Content-Type": "application/json"}
BASE = "https://api.dataforseo.com/v3"

DOMAIN = "acme.com"
LOCATION = 2826  # United Kingdom (project default — see CLAUDE.md)
LANGUAGE = "en"

def post(path, payload):
    r = requests.post(f"{BASE}{path}", json=payload, headers=HEADERS)
    r.raise_for_status()
    return r.json()["tasks"][0]["result"]

overview = post("/dataforseo_labs/google/domain_rank_overview/live", [
    {"target": DOMAIN, "location_code": LOCATION, "language_code": LANGUAGE}
])

keywords = post("/dataforseo_labs/google/ranked_keywords/live", [
    {"target": DOMAIN, "location_code": LOCATION, "language_code": LANGUAGE, "limit": 100}
])

competitors = post("/dataforseo_labs/google/competitors_domain/live", [
    {"target": DOMAIN, "location_code": LOCATION, "language_code": LANGUAGE, "limit": 20}
])
```

### When to use

User says: "research domain X", "give me an overview of competitor Y", "what keywords does acme.com rank for".

### Variants

- **Historical view.** Add `dataforseo_labs_google_historical_rank_overview` to show traffic/keyword trends over time.
- **Page-level breakdown.** Use `dataforseo_labs_google_relevant_pages` to see which pages drive the most traffic.
- **Subdomain split.** Use `dataforseo_labs_google_subdomains` for large sites with significant subdomain traffic.

---

## Pattern 2 — Keyword research and clustering

**Goal:** Expand a set of seed keywords into a large list, score KD, get search volumes, classify by intent.

**Tools used:** DataForSEO Labs + Keyword Data.
**Credits:** Moderate — scales with keyword count.

### Sequence

```text
for each seed:
  dataforseo_labs_google_keyword_ideas          // broad expansion
  dataforseo_labs_google_related_keywords       // semantic relatives
  dataforseo_labs_google_keyword_suggestions    // autocomplete-based

dataforseo_labs_bulk_keyword_difficulty         // batch KD for the full merged list
kw_data_google_ads_search_volume               // accurate monthly volume
dataforseo_labs_search_intent                  // classify by intent
```

### Python skeleton

```python
import csv, itertools

SEEDS = ["seo software", "rank tracker", "keyword research tool"]
LOCATION = 2826  # United Kingdom (project default)
LANGUAGE = "en"

all_keywords = []

for seed in SEEDS:
    ideas = post("/dataforseo_labs/google/keyword_ideas/live", [
        {"keyword": seed, "location_code": LOCATION, "language_code": LANGUAGE, "limit": 200}
    ])
    related = post("/dataforseo_labs/google/related_keywords/live", [
        {"keyword": seed, "location_code": LOCATION, "language_code": LANGUAGE}
    ])
    all_keywords.extend(ideas or [])
    all_keywords.extend(related or [])

# Dedupe
unique_kws = list({item["keyword"]: item for item in all_keywords}.values())
kw_strings = [item["keyword"] for item in unique_kws]

# Batch KD (up to 1000 per call)
kd_results = post("/dataforseo_labs/google/bulk_keyword_difficulty/live", [
    {"keywords": kw_strings[:1000], "location_code": LOCATION, "language_code": LANGUAGE}
])

# Write CSV
with open("keywords.csv", "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=["keyword", "search_volume", "keyword_difficulty", "intent"])
    writer.writeheader()
    writer.writerows(unique_kws)
```

### When to use

User says: "expand these seeds", "build a keyword list for X", "I need 2000 keywords from 20 seeds", "what should we target for Y topic".

### Variants

- **Filter by KD.** Keep only `keyword_difficulty <= 30` for new domains.
- **Filter by intent.** Use `dataforseo_labs_search_intent` and keep `informational` + `commercial` for content strategy.
- **Volume accuracy.** Replace volume from Labs with `kw_data_google_ads_search_volume` for Google Ads-sourced figures.

---

## Pattern 3 — Backlink audit and gap analysis

**Goal:** Audit the backlink profile of a domain, compare against a competitor, find link gap opportunities.

**Tools used:** Backlinks tools.
**Credits:** Moderate — scales with domain size.

### Sequence

```text
1. backlinks_summary                          // total links, referring domains, rank, spam score
2. backlinks_referring_domains                // full referring domain list
3. backlinks_anchors                          // anchor text distribution
4. backlinks_timeseries_summary               // backlink growth over time
5. backlinks_competitors                      // domains with overlapping backlink sources
6. backlinks_domain_intersection              // shared referring domains with main competitor
```

### Python skeleton

```python
MY_DOMAIN = "acme.com"
COMPETITOR = "rival.com"

summary = post("/backlinks/summary/live", [{"target": MY_DOMAIN, "include_subdomains": True}])

ref_domains = post("/backlinks/referring_domains/live", [
    {"target": MY_DOMAIN, "limit": 1000, "order_by": ["rank,desc"]}
])

anchors = post("/backlinks/anchors/live", [
    {"target": MY_DOMAIN, "limit": 100}
])

intersection = post("/backlinks/domain_intersection/live", [
    {
        "targets": [MY_DOMAIN, COMPETITOR],
        "exclude_targets": [MY_DOMAIN],  # show only domains linking to competitor but not us
        "limit": 200
    }
])
```

### When to use

User says: "audit backlinks for X", "compare our links to competitor Y", "find link building opportunities", "check our spam score".

### Variants

- **Spam detection.** Use `backlinks_bulk_spam_score` on the full referring domain list to flag toxic links.
- **Delta tracking.** Use `backlinks_timeseries_new_lost_summary` to detect sudden drops (penalty signals) or spikes (competitor activity).
- **Bulk competitor scan.** Use `backlinks_bulk_ranks` to quickly benchmark domain authority for a list of prospects.

---

## Pattern 4 — AI visibility and GEO research

**Goal:** Track how a brand appears in AI engine answers (ChatGPT, etc.) and identify citation opportunities.

**Tools used:** AI Optimization tools.
**Credits:** Varies — ChatGPT scraper calls are metered per request.

### Sequence

```text
1. ai_opt_llm_ment_search                    // search for brand mentions across AI engines
2. ai_opt_llm_ment_agg_metrics               // visibility score, share of voice for a domain
3. ai_opt_llm_ment_top_domains               // top-cited domains for a topic (competitor benchmark)
4. ai_opt_llm_ment_top_pages                 // specific pages being cited
5. ai_optimization_chat_gpt_scraper          // directly test how ChatGPT answers a prompt
```

### Python skeleton

```python
BRAND = "acme"
TOPIC = "seo software"

mentions = post("/dataforseo/ai_optimization/llm_mentions/search/live", [
    {"keyword": BRAND, "location_code": 2826}
])

top_domains = post("/dataforseo/ai_optimization/llm_mentions/top_domains/live", [
    {"keyword": TOPIC, "location_code": 2826, "limit": 20}
])

# Test a specific prompt in ChatGPT
chatgpt_result = post("/dataforseo/ai_optimization/chat_gpt/scraper/live", [
    {"keyword": f"what is the best {TOPIC}", "location_code": 2826}
])
```

### When to use

User says: "does our brand appear in ChatGPT?", "which domains get cited for X topic", "track AI visibility", "GEO research for Y keyword", "test AI search answers".

### Variants

- **Cross-engine comparison.** Use `ai_opt_llm_ment_cross_agg_metrics` to compare visibility across multiple LLM engines.
- **Keyword-level AI volume.** Use `ai_optimization_keyword_data_search_volume` to find keywords with growing AI search volume.
- **Trend research.** Combine with `kw_data_dfs_trends_explore` to correlate AI citation growth with traditional search trends.

---

## Pattern 5 — On-page audit + Lighthouse for a URL list

**Goal:** Audit a list of URLs for on-page SEO issues and performance scores.

**Tools used:** On-Page tools.
**Credits:** Per-URL billing; Lighthouse is more expensive than instant_pages.

### Sequence

```text
for each URL:
  on_page_instant_pages          // on-page signals (title, meta, h1, links, schema)
  on_page_lighthouse             // performance + SEO + accessibility scores
merge results
output issue summary
```

### Python skeleton

```python
URLS = [
    "https://acme.com/",
    "https://acme.com/pricing",
    "https://acme.com/blog/seo-guide",
]

results = []
for url in URLS:
    page_data = post("/on_page/instant_pages/live", [
        {"url": url, "enable_javascript": True, "load_resources": True}
    ])
    lighthouse = post("/on_page/lighthouse/live", [
        {"url": url, "for_mobile": False}
    ])
    results.append({
        "url": url,
        "title": page_data[0].get("meta", {}).get("title"),
        "seo_score": lighthouse[0].get("categories", {}).get("seo", {}).get("score"),
        "performance_score": lighthouse[0].get("categories", {}).get("performance", {}).get("score"),
    })

# Print summary
for r in results:
    print(f"{r['url']} | SEO: {r['seo_score']} | Perf: {r['performance_score']}")
```

### When to use

User says: "audit these pages", "check the SEO score for X URL", "run Lighthouse on the site", "find on-page issues for Y".

### Variants

- **Content extraction.** Use `on_page_content_parsing` to extract structured text from URLs for content analysis or ingestion pipelines.
- **SERP comparison.** Pair with `serp_organic_live_advanced` to compare on-page signals of top-ranking pages vs. the user's page.

---

## Composing patterns

Real integrations chain these. Common compositions:

| Goal | Patterns chained |
|---|---|
| "Weekly competitive SEO report" | Pattern 1 (domain overview) + Pattern 3 (backlink delta) + `serp_organic_live_advanced` for key money keywords |
| "Content strategy for a new topic" | Pattern 2 (keyword research) → intent filter → `content_analysis_summary` for topical coverage gaps |
| "AI search competitive intelligence" | Pattern 4 (brand mentions + top domains) → content gap from top-cited pages |
| "Full site audit before launch" | Pattern 5 (per-URL audit) + `on_page_content_parsing` for all pages |
| "Link building prospecting" | Pattern 3 (intersection with competitor) → filter by domain rank → outreach CSV |

When the user's goal spans more than one pattern, the `seo-api` skill writes them all as numbered sections and emits separate code files per language for the combined flow.
