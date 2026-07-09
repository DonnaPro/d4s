# SXO Report: {URL} for keyword "{keyword}"

> Snapshot dated {YYYY-MM-DD} · Market: {location_name}/{language_code}

## SERP profile
- Top 10 page types: {comparison: 4, listicle: 3, editorial: 2, video: 1}
- Dominant pattern: **{pattern}** ({n} of 10)
- SERP features: AIO ✓ ({n} citations), PAA ✓ ({n} questions), Image carousel ✗, Video carousel ✗, Shopping pack ✗
- Intent: {informational | commercial-investigation | transactional | navigational}
- (Or, if <5 organic results returned: `Insufficient SERP data — {n} organic results; dominant pattern not computed.`)

## Your page
- Page type: **{detected type}**
- Page-type match with dominant: **{✓ match | ✗ MISMATCH — see Verdict}**
- Word count: {n}
- Primary content structure: {prose | numbered-list | table | step-blocks | Q&A | mixed}

## SXO score: **{score}/100**

| Persona | Weight | Score | Notes |
|---|---|---|---|
| Skimmer | {%} | {n}/10 | {1-line note} |
| Researcher | {%} | {n}/10 | {1-line note} |
| Buyer | {%} | {n}/10 | {1-line note} |
| Validator | {%} | {n}/10 | {1-line note} |

## Verdict

{One paragraph. If page type matches: "Your page is the right type for this SERP. The score gap is {X} points — see persona-specific gaps below." If MISMATCH: "Your page is a {your type} but the SERP rewards {dominant type}. No amount of on-page optimization will close the gap; ship a {dominant type} page instead. Wireframe below."}

## If MISMATCH — wireframe for the winning page type

```
{Page title pattern — e.g., "{Brand A} vs {Brand B}: 2026 Comparison"}

[Hero / TL;DR — first 200 words answer the comparative question]
[Comparison table — must be visually dominant]
[Section per dimension — each with H2 named after the dimension]
[Verdict / recommendation — explicit, justified]
[FAQ — top 3–5 PAA questions]
[Schema — Product (×2) + BreadcrumbList + FAQPage]
```

## If MATCH — top 3 changes by persona

1. {Skimmer}: {specific change}
2. {Researcher}: {specific change}
3. {Buyer or Validator}: {specific change}

## Raw data
- 02-page-type-classification.md — every top-10 result, classified
- 03-user-page-fingerprint.md — your page's signals
- 04-persona-scores.md — full persona-by-persona breakdown
