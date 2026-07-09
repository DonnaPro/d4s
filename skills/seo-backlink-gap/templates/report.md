# REPORT.md template

Primary deliverable for a seo-backlink-gap run. Load only when writing the final report.

```markdown
# Backlink Gap: {target} vs {competitors}

## Filters applied
- Dofollow only: yes
- Min Domain Rank: {n}
- Min intersection: links to at least {n} of {total} competitors
- Relaxations applied (if any): {e.g. "dropped dofollow filter + lowered rank to 10 — thin intersection; quality bar lowered accordingly"}

## Top 25 prospects

| # | Referring domain | DR | Links to | Sample anchor | Link type | Angle | Score |
|---|---|---|---|---|---|---|---|
| 1 | example.com | 68 | {3 of 5} | "best yoga studios" | Resource list | Topical fit | 92 |
| 2 | ... | ... | ... | ... | ... | ... | ... |

## Outreach brief
- Segment these prospects into 3 batches by link type and pitch each batch with a tailored template.
- For editorial links: pitch a unique-angle comparison or original research.
- For resource lists: suggest inclusion with a specific anchor.
- For directories: apply directly.
- For forums/UGC: engage before pitching; these are not cold-outreachable.

## Counts
- Referring domains in the intersection: {n}
- Passed filters: {n}
- Already linking to {target}: excluded server-side via exclude_targets
- Final prospects: {n}

## Files
- prospects.csv: import to Hunter.io, Pitchbox, or your outreach tool
- evidence/intersection-raw.md: raw intersection response
```
