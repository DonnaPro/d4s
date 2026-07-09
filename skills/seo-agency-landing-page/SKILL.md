---
name: seo-agency-landing-page
description: Generate a demand-gen landing page for an SEO agency, complete with pain-point hook, proof, a free-audit lead magnet flow, and CTAs tuned for cold traffic. Pulls real competitive and AI-search data for the agency's target niche to make the copy specific and credible. Use when the user asks for an SEO agency landing page, lead-gen page for an SEO agency, demand-gen page, free-audit landing page, or wants to convert cold traffic into discovery calls.
---

> Example output: [examples/seo-agency-landing-page-saas-founders-20260514/copy.md](../../examples/seo-agency-landing-page-saas-founders-20260514/copy.md)

# Agency Landing Page

Produce a production-ready landing page for an SEO agency offering a free audit as the lead magnet, with the audit promise backed by a real data workflow, not just copy.

## Prerequisites

- DataForSEO MCP server connected.
- User provides: (a) agency name, (b) target vertical or niche the agency serves (e.g., "SaaS", "local dentists", "DTC ecommerce"), (c) the agency's website or positioning, and optionally (d) a sample client domain to pull real numbers from for case-study copy.

## Process

1. **Niche data pull** `dataforseo_labs_google_domain_rank_overview`, `dataforseo_labs_google_competitors_domain`, `serp_organic_live_advanced` (AI overview items are in the response)
   - Market: per CLAUDE.md defaults (UK unless the user specifies). Set `limit` + filters on Labs calls per CLAUDE.md.
   - If a sample client domain was provided, pull their organic traffic, top competitors, and AI Overview exposure.
   - Extract 3 concrete, pitchable numbers for the page (e.g., "agencies in this niche average 12k organic visits/mo. Top performers average 180k.").

2. **Pain-point discovery**
   - Use niche-level findings to identify the 3 most acute SEO pains for this vertical (e.g., AI Overviews eating top-of-funnel traffic, cannibalisation in product pages, thin category pages).
   - Each pain becomes a section of the page.

3. **Offer construction**
   - Primary offer: a free 5-minute automated SEO audit delivered to their inbox.
   - Secondary offer: book a 30-minute strategy call once audit is received.
   - Lead form: 3 fields max (name, work email, domain).

4. **Proof layer**
   - Case-study placeholder blocks with real metric deltas (user fills names).
   - Logo bar (user fills with 4-6 clients).
   - A "data snapshot" block that uses the real numbers from step 1 (builds trust instantly).

5. **CTA and urgency**
   - Above-the-fold CTA.
   - Mid-page CTA after social proof.
   - Final CTA after FAQ.
   - Urgency: "We cap free audits at {n}/month" (user fills n).

6. **Generate the page** (see Output Format).

## Output format

Create a folder `output/seo-agency-landing-page-{target-slug}-{YYYYMMDD}/` with:

```
output/seo-agency-landing-page-{target-slug}-{YYYYMMDD}/
├── 01-niche-data.md      # the real numbers pulled in step 1
├── 02-pain-points.md     # the 3 pains used in copy
├── index.html            # self-contained HTML page (uses the site's CSS stack, or minimal inline styles)
├── copy.md               # the copy alone, markdown, for CMS paste
└── README.md             # how to customise and deploy
```

`copy.md` is the page copy in markdown: hero (headline / subhead / hook / CTA + microcopy), Section 1 (the 3 niche pains with real numbers from step 1), Section 2 (what the free audit covers), Section 3 (why {agency} + proof + logo bar), Section 4 (how it works), FAQ, and a final CTA with spots-left urgency. Full skeleton: `templates/report.md`.

`index.html` is a self-contained page with:
- **The site's existing CSS stack.** If the agency's site uses Tailwind, Bootstrap, or a house stylesheet, match it. If there is no existing stack (or none is provided), inline a minimal stylesheet in a `<style>` block — do NOT hard-require a CDN framework.
- Semantic HTML, no JS frameworks.
- A real HTML form POSTing to a configurable endpoint (placeholder `action="REPLACE_WITH_FORM_ENDPOINT"`).
- OG tags for social sharing.
- A CTA button that scrolls to the form.

> **Form endpoint:** Replace `REPLACE_WITH_FORM_ENDPOINT` with a webhook from Netlify Forms, Formspree, or a Zapier catch hook. If none is configured, leave the placeholder and flag it in the deliverable's README so the user knows to set it before publishing.

`README.md` explains:
- How to fill in client logos and case-study numbers.
- How to wire the form to a real audit backend (link to DataForSEO audit API or the agency's own tool).
- How to deploy: Netlify, Vercel, or drop into any static host.
- How to A/B test the hero headline.

## Tips

- Respect DataForSEO Data API rate limit: 10 requests per second. Iterate sequentially.
- The page lives and dies by the hook. Specific numbers beat generalities. "You are losing 18% of top-funnel traffic to AI Overviews" beats "AI is changing SEO".
- Do not promise what the agency cannot deliver. If the free audit is limited to the first 100 URLs, say so on the page.
- Mobile-first. Hero fits on one iPhone screen.
- The lead-magnet audit should itself be an automated workflow, not a promise. Chain with the `seo-drift` skill as the delivery mechanism.
- Do not add stock photography. Real screenshots of actual audit outputs convert better.
- If the agency has no case studies yet, use aggregate data (e.g., "Agencies like ours typically lift organic traffic by 40-80% in year one") with a clear disclaimer, not fake numbers.
