---
name: seo-backlinks-profile
description: Full backlink profile for a domain — referring domains, anchor text distribution, authority distribution, IP and subnet diversity, growth/decay trend, toxic-candidate flagging. Distinct from `seo-backlink-gap` (which is gap-vs-competitor only). Produces a profile health score and reviewable disavow candidate list (never auto-disavow). Use when the user asks "backlink profile", "link profile audit", "anchor distribution", "toxic links", "disavow candidates", or "backlink health".
---
> Example output: [examples/seo-backlinks-profile-stripe-com-20260514/PROFILE.md](../../examples/seo-backlinks-profile-stripe-com-20260514/PROFILE.md)

# Backlinks Profile

A complete backlink profile audit for a domain. Surfaces composition (where do links come from?), quality (what's the authority distribution?), diversity (concentrated in a few IPs/subnets, or spread out?), trajectory (growing or decaying?), and risk (which links look manipulative?). Output includes a health score and a reviewable disavow-candidate list — never an auto-disavow.

## Prerequisites

- DataForSEO MCP server connected.
- User provides: a target domain.
- Claude's `WebFetch` tool optional (for spot-checking flagged toxic candidates).
- `mcp__firecrawl-mcp__firecrawl_scrape` optional (for the new step 8b — link-source verification).

## Process

1. **Validate target & preflight.** See `skills/seo-firecrawl/references/preflight.md` for the canonical 3-stage preflight (Firecrawl availability, Google APIs). Skill-specific notes:
   - Normalise domain before continuing.
   - Firecrawl: optional. When `--verify-sources` is passed, step 8b (link-source verification) scrapes top-20 referring domains' linking pages to verify each link is still present and what `rel` it carries (dofollow / nofollow / sponsored / UGC), ~20 Firecrawl credits per run. Default off; pass `--no-firecrawl` to skip even if available.
   - Google APIs: not used.

2. **Profile summary** `backlinks_summary`
   - Total backlinks, total referring domains, dofollow/nofollow ratio, link-type distribution (text / image / form / frame), growth velocity over the last 30/90 days.

3. **Referring domains** `backlinks_referring_domains` (`limit: 100, order_by: ["rank,desc"]`)
   - Top referring domains by authority. Pull authority score, link count per domain, domain TLD, country.
   - **Small-profile guard:** if the total referring-domain count (from step 2) is under 50, the profile is too small for meaningful distribution statistics. Skip the authority histogram (step 5) and IP/subnet diversity scoring (step 6), and set the `PROFILE.md` verdict to `profile too small to score (<50 referring domains)` — report the raw numbers only, no health score.

4. **Anchor distribution** `backlinks_anchors` (`limit: 100`)
   - Top anchor texts by frequency.
   - Classify each anchor: branded (contains brand name), exact-match commercial (the target's primary commercial keyword), partial-match, generic ("click here", "read more", "this page"), naked URL, image-alt-derived.

5. **Authority distribution** `backlinks_bulk_ranks`
   - Histogram of referring-domain authority: how many Domain Rank 0-9, 10-19, 20-29, etc.
   - A healthy profile has a long tail; an unhealthy profile is concentrated at Domain Rank <10.

6. **IP and subnet diversity** `backlinks_referring_networks`
   - Total unique IPs hosting referring domains.
   - Total unique /24 subnets.
   - Compute concentration ratio: `referring_domains / unique_subnets`. Healthy: ~3–10. Unhealthy: many domains share few subnets (PBN signal).

7. **Growth / decay trend** `backlinks_timeseries_new_lost_summary`
   - Net new backlinks per month (last 6 months).
   - Net new referring domains per month.
   - Velocity changes — sharp spikes or sharp losses both deserve flags.

8. **Lost links list** `backlinks_backlinks` (`filters: [["is_lost","=",true]], limit: 50`), `backlinks_bulk_new_lost_referring_domains`
   - Sample recent losses. Are any high-authority losses?

8b. **Optional: live link-source verification** `mcp__firecrawl-mcp__firecrawl_scrape`
   - Triggered only when `--verify-sources` is passed (default off — credit-conscious).
   - For the top 20 referring domains by authority (from step 3), pick the highest-authority linking page per domain. Scrape each (20 Firecrawl credits typical).
   - For each scrape, parse the returned `html` for `<a href>` matching the target domain. Capture: link still present (`true`/`false`/`page-404`), `rel` attribute (`dofollow` if absent or empty, else the literal value: `nofollow`, `ugc`, `sponsored`, or combinations), surrounding context (anchor text + 50 chars before/after).
   - Surface mismatches against the DataForSEO-reported state in `evidence/08b-source-verification.md`:
     - Link gone — DataForSEO still reports it as live (lag/error).
     - `rel` attribute differs from what DataForSEO flagged.
     - Source page returns non-200.
   - Feeds into step 9: a verified-gone link or `rel=nofollow` discovered post-hoc upgrades the toxic-candidate signal for that referring domain.
   - **If Firecrawl unavailable (or flag not passed):** skip entirely. DataForSEO's reported state remains the source of truth for all non-verified steps.

9. **Toxic candidate detection** (heuristic — see `references/health-heuristics.md` for the rules)
   - Apply the toxic heuristic to the referring-domain list.
   - Flag candidates. Each row gets a `risk_score` and `triggers` (which heuristic rules fired).
   - **Never auto-disavow.** Output is a reviewable list, not an action.

10. **Synthesise** `PROFILE.md`

## Output format

Create a folder `output/seo-backlinks-profile-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-backlinks-profile-{target-slug}-{YYYYMMDD}/
├── PROFILE.md                       (synthesised report — primary deliverable; inlines summary, authority distribution, diversity, trend)
├── 02-referring-domains.md          (top N with authority — load-bearing reference for outreach/audit)
├── 03-anchors.md                    (anchor distribution + classification — load-bearing reference)
├── disavow-candidates.csv           (toxic-flagged rows for review — load-bearing CSV)
└── evidence/
    ├── 01-summary.md                (backlinks_summary top-line — raw step output)
    ├── 04-authority-distribution.md (histogram — raw step output)
    ├── 05-diversity.md              (IPs + subnets + concentration — raw step output)
    ├── 06-trend.md                  (last 6 months new/lost — raw step output)
    ├── 07-losses-sample.md          (recent lost backlinks)
    └── 08b-source-verification.md   (only if --verify-sources ran: live link + rel attribute checks for top-20 sources)
```

Step files 01, 04, 05, 06 are inlined as sections in `PROFILE.md`; the copies in `evidence/` preserve raw step output for reproducibility. `02-referring-domains.md`, `03-anchors.md`, and `disavow-candidates.csv` stay at top level — outreach/audit teams consult them directly.

`PROFILE.md` structure: header → Health score /100 (5 dimensions ×20: authority distribution, anchor diversity, IP/subnet diversity, growth trajectory, toxic ratio) → Top-line numbers → Authority distribution histogram → Anchor distribution (with healthy ranges + status) → Trend (last 6 months) → Toxic candidates (top 10 + NEVER AUTO-DISAVOW warning) → Recommended next steps. Load `templates/report.md` for the full mock when writing the deliverable.

`disavow-candidates.csv` columns: `domain,domain_rank,backlinks_count,sitewide_links,top_anchor,anchor_class,risk_score,triggers,sample_url`

## Tips

- Respect DataForSEO API rate limit. The endpoints in steps 2–8 are ~15 calls; pace sequentially.
- Optional step 8b adds 20 Firecrawl credits when `--verify-sources` is passed (one scrape per top-20 source domain).
- The toxic-candidate rules and profile-health ranges (anchor / growth / disavow guidance) live in `references/health-heuristics.md`.
- Pair with `seo-backlink-gap` for prospecting (gap analysis vs competitors).
- Pair with `seo-drift` to track profile composition over time.
