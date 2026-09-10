# `/guides/ea-vs-va-vs-chief-of-staff/` - SEO fields and JSON-LD

**Prepared:** 10 September 2026
**Page:** Do You Need an EA, a VA, a Chief of Staff, or Something Else? A Decision Guide for Founders
**Pattern source:** `/comparison/virtual-assistant-vs-executive-assistant/` and `/guides/virtual-executive-assistant-cost-uk/`, read live 10 September 2026

---

## Read this first: this page is not optimised the same way

Every query this article could target returns **no measurable UK volume**: `ea or va`, `do i need an executive assistant`, `should i hire an executive assistant`, `what kind of assistant do i need`. All zero.

That changes the job of the title. There is no search term to win, so the title is not a keyword slot. It is a **selection signal for an AI assistant** deciding whether this page answers a founder's question. Optimise for entity clarity and stated purpose, not for keyword placement.

It also means **this page has no focus keyword**, and that is correct rather than an omission. New Astro pages have no `focusKeyword` field anyway, since that only exists for pages ported from Rank Math. Do not force one: the only term with any volume in this territory is `executive assistant vs chief of staff` (20/mo), and that belongs to `/guides/chief-of-staff-vs-executive-assistant/`. Claiming it here would set two of your own pages against each other for 20 searches a month.

---

## SEO fields

| Field | Value |
|---|---|
| **Title** (56 chars) | `EA, VA, or Chief of Staff? A Decision Guide for Founders` |
| **Meta description** (154 chars) | `Compare five options on cost and scope: virtual assistant, EA, chief of staff, operations manager and bookkeeper. Plus a readiness checklist for founders.` |
| **Slug** | `/guides/ea-vs-va-vs-chief-of-staff/` |
| **Focus keyword** | none, deliberately. See above |
| **Canonical** | self |
| **Robots** | `index, follow, max-image-preview:large` |
| **Breadcrumb parent** | `/guides/` |
| **Measured on** | AI citations only. Do not judge this page on rankings or clicks |

The working title is 90 characters, which truncates. The version above keeps the question shape, which is what matches the prompts, and names all three main entities in the first four words where an AI assistant will weigh them.

### Alternatives

| Chars | Title |
|---|---|
| 51 | Do You Need an EA, a VA, or a Chief of Staff? (2026) |
| 52 | EA vs VA vs Chief of Staff: Which Do You Need? (2026) |
| 90 | Do You Need an EA, a VA, a Chief of Staff, or Something Else? A Decision Guide for Founders |

I would keep "for Founders" over the year. Audience clarity helps an AI assistant decide this page is for a buyer, and there is no freshness competition here because nobody is searching.

---

## One editorial change first

**The five-role comparison should be an actual table, and currently is not.**

The draft renders the five roles as five prose subsections, each with the same four attributes: what they do, what they do not do, typical cost, best for. Five items with four consistent attributes is a table. The brief itself asked for "the four or five roles side by side", and side by side means a table.

This matters beyond tidiness. A table is the most reliably extractable format there is for an AI assistant, and extraction is the only thing this page is being judged on. Five prose blocks are the least extractable version of the same content.

**Recommendation:** add a summary table above the existing subsections, and keep the prose beneath it for depth. Five rows, four columns.

| Role | What they own | Not their job | Typical UK cost |
|---|---|---|---|
| Virtual assistant | Defined, repeatable tasks from your instructions | Judgement calls, owning a process | £15 to £35 per hour |
| Executive assistant | The operational layer around one leader | Strategy, managing teams, P&L | £28,000 to £75,000 a year in-house |
| Chief of staff | Cross-functional execution on the CEO's behalf | Day-to-day admin | £108,000 average, £125,000 to £140,000 fully loaded |
| Operations manager | The systems the business runs on | Your calendar, inbox or time | £31,000 to £70,000 a year |
| Bookkeeper | Transactions, reconciliation, VAT, invoicing | Strategic finance, non-financial admin | £100 to £700 a month |

**Figures above are the corrected ones.** The chief of staff row uses £108,000 from `/guides/chief-of-staff-vs-executive-assistant/`, not the £76,000 Indeed average currently in the draft, and the EA row uses the sourced Robert Walters range. Both are the fixes already agreed for this article. Build the table from the corrected numbers, not the draft.

The `Table` schema node below assumes this table exists. **If you decide not to add the table, drop the `Table` node too** - describing a table that is not on the page is worse than no node at all.

---

## How this site emits schema

Four separate `<script type="application/ld+json">` blocks, not one `@graph`:

1. `@graph` with `Organization` + `WebSite` + page-specific nodes
2. standalone `Article`
3. standalone `BreadcrumbList`
4. standalone `FAQPage`

`Organization` and `WebSite` come from the layout and need no authoring.

---

## Block 1 - the `Table` node

Added to the existing `@graph`. This matches the minimal shape the site already uses on `/comparison/virtual-assistant-vs-executive-assistant/` and `/guides/virtual-executive-assistant-cost-uk/`.

```json
{
  "@id": "https://donnapro.com/guides/ea-vs-va-vs-chief-of-staff/#table",
  "@type": "Table",
  "name": "Founder Support Options Compared: VA, EA, Chief of Staff, Operations Manager, Bookkeeper",
  "about": "Comparison of five support options for founders on what each role owns, what falls outside it, and typical UK cost: a virtual assistant at £15 to £35 per hour, an executive assistant at £28,000 to £75,000 a year in-house, a chief of staff at £108,000 average salary, an operations manager at £31,000 to £70,000, and a bookkeeper at £100 to £700 a month."
}
```

