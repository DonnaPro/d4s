# `/case-studies/` archive page: structure spec

**Prepared:** 29 September 2026
**Purpose of this document:** the layout and section-by-section spec for the case studies archive. Structure only, no copy.

---

## What this page is for

It is a **proof surface and a routing page**, in that order.

1. A link you send in proposals and follow-up emails, so a prospect can browse several stories rather than one.
2. A place a hesitant buyer lands from `/testimonials/`, the footer, or a link in a guide, and finds the story that matches their situation.
3. A holding page so `/case-studies/` does not 404 when someone truncates a URL.

It is **not** a page built to rank, and it should not be written as one. No 2,000-word introduction, no keyword section, no FAQ block. Every extra paragraph pushes the cards further down and costs you the only thing this page does.

**Target length: 350 to 600 words total, including all card text.**

---

## The governing principle

A buyer arriving here is asking one question: *"is there someone like me on this page?"*

They will scan, not read. So the page has to answer that question with **scannable cards keyed to recognition**, and every word spent before the first card is a word spent delaying the answer.

---

## Section by section

### 1. Hero

| | |
|---|---|
| Height | Keep it short. One screen maximum, ideally half |
| H1 | Names the content type plainly. "Client Stories" or "Case Studies" |
| Sub-line | One sentence, maximum 25 words. What these are and who they are from |
| No | Background video, large illustration, or anything that pushes the cards below the fold |

The first card should be **visible or half-visible without scrolling on desktop**. That is the single most important layout decision on this page.

### 2. Proof strip (optional, only if the numbers are real)

A single row of three or four aggregate figures directly under the hero.

Examples of what belongs here: number of clients supported, countries covered, average time from brief to placed assistant, average length of client relationship.

**Do not build this section with invented or rounded-up numbers.** If you do not have four figures you would defend in a sales call, skip the section entirely. A missing proof strip costs nothing. A soft one costs credibility on a page whose entire job is credibility.

### 3. Card grid

The core of the page. Everything above exists to get the reader here.

**Layout:** two columns on desktop, one on mobile. Not three, because each card carries enough text that three columns forces the type too small to scan.

**Each card contains, in this order:**

| Element | Notes |
|---|---|
| Client logo, or industry icon if anonymous | Small, top-left. Logos are the fastest trust signal on the page |
| Industry + country tag | e.g. "Ecommerce · UK". Small caps, muted |
| **Headline: the result, not the client name** | This is the key decision, see below |
| Context line | One sentence, maximum 20 words. Who they are and what they were facing |
| Assistant first name | "Supported by Saga". Humanises it and doubles as a recruitment signal |
| Link | "Read the full story". Whole card clickable |

**Why the result is the headline, not the client name.** A reader scanning eight cards does not recognise your clients by name. They recognise *situations* and *outcomes*. "Won a council tender with bid support from an EA" earns a click. "WUKA" does not. The client name still appears, on the logo and in the tag, where it does its trust job without costing the headline.

**Card order:** strongest evidence first, not newest first, and not alphabetical. Whichever case study has the most verifiable outcome goes top-left.

### 4. Filtering

**With five case studies, do not build filters.** Five cards fit on one screen and a filter row with three chips that each return one result looks thin and draws attention to how few you have.

**Build filters at eight or more.** When you do, filter by the two things buyers self-identify with:

- **Industry** (ecommerce, healthcare, property, professional services)
- **Challenge** (drowning in admin, no systems, scaling a second business, finance visibility)

Challenge-based filtering will outperform industry, because a founder's problem is more salient to them than their sector. Build both, default to challenge.

Client-side filtering only. No page reloads, no separate filtered URLs.

### 5. "Not seeing your situation?" block

One short block after the grid. Two or three sentences acknowledging that the published stories are a sample, with links to `/who-we-serve/` and `/get-started/`.

This catches the reader who scanned all the cards and did not find themselves, which will be most of them while there are only five. Without it, that reader has nowhere to go but back.

### 6. CTA

Use `Cta.astro` so it carries the smush hover-sweep, per the site convention.

One CTA, at the end. Not a sticky bar, not a mid-grid interruption. The cards are the persuasion; the CTA just catches whoever is already convinced.

---

## What must NOT go on this page

- A long introduction explaining what a case study is
- An FAQ block
- Testimonial quotes. Those live on `/testimonials/`. Duplicating them here blurs both pages
- Pricing
- A newsletter signup
- Anything that sits between the hero and the first card

---

## Build notes

| Item | Spec |
|---|---|
| URL | `/case-studies/` |
| Robots | `index, follow` |
| Sitemap | include |
| Nav | footer link. Not main nav while there are only five |
| Schema | `CollectionPage` with an `ItemList` of the case studies. Keep `Review` schema off this page, it belongs on `/testimonials/` |
| Body copy | `--text-size` token, per the design system |
| Section rhythm | standard hero 72 / section 76 |
| CTA | `Cta.astro` |
| Copy style | no em dashes, no en dashes, British spelling |

---

## How `/testimonials/` connects to it

`/testimonials/` stays the reviews page and becomes the promotion surface:

1. Promote the featured clients there from quote-sized to a short story block each: two or three sentences, one named outcome, logo, and a "Read the full story" link to `/case-studies/{slug}/`.
2. Keep the 50+ short quotes below. That volume is the page's real asset.
3. Leave its `Review` and `Rating` schema alone.
4. Add one link from `/testimonials/` to `/case-studies/` so the two pages are properly joined.

So `/testimonials/` shows breadth, `/case-studies/` shows depth, and each points at the other.
