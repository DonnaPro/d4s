# `/guides/how-to-outsource-admin/` - SEO fields and JSON-LD

**Prepared:** 10 September 2026
**Page:** How to Outsource Your Admin as a CEO
**Pattern source:** `/guides/how-to-choose-executive-assistant-agency/`, read live 10 September 2026

---

## SEO fields

| Field | Value |
|---|---|
| **Title** (52 chars) | `How to Outsource Admin as a CEO: Step-by-Step (2026)` |
| **Meta description** (154 chars) | `How to outsource your admin as a CEO: the one-week audit, what to delegate first, who to hire, and what it costs in the UK. Recover 10 to 20 hours a week.` |
| **Slug** | `/guides/how-to-outsource-admin/` |
| **Focus keyword** | `outsource admin` |
| **Secondary** | `outsourced admin support`, `outsourced administration`, `virtual admin support`, `outsource administrative tasks` |
| **Canonical** | self |
| **Robots** | `index, follow, max-image-preview:large` |
| **Breadcrumb parent** | `/guides/` |

Guides on this site do not carry `| DonnaPro` in the title. Only service pages do. Keep it off.

**Keep out of the title:** "administrator", "admin jobs", "admin support jobs". `uk.indeed.com/q-outsourcing-administrator-jobs` ranks fourth on `outsource admin`, and this page must give Google no reason to read it as job content.

---

## How this site emits schema

Not one `@graph`. **Four separate `<script type="application/ld+json">` blocks:**

1. A `@graph` block carrying `Organization` + `WebSite` + the page-specific primary node
2. A standalone `Article` block
3. A standalone `BreadcrumbList` block
4. A standalone `FAQPage` block

`Organization` and `WebSite` are emitted by the layout and need no authoring. Only the `HowTo` node below gets added into block 1.

---

## Block 1 - the `HowTo` node

Added to the existing `@graph` alongside `Organization` and `WebSite`.

```json
{
  "@id": "https://donnapro.com/guides/how-to-outsource-admin/#howto",
  "@type": "HowTo",
  "name": "How to Outsource Your Admin as a CEO",
  "description": "A five-step process for CEOs outsourcing administrative work: auditing where the time goes, deciding what to hand off first, choosing the right type of support, setting it up, and measuring the result.",
  "step": [
    {
      "@type": "HowToStep",
      "name": "Audit what is actually taking your time",
      "position": "1",
      "text": "Log every task over 10 minutes for five working days, then sort them into work only you can do, work someone else could do with instructions, and work someone else could do without instructions. Most CEOs find 10 to 20 hours per week in the second and third groups."
    },
    {
      "@type": "HowToStep",
      "name": "Decide what to outsource first",
      "position": "2",
      "text": "Start with tasks that are recurring, time-consuming, and have a clear definition of done. Inbox management, calendar management and travel logistics deliver the largest immediate saving. Add meeting preparation, follow-ups, expenses and document work once the basics are running. Outsource bookkeeping and payroll to specialists rather than a generalist."
    },
    {
      "@type": "HowToStep",
      "name": "Choose the right type of support",
      "position": "3",
      "text": "A virtual assistant works from instructions you provide and suits defined, repeatable tasks. A managed executive assistant through an agency exercises judgement, anticipates what needs doing and owns processes end to end. An in-house hire makes sense only when you genuinely need 40 hours a week."
    },
    {
      "@type": "HowToStep",
      "name": "Set it up so it actually works",
      "position": "4",
      "text": "Define outcomes rather than steps, give your support access to the same tools you use, and establish a daily check-in for the first two weeks before moving to a weekly review. Expect the first two to four weeks to cost you time rather than save it."
    },
    {
      "@type": "HowToStep",
      "name": "Measure whether it is working",
      "position": "5",
      "text": "After 90 days, assess three things: hours recovered against your original audit, quality of output against the standard you need, and whether you are using the recovered time for strategic work or have refilled it with different admin."
    }
  ]
}
```

**Note `"position"` is a string**, not a number. That is this site's existing convention and the validator accepts it. Match it rather than "improving" it.

**Honest caveat on `HowTo`:** Google retired `HowTo` rich results in 2023, so this earns no visual treatment in search. It is worth keeping anyway, because the value here is clean machine-readable structure for AI assistants, which is this page's primary objective, and because five client guides on the site already carry it. Do not expect a SERP change from it.

**Do not add** `totalTime` or `estimatedCost` to the `HowTo`. Both would be invented figures.

---

