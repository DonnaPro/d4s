# Backlink profile health & toxic heuristics

Used by `seo-backlinks-profile` step 9 (toxic detection) and the health-score dimensions.

## Toxic-candidate rules (any 2+ triggers = candidate)

- Domain Rank < 10 (low-trust source).
- Sitewide link count > 5 (footer/sidebar links across many pages — manipulation signal).
- Exact-match commercial anchor on >50% of links from this domain.
- Hosted in a known link-farm subnet (when unique IPs / unique subnets ratio is heavily concentrated).
- Domain name is a non-pronounceable string of characters (very strong PBN signal).
- TLD is in the high-spam list (`.xyz`, `.click`, `.work` historically; verify against current spam-domain reports).

Never auto-disavow. Each flagged row gets a `risk_score` and the list of `triggers` that fired; the output is a reviewable list, not an action.

## Healthy anchor distribution

Branded should be the largest class (30–60%); exact-match commercial should be small (<5%) — over-optimised commercial anchors historically trigger link-spam penalties. Full per-class ranges:

| Class | Healthy range |
|---|---|
| Branded | 30–60% |
| Generic | 15–30% |
| Naked URL | 10–25% |
| Partial-match | 10–20% |
| Exact-match commercial | <5% (over that = over-optimised) |
| Image-alt-derived | <10% |

## Healthy growth

Steady 10–20% YoY referring-domain growth is the goal. Sharp spikes (>50% in a month) often indicate paid links and trigger algorithmic suspicion. Sharp losses deserve a flag too.

## Disavow conservatively

Removing links via outreach is preferred. Disavow only as a last resort; never disavow domains that send referral traffic. Disavow a domain only after confirming the link is manipulative AND the domain is not delivering referral traffic AND removal requests have failed.
