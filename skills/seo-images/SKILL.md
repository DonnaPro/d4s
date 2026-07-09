---
name: seo-images
description: Image SEO audit for a URL or domain. Pulls raw image inventory via Firecrawl, then audits alt-text quality, modern-format coverage (WebP / AVIF), responsive sizing (`srcset` / `sizes`), lazy-loading and LCP signals (`loading`, `fetchpriority`, `decoding`), CLS-safe dimensions, descriptive file names, and `ImageObject` JSON-LD. Optional PageSpeed Insights cross-reference for real byte-saving estimates. Produces a prioritised remediation list plus paste-ready `<picture>` markup and `ImageObject` schema. Distinct from `seo-technical-audit` (which surfaces audit-flagged image issues at the site level) and from `seo-schema` (which generates page-level JSON-LD but not image-specific markup). Use when the user asks for "image SEO", "image audit", "alt-text audit", "WebP coverage", "AVIF", "responsive images", "lazy loading", "CLS images", "image schema", "ImageObject", "image rich results", "licensable images", or "optimise images".
---

# Image SEO Audit

A focused, page-level (or domain-sample) audit of every `<img>` and `<picture>` on the target. Surfaces alt-text issues, format gaps (WebP/AVIF coverage), responsive-image gaps (`srcset` / `sizes`), LCP and CLS risk, and missing `ImageObject` markup. Output is a prioritised remediation list plus paste-ready `<picture>` and JSON-LD snippets.

