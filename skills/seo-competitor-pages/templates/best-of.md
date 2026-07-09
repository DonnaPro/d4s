# BEST-OF.md template — "Best X for Y" segmented page

Deliverable skeleton for a best-of page. Load only when writing the draft. Segment explicitly by use case / audience so the page wins multiple long-tail variants ("best {category} for solo developers", "…for enterprise teams", etc.).

```markdown
# Best {category} for {audience/use case} in {current year}

> Updated {YYYY-MM-DD}. The best {category} tools for {audience}, segmented by need. {N} picks, each with who it's for and what it costs.

## TL;DR
{One paragraph: the single best overall pick, plus the best pick for each major segment below.}

## How we evaluated
{One or two sentences on criteria. Builds trust and information gain.}

## At a glance

| Pick | Best segment | Starting price | Free tier | Standout |
|---|---|---|---|---|
| {Brand} | {segment} | {$X/mo} | {✓/✗} | {feature} |
| ... | | | | |

## Best overall: {Brand}
{2–3 balanced paragraphs.}
- **Best for:** {segment}
- **Pricing:** {detail}
- **Watch out for:** {honest limitation}

## Best for {segment 1 — e.g., solo developers}: {Brand}
{Why this pick wins for this segment specifically.}

## Best for {segment 2 — e.g., enterprise teams}: {Brand}
{...}

## Best for {segment 3 — e.g., budget-conscious}: {Brand}
{...}

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
See `schema.jsonld` — paste into `<head>`. (Product ×N + BreadcrumbList + FAQPage if the FAQ is real Q&A; ItemList for the ranked segments.)
```
