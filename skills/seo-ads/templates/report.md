# ADS.md template

Primary deliverable for a seo-ads run. Load only when writing the final brief.

```markdown
# Paid-Search Intelligence: {target}

> Snapshot dated {YYYY-MM-DD} · Market: {market} · Mode: {domain | keyword}

## Footprint summary
- Paid keywords: {n}
- Estimated paid traffic: {n}/mo
- Average CPC: ${n}
- SERP slots covered: {n} of top-4 above organic across {n} target keywords

## Top 10 paid keywords (domain mode)

| Keyword | Volume | CPC | Position | Ad copy excerpt |
|---|---|---|---|---|
| {kw} | {n} | ${n} | {pos} | "{headline} — {snippet}" |
| ...

(Ad-copy excerpts come from the live SERP pull, not from Labs.)

## Bidding landscape (keyword mode — for "{keyword}")

| Advertiser | Position | Ad copy excerpt | URL |
|---|---|---|---|
| {domain} | {pos} | "{headline} — {snippet}" | {url} |
| ...

## Ad copy patterns (top patterns observed)

1. **Pricing-led:** "{N}% off — start at ${X}/mo" — used by {n} advertisers.
2. **Outcome-led:** "Get {specific outcome} in {time}" — used by {n}.
3. **Trust-led:** "Trusted by {n} {audience}" — used by {n}.
4. ...

## SERP feature inventory

| Keyword | Top ads | Shopping pack | PAA | Image pack |
|---|---|---|---|---|
| {kw} | {advertiser list, or "no paid presence"} | {✓/✗} | {✓/✗} | {✓/✗} |
| ...

## Recommended bid-keyword shortlist

See `recommended-keywords.csv`. Top 10:

| Keyword | Volume | Est. CPC | Why |
|---|---|---|---|
| {kw} | {n} | ${n} | Question-intent variant; competitor X bids on head term but not this. |
| ...

## Constraints / caveats
- CPC and volume estimates are directional. Actual costs depend on Quality Score, time of day, audience, etc.
- {Note any ad-copy that's clearly seasonal / promotional and may not represent steady-state.}
- {List keywords with "no paid presence" — a valid finding, not a gap in the data.}

## Recommended next step
Cross-reference these paid keywords with `seo-keyword-cluster` output to find under-served paid clusters. For organic content opportunities corresponding to these paid keywords, run `seo-keyword-niche`.
```