> **Adapted from [`AgriciDaniel/claude-seo`](https://github.com/AgriciDaniel/claude-seo)'s `seo-images` skill** (MIT). Rubric, lazy-loader taxonomy, and severity ladder track the upstream implementation; data sources are wired to this catalogue's DataForSEO / Firecrawl / Google APIs stack.

## Prerequisites

- **Required for inventory: any Firecrawl scrape capability** — the `mcp__firecrawl-mcp__firecrawl_scrape` MCP tool, the `firecrawl:firecrawl-scrape` skill, or the Firecrawl CLI all work; use whichever is available in the session. Raw HTML access is what matters: `WebFetch` returns markdown only, stripping every `<img>` attribute (`srcset`, `sizes`, `loading`, `fetchpriority`, `width`, `height`, `data-src*` lazy variants) before the skill sees it. If no Firecrawl scrape capability exists at all, tell the user the audit cannot run and surface the install hint (`bash extensions/firecrawl/install.sh`) — don't hard-require one specific tool id.
- **Optional (PSI byte-saving estimates):** `google-api.json` configured (Tier 0 — API key only). When present, step 9 runs and adds real Lighthouse `wastedBytes` per image to the remediation list. (Not configured on this machine — see `CLAUDE.md § Environment notes`.)
- **Optional (DataForSEO on-page cross-reference):** DataForSEO MCP server connected. When present, step 10 elevates image-related on-page issues onto the same remediation list.
- User provides: a target URL (single-page audit) or a domain (sampled audit). For domains, the skill confirms how many pages to sample before spending Firecrawl credits.
- Market: per `CLAUDE.md` defaults (UK unless the user specifies) for any DataForSEO calls.

## Process

1. **Validate target & preflight.** Normalise the URL (strip trailing slash, decode IDN). Resolve mode:
   - **URL mode** (default for inputs that look like a single page): the target is one URL. Cost: 1 Firecrawl credit + optional PSI calls.
   - **Domain mode** (input is a bare domain or the user explicitly asks for a domain-wide audit): map first, then scrape a sample.
   - **Preflight.** See `skills/seo-firecrawl/references/preflight.md` (budget guard, Firecrawl availability, Google APIs) and `CLAUDE.md` (market defaults, cost discipline). Skill-specific notes:
     - Typical DataForSEO calls for this skill: 0–2 (optional step 10 cross-reference; sampling helper in domain mode).
     - Firecrawl: **required** — any scrape capability counts (MCP tool, `firecrawl:firecrawl-scrape` skill, or CLI). Without it the audit cannot run; explain why and stop after surfacing the install hint.
     - Google APIs: Tier 0 (PSI, step 9) — optional; skip and note when not configured.

2. **Gather image inventory** (Firecrawl scrape in URL mode; map + scrape sample in domain mode)
   - **URL mode:** scrape the target with `formats: ["html", "markdown"]` and `onlyMainContent: false` (we want nav/footer images too — hero logo, footer trust badges, decorative imagery all matter for the audit). For SPAs, pass `waitFor: 2000` so lazy-injected images appear in the rendered DOM. Parse every `<img>` and every `<picture>` from the returned `html`. Capture per image:
     - `src`, `srcset`, `sizes`, `alt`, `loading`, `fetchpriority`, `decoding`, `width`, `height`, `role`, `aria-hidden`
     - Lazy-loader attributes and class signals per `references/lazy-loaders.md`'s taxonomy
     - Parent `<picture>` `<source>` entries: `type`, `srcset`, `media`
     - Resolved absolute URL (for cross-origin / CDN detection)
   - **Domain mode:** run `firecrawl_map` (default `limit: 500`, hard cap; cost: ~0.5 credit per discovered URL — surface the estimate before running). From the URL list, select a sample of up to 10 pages: homepage, plus the top traffic landing pages (from `dataforseo_labs_google_ranked_keywords`'s page aggregation if DataForSEO is connected — set `limit` and filters per `CLAUDE.md` — otherwise the deepest-nested URLs found in the sitemap). Confirm the sample list and credit cost before scraping. Then scrape each (1 credit per page). Inventory is the union of every image on the sampled pages.
   - **CSS background-images are a known blind spot** (this is the only place this caveat lives): `background-image: url(...)` in stylesheets is not audited — those aren't crawled as content images by Google and get no image-search visibility. Count likely occurrences and surface "{n} likely background-images detected — out of scope; review separately if hero/feature images are CSS-based" in the synthesis.

3. **Alt-text audit.** Apply `references/image-checks.md` § Alt text — every check, issue code, severity, and the good/bad examples live there. Evaluate each image against the full rubric (presence, decorative intent, generic text, length window, keyword stuffing, duplicate alts across the page).

4. **Format coverage (WebP / AVIF).** Classify each image's served format from the `src` extension and `<picture>` `<source>` `type` attributes, then compute three page-level (or sample-level) coverage metrics:
   - % images served as WebP or AVIF directly,
   - % images wrapped in `<picture>` with at least one modern-format `<source>`,
   - % images stuck on legacy formats with no modern alternative.
   Per-image flags (legacy format, oversized animated GIF, SVG misuse, oversized files): apply `references/image-checks.md` § Format hierarchy and § File size. For formats beyond WebP/AVIF (JPEG XL etc.), check caniuse for current browser support before recommending anything — don't rely on remembered support claims.

5. **Responsive coverage (`srcset` / `sizes`).** Apply `references/image-checks.md` § Responsive sizing to each non-SVG raster image (missing `srcset`, `srcset` without `sizes`, useless candidate ranges).

6. **Lazy loading & LCP signals**
   - Classify each image's lazy-loading mechanism using `references/lazy-loaders.md`'s taxonomy: `native` / `perfmatters` / `ewww` / `js-generic` / `none`. Report `lazy_method` alongside `loading` so a JS-loader-driven page isn't mis-flagged for missing `loading="lazy"`.
   - **LCP-candidate heuristic.** The LCP image is typically the first `<img>` that:
     - Appears above the fold on a typical mobile viewport (no exact viewport without rendering; heuristic = first `<img>` in the rendered DOM that is not inside a `<header>` / `<nav>` / `<aside>` and has no `loading="lazy"` ancestor),
     - Has a large rendered area (width × height attributes both ≥ 300, or `<picture>` `<source>` with viewport-spanning `sizes`).
   - Flag the LCP candidate and below-fold images per `references/image-checks.md` § Lazy loading & LCP (`image_lcp_lazy`, `image_lcp_no_fetchpriority`, `image_below_fold_eager`, `image_no_decoding_async`).

7. **CLS dimensions.** Apply `references/image-checks.md` § CLS dimensions (`image_unsized`, `image_aspect_mismatch`). The fix for both is the same: set `width`/`height` to intrinsic dimensions and let CSS scale responsively.

8. **File-name quality.** Extract the filename from each image's resolved URL and apply `references/image-checks.md` § File names — including its "don't flag every CDN-hashed filename" caveat; the signal matters when paired with a missing/generic alt on the same image.

9. **`ImageObject` JSON-LD: detect, validate, generate**
   - **Detect:** parse every `<script type="application/ld+json">` block returned by Firecrawl. Find existing `ImageObject` blocks — top-level or nested under `Article.image`, `Product.image`, `Recipe.image`, etc.
   - **Validate** against `references/image-checks.md` § ImageObject (required/recommended fields, common mistakes).
   - **Generate:** for each image that lacks an `ImageObject` block AND meets the "worth marking up" threshold (page hero / first-fold image with a clear creator/owner), produce a paste-ready block from `templates/image-object.json`, filling fields from the live HTML. Mark unresolved fields as `{REPLACE: ...}`. Emit as `02-remediation/image-object.jsonld`.
   - **Don't generate `ImageObject` for every `<img>`.** Limit to the hero image and any image that should be eligible for licensable-images rich results.

10. **Optional: PageSpeed Insights byte savings** *(only if `~/.config/seo-skills/google-api.json` is present, Tier ≥ 0)*
    - Run `python E:\DonnaProSEO\scripts\pagespeed_check.py "{url}" --strategy=mobile --json` and `--strategy=desktop --json` (2 API calls per target URL — within PSI's 25k/day free quota).
    - Pull the following audits from the JSON response and merge per-image `wastedBytes` into the remediation list: `modern-image-formats`, `uses-optimized-images`, `uses-responsive-images`, `offscreen-images`, `unsized-images`, `prioritize-lcp-image` (confirms or contradicts the step-6 LCP heuristic — PSI is authoritative), `efficient-animated-content`.
    - Each PSI audit returns `details.items[]` with `url` and `wastedBytes`. Join on resolved absolute image URL and tag each remediation row with `psi_wasted_bytes` so the prioritised list orders by real savings, not heuristic severity alone.
    - **If PSI is configured but returns no audits** (likely a 4xx — usually a private/protected URL Lighthouse can't load): note "PSI: could not analyse {url} ({reason})" and continue with non-PSI signals.

11. **Optional: DataForSEO on-page cross-reference** *(only if DataForSEO MCP is connected)*
    - Use `on_page_instant_pages` on the target URL (one URL per call — see `CLAUDE.md § DataForSEO cost discipline`) to retrieve on-page analysis results. If the URL hasn't been analysed recently (>30 days), skip this step rather than triggering a full crawl — that's `seo-technical-audit`'s call to make.
    - For each image-related issue in the on-page results (oversized/uncompressed images, missing alt, broken image URLs, images missing dimensions): merge findings. For any image flagged by both the on-page analysis and this skill, elevate severity by one step. For any analysis-flagged URL the Firecrawl sample didn't include, list it under "Analysis-flagged pages not in this sample" with a recommendation to re-run on those URLs specifically.

12. **Synthesise** `IMAGES.md`. Build the remediation table sorted by:
    1. Severity (Critical → High → Medium → Low),
    2. Within severity: PSI `wastedBytes` descending (when PSI ran), else affected-image count descending,
    3. Then alphabetical by issue code.

## Output format

Create a folder `output/seo-images-{target-slug}-{YYYYMMDD}/` (per `CLAUDE.md § Output conventions`) with:

```
output/seo-images-{target-slug}-{YYYYMMDD}/
├── IMAGES.md                       (synthesised audit + remediation list — primary deliverable)
├── images.csv                      (every image with all audit columns — engineering pastes into Jira)
├── 01-inventory.md                 (per-page image list with raw attributes)
├── 02-remediation/
│   ├── picture-snippets.md         (paste-ready <picture> blocks for the top N legacy-format images)
│   ├── alt-text-rewrites.md        (suggested alts for missing / generic-text cases)
│   └── image-object.jsonld         (generated ImageObject for the hero image, if applicable)
├── 03-psi-report.md                (PSI image-audit breakdown — only if Google APIs configured)
└── 04-audit-cross-ref.md           (image-related on-page analysis issues — only if step 11 ran)
```

`IMAGES.md` structure (load `templates/report.md` when writing the deliverable):
- Header line: snapshot date, mode (URL vs domain-sample), images analysed.
- "Coverage at a glance" metric table (alt coverage, modern-format %, srcset %, loading strategy, LCP flag, unsized count, ImageObject status).
- "Top 10 remediations" table ranked by severity × PSI byte savings.
- "By category" sections: alt text, format coverage, responsive sizing, lazy loading & LCP, CLS dimensions, file names, ImageObject.
- Pointers to the paste-ready files in `02-remediation/`, an "Out of scope" note, and recommended next steps.

`images.csv` columns: `page_url,image_url,alt,alt_length,alt_issue,format,in_picture,modern_source,srcset,sizes,loading,lazy_method,fetchpriority,decoding,width,height,unsized,lcp_candidate,filename_issue,psi_wasted_bytes,severity,fix,effort`.

## Tips

- **Default to URL mode.** Single-page audits are 1 Firecrawl credit and produce a complete deliverable for the most common ask ("audit the images on /this/page"). Domain mode is for "give me a representative read on the whole site" — it surfaces patterns (templating bugs, CMS-wide missing alts) that single-page mode misses.
- **`<picture>` is the right answer.** When recommending modern formats, always recommend the `<picture>` element with AVIF + WebP `<source>` and a JPEG fallback `<img>` — the fallback is what makes the markup safe for older clients and crawlers. Check caniuse for current support levels before recommending any format beyond WebP/AVIF.
- **Reverse the inventory if it's small.** For pages with <10 images, list every image with its full audit row in `IMAGES.md`'s "By category" section, not just the aggregate counts. Aggregate-only output hides the specifics below ~100 images.
- **PSI is rate-limited at 25k/day on the free tier** but counts requests, not images. Calling PSI twice per target URL (mobile + desktop) is the default; skip desktop if you only care about Google's mobile-first ranking signal.
- **Don't auto-apply fixes.** The skill diagnoses and produces paste-ready snippets; humans decide which fixes to ship and in what order.
- **Verify after deploy.** Re-run this skill on the same URL after the fixes ship — the new run's "Coverage at a glance" reflects the live state and confirms the markup actually changed (vs sitting in the CMS but not pushed).

## Works well with

- **Predecessors:**
  - `seo-firecrawl` — when the user already scraped a page and now wants the image-specific cut.
  - `seo-technical-audit` — when a site-wide audit flagged image issues and the user wants the deep per-image rubric.
  - `seo-page` — when a URL-level keyword/traffic verdict is "refresh" and images are part of the refresh.
- **Successors:**
  - `seo-schema` — when the page also needs `Article` / `Product` / `LocalBusiness` schema beyond `ImageObject`.
  - `seo-google pagespeed` — for the full Lighthouse report (this skill cherry-picks the image audits; PSI has 100+ more).
  - `seo-drift` — to baseline image markup and detect regressions after a CMS or theme upgrade.
