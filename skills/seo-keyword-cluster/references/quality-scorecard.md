# Quality Scorecard (step 7)

Post-synthesis validation for a cluster plan. Run **after** `PLAN.md` is written and warn the user if any metric fails. Inspired by a post-execution scorecard model — adapted to our cluster-plan output: we score the *plan*, not generated content, since `seo-keyword-cluster` stops at the architecture.

## The four gates

- **Cannibalisation (zero tolerance).** No two clusters in the plan should share ≥ 40% SERP overlap with each other (computed from the cached SERP matrix in step 4). If two clusters trip this gate, re-merge them and re-run from step 5 onward.
- **Orphan (zero tolerance).** Every spoke article in the plan must be linked from its pillar in the internal-link map produced in step 5. Any spoke without an inbound link from its pillar is an orphan.
- **Coverage.** The pillar page in each cluster must cover ≥ 70% of the cluster's high-volume keywords (top half of the cluster by volume) in its primary keyword + secondary keyword set, or via the H2s drafted in step 5. Below 70% means the pillar is too narrow for the cluster it heads.
- **Anchor diversity.** Across all internal links inside a cluster (pillar↔spoke + spoke↔spoke), no single anchor text should be used > 40% of the time. Concentration above 40% is an over-optimisation signal.

## Output protocol

- If **all four** metrics pass, append a single line to `PLAN.md` under "## Quality scorecard":
  `All gates passed (cannibalisation/orphan/coverage/anchor-diversity).`
- If **any** metric fails, append a "## Quality scorecard" section to `PLAN.md` with red/yellow/green rows for each metric (red = fail, yellow = within 10% of threshold, green = pass), and annotate the verdict header at the top of `PLAN.md` with `(needs review — N quality-gate failures)`.
- Every run (pass or fail) also writes the same scorecard verbatim to `06-quality-scorecard.md` in the output folder so it is auditable independently.
