---
name: seo-google
description: The Google first-party data access layer for this SEO catalogue. Direct, authenticated access to Google's own data via Search Console (Search Analytics, URL Inspection, Sitemaps), PageSpeed Insights v5, CrUX field data with 25-week history, Indexing API v3, GA4 organic traffic, YouTube video search, Google NLP entity/sentiment analysis, Knowledge Graph entity verification, Web Risk safety, and Google Ads Keyword Planner. Where the crawl-based skills estimate, this skill returns Google's real measured data — actual Chrome user metrics, real indexation status, real search performance, real organic traffic. Use when the user asks "search console", "GSC", "PageSpeed", "CrUX", "field data", "indexing API", "GA4 organic", "URL inspection", "google api setup", "impressions", "clicks", "CTR", "position data", "youtube SEO", "knowledge graph", "keyword planner", or "real google data".
---

> Example output: [examples/seo-google-quickstart-20260514/README.md](../../examples/seo-google-quickstart-20260514/README.md)

# Google SEO APIs

Direct access to Google's own SEO data. Bridges the gap between crawl-based analysis (the rest of the catalogue) and Google's real-time field data: actual Chrome user metrics, real indexation status, search performance, and organic traffic.

All APIs are free. Setup requires a Google Cloud project with API key and/or service account — run the `setup` command for step-by-step instructions, or read `references/auth-setup.md` directly.

