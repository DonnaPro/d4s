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
| en-GB | {n} | ✓ / ✗ {count} | ✓ / ✗ | ✓ / ✗ |
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