## Block 2 - `Article`

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "How to Outsource Admin as a CEO: Step-by-Step (2026)",
  "description": "How to outsource your admin as a CEO: the one-week audit, what to delegate first, who to hire, and what it costs in the UK. Recover 10 to 20 hours a week.",
  "datePublished": "SET TO THE ACTUAL PUBLISH DATE, FORMAT 2026-09-DD",
  "dateModified": "SAME AS datePublished ON FIRST PUBLISH",
  "author": {
    "@type": "Person",
    "name": "Filip Pesek",
    "url": "https://donnapro.com/author/filip/"
  },
  "publisher": {
    "@type": "Organization",
    "name": "DonnaPro",
    "logo": {
      "@type": "ImageObject",
      "url": "https://donnapro.com/images/donnapro-logo-512.png"
    }
  },
  "mainEntityOfPage": {
    "@type": "WebPage",
    "@id": "https://donnapro.com/guides/how-to-outsource-admin/"
  }
}
```

**One deliberate deviation from the existing pages.** The comparable guides set the `publisher.logo.url` to `donnapro-logo.svg`. Google skips SVG logos, which is why the `Organization` node correctly uses the 512px PNG. The `Article` publisher logo should use the PNG too. I have used the PNG above. The SVG on the older guides is a pre-existing bug worth fixing sitewide in a separate pass.

**Optional improvement, not on the existing pages:** add an `image` property pointing at the hero image. Google prefers `Article` nodes to carry an image, and this article has two. It deviates from the current site pattern, so it is your call whether to introduce it here or sitewide.

---

## Block 3 - `BreadcrumbList`

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://donnapro.com/"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Guides",
      "item": "https://donnapro.com/guides/"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "How to Outsource Admin as a CEO: Step-by-Step (2026)",
      "item": "https://donnapro.com/guides/how-to-outsource-admin/"
    }
  ]
}
```

Note `position` is a number here, unlike in `HowToStep`. That is the site's existing inconsistency and both validate.

---

## Block 4 - `FAQPage`

Six questions, matching the article's six FAQ headings.

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    { "@type": "Question", "name": "How do I go about outsourcing my admin?", "acceptedAnswer": { "@type": "Answer", "text": "..." } },
    { "@type": "Question", "name": "What admin tasks can a CEO realistically outsource?", "acceptedAnswer": { "@type": "Answer", "text": "..." } },
    { "@type": "Question", "name": "How much does it cost to outsource admin support in the UK?", "acceptedAnswer": { "@type": "Answer", "text": "..." } },
    { "@type": "Question", "name": "Will I lose control of my business if I outsource admin?", "acceptedAnswer": { "@type": "Answer", "text": "..." } },
    { "@type": "Question", "name": "How long does it take for outsourced admin to start saving me time?", "acceptedAnswer": { "@type": "Answer", "text": "..." } },
    { "@type": "Question", "name": "I have tried outsourcing admin before and it did not work. What went wrong?", "acceptedAnswer": { "@type": "Answer", "text": "..." } }
  ]
}
```

**The answer text is left as `"..."` deliberately, and this matters more than it looks.**

Those six answers currently run 100 to 130 words each and the earlier review flagged them for trimming to the 40 to 90 word limit. If I froze the current wording into schema now, it would not match the published page, and a `FAQPage` whose answer text differs from the visible answer loses rich-result eligibility. That mismatch is exactly the defect that had to be cleaned up on the careers pages.

**So: trim the on-page answers first, then copy each final answer into the schema character for character.** Nothing added, nothing paraphrased.

Two specific things to strip from the answers before they go into schema:

- FAQ 1 and FAQ 6 contain `[LINK → /services/ "..."]` and `[LINK → /guides/how-to-hire-virtual-assistant-uk/ "..."]` markers. Those become real anchors in the visible HTML. The schema `text` value takes the **plain sentence with no markup**.
- The first question is written as *"How do I go about outsourcing my admin? I am a busy CEO and need support."* The second sentence is not a question. Use only the question itself in `name`, as above, and keep the fuller phrasing as the visible H3 if you want it.

---

## Do not add

| Type | Why |
|---|---|
| `JobPosting` | Buyer page. `JobPosting` belongs only on `/careers/executive-virtual-assistant-jobs/` and the twelve `/careers/location/*` pages |
| `DefinedTerm` | Nothing on this page defines a term the site does not already own elsewhere |
| `Service` | This is editorial, not the offer. `Service` belongs on `/virtual-executive-assistant/` and `/virtual-pa/` |
| `Offer` with a typed price | Prices live on `/pricing/`. Never hardcode one into schema |
| `Review` or `AggregateRating` | No first-party review data attached to this page |

---

## Verification

- [ ] Four `<script type="application/ld+json">` blocks present
- [ ] `HowTo` has exactly five `HowToStep` nodes, `position` as strings "1" to "5"
- [ ] `Article.headline` matches the title tag exactly
- [ ] `Article.description` matches the meta description exactly
- [ ] `Article.publisher.logo.url` is the **PNG**, not the SVG
- [ ] `datePublished` and `dateModified` are real dates, not left as instructions
- [ ] `BreadcrumbList` third item name matches the title tag
- [ ] `FAQPage` has six `Question` nodes
- [ ] **Every `acceptedAnswer.text` is character-identical to the visible answer on the page**
- [ ] No `[LINK →` markers survive anywhere in the JSON-LD
- [ ] **No literal `\uXXXX` sequences.** Every `£` in the answers must be a real character. The site had 292 of these across 63 pages before the September repair, and they came from exactly this kind of hand-authored JSON
- [ ] Zero em dashes and zero en dashes in any schema string
- [ ] `Rich Results Test` passes with `FAQPage` detected; `HowTo` will validate but shows no rich result, which is expected
- [ ] Page in `sitemap-0.xml`