> **Adapted from [`AgriciDaniel/claude-seo`](https://github.com/AgriciDaniel/claude-seo)'s `seo-google` skill** (MIT). Scripts, references, and command surface mirror the upstream implementation. Config path namespaced to `~/.config/seo-skills/` for clean coexistence with the original.

## Prerequisites

- **Required:** Python 3.10+ and the Google API client libraries. Install via `bash extensions/google/install.sh`.
- **Required:** at minimum a Google API key (Tier 0). For full coverage, also a Google Cloud service account (Tier 1+) and optionally a GA4 property ID (Tier 2) and Google Ads developer token (Tier 3).
- Config file: `~/.config/seo-skills/google-api.json`.

Before executing any command, check credentials:

```bash
python E:\DonnaProSEO\scripts\google_auth.py --check --json
```

Config file shape (`~/.config/seo-skills/google-api.json`):

```json
{
  "service_account_path": "/path/to/service_account.json",
  "api_key": "AIzaSy...",
  "default_property": "sc-domain:example.com",
  "ga4_property_id": "properties/123456789"
}
```

If missing, read `references/auth-setup.md` and walk the user through setup.

### Credential Tiers

| Tier | Detection | Available Commands |
|------|-----------|-------------------|
| **0** (API Key) | `api_key` present | `pagespeed`, `crux`, `crux-history`, `youtube`, `nlp`, `entity`, `safety` |
| **1** (OAuth/SA) | + OAuth token or service account | Tier 0 + `gsc`, `inspect`, `sitemaps`, `index` |
| **2** (Full) | + `ga4_property_id` configured | Tier 1 + `ga4`, `ga4-pages`, `ga4-referrals`, `ga4-channel-mix`, `ga4-properties` |
| **3** (Ads) | + `ads_developer_token` + `ads_customer_id` | Tier 2 + `keywords`, `volume` |

Always communicate the detected tier before running commands.

## Quick Reference

| Command | What it does | Tier |
|---------|-------------|------|
| `setup` | Check/configure API credentials | -- |
| `pagespeed <url>` | PSI Lighthouse + CrUX field data | 0 |
| `crux <url>` | CrUX field data only (p75 metrics) | 0 |
| `crux-history <url>` | 25-week CWV trend analysis | 0 |
| `gsc <property>` | Search Console: clicks, impressions, CTR, position | 1 |
| `inspect <url>` | URL Inspection: index status, canonical, crawl info | 1 |
| `inspect-batch <file>` | Batch URL Inspection from file | 1 |
| `sitemaps <property>` | GSC sitemap status | 1 |
| `index <url>` | Submit URL to Indexing API | 1 |
| `index-batch <file>` | Batch submit up to 200 URLs | 1 |
| `ga4 [property-id]` | GA4 organic traffic report | 2 |
| `ga4-pages [property-id]` | Top organic landing pages | 2 |
| `ga4-referrals [property-id]` | Referral sessions by source — AI assistants by default | 2 |
| `ga4-channel-mix [property-id]` | Sessions split by channel group (Direct / Organic / Referral / Paid …) | 2 |
| `ga4-properties` | List every GA4 account + property the service account can read | 2 |
| `youtube <query>` | YouTube video search (views, likes, duration) | 0 |
| `youtube-video <id>` | YouTube video details + top comments | 0 |
| `nlp <url-or-text>` | NLP entity extraction + sentiment + classification | 0 |
| `entities <url-or-text>` | Entity analysis only (for E-E-A-T) | 0 |
| `keywords <seed>` | Keyword ideas from Google Ads Keyword Planner | 3 |
| `volume <keywords>` | Search volume lookup from Keyword Planner | 3 |
| `entity <query>` | Knowledge Graph entity check | 0 |
| `safety <url>` | Web Risk URL safety check | 0 |
| `quotas` | Show rate limits for all APIs | -- |
| `report <type>` | Generate a PDF/HTML/XLSX report from collected JSON | -- |

---

## Command details

Each API group has a full reference under `references/` — load it for parameters, response shapes, and edge cases. Scripts live under `E:\DonnaProSEO\scripts\`; invoke them as `python E:\DonnaProSEO\scripts\<name>.py` (Windows host — not `python3`, not a relative path). Only the non-obvious invocation details are called out below.

### PageSpeed + CrUX (Tier 0) — `references/pagespeed-crux-api.md`
- `pagespeed <url>` → `pagespeed_check.py <url> --json`. Both mobile + desktop, all Lighthouse categories; merges lab scores with 28-day field data (CrUX tries URL-level, falls back to origin).
- `crux <url>` → `pagespeed_check.py <url> --crux-only --json` (field data only, faster).
- `crux-history <url>` → `crux_history.py <url> --json` (25-week trend: direction, % change, weekly p75).

### Search Console (Tier 1) — `references/search-console-api.md`
- `gsc <property>` → `gsc_query.py --property <property> --json`. Default 28 days, dimensions=query,page, type=web, limit=1000; flags quick wins (position 4–10, high impressions). Filters: `--device`, `--country <ISO3>`, `--page <url|substr>` (`--page-match equals` for exact). `--ai-overview`/`--ai-mode` scopes to AI Overview / AI Mode appearances (Google's first-party "are we cited in AI Overview?"); `--search-appearance <value>` for other appearance types (RICH_RESULT, REVIEW_SNIPPET, …).
- `inspect <url>` → `gsc_inspect.py <url> --json` (real index verdict, coverage, canonical, mobile usability, rich results).
- `inspect-batch <file>` → `gsc_inspect.py --batch <file> --json` (one URL/line; 2,000/day per site).
- `sitemaps <property>` → `gsc_query.py sitemaps --property <property> --json`.

### Indexing API (Tier 1) — `references/indexing-api.md`
- `index <url>` → `indexing_notify.py <url> --json`. Officially JobPosting + BroadcastEvent/VideoObject only — always tell the user. Quota 200 publish/day.
- `index-batch <file>` → `indexing_notify.py --batch <file> --json` (tracks quota).

### GA4 traffic (Tier 2) — `references/ga4-data-api.md`
All reports accept `--page <path|url>` (EXACT match on `landingPage`; URLs auto-stripped to path). `--report organic`/`top-pages` accept `--channel <name|all>` (default Organic Search; `all` drops the filter — needed for whole-page trends when traffic is mostly Direct/Referral, the AI-cited-content case).
- `ga4` → `ga4_report.py --property <id> --json` (daily time series; 28 days, Organic Search).
- `ga4-pages` → `ga4_report.py --property <id> --report top-pages --json`.
- `ga4-referrals` → `ga4_report.py --property <id> --report referrals --json`. `--sources ai|all|<csv>` (default `ai` = curated AI-assistant hostnames). Measures users sharing your links in AI chats, not proactive AI citation.
- `ga4-channel-mix` → `ga4_report.py --property <id> --report channel-mix --json` (sessions by channel group + share%; AI traffic often lands in Direct — pair with `ga4-referrals`).
- `ga4-properties` → `ga4_admin.py properties --json` (enumerate readable properties; requires the Google Analytics Admin API enabled, separate from the Data API).

### YouTube (Tier 0) — `references/youtube-api.md`
- `youtube <query>` → `youtube_search.py search "<query>" --json` (100 units/search; 10k/day free).
- `youtube-video <id>` → `youtube_search.py video <id> --json` (2 units; details + top comments).

### NLP content analysis (Tier 0) — `references/nlp-api.md`
- `nlp <url|text>` → `nlp_analyze.py --url <url> --json` (or `--text "..."`). Entities + sentiment + classification. Free tier 5,000 units/month; requires billing enabled on the GCP project.
- `entities <url|text>` → `nlp_analyze.py --url <url> --features entities --json` (faster, less quota).

### Keyword research — Google Ads (Tier 3) — `references/keyword-planner-api.md`
- `keywords <seed>` → `keyword_planner.py ideas "<seed>" --json` (needs Ads developer token + customer ID).
- `volume <keywords>` → `keyword_planner.py volume "<kw1>,<kw2>" --json`.

### Supplementary (Tier 0) — `references/supplementary-apis.md`
- `entity <query>` → Knowledge Graph entity check (brand presence).
- `safety <url>` → Web Risk malware / social-engineering check.
- `quotas` → rate-limits table; see `references/rate-limits-quotas.md`.

### Reports
After any analysis command, offer a report. `report <type>` → `google_report.py --type <type> --data <json> --domain <domain> --format pdf`. Types: `cwv-audit` (PSI+CrUX+history), `gsc-performance` (GSC queries + quick wins), `indexation` (batch inspection + coverage donut), `full` (all sections). Workflow: run a collection command → save JSON to a file → generate the report. Templates in `assets/templates/`.

## Rate limits & cross-skill integration

- Per-API rate limits and daily quotas: `references/rate-limits-quotas.md` (or run `quotas`).
- How each SEO skill consumes this one (per-skill enrichment recipes and tier branches): `references/cross-skill-integration.md`.

## Output Format

- CWV metrics: traffic-light rating (Good / Needs Improvement / Poor)
- Performance reports: tables with sortable columns
- Always include data freshness note
- Save reports as `GOOGLE-API-REPORT-{domain}.md`
- Use templates from `assets/templates/` for structured output

## Technical Notes

- INP replaced FID on March 12, 2024. Never reference FID.
- CLS values from CrUX are string-encoded (e.g., "0.05"). Scripts handle parsing.
- CrUX 404 = insufficient traffic, not an auth error.
- Search Analytics data has a 2-3 day lag.
- `round_trip_time` replaced `effectiveConnectionType` in CrUX (Feb 2025).
- Custom Search JSON API is closed to new customers (2025).

## Error Handling

| Scenario | Action |
|----------|--------|
| No credentials configured | Run `setup`. List Tier 0 commands that work with just an API key. |
| Service account lacks GSC access | Report error. Instruct: add `client_email` to GSC > Settings > Users > Add. |
| CrUX data unavailable (404) | Report insufficient Chrome traffic. Suggest PSI lab data as fallback. |
| GA4 property not found | Report error. Show how to find property ID in GA4 Admin > Property Details. |
| Indexing API quota exceeded | Report 200/day limit. Suggest prioritizing most important URLs. |
| Rate limit (429) | Wait and retry with exponential backoff. Report which API hit the limit. |
