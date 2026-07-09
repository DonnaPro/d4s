# GEO Analysis: {URL}

> Snapshot dated {YYYY-MM-DD} · Market: {location_name}/{language_code} · Keywords analysed: {n}

## Citation footprint

| Keyword | AIO present | Candidate cited | Citers |
|---|---|---|---|
| {keyword 1} | ✓ | ✗ | {3 cited sources} |
| {keyword 2} | ✓ | ✓ | {includes candidate + 2 others} |
| ... |

**Citation rate: {n}/{checked} ({%}) of AIOs where candidate could appear actually cite it.**

## Where the candidate IS cited
- {keyword X} — passage cited: "{passage text}"
- ...

## Where the candidate is NOT cited (and AIO is present)
- {keyword Y} — cited sources tend to share these patterns:
  - {pattern 1: short definitive answer in first 100 words}
  - {pattern 2: numbered stat with date}
  - {pattern 3: schema-marked Article with author bio}
- The candidate is missing: {specific gap}.

## Page passage-level audit

Top-scoring passages on the candidate (by citability score):
1. {passage at H2 "X" — score 8/10. Strong: definitive sentence, named stat. Weak: no date.}
2. ...

Lowest-scoring passages (refresh candidates):
1. {passage at H2 "Y" — score 3/10. Weak: vague generalities, no specific data.}
2. ...

## Schema check
- `Article` (or sub-type) present and valid: {✓/✗ | skipped — Firecrawl required}
- `author` populated with `@type: Person` and `url`: {✓/✗}
- `datePublished` + `dateModified` ISO 8601: {✓/✗}
- `FAQPage` for visible Q&A: {✓/✗/N-A}
- `BreadcrumbList`: {✓/✗}

## AI-protocol files
- `/llms.txt` present: {✓ status 200 / ✗ status {n}}
- `/.well-known/rsl.json` (or `/RSL.txt`) present: {✓ / ✗}
- Stance summary: {permissive / restrictive / mixed / unknown — based on declared categories and allow/deny scope}

## Recommendations (top 5 to improve citability)

1. {Specific change — e.g., "Add a 60-word TL;DR after the H1 that directly answers '{primary keyword}' — current page buries the answer below 800 words of preamble"}
2. {Specific change}
3. {Specific change}
4. {Specific change}
5. {Specific change}

## Recommended next step
Re-run `seo-geo` on this URL in 30 days after applying the recommendations. AIO indexes update on a monthly cadence — citation changes show up there first.
