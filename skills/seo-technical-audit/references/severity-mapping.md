# Audit issue severity mapping

> Covers crawlability, indexability, security (incl. extended headers), mobile, structured data, content, performance, JS-rendering risks, and IndexNow. Guidance current as of 2026-05-01 — re-verify severity/fix advice against current search-engine documentation.

Maps common audit issue codes and issue names to severity, suggested fix, and effort estimate. Used by `seo-technical-audit` to score impact × effort and produce the top-10 fix list. This file also holds the **detection detail** (criteria, order, thresholds) for the security-header, JS-rendering, and IndexNow checks so the `SKILL.md` steps can point here instead of re-listing them.

## Severity scale

- **Critical** — site-breaking or major-traffic-loss potential. Fix today.
- **High** — significant ranking or indexation risk. Fix this week.
- **Medium** — quality-signal issue. Fix this month.
- **Low** — best-practice nudge. Fix when convenient.

## Effort scale

- **S** — config or template change, <1 hour.
- **M** — content or template work across multiple pages, <1 day.
- **L** — engineering work or content rewrite at scale, multiple days.

## Mapping

### Crawlability

| Issue | Severity | Fix | Effort |
|---|---|---|---|
| robots.txt blocking important resources (CSS/JS/images) | Critical | Allow CSS, JS, image directories in robots.txt | S |
| robots.txt 5xx error | Critical | Fix server config; ensure robots.txt returns 200 or 404 (never 5xx) | S |
| XML sitemap missing | High | Generate and submit sitemap; reference in robots.txt | M |
| XML sitemap not in robots.txt | Medium | Add `Sitemap:` directive to robots.txt | S |
| JS rendering blocking critical content | High | Server-side render critical content; ensure crawler-accessible | L |
| Crawl depth >5 for important pages | Medium | Add internal links from higher-traffic pages | M |
| Internal redirect chain >2 hops | Medium | Update internal links to final destination | S |

### Indexability

