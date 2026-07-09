# IMAGES.md template

Full shape of the primary deliverable. Load this only when writing the final report.

```markdown
# Image SEO Audit: {URL or domain}

> Snapshot dated {YYYY-MM-DD} · Mode: {URL | domain-sample (n pages)} · Images analysed: {n}

## Coverage at a glance

| Metric | Result |
|---|---|
| Total images | {n} |
| Missing alt text | {n} ({pct}%) |
| Generic / templated alt text | {n} ({pct}%) |
| Modern format (WebP/AVIF) coverage | {pct}% direct, {pct}% via `<picture>` fallback |
| `srcset` present (responsive) | {pct}% |
| `loading` strategy detected | native: {pct}% · JS-loader: {pct}% · none: {pct}% |
| LCP image flagged | {yes/no — element + risk} |
| Unsized (CLS risk) | {n} ({pct}%) |
| `ImageObject` JSON-LD | {present / partial / missing} |

## Top 10 remediations (severity × byte savings)

| Rank | Issue code | Severity | Images | PSI wastedBytes | Fix | Effort |
|---|---|---|---|---|---|---|
| 1 | image_lcp_lazy | High | 1 | 480 KB | Remove `loading="lazy"`; add `fetchpriority="high"` | S |
| 2 | image_legacy_format | Medium | 14 | 2.1 MB | Convert to WebP, wrap in `<picture>` with fallback | M |
| ... |

## By category

### Alt text ({n} issues)
- {n} images missing `alt` entirely. See `02-remediation/alt-text-rewrites.md` for suggested rewrites.
- {n} images with generic alt (`image.jpg`, `photo`, "click here").
- {n} images with identical alt across multiple images (templating bug).

### Format coverage ({pct}% modern)
- {n} images stuck on legacy JPEG/PNG. See `02-remediation/picture-snippets.md`.
- {n} animated GIFs >500 KB — recommend video.

### Responsive sizing ({pct}% have `srcset`)
- {n} images without `srcset`.
- {n} images with `srcset` but no `sizes`.

### Lazy loading & LCP
- LCP candidate: `{img src or selector}` — {risk summary}.
- {n} below-fold images loading eagerly.
- {n} images missing `decoding="async"`.

### CLS dimensions ({n} unsized)
- {n} images without `width`/`height` attributes.
- {n} images with aspect-ratio mismatches.

### File names ({n} flagged)
- {n} camera-default names (IMG_xxxx).
- {n} hash-only filenames coupled with a missing/generic alt.

### ImageObject JSON-LD
- Currently present: {none | block-level on hero | partial}.
- Recommended additions: {none | hero-image ImageObject for licensable-images rich result}.

## Paste-ready remediations

See `02-remediation/`:
- `picture-snippets.md` — `<picture>` blocks for the top N legacy-format images.
- `alt-text-rewrites.md` — alt-text rewrites for missing / generic cases.
- `image-object.jsonld` — `ImageObject` block for the hero image.

## Out of scope for this skill

- **File-level optimisation** (running `cwebp` / `exiftool` / ImageMagick / `ffmpeg` against the actual binary). This skill audits markup and references; converting and re-uploading the files is engineering work — see `references/image-checks.md` § Optimisation pipeline for a starting recipe.
- **CSS background-images.** {n} likely background-image references detected via computed style, but not audited (see the caveat in the skill's step 2).
- **Site-wide audit at >10 pages.** This is a sampled audit. For domain-level "every image on every page", run `seo-technical-audit` first, then come back here for sample-level deep audit.

## Recommended next steps

- {`seo-technical-audit` if domain-wide image issues need to be quantified — uncompressed-images counts, etc.}
- {`seo-schema` if `ImageObject` was generated and the page also needs `Article` / `Product` / etc. markup.}
- {`seo-google pagespeed` for the full Lighthouse breakdown (this skill only pulls image-specific audits).}
```
