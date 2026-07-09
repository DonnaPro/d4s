# Drift Report: {target}
> Baseline: {baseline date} · Current: {today's date} · Location/language: {location_code}/{language_code}

## RED — investigate today
- {finding} ({severity rationale})
- ...

## YELLOW — investigate this week
- {finding}
- ...

## GREEN — positive deltas
- {finding}
- ...

## Field-data drift (CrUX + URL Inspection)
- LCP p75: {baseline} → {current} ms ({Δ%}) {↑ red / ↑ yellow / stable / ↓ green}
- INP p75: {baseline} → {current} ms ({Δ%}) {…}
- CLS p75: {baseline} → {current} ({Δ absolute}) {…}
- Indexation status: {baseline INDEXED → current EXCLUDED} (URL mode)
- googleCanonical: {baseline → current} (if changed)
- (Or: `Field-data / indexation drift: not configured` / `not comparable — missing from {snapshot}`)

## What to investigate first
1. {prioritised action with reasoning}
2. ...
