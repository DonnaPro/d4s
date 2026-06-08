---
name: seo-hreflang
description: Hreflang and international SEO audit for multi-language and multi-region sites. Validates language-region codes, return tags, x-default, canonical alignment, and conflict detection across the per-URL HTML, the DataForSEO audit, and the XML sitemap. Use when the user asks "hreflang", "international SEO", "i18n", "language targeting", "x-default", "regional sites", or "multi-language SEO".
---
> Example output: [examples/seo-hreflang-airbnb-com-20260514/HREFLANG-REPORT.md](../../examples/seo-hreflang-airbnb-com-20260514/HREFLANG-REPORT.md)

# Hreflang Audit

Adapted from `AgriciDaniel/claude-seo`'s `seo-hreflang` skill (MIT). Concept and validation rules originate there; this implementation is rebuilt against our backend (DataForSEO MCP + Firecrawl + WebFetch + Google APIs via `seo-google`).

Validate hreflang implementations on a multi-language or multi-region site. Surface per-page hreflang issues via `on_page_instant_pages`, parse a sample of pages for the actual `<link rel="alternate" hreflang="…">` tags they emit, cross-check the sitemap, and produce one of three verdicts — **PASS**, **NEEDS-FIX**, or **BROKEN** — with a top-fixes table anchored in objective signals.

## Prerequisites

- DataForSEO MCP server connected.
- Claude's `WebFetch` tool available (fallback when Firecrawl is unavailable).
- User provides: a target domain (e.g. `example.com`). Optional: explicit list of representative pages to inventory; explicit sitemap URL if not at `/sitemap.xml`.
- **Predecessor (recommended):** `seo-technical-audit` or `seo-sitemap` already run on this domain.

## Process

1. **Validate target & preflight.** See `skills/seo-firecrawl/references/preflight.md` for the canonical 3-stage preflight (Firecrawl availability, Google APIs). Skill-specific notes:
   - Normalise domain (strip protocol, trailing slash) before continuing.
   - Firecrawl: optional with WebFetch fallback, ~6 Firecrawl credits if available (hard cap). When available, step 3 (per-URL hreflang inventory) runs on homepage + 5 representative pages with `formats: ["rawHtml"]`. Without Firecrawl, step 3 falls back to WebFetch — coverage is degraded because WebFetch returns markdown only and silently strips `<link rel="alternate">` tags from `<head>`. Pass `--no-firecrawl` to force WebFetch even when Firecrawl is available.
   - Google APIs: tier 1 (GSC) unlocks step 5 (GSC verification of hreflang-targeted alternates). See `skills/seo-google/references/cross-skill-integration.md` for the full enrichment contract.

2. **Pull hreflang findings via on-page analysis** `on_page_instant_pages`
   - Use `on_page_instant_pages` on the homepage and representative pages to extract on-page signals including hreflang tags.
   - Surface hreflang errors — typical issues: missing return tags, invalid language codes, missing x-default, canonical mismatches, missing self-reference.
   - For each significant hreflang issue (count ≥ 1), enumerate the affected URLs from the results.
   - Persist to `01-audit-hreflang-issues.md` and feed into `hreflang-issues.csv`.

3. **Per-URL hreflang tag inventory** `mcp__firecrawl-mcp__firecrawl_scrape` (preferred) / `WebFetch` (fallback)
   - **Sample selection:** homepage + up to 5 representative pages from `dataforseo_labs_google_relevant_pages` (sort by traffic descending; bias toward pages on different language paths if the URL structure exposes them — `/en/`, `/fr/`, `/de/`, etc.).
   - **Firecrawl path** (1 credit per URL, ~6 total): call `firecrawl_scrape(url=..., formats=["rawHtml"])`. Pin `rawHtml` — the default `html` post-processing strips `<link rel="alternate">` on many sites. Parse every `<link rel="alternate" hreflang="…" href="…">` from the `<head>`. Capture: source URL, hreflang attribute, href, and whether it's self-referencing.
   - **WebFetch fallback** (no Firecrawl): try fetching each URL and extracting hreflang from the markdown response. WebFetch frequently returns markdown that has stripped `<head>` link tags, so this path will under-report. Note in `HREFLANG-REPORT.md`: `Per-URL inventory: degraded coverage — Firecrawl not installed; some hreflang tags may be missed.`
   - **Apply validation rules** (see references/validation-rules.md for the full list):
     - **Self-referencing tag:** the page's own URL must appear in its own hreflang set.
     - **Return tags:** every alternate link must reciprocate. If page A lists B as `fr`, page B must list A as `en` (or whichever).
     - **x-default:** at least one alternate per set must use `hreflang="x-default"`.
     - **Language-region code validation:** every value must be a valid ISO 639-1 language (optionally followed by `-` and an ISO 3166-1 Alpha-2 region). Common errors caught: `eng` (use `en`), `jp` (use `ja`), `en-uk` (use `en-GB`), `es-LA` (no such ISO region).
     - **Conflict detection:** the same hreflang value (e.g. `de-DE`) appearing on multiple distinct URLs is a conflict — Google ignores conflicting sets.
     - **Canonical alignment:** if the page has `<link rel="canonical">`, it must match the page's own URL (or its self-referencing hreflang URL). Hreflang on a non-canonical page is silently ignored by Google.
     - **Protocol consistency:** all URLs in a set must share the same scheme (HTTPS preferred).
   - Persist to `02-per-url-hreflang.md` and append findings to `hreflang-issues.csv`.

