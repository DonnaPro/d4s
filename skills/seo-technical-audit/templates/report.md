# seo-technical-audit deliverable templates

Load this file only when writing the final deliverable. It holds the output-folder layout and the `TECH-AUDIT.md` shape.

## Output folder layout

Create `output/seo-technical-audit-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-technical-audit-{target-slug}-{YYYYMMDD}/
├── TECH-AUDIT.md                       (synthesised top-10 fix list + category summary — primary deliverable; inlines 01-audit-summary header + the six 02-issues-by-category/* tables under "By category")
├── issues.csv                          (every issue: code, severity, count, fix, effort — load-bearing CSV engineering pastes into Jira)
├── 03-key-pages-issues.md              (top 5 traffic pages, all their issues — load-bearing reference engineering / on-call consult per-URL)
└── evidence/
    ├── 02-issues-by-category/          (raw per-category tables — preserved in case a reader wants the unmerged view)
    │   ├── crawlability.md
    │   ├── indexability.md
    │   ├── security.md
    │   ├── mobile.md
    │   ├── structured-data.md
    │   └── content.md
    ├── 04-robots-sitemap-snapshot.md   (raw fetched files — preserved for reproducibility)
    └── 05-modern-signals.md            (JS-render canonical/noindex divergence, X-Robots-Tag, AI-crawler rules — requires Firecrawl)
```

Top-level: `TECH-AUDIT.md` + `issues.csv` + `03-key-pages-issues.md`. The audit summary header (`01-audit-summary`) is already in TECH-AUDIT.md's header; the six per-category tables (`02-issues-by-category/*.md`) are inlined under TECH-AUDIT.md's "By category" section. The raw category files, robots/sitemap snapshot, and modern-signals dump live under `evidence/` for reproducibility.

`issues.csv` columns: `category,issue_code,issue_name,severity,affected_pages,suggested_fix,effort,priority_score`

## TECH-AUDIT.md shape

```markdown
# Technical Audit: {domain}

> Audit date {YYYY-MM-DD} · Pages analyzed: {n} of {total-discovered} discovered · Domain rank: {n} · Est. organic traffic: {n}/mo

## Summary

| Severity | Count |
|---|---|
| Critical | {n} |
| High | {n} |
| Medium | {n} |
| Low | {n} |

> Note: Analysis covers a sample of {n} pages (top by organic traffic). For sites with >50 pages, results represent the highest-traffic section of the site. Full-site analysis requires increasing `--limit`.

## Top 10 fixes (impact × effort)

| Rank | Issue | Severity | Pages | Fix | Effort |
|---|---|---|---|---|---|
| 1 | {issue name} | {severity} | {n} | {one-line fix} | {S/M/L} |
| ... |

## By category

### Crawlability ({n} issues)
- {issue name} ({n} pages) — {fix}
- ...

### Indexability ({n} issues)
- ...

### Security ({n} issues)
- ...

### Mobile ({n} issues)
- ...

### Structured data ({n} issues)
- ...

### Content ({n} issues)
- ...

### Modern signals ({n} findings — Firecrawl)
- {URL} — initial-HTML canonical `{X}` differs from JS-rendered canonical `{Y}` (`js_canonical_mismatch`)
- {URL} — JS-rendered `noindex` not visible to static analysis
- {URL} — `X-Robots-Tag: noindex` at HTTP layer
- {URL} — rendered HTML <50% of initial HTML size (`js_render_budget` — Google may stop rendering before content loads)
- {URL} — title / H1 / meta description differ between initial HTML and post-render DOM (`js_csr_meta_drift`)
- {URL} — rendered body <500 chars but HTTP 200 (`js_soft_404` — likely JS render failure, treated as soft-404 by Google)
- robots.txt — `GPTBot`: {allow / disallow `/path`}, `ClaudeBot`: {…}, `Google-Extended`: {…}, ...
- IndexNow — configured: {Y/N} · key-file: `/<key>.txt` {found / missing / mismatch} · last-key-rotation: {YYYY-MM-DD or "unknown"}

### Security headers (extended — WebFetch)

| Header | Homepage | Sample 1 | Sample 2 | Sample 3 | Issue |
|---|---|---|---|---|---|
| Content-Security-Policy | {present/absent} | … | … | … | `csp_missing` if absent |
| X-Frame-Options | {present/absent} | … | … | … | `xframe_missing` if absent (informational; CSP frame-ancestors supersedes) |
| X-Content-Type-Options | {`nosniff`/absent/other} | … | … | … | `xcontent_missing` if not `nosniff` |
| Referrer-Policy | {present/absent} | … | … | … | `referrer_policy_missing` if absent |
| HSTS preload | {preload directive Y/N · on Chromium preload list Y/N} | … | … | … | `hsts_no_preload` if not on list |

## Lighthouse scores (DataForSEO — lab data, top 5 pages)

| URL | Performance | Accessibility | Best Practices | SEO | LCP | CLS |
|---|---|---|---|---|---|---|
| {url 1} | {0–100} | {0–100} | {0–100} | {0–100} | {n} ms | {n} |
| ... |

Source: DataForSEO `on_page_lighthouse`. Lab data only — see CrUX section below for real-user field data.
(Or: `Lighthouse scores: skipped — pass --no-lighthouse to suppress, or this note means no pages were analyzed.`)

## Core Web Vitals (field data — CrUX)

| Metric | p75 (current) | 25-week trend | Threshold | Status |
|---|---|---|---|---|
| LCP | {n} ms | {improving/stable/degrading} | ≤2500 ms good · ≤4000 ms needs improvement | {pass/warn/fail} |
| INP | {n} ms | … | ≤200 ms good · ≤500 ms needs improvement | … |
| CLS | {n} | … | ≤0.1 good · ≤0.25 needs improvement | … |
| FCP | {n} ms | … | ≤1800 ms good · ≤3000 ms needs improvement | … |
| TTFB | {n} ms | … | ≤800 ms good · ≤1800 ms needs improvement | … |

Source: CrUX 28-day origin. If insufficient field data: "CrUX: insufficient data for {domain} (low-traffic origin)."
(Or: `CWV (field data): not configured — run `bash extensions/google/install.sh` for setup.`)

## Indexation reality check (GSC URL Inspection)

| URL | Status | userCanonical → googleCanonical | Last crawled |
|---|---|---|---|
| {top-traffic URL 1} | {INDEXED|EXCLUDED|...} | {URL} {→ different URL if divergent} | {YYYY-MM-DD} |
| {top-traffic URL 2} | … | … | … |
| ... |

Source: GSC URL Inspection (Tier 1). If property not verified: "GSC: {domain} not verified — add it in Search Console."
(Or: `Indexation reality check: not configured (Tier 1 setup required).`)

## Key-page deep dives

### {URL with most issues}
{n} issues found. Top fixes:
1. ...
2. ...

## Recommended cadence
Re-run this skill monthly to catch regressions, or wire `seo-drift` to baseline + diff between audits.
```
