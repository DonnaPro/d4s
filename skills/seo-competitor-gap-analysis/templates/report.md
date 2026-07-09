# REPORT.md template

Primary deliverable for a seo-competitor-gap-analysis run. Load only when writing the final report.

```markdown
# Competitor Gap: {target}
Market: {market — per CLAUDE.md}
Competitors analysed: {list}

## Summary
- Competitor keywords in top 20: {n}
- Target keywords overall: {n}
- Gap keywords (opportunities): {n}
- Gap traffic potential: ~{n}/mo

## Top 50 opportunities

### Informational intent
| # | Keyword | Volume | KD | Competitors ranking | Action | Score |
|---|---|---|---|---|---|---|
| 1 | {kw} | {n} | {n} | {3 of 5} | New article | {score} |
| 2 | ... | ... | ... | ... | ... | ... |

### Commercial intent
| # | Keyword | Volume | KD | Competitors ranking | Action | Score |
|---|---|---|---|---|---|---|
...

### Transactional intent
...

## Quick wins (top 10)
Keywords where competitors rank in positions 5 to 20 with thin content, low DT, or old dates.

| # | Keyword | Weakest competitor position | Suggested angle |
|---|---|---|---|
| 1 | {kw} | example.com at #14 (2022 article, 800 words) | Fresh, comprehensive guide |

## Recommended next steps
1. Run `seo-content-brief` on the top 3 opportunities to generate writer-ready briefs.
2. Run `seo-keyword-cluster` on the full gap list to build a sequencing plan.
3. Save the gap list to `output/` and re-run this skill quarterly to track which gaps closed (DataForSEO has no rank-tracking projects — the re-run is the tracking mechanism).

## Files
- gaps.csv: full gap list for spreadsheet analysis
- evidence/02-gap-by-competitor.md: per-competitor intersection results
```
