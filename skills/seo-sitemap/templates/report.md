# SITEMAP.md template

Primary deliverable for a seo-sitemap run. Load only when writing the final report.

```markdown
# Sitemap Analysis: {domain}

> Sitemap pulled {YYYY-MM-DD} · DataForSEO ranking-visibility reference {YYYY-MM-DD}

## Mode

- **Mode-1 (sitemap fetch):** {ran / skipped — no sitemap reachable}
- **Mode-2 (Firecrawl URL discovery):** {ran with {n} URLs / not triggered / triggered but Firecrawl not installed}

## Health summary

| Metric | Value | Status |
|---|---|---|
| Sitemap URLs (Mode-1) | {n} | — |
| Discovered URLs (Mode-2, if ran) | {n} | — |
| URLs with ranking visibility (DataForSEO) | {n} | — |
| Missing from sitemap (probable adds) | {n} | {🔴 if >5%} |
| Orphans from sitemap (probable cuts or link-ins) | {n} | {🟡 if >5} |
| Broken sitemap entries (non-200) | {n} | {🔴 if >0} |
| Lastmod issues | {n} | {🟡 if uniform; 🔴 if stale} |

## Recommended changes

### Add to sitemap ({n} URLs)
- {URL} — found by Firecrawl crawl / has ranking visibility, status 200, indexable.
- ...

### Remove from sitemap ({n} URLs)
- {URL} — returns {status code}.
- ...

### Investigate (orphan from sitemap, {n} URLs)
- {URL} — in sitemap but not reachable via internal links. Either link from {suggested parent} or remove from sitemap.
- ...

### Fix lastmod ({n} URLs)
- {URL} — lastmod is {date} but appears stale relative to other pages last modified on {date}.
- ...

## Validation

- Total URL count: {n} ({✓ under 50k limit | ✗ exceeds — split into sitemap-of-sitemaps})
- Referenced in robots.txt: {✓/✗}
- HTTPS consistency: {✓/✗}
- Encoding: {✓/✗}

## Apply
- See `recommended-sitemap-diff.md` for the proposed sitemap.xml changes.
- After applying, re-run this skill to verify.
```
