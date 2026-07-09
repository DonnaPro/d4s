# seo-plan deliverable templates

Load this file only when writing the final deliverable. It holds the output-folder layout and the `PLAN.md` shape.

## Output folder layout

Folder `output/seo-plan-{domain-slug}-{YYYYMMDD}/`:

```
output/seo-plan-{domain-slug}-{YYYYMMDD}/
├── PLAN.md                              (synthesis — primary deliverable; inlines 01-baseline, 02-competitive-frame, 07-dependencies, 08-metrics as sections)
├── 04-phase-1-foundations.md            (load-bearing — owners share single phase files in standups)
├── 05-phase-2-build.md                  (load-bearing — owners share single phase files)
├── 06-phase-3-compound.md               (load-bearing — owners share single phase files)
└── evidence/
    ├── 01-baseline.md                   (where you are now — raw data inlined into PLAN.md)
    ├── 02-competitive-frame.md          (who you're actually competing with — raw data inlined into PLAN.md)
    ├── 03-pillar-scores.md              (technical / content / topical / AI Search — scoring math)
    ├── 07-dependencies-and-critical-path.md  (dependency map — inlined as PLAN.md section)
    └── 08-metrics.md                    (metric tables — inlined as PLAN.md section)
```

Top-level: `PLAN.md` + the three phase files (`04`/`05`/`06`). Owners share single phase files in standups, so phase files stay top-level rather than collapsing into PLAN.md. The verbatim-duplicate sections (baseline, competitive frame, dependencies, metrics) are inlined into PLAN.md but the raw step files are preserved in `evidence/` along with the pillar-scoring math.

## PLAN.md shape

```markdown
# SEO Plan: {domain}

> Plan dated {YYYY-MM-DD} · Horizon: {n} days · Business type: {type} · Market: {market}

## Where you are
- Organic keywords: {n} (trend: {up/down/flat over 12mo})
- Organic traffic estimate: {n}/mo
- Domain authority: {n}
- Referring domains: {n}
- Pillar scores: Technical {n|unscored}/100 · Content {n|unscored}/100 · Topical {n|unscored}/100 · AI Search {n|unscored}/100

## Lead theme
{The lowest pillar from step 5, plus a one-line "why this is the constraint." If specialists were not dispatched, the lead theme is "run discovery" and pillars are unscored.}

## Top 5 competitors
| Domain | DA | Organic kw | Top cluster they own |
|---|---|---|---|
| {comp} | {n} | {n} | {cluster} |

## Phase 1 — Foundations (weeks 1–4)

**Goal:** {1-line outcome, e.g. "remove technical debt blocking content investment"}

| # | Work item | Skill / source | Owner | Effort | Phase-end metric |
|---|---|---|---|---|---|
| 1.1 | {item} | `seo-technical-audit` follow-up | {role} | {S/M/L} | {metric} |
| 1.2 | ... | | | | |

**Phase exit criteria:** {what must be true to declare Phase 1 done}

## Phase 2 — Build (weeks 5–8)
{same shape}

## Phase 3 — Compound + measure (weeks 9–12)
{same shape}

## Critical path
{Ordered list of work items that block subsequent phases. Anything not on this list is moveable.}

## Metrics

| Metric | Type | Current | Phase 1 target | Phase 2 target | Phase 3 target |
|---|---|---|---|---|---|
| Organic traffic | Lagging | {n} | {n} | {n} | {n} |
| Pages with E-E-A-T >= 70 | Leading | {n} | {n} | {n} | {n} |
| Technical issue count | Leading | {n} | {n} | {n} | {n} |
| AI Search citation count | Leading | {n} | {n} | {n} | {n} |
| Referring domains | Leading | {n} | {n} | {n} | {n} |

## Constraints / caveats
{User-supplied constraints, plus anything the data flags — e.g., "DA gap to top competitor is 25 points; expect 6+ months for keyword parity."}

## Recommended next step
Run Phase 1 work items. After week 4, run `seo-drift compare` against the baseline captured today, then adjust Phase 2 scope.
```