| Issue | Severity | Fix | Effort |
|---|---|---|---|
| Important page noindexed | Critical | Remove `noindex` from meta robots and X-Robots-Tag | S |
| Canonical points to different URL than self | High | Fix canonical to self-reference; or confirm intentional consolidation | S |
| Canonical to a 404 page | Critical | Update or remove canonical | S |
| Multiple canonicals on one page | High | Consolidate to one canonical tag | S |
| Hreflang return-tag mismatch | Medium | Ensure each hreflang variant points back to the original | M |
| Pagination noindexed (when shouldn't be) | Medium | Use rel=next/prev or self-canonical paginated pages | S |
| Orphan pages (no internal links) | Medium | Add internal links from relevant parent pages | M |

### Security

| Issue code | Issue | Severity | Fix | Effort |
|---|---|---|---|---|
| `http_not_https` | HTTP page (not HTTPS) | Critical | Redirect HTTP → HTTPS site-wide; update internal links | M |
| `mixed_content` | Mixed content (HTTPS page loading HTTP resources) | High | Update resource URLs to HTTPS or //protocol-relative | S |
| `hsts_missing` | Missing HSTS header | Medium | Add `Strict-Transport-Security` header | S |
| `cert_expired` | Expired or self-signed certificate | Critical | Renew certificate via the CA | S |
| `domain_mixed_case` | Mixed-case domain in canonical | Low | Normalise to lowercase | S |
| `csp_missing` | Content-Security-Policy header absent | Medium | Define a CSP policy (start with report-only, then enforce) | M |
| `xframe_missing` | X-Frame-Options header absent | Low | Add `X-Frame-Options: SAMEORIGIN` (informational; CSP `frame-ancestors` supersedes) | S |
| `xcontent_missing` | X-Content-Type-Options not set to `nosniff` | Low | Add `X-Content-Type-Options: nosniff` | S |
| `referrer_policy_missing` | Referrer-Policy header absent | Low | Add `Referrer-Policy: strict-origin-when-cross-origin` (or stricter) | S |
| `hsts_no_preload` | HSTS present but `preload` directive absent and domain not on Chromium HSTS preload list | Low | Add `preload` directive (`max-age≥31536000; includeSubDomains; preload`) and submit to hstspreload.org | S |

**Detection (extended security headers).** WebFetch the homepage plus 3 sample URLs (top-traffic landing pages; fall back to homepage + key pages), read the response headers and flag: `csp_missing` (no `Content-Security-Policy`), `xframe_missing` (no `X-Frame-Options` — informational, CSP `frame-ancestors` supersedes), `xcontent_missing` (`X-Content-Type-Options` not `nosniff`), `referrer_policy_missing` (no `Referrer-Policy`), `hsts_no_preload` (`Strict-Transport-Security` present but no `preload` directive AND domain not on the Chromium HSTS preload list). Surface in `evidence/02-issues-by-category/security.md` and inline into TECH-AUDIT.md "By category → Security".

### Mobile

| Issue | Severity | Fix | Effort |
|---|---|---|---|
| Viewport meta missing | High | Add `<meta name="viewport" content="width=device-width, initial-scale=1">` | S |
| Tap targets too small | Medium | Increase button/link size to 44×44 px minimum | S |
| Text too small to read | Medium | Increase base font size to ≥ 16px | S |
| Content wider than screen | Medium | Fix responsive layout; avoid fixed widths | M |

### Structured data

| Issue | Severity | Fix | Effort |
|---|---|---|---|
| Schema parse error | High | Fix JSON-LD syntax (commas, quotes, braces) | S |
| Required field missing | High | Add the required field per `schema.org` spec for the type | S |
| Schema describes hidden content | Medium | Remove the schema OR make the content visible | S |
| Multiple competing types on one page | Low | Use one primary `@type` per `<script>` block | S |

### Content

| Issue | Severity | Fix | Effort |
|---|---|---|---|
| Title tag missing | Critical | Add unique, descriptive `<title>` 50–60 chars | S |
| Title tag duplicate across pages | High | Make each title unique per page | M |
| Title tag too long (>60 chars) | Low | Trim to 50–60 chars; keep keyword in first 50 | S |
| Meta description missing | Medium | Add 150–160 char description | S |
| Meta description duplicate across pages | Medium | Make unique per page | M |
| H1 missing | High | Add exactly one descriptive H1 per page | S |
| Multiple H1s | Medium | Consolidate to one H1; demote others to H2 | S |
| H2-H6 hierarchy skipped levels | Low | Use levels in order (H1 → H2 → H3, no skipping) | S |
| Thin content (<300 words) on indexable page | Medium | Expand or noindex/consolidate | M |
| Duplicate content (>80% similarity across pages) | High | Consolidate; canonical to the primary; or differentiate | L |

### Performance

| Issue | Severity | Fix | Effort |
|---|---|---|---|
| Slow LCP (>2.5s on mobile) | High | Optimise hero image; reduce render-blocking JS | L |
| Slow INP (>200ms) | High | Reduce main-thread blocking; defer non-critical JS | L |
| Layout shift (CLS >0.1) | Medium | Set explicit width/height on images; reserve space for ads | M |
| Render-blocking JS in head | Medium | Defer or async non-critical scripts | S |
| Uncompressed images | Medium | Compress and convert to WebP/AVIF | M |
| Missing caching headers | Low | Add `Cache-Control` to static assets | S |

### JS Rendering (rendering-budget, hydration/canonical, CSR meta-drift, soft-404)

Four JS-rendering risks a static crawler / `on_page_instant_pages` can't see (it doesn't execute JS). Detected via Firecrawl in step 8 of `SKILL.md` by comparing initial HTML against the JS-rendered DOM.