4. **Sitemap-level hreflang** (defer to `seo-sitemap` where appropriate)
   - If the user's domain uses sitemap-based hreflang (`<xhtml:link rel="alternate" …>` inside the sitemap), this skill checks structure and consistency only. Full sitemap analysis (orphans, missing pages, broken entries) is `seo-sitemap`'s job — recommend it explicitly if a sitemap-vs-audit diff is in scope.
   - **Fetch the sitemap.** Try `https://{domain}/sitemap.xml`; if 404, fetch `/robots.txt` and find `Sitemap:` directives. For sitemap-of-sitemaps, recursively fetch each child.
   - **Validate hreflang within the sitemap:**
     - Does the sitemap use the `xmlns:xhtml="http://www.w3.org/1999/xhtml"` namespace? Required for hreflang in sitemaps.
     - Does each `<url>` entry that has hreflang alternates include itself in the alternate set (self-reference)?
     - Does every alternate listed in one `<url>` entry reciprocate as its own `<url>` entry with the same alternate set (return tags)?
     - Are language-region codes valid (apply same rules as step 3)?
   - **Cross-check against per-URL inventory (step 3):** if a sample URL's HTML lists 4 hreflang alternates but the sitemap entry for that URL lists 6, that mismatch is a conflict — Google may pick either, and inconsistency degrades the signal.
   - Persist to `03-sitemap-hreflang.md` and append findings to `hreflang-issues.csv`.

5. **GSC verification of hreflang-targeted alternates** *(only if google-api.json is present, tier ≥ 1)*
   - For each unique domain that appears as an `href` target in the hreflang sets (e.g. `example.com`, `example.de`, `example.fr`), confirm GSC verification:
     `python3 scripts/gsc_query.py --property "{property}" --json` (a status-only check; just confirm the property responds without `PROPERTY_NOT_VERIFIED`).
   - **Why this matters:** Google explicitly recommends verifying every domain that participates in a cross-domain hreflang setup. If `example.de` is listed as an alternate but isn't verified in this account, the hreflang signal is weakened and you can't see how Google interprets it.
   - Surface in `HREFLANG-REPORT.md` as a section "## GSC verification of hreflang targets" with one row per target domain: `verified` / `not verified` / `not configured`.
   - If property not verified for a target domain: list it as a fix at Medium severity ("Verify {domain} in Google Search Console — required for cross-domain hreflang trust").
   - See `skills/seo-google/references/cross-skill-integration.md` § "Trigger pattern" for the failure-mode contract.

6. **Synthesise verdict**
   - Apply the verdict heuristic (see Tips) to produce **PASS**, **NEEDS-FIX**, or **BROKEN**.
   - Sort `hreflang-issues.csv` by severity descending, then count descending.
   - Write `HREFLANG-REPORT.md` with the top-fixes table (top 10) and the verdict.

## Output format

Create a folder `seo-hreflang-{target-slug}-{YYYYMMDD}/` with:

```
seo-hreflang-{target-slug}-{YYYYMMDD}/
├── 01-audit-hreflang-issues.md   (on-page analysis findings filtered to hreflang)
├── 02-per-url-hreflang.md         (per-URL <link rel="alternate"> inventory + validation findings)
├── 03-sitemap-hreflang.md         (sitemap-level hreflang validation; defer details to seo-sitemap)
├── evidence/
│   ├── homepage-rawhtml.html      (raw HTML from Firecrawl, for the homepage sample)
│   ├── sample-{n}-rawhtml.html    (raw HTML for each sampled URL)
│   └── sitemap.xml                (raw fetched sitemap)
├── hreflang-issues.csv            (load-bearing: URL, issue code, severity, fix)
└── HREFLANG-REPORT.md             (PRIMARY: verdict + top fixes table)
```

`HREFLANG-REPORT.md` follows this shape:

```markdown
# Hreflang Audit: {domain}

> Audit date {YYYY-MM-DD} · Sample size: {n} URLs · Languages detected: {comma-separated list}

## Verdict: {PASS | NEEDS-FIX | BROKEN}

Reasoning: {1–2 sentences anchored in concrete numbers from the data}.

## Summary

| Source | Findings | Severity breakdown |
|---|---|---|
| On-page analysis (on_page_instant_pages) | {n} | Critical: {n} · High: {n} · Medium: {n} · Low: {n} |
| Per-URL HTML inventory | {n} | … |
| Sitemap | {n} | … |

## Top fixes (impact-ranked)

| # | URL | Issue | Severity | Fix |
|---|---|---|---|---|
| 1 | {URL} | {issue code} | {severity} | {one-line fix} |
| 2 | … | … | … | … |
| ... up to 10 |

## Languages detected

| Language | URL count | Self-ref OK | Return tags OK | x-default OK |
|---|---|---|---|---|
| en-US | {n} | ✓ / ✗ {count} | ✓ / ✗ | ✓ / ✗ |
| de-DE | {n} | … | … | … |
| ... |

## Per-URL inventory ({n} URLs sampled)

| URL | Alternates | Self-ref | x-default | Notable issues |
|---|---|---|---|---|
| {URL} | {n} | ✓/✗ | ✓/✗ | {short text} |
| ... |

## Sitemap-level hreflang
- xhtml namespace declared: {✓/✗}
- URLs with hreflang alternates: {n}
- Self-reference within sitemap: {✓ all / ✗ {count} missing}
- Return tags within sitemap: {✓ all / ✗ {count} missing}
- Per-URL HTML vs sitemap consistency: {✓ all match / ✗ {count} mismatched}
- Full sitemap-vs-audit analysis: see `seo-sitemap` (orphans, broken entries, lastmod).

## GSC verification of hreflang targets

| Domain | Verified | Notes |
|---|---|---|
| {domain1} | ✓ / ✗ | {note if unverified} |
| ... |

(Or: `GSC verification: not configured (run bash extensions/google/install.sh)`.)

## Coverage notes

- Per-URL inventory tool: {Firecrawl rawHtml | WebFetch fallback (degraded — some hreflang tags may be missed)}.
- Pages sampled: homepage + {n} representative pages (selection: top traffic from `dataforseo_labs_google_relevant_pages`).

## Apply

- Walk `hreflang-issues.csv` row-by-row; each row is one specific change (URL + issue + fix).
- After applying changes, re-run `seo-technical-audit` to refresh findings, then re-run this skill to verify.
```

`hreflang-issues.csv` columns: `url,issue_code,severity,fix,source` where `source` is one of `audit | html | sitemap | gsc`.

## Tips

- Respect DataForSEO API rate limit: 10 req/sec.
- **Verdict heuristic:**
  - **PASS:** zero Critical findings; ≤ 2 High findings; sample URLs all have self-reference, x-default, and reciprocal return tags; all language-region codes valid; canonical aligns with self-ref hreflang.
  - **NEEDS-FIX:** any High finding; or > 5 Medium findings; or any one of (missing x-default, missing return tags on > 25% of sampled pages, language-region code error, sitemap-vs-HTML mismatch).
  - **BROKEN:** any Critical finding; or hreflang attempted but no self-reference on the homepage; or canonical pointing elsewhere on a page that nonetheless emits hreflang (entire set is ignored by Google); or > 50% of sampled URLs missing return tags.
- Anchor every claim in `HREFLANG-REPORT.md` to a row in `hreflang-issues.csv`. If a stakeholder questions the verdict, walk them through the CSV.
- For sites with > 50 language variants per page, the per-URL HTML implementation bloats the `<head>` — recommend the sitemap-based implementation instead. Don't generate code; the deliverable is diagnostic, not code-gen.
- The skill **does not** assess cultural adaptation, content parity, or locale formatting. Those are translation/QA concerns; they're orthogonal to whether hreflang itself is technically correct. If the user wants those, point them at the translation team — this skill answers "is the technical hreflang signal working?", not "is the localised content good?".
- For cross-domain hreflang (e.g. `example.com` ↔ `example.de`), step 5's GSC check is the highest-value enrichment — verifying both domains is Google's explicit recommendation.
- **Common false-positive guard:** if a sampled page legitimately has no internationalization (e.g. a single-region site), zero hreflang tags is correct, not an issue. The skill detects this by checking whether *any* sampled page emits hreflang; if none do, the verdict is PASS with note "No hreflang implementation detected — single-language site."
- Pair with `seo-sitemap` for the sitemap-vs-audit diff; pair with `seo-technical-audit` for full technical health. This skill is narrow: hreflang correctness only.
- See `references/validation-rules.md` for the full per-issue rule table (severity, detection logic, suggested fix).
