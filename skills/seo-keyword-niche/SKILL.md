---
name: seo-keyword-niche
description: Mine longtail keywords + question keywords for a topic at scale to surface niche content opportunities. Outputs a content tier plan (template + URL pattern + sample pages + quality gates) suitable for programmatic publishing or steady editorial output. Distinct from `seo-keyword-cluster` (which plans pillar+spoke architecture from broad seeds) — this skill goes deeper into the long tail. Use when the user asks "longtail keywords", "question keywords", "niche content", "content opportunities at scale", "programmatic SEO", "content mining", or "what should I write about for {topic}".
---
> Example output: [examples/seo-keyword-niche-espresso-machine-reviews-20260514/KEYWORD-NICHE-PLAN.md](../../examples/seo-keyword-niche-espresso-machine-reviews-20260514/KEYWORD-NICHE-PLAN.md)

# Keyword Niche

Mine the long tail for content opportunities. Pulls longtail variants, question-intent keywords, related keywords, and SERP samples to find under-served niche keywords; clusters them by intent; proposes a content tier (template + URL pattern + sample pages + thin-content quality gates) that can be published programmatically or as a steady editorial cadence.

## Prerequisites

- DataForSEO MCP server connected.
- User provides: a seed topic (e.g. "running shoes", "tax preparation"), or 2–5 seed keywords. Market: per `CLAUDE.md` defaults (UK unless the user specifies another market). Optional: minimum volume threshold (default: 50/mo for niche skill — lower than `seo-keyword-cluster`'s 100), maximum KD (default: 40 for accessibility).

## Process

1. **Validate & preflight**
   - Confirm seeds make sense (not too broad, not branded, not single-letter).
   - See `skills/seo-firecrawl/references/preflight.md` (budget guard) and `CLAUDE.md` (market defaults, cost discipline). Typical DataForSEO calls: ~10–14 (Labs expansion across seeds + a handful of SERP samples). Firecrawl and Google APIs: not used.
   - **Cost discipline for all Labs calls in steps 2–4:** always pass `limit` and server-side `filters` — `filters: [["keyword_info.search_volume", ">=", {min_volume}], "and", ["keyword_properties.keyword_difficulty", "<=", {max_kd}]]`. Filter server-side; never pull thousands of rows to trim client-side. Cap the total candidate pool at ~1,000 keywords across all seeds — once reached, stop expanding.

2. **Longtail expansion** `dataforseo_labs_google_keyword_suggestions`
   - For each seed: pull longtail variants (typically 3+ words, lower individual volume, lower KD). Apply the `limit` + `filters` above (e.g. `limit: 300` per seed).
   - **Empty-result handling:** if a seed returns fewer than 20 suggestions, it is too narrow (or the filters are too tight). Widen the seed and/or lower `min_volume` / raise `max_kd`, retry once, and note the adjustment in the plan.

3. **Question expansion** `dataforseo_labs_google_keyword_ideas`
   - For each seed: pull question-phrased keywords. Apply `limit` + `filters` as above.
   - These are gold for content mining — explicit user intent in the keyword.

4. **Related expansion** `dataforseo_labs_google_related_keywords`
   - For each seed: pull related + similar keywords (with `limit` + `filters`).
   - Catches semantic neighbours that longtail expansion missed. (Do not re-call `keyword_suggestions` here — step 2 already covered it.)

5. **Filter and clean**
   - Remove keywords below `min_volume` and above `max_kd`.
   - Strip branded keywords the seed-domain doesn't own (unless the user supplied a branded seed).
   - Tag each keyword with detected intent: informational, commercial, transactional, navigational.
   - De-duplicate across seeds.

6. **SERP sample for representative keywords** `serp_organic_live_advanced`
   - For 5–10 representative keywords (one per emerging cluster), pull top 10.
   - Identify the dominant page type for each cluster (informs the template proposal in step 8).

7. **Cluster by intent + theme**
   - Group keywords by semantic similarity + intent.
   - Each cluster: name, primary keyword, supporting keywords, total volume, weighted KD, dominant page type.
   - Target 8–20 clusters (more granular than `seo-keyword-cluster`'s 5–12 — this skill is for niche tiers).

8. **Propose a content tier**
   - Template structure: which fields make each page unique. For `{city} apartment rentals`, the template fields are `{city}`, `{neighborhood}`, `{price_range}`, `{property_count}`. For `{tool} alternatives` it's `{tool}`, `{competitor_count}`, `{primary_use_case}`.
   - URL pattern: `/{category}/{slug}/` or `/{topic}/{tool}-alternatives/` etc.
   - Sample pages: 3 fully-spec'd page wireframes for representative cluster keywords.
   - Internal-linking automation: how to link pages within the tier (hub-spoke from a category page, or peer-to-peer for genuinely flat structures).

9. **Quality gates** (anti-thin-content guardrails)
   - Apply the full gate set from `references/quality-gates.md`: gates 1–5 always; gates 6–9 (programmatic-only) additionally whenever the proposed tier expects to ship 50+ templated pages. These gates are not negotiable — if the proposed tier can't pass them, the answer is fewer pages, not lower thresholds. Write the applicable gates into `07-quality-gates.md`.

10. **Synthesise** `KEYWORD-NICHE-PLAN.md`

## Output format

Create a folder `output/seo-keyword-niche-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-keyword-niche-{target-slug}-{YYYYMMDD}/
├── KEYWORD-NICHE-PLAN.md           (synthesised plan — primary deliverable)
├── keywords.csv                    (all enriched keywords with cluster + intent — load-bearing CSV the publishing team paste into CMS/sheets)
├── 06-template-spec.md             (fields, URL pattern, sample pages — load-bearing reference writers consult directly)
├── 07-quality-gates.md             (thin-content guardrails — load-bearing reference release-gate readers consult directly)
└── evidence/
    ├── 01-seed-expansion.md        (raw expansion per seed — raw step output)
    ├── 02-question-keywords.md     (dataforseo_labs_google_keyword_ideas)
    ├── 03-filtered-keywords.md     (post min-vol / max-kd filter)
    ├── 04-cluster-assignment.md    (every keyword and its cluster)
    └── 05-serp-samples.md          (top 10 for representative cluster keywords)
```

Top-level: `KEYWORD-NICHE-PLAN.md` + `keywords.csv` + `06-template-spec.md` + `07-quality-gates.md`. Writers consult the template spec directly when authoring; release gates consult the quality gates directly. The 01–05 step files preserve raw API/clustering outputs in `evidence/`.

`KEYWORD-NICHE-PLAN.md` structure: header (topic, date, market, seeds) → Inventory (mined / filtered / cluster counts) → Recommended content tier (template + URL pattern + required fields) → Cluster build order (top 10 by priority) → Quality gates checklist (references gates 1–9 in `references/quality-gates.md`) → Scaling estimate → Risks / monitoring → Recommended next step (10-page pilot first). Load `templates/report.md` for the full mock when writing the deliverable.

`keywords.csv` columns: `keyword,volume,kd,cpc,intent,cluster,role_in_cluster,dominant_page_type,unique_attributes_estimate`

## Tips

- Respect DataForSEO API rate limit. Steps 2–4 fan out across all seeds; pace sequentially.
- **Programmatic SEO is risky.** Pages that don't pass the unique-data threshold are dead weight at best, penalty bait at worst. The quality gates in step 9 are not optional.
- The pilot recommendation is critical. 10 pages with thoughtful templates outperform 1000 pages of templated mush.
- For e-commerce / inventory-driven content (city pages, product variations), the unique-data threshold is usually easy to hit.
- For "best X for Y" content (where Y has many variants), pick variants that have genuinely distinct content — don't templatise across near-synonyms.
- Pair with `seo-keyword-cluster` for the broader pillar+spoke architecture (this skill complements, not replaces).
- Pair with `seo-content-brief` to expand individual pillar topics into full editor briefs.
- Pair with `seo-technical-audit` after first 100 pages ship to catch any thin-content / canonicalization issues.
- Don't auto-publish. The template, URL pattern, and quality gates ship from this skill; the content authoring + review remains a human responsibility.