**Detection.** Pick 5 sample URLs from the analysis set (bias toward high-traffic landing pages and pages already flagged for noindex/canonical issues). For each:
- `js_canonical_mismatch` — compare `metadata.canonical` (after JS render) against the canonical recorded in step 5; flag any divergence.
- JS-rendered `noindex` — check `metadata.robots` for `noindex` after render (catches client-side-only injection).
- `X-Robots-Tag` — read response headers from `metadata`; flag `noindex`/`nofollow`/`none` at the HTTP layer.
- `js_render_budget` — flag when rendered HTML is <50% of initial HTML size after JS execution.
- `js_csr_meta_drift` — diff initial-HTML `<title>`, `<h1>`, `<meta name="description">` against the JS-rendered DOM; flag any divergence.
- `js_soft_404` — flag rendered pages with <500 chars body text but HTTP 200.

| Issue code | Issue | Severity | Fix | Effort |
|---|---|---|---|---|
| `js_render_budget` | Rendering-budget cut: rendered HTML <50% of initial HTML size after JS execution (Google may stop rendering before main content loads) | High | Server-side render or pre-render critical content; reduce JS bundle so first paint contains the indexable content | L |
| `js_canonical_mismatch` | Hydration mismatch: `metadata.canonical` after JS-render differs from initial-HTML canonical (Google may use either; canonical decisions become non-deterministic) | High | Identical canonical in initial HTML and post-hydration DOM; never inject canonical client-side | M |
| `js_csr_meta_drift` | CSR pitfall: rendered title / H1 / meta description differ from initial HTML (these don't get indexed reliably; Google may use the empty initial values) | High | Serve final title / H1 / meta description in the initial server-rendered HTML rather than via JS injection | L |
| `js_soft_404` | Soft-404 from JS errors: rendered body content <500 chars but HTTP status is 200 (likely JS failed to render and Google sees an empty page treated as soft-404) | Critical | Return real 404 status when content is missing; add SSR fallback so failed JS doesn't strand the page on a 200 with no body | M |

### IndexNow

Bing/Yandex/Naver-only signal — Google does not honour IndexNow. Low-severity by default (Bing-only benefit), but configuration mismatches are a Medium issue because they advertise the wrong key to crawlers.

**Detection.** IndexNow advertises its key one of three ways — check in this order: (1) `/robots.txt` (already fetched in step 7) for an `IndexNow:` directive or comment referencing the key-file path; (2) homepage response headers for `x-indexnow-key`, `x-indexnow`, or `x-indexnow-key-location`; (3) WebFetch `/<key>.txt` if a key was hinted in (1) or (2). Detect the last-key-rotation date where possible via the key file's `Last-Modified` response header. Surface in `evidence/02-issues-by-category/security.md` (or a new `indexnow.md` if findings are non-trivial) and add a row to the TECH-AUDIT.md Modern signals section.

| Issue code | Issue | Severity | Fix | Effort |
|---|---|---|---|---|
| `indexnow_no_key` | Site doesn't ship `/<key>.txt` (no IndexNow key file detected at root) | Low | Generate an IndexNow key, host it at `/<key>.txt`, and reference it in submissions (Bing-only benefit; informational for Google-focused sites) | S |
| `indexnow_key_mismatch` | `/<key>.txt` content ≠ host header API key (the served key file disagrees with the key advertised in the `x-indexnow-key` header / robots.txt hint) | Medium | Sync the file content with the advertised key; rotate if compromised | S |
| `indexnow_not_submitted_recently` | Site has key but no recent submissions detected (key file present but URLs not pushed to IndexNow endpoints) | Low | Wire up automated submission on publish/update (informational — confirms the integration is live) | S |

## Priority scoring

`priority_score = severity_weight × affected_pages / effort_weight`

- severity_weight: Critical=5, High=3, Medium=1, Low=0.5
- effort_weight: S=1, M=3, L=5

Top-10 fixes are the highest priority_score across all categories.
