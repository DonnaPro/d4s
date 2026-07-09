# PLAN.md template

Primary deliverable for a seo-keyword-cluster run. Load only when writing the final plan.

```markdown
# Cluster Plan: {topic} {(needs review — N quality-gate failures) if step 7 flagged any}
Market: {market — per CLAUDE.md}
Seeds: {seed list}

## Summary
- Keywords analysed: {n}
- Clusters formed: {n}
- Estimated combined monthly volume: {n}
- Pillars: {n}, spokes: {n}
- Clustering method: SERP-overlap top-10 (serp_organic_live_advanced, depth 10, ~{n} calls)

## Build order

### Cluster 1: {cluster name} [PILLAR]
- Primary keyword: {kw} ({volume}/mo, KD {kd})
- Secondary: {list}
- Total volume: {n}/mo
- Priority score: {n}

#### Pillar page
- H1: {H1}
- H2s: {list}

#### Spoke articles
1. **{spoke title}**
   - H1: {H1}
   - H2s: {list}
   - Target keyword: {kw} ({volume})
2. **{spoke title}** ...

### Cluster 2: {cluster name} [SPOKE-ONLY]
...

## Internal linking map
- Pillar A links to: spokes A1, A2, A3
- Spoke A1 links back to: pillar A, and cross-links to spoke B2 (topical overlap)
...

## Quality scorecard
{If all four gates pass:}
All gates passed (cannibalisation/orphan/coverage/anchor-diversity).

{If any fail, render this table instead:}
| Gate | Status | Detail |
|---|---|---|
| Cannibalisation (no two clusters ≥40% SERP overlap) | RED / YELLOW / GREEN | {detail} |
| Orphan (every spoke linked from its pillar) | RED / YELLOW / GREEN | {detail} |
| Coverage (pillar covers ≥70% of cluster's high-volume keywords) | RED / YELLOW / GREEN | {detail} |
| Anchor diversity (no anchor used >40% of internal links per cluster) | RED / YELLOW / GREEN | {detail} |

## Raw data
- keywords.csv: full enriched keyword list
- 03-cluster-assignment.md: every keyword and its cluster (incl. SERP overlap matrix)
- 06-quality-scorecard.md: standalone copy of the scorecard above (evidence)
```
