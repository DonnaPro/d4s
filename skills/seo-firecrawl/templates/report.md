# FIRECRAWL.md template

The root synthesis + handoff payload for every seo-firecrawl run. Load only when writing the final deliverable.

```markdown
# Firecrawl: {target}

> Run dated {YYYY-MM-DD} · Mode: {scrape | map | crawl | search} · Credits used: {n}

## Summary

{One-paragraph what-came-back. Example: "Scraped https://example.com/article. og:title and og:image present, JSON-LD Article schema with author + datePublished. 12 outbound links. Page is server-rendered (no JS-render divergence). Robots: index,follow."}

## Key findings

1. {Finding anchored in concrete data}
2. ...
5. ...

## Open loops

- {What this run did NOT answer}
- ...

## Recommended next step

{One of: `seo-page` (when a single URL was scraped and now wants performance analysis) | `seo-schema` (when JSON-LD audit needs follow-up generation) | `seo-technical-audit` (when crawl revealed broken pages) | `seo-content-audit` (when crawl produced a corpus to audit) | `seo-drift baseline` (when the user wants to track this URL over time) | "this completes the user's ask".}

## Handoff payload

- **Produced by:** seo-firecrawl
- **Target:** {url or domain}
- **Mode:** {scrape | map | crawl | search}
- **Credits used:** {n}
- **Key findings:** {5 bullets — e.g., "twitter:card present (summary_large_image)", "JSON-LD types: Article + Organization + BreadcrumbList", "robots: index,follow", "canonical self-referencing", "404s: 0 of 50 pages crawled"}
- **Open loops:** {what this didn't answer}
- **Recommended next skill:** {seo-page | seo-schema | seo-technical-audit | seo-content-audit | …} — {one-line why}
```