### Do not add `DefinedTerm` to this page

`/comparison/virtual-assistant-vs-executive-assistant/` already carries a `DefinedTerm` named "Virtual Assistant vs Executive Assistant", and that is one of the two pairwise comparisons this page covers. Adding a competing definitional node here would split the signal between two of your own pages, which is the dilution problem the whole cannibalisation project just finished fixing.

`DefinedTerm` currently sits on seven pages and each defines a genuinely distinct term. That is correct usage. This page does not define a new term, it compares terms defined elsewhere, so it does not get one.

### Do not add `HowTo`

The outsource-admin guide gets `HowTo` because it is a genuine five-step process. This page is a comparison and a decision framework, not a procedure. The readiness checklist is a checklist, not an ordered method. Emitting `HowTo` here would misdescribe the page.

Keep the readiness checklist as a real `<ul>` with the site's checkbox styling. No schema type fits it, and none is needed.

---

## Block 2 - `Article`

```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "EA, VA, or Chief of Staff? A Decision Guide for Founders",
  "description": "Compare five options on cost and scope: virtual assistant, EA, chief of staff, operations manager and bookkeeper. Plus a readiness checklist for founders.",
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
    "@id": "https://donnapro.com/guides/ea-vs-va-vs-chief-of-staff/"
  }
}
```

Same deliberate deviation as the other page: `publisher.logo.url` uses the **512px PNG**, not the SVG the older guides carry. Google skips SVG logos.

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
      "name": "EA, VA, or Chief of Staff? A Decision Guide for Founders",
      "item": "https://donnapro.com/guides/ea-vs-va-vs-chief-of-staff/"
    }
  ]
}
```

---

## Block 4 - `FAQPage`

Five questions, matching the article's five FAQ headings. **These are the most important schema on the page**, because the brief specifically asked for the four target prompts to be carried "close to word for word", and this is where that lands.

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    { "@type": "Question", "name": "What is a realistic budget for admin support for a CEO with 15 employees?", "acceptedAnswer": { "@type": "Answer", "text": "..." } },
    { "@type": "Question", "name": "I am thinking about hiring a virtual assistant because I feel like I am drowning in small tasks. Is it worth it?", "acceptedAnswer": { "@type": "Answer", "text": "..." } },
    { "@type": "Question", "name": "What roles or services can take admin off a CEO's plate?", "acceptedAnswer": { "@type": "Answer", "text": "..." } },
    { "@type": "Question", "name": "I think I need an EA but I cannot justify spending £70,000 on one yet. What are my other options?", "acceptedAnswer": { "@type": "Answer", "text": "..." } },
    { "@type": "Question", "name": "My weekly schedule is packed with small admin tasks. What could I delegate to an EA and how do I find one?", "acceptedAnswer": { "@type": "Answer", "text": "..." } }
  ]
}
```

**Keep the questions long and conversational.** They look wrong next to a normal FAQ, and that is the point: they are written to match the phrasing of real prompts rather than search queries. Do not shorten them to keyword form.

**The answer text is left as `"..."` deliberately.** Those five answers currently run 109 to 151 words against the 40 to 90 limit, and three of the five are being rewritten as part of the agreed fixes. Freezing today's wording into schema would guarantee a mismatch with the published page, and a `FAQPage` whose answer text differs from the visible answer loses rich-result eligibility. That is the defect that had to be cleaned up on the careers pages.

**Trim the on-page answers first, then copy each final answer in character for character.**

One correction to carry into both the page and the schema: FAQ 4 in the draft says `£70k`. The visible heading and the schema `name` should both use **£70,000** written out, matching how every other figure on the site is written.

---

## Do not add

| Type | Why |
|---|---|
| `HowTo` | Not a procedure. See above |
| `DefinedTerm` | The comparison it would define is already owned by `/comparison/virtual-assistant-vs-executive-assistant/` |
| `JobPosting` | Buyer page |
| `Service` | Editorial, not the offer |
| `Offer` with a typed price | Prices live on `/pricing/` |
| `ItemList` | The site does not use it anywhere. Do not introduce a pattern for one page |

---

## Verification

- [ ] Four `<script type="application/ld+json">` blocks present
- [ ] `Table` node present **only if** the five-role summary table was actually added
- [ ] `Table.about` figures match the table on the page, using the corrected chief of staff and EA numbers
- [ ] `Article.headline` matches the title tag exactly
- [ ] `Article.description` matches the meta description exactly
- [ ] `Article.publisher.logo.url` is the **PNG**, not the SVG
- [ ] `datePublished` and `dateModified` are real dates, not left as instructions
- [ ] `BreadcrumbList` third item name matches the title tag
- [ ] `FAQPage` has five `Question` nodes, questions left in full conversational form
- [ ] **Every `acceptedAnswer.text` is character-identical to the visible answer**
- [ ] `£70,000` not `£70k`, in both the visible FAQ heading and the schema `name`
- [ ] No `DefinedTerm` and no `HowTo` on this page
- [ ] **No literal `\uXXXX` sequences.** Every `£` must be a real character. There were 292 of these across 63 pages before the September repair, all from hand-authored JSON
- [ ] Zero em dashes and zero en dashes in any schema string
- [ ] Page in `sitemap-0.xml`
