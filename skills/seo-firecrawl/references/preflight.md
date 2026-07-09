# Shared preflight contract for analysis skills

Every analysis skill runs the same 3-stage preflight at the start of its Process section. This file is the single source of truth — skills reference it from step 1 (or Prerequisites) instead of inlining the prose. Project-wide defaults (markets, cost discipline, output conventions) live in `CLAUDE.md` and always apply.

## The 3-stage preflight

### Stage A — DataForSEO budget guard

DataForSEO has no MCP credit-balance tool, so the guard is an estimate-and-confirm gate, not a balance check:

1. Estimate the number of paid DataForSEO calls the run will make (each skill states its typical range in its own step 1).
2. If the estimate exceeds ~10 calls — or the user asked for a multi-market breakdown, which multiplies cost per market — surface it and confirm before running:

```
Estimated DataForSEO calls: ~{n} ({scope description}). Continue? (y/N)
```

3. On confirmation, apply the cost rules from `CLAUDE.md § DataForSEO cost discipline`: always set `limit` + server-side `filters`, prefer intersection/bulk endpoints over per-domain fan-out, never repeat a call for data already saved in `evidence/`.

All DataForSEO APIs (including Backlinks and LLM Mentions) are pay-as-you-go with no monthly minimum as of 2026-07-01.

### Stage B — Firecrawl availability

Check whether a Firecrawl scrape capability is available (MCP tool `mcp__firecrawl-mcp__firecrawl_scrape`, or the `firecrawl:firecrawl-scrape` skill/CLI — accept any of them, do not hard-require one tool id).

- **If available → enriched path.** Run the Firecrawl steps as documented in the skill; surface projected Firecrawl cost (typically 1 credit per URL, varies by mode — see `seo-firecrawl/SKILL.md` § Cost estimation).
- **If unavailable → degraded path.** The skill still runs on WebFetch + DataForSEO data. Firecrawl-only deliverable lines emit `(skipped — Firecrawl not available)`; skill-specific caveats live in each skill's own steps.
- **`--no-firecrawl` flag** forces the degraded path even when Firecrawl is available (credit conservation).
- Plain-text or tiny files (llms.txt, robots.txt, sitemaps) may always be fetched with WebFetch — don't spend Firecrawl credits on them.

When unavailable, surface the install hint: `bash extensions/firecrawl/install.sh`.

### Stage C — Google APIs

Run `python E:\DonnaProSEO\scripts\google_auth.py --check --json` (Windows host: `python`, absolute path) and parse the result.

- **If `tier >= 0`**: branch into the per-tier enrichment recipes in `skills/seo-google/references/cross-skill-integration.md`.
- **If `tier == -1`** or the script/config is missing: proceed without Google enrichment and note `Google enrichment: not configured` in the deliverable. (On this machine Google APIs are not configured — expect this path; see CLAUDE.md.)

Stage C defers entirely to `cross-skill-integration.md` for per-tier branches and failure handling — don't duplicate that contract here.

## Failure-mode table

| Failure | Detection | Skill response |
|---|---|---|
| DataForSEO call fails / empty result | Error status or zero rows | Note it in the deliverable, mark the affected section "insufficient data", and continue. Do not retry with query variations; do not fabricate values. Failed DataForSEO requests don't consume credits. |
| DataForSEO rate limit | HTTP 429 | Pace sequentially (10 req/s cap); back off once, then continue. |
| Firecrawl not available | No scrape tool/skill in session | Note "Firecrawl not available — degraded path active" and run the WebFetch-only path. |
| Firecrawl rate limit | 429 | Fall back to WebFetch for remaining URLs; no tight-loop retries. |
| Firecrawl WAF/anti-bot block | 403 / blocked | Note the URL and reason, continue. Defeating WAFs is out of scope. |
| Google config missing | `google_auth.py --check` non-zero | Note "Google field data: not configured" and skip enrichment. |
| GSC property not verified | `{"error": "PROPERTY_NOT_VERIFIED"}` | Skip GSC enrichment only, note it. |
| Insufficient CrUX data | `{"crux": null}` | Note "CrUX: insufficient field data" and skip CrUX only. |

A skill **never** fails the run because preflight or enrichment failed. Enrichment is optional uplift; the DataForSEO-based deliverable always ships.

## How to reference this from a skill

In the skill's Prerequisites or Process step 1, replace verbose preflight prose with:

```
1. **Validate target & preflight.** See `skills/seo-firecrawl/references/preflight.md` (budget guard, Firecrawl availability, Google APIs) and `CLAUDE.md` (market defaults, cost discipline). Skill-specific notes:
   - Typical DataForSEO calls for this skill: ~{N} ({scope}).
   - Firecrawl: {required | optional with WebFetch fallback | not used}.
   - Google APIs: {tier/step, or "not used"}.
```
