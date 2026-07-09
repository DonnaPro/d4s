# ALTERNATIVES.md template — "Alternatives to X" listicle

Deliverable skeleton for an alternatives page. Load only when writing the draft. Position the user's brand as one of N (typically 5–10), not as a foregone #1 — numbered listicles convert better than self-promotional pages.

```markdown
# {N} Best {Competitor} Alternatives in {current year}

> Updated {YYYY-MM-DD}. {Competitor} is a strong {category} tool, but it isn't the right fit for everyone. Here are the {N} best alternatives, who each is for, and how they compare.

## TL;DR
{One paragraph: which alternative wins for which need. Name the user's brand honestly among the set, not above it.}

## How we picked
{One or two sentences on the comparison criteria — pricing, feature depth, best-fit use case. Builds trust.}

## At a glance

| Tool | Best for | Starting price | Free tier | Standout feature |
|---|---|---|---|---|
| {Competitor} (the baseline) | {use case} | {$X/mo} | {✓/✗} | {feature} |
| {User's Brand} | {use case} | {$Y/mo} | {✓/✗} | {feature} |
| {Alternative 3} | {use case} | {$Z/mo} | {✓/✗} | {feature} |
| ... | | | | |

## 1. {User's Brand or top alternative}
{2–3 balanced paragraphs: what it does well, where it falls short vs {Competitor}, who should pick it.}
- **Best for:** {use case}
- **Pricing:** {detail}
- **Watch out for:** {honest limitation}

## 2. {Alternative}
{...same structure per entry...}

## 3. {Alternative}
{...}

## {Competitor} itself — when to just stick with it
{Honest note on when {Competitor} remains the right choice. Reinforces balance.}

## FAQ
**{PAA question 1}**
{Answer}

**{PAA question 2}**
{Answer}

**{PAA question 3}**
{Answer}

## Get started
{User's Brand} CTA — {link}

## Schema
See `schema.jsonld` — paste into `<head>`. (Product ×N + BreadcrumbList + FAQPage if the FAQ is real Q&A; ItemList is appropriate for the ranked set.)
```
