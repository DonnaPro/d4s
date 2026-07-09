# SUBDOMAINS.md template

Primary deliverable for a seo-subdomain run. Load only when writing the final report.

```markdown
# Subdomain Analysis: {root domain}

> Snapshot dated {YYYY-MM-DD} · Subdomains analysed: {n} of {n discovered} (limit: top {limit} by keyword count)

## Subdomain inventory

| Subdomain | Keywords | Traffic est. | Backlinks | Domain Rank | Top topics owned |
|---|---|---|---|---|---|
| {root} | {n} | {n}/mo | {n} | {rank} | {topics} |
| blog.{root} | {n} | {n}/mo | {n} | {rank} | {topics} |
| docs.{root} | {n} | {n}/mo | {n} | {rank} | {topics} |
| ... |

## Topic ownership map

| Topic cluster | Owned by | Also ranks (cannibalization?) |
|---|---|---|
| {topic 1} | blog.{root} (avg pos 3.2 across 47 keywords) | {root} (avg pos 12) — {⚠ cannibalization} |
| {topic 2} | docs.{root} | (none) |
| ... |

## Fragmentation flags

### {⚠ Cannibalization detected: topic = {topic X}}
- `blog.{root}` ranks {n} keywords for {topic X}, avg position {p}.
- `{root}` (root path) ranks {m} keywords for the same topic, avg position {p}.
- The two sets overlap on {k} exact keywords.
- **Recommendation:** consolidate to `blog.{root}` (the stronger ranker). 301 the root-path duplicates with intent preserved.

### ... (per fragmentation finding)

## Recommendations summary

- **Consolidate:** {n} subdomain pairs → see fragmentation flags above.
- **Split intentional and healthy:** {n} subdomains have distinct ownership; leave alone.
- **Investigate:** {n} edge cases flagged for human review.

## Risk notes

- Subdomain consolidation requires careful 301 redirect mapping; track via `seo-drift` after the migration.
- A subdomain with separate backlinks (per `evidence/05-backlinks-bulk.md`) is harder to consolidate without losing link equity — plan accordingly.

## Raw data
- See per-subdomain files under `evidence/03-keywords-by-subdomain/`.
- Topic ownership matrix: `06-topic-ownership-map.md`.
```
