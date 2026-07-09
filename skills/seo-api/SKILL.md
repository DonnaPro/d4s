---
name: seo-api
description: DataForSEO API integration guide for developers. Covers the full DataForSEO MCP surface — SERP, Labs (keyword/domain/competitor research), Backlinks, On-Page, AI Optimization (LLM mentions, ChatGPT scraper), Keyword Data, Business Data, Content Analysis, Domain Analytics, YouTube SERP, Merchant — and produces ready-to-paste cURL / Python / TypeScript / MCP-tool-call recipes. Distinct from the other SEO skills, which produce analysis deliverables (briefs, audits, reports); seo-api produces integration recipes. Use when the user asks "how do I use DataForSEO to do X", "what tool gives me Y", "build a rank tracker", "pull backlinks into BigQuery", "cURL/Python/TypeScript for DataForSEO", "what's the rate limit", "integrate DataForSEO with n8n / Make / Looker", or any direct question about tools, parameters, JSON schemas, rate limits, or auth.
---

# DataForSEO API Integration Guide

Help developers ship real integrations against the DataForSEO API via the DataForSEO MCP server. The deliverable is a **code recipe** (ready-to-paste cURL / Python / TypeScript / MCP-tool-call sequence) covering authentication, tool selection, parameter patterns, and retry strategy.

## Prerequisites

- **DataForSEO MCP server connected.** Authentication is handled via `DATAFORSEO_USERNAME` and `DATAFORSEO_PASSWORD` environment variables — the MCP server injects HTTP Basic Auth on every request. No OAuth, no per-call token management.
- **(Optional) `WebFetch`** for fetching deep reference docs at `docs.dataforseo.com` when the request needs prose beyond the tool schema.
- User provides: an integration goal in plain language (e.g., "pull ranked keywords for a domain", "get backlink summary for these 50 domains weekly", "check LLM mentions for my brand"). The skill interviews only when the goal is ambiguous.

## Reference material

The detail lives in `references/` — load the one the question needs; don't duplicate it here.

- **Authentication & setup** → `references/auth-and-keys.md` (HTTP Basic Auth, `DATAFORSEO_USERNAME`/`DATAFORSEO_PASSWORD` env vars, MCP server config per client, REST-direct auth, liveness check, common auth errors).
- **Tool surface / "which tool do I need"** → `references/api-surface-map.md` (every MCP tool by category, plus a quick decision tree).
- **Integration patterns** → `references/integration-patterns.md` (five canonical recipes: domain overview, keyword research, backlink audit, AI visibility, on-page audit — with Python skeletons).
- **Rate limits & credits** → `references/rate-limits-and-credits.md` (per-category rate defaults, 429 backoff, client-side throttling, credit/cost forecasting, response envelope).

## Process

1. **Clarify the goal.** Ask 1–3 questions only if the goal is ambiguous. Skip when the user already spelled it out. Useful follow-ups:
   - "Is this a one-off run, a recurring job (daily/weekly), or a long-lived integration?"
   - "Target country / language / device — or worldwide?"
   - "Which domains or keywords are the starting point?"

2. **Map goal to tools.** Identify the tool sequence from `references/api-surface-map.md`. For every step, note:
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

Write to `output/seo-api-{slug}-{YYYYMMDD}/` (per `CLAUDE.md` output conventions), where `{slug}` is a kebab-case summary of the goal.

```
output/seo-api-{slug}-{YYYYMMDD}/
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
- **location_code is required for most Labs and SERP tools.** Use `serp_locations` or `kw_data_google_ads_locations` to resolve a country name to its integer code (e.g., UK = 2826 — the project default; see `CLAUDE.md`). Hardcode common codes in your scripts; don't look them up on every run.
- **language_code is usually a two-letter string** (e.g., `"en"`, `"de"`, `"fr"`). Check tool schemas for the exact format — a few endpoints use `language_name` instead.
- **Bulk over loops where the tool supports it.** `backlinks_bulk_ranks` accepts up to 1000 domains in one call — always batch those rather than looping. **`on_page_instant_pages` is one URL per call in this MCP** (the `url` param is a single string; the raw REST API can batch tasks, but the MCP tool does not) — loop over URLs and pace the calls per `references/rate-limits-and-credits.md`.
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
