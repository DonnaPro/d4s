# Passage citability criteria & GEO levers

Used by `seo-geo` step 5 to score each candidate passage, and to prioritise recommendations.

## Passage citability criteria (score each passage against these)

A passage is a paragraph that could be extracted standalone — a TL;DR box, a definition paragraph, a summary sentence after an H2. For each passage, score citability on:

1. **Complete thought in 1–3 sentences?** — an LLM can lift it without needing surrounding context.
2. **Answers a specific question?** — ideally the question its parent H2 implies.
3. **Contains a stat / number / named entity?** — concrete facts are cited far more than generalities.
4. **Has a clear timestamp or freshness signal?** — dated claims read as current and authoritative.

Score 0–10 per passage; strong passages hit all four, weak ones (vague generalities, no data, no date) are refresh candidates.

## The biggest GEO levers

When writing recommendations, these move citability the most, in rough priority order:

1. **Definitive answer in the first 200 words** — don't bury the answer below preamble.
2. **Specific stats with dates and sources** — quantified, attributable, current.
3. **Schema with author + dates** — `Article`/`BlogPosting` with valid `author`, `datePublished`, `dateModified`.
4. **Passage-level structure** — each H2 is a question; the first paragraph after each H2 is the answer.

Optimising for these should never come at the expense of human readability — the two reinforce each other when done right.
