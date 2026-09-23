# Build brief: ADHD founders + Private Equity articles

**Prepared:** 23 September 2026
**For:** the Claude session building these in Astro
**Source docs:** Olivia's two drafts, reviewed in `18-review-adhd-and-private-equity.md`
**Scope:** one broken link, four link swaps, three copy corrections. No restructuring.

---

## House rules for anything you write here

No em dashes and no en dashes, use a spaced hyphen. No contractions. British spelling. Do not change wording outside the edits below. Prices stay as `[DONNAPRO PRICE EUR]` placeholders for Zoran to swap at build.

---

# PART 1: the fix that affects both articles

Both drafts link to `/guides/what-does-executive-assistant-do/`. **That URL returns 404.**

The correct page is `/guides/what-does-an-executive-assistant-do/`, with **"an"**.

**Find, in both articles:**
```
/guides/what-does-executive-assistant-do/
```
**Replace with:**
```
/guides/what-does-an-executive-assistant-do/
```

This is the fourth article carrying the wrong URL. If it lives in a saved link list, correct it there too.

---

# PART 2: ADHD founders article

## Link changes

The article has seven internal links. Every one currently points at a page that is already well linked. Two swaps fix that. Keep the total at seven.

| # | Section | Current target | Change to | Why |
|---|---|---|---|---|
| 1 | "why standard advice fails", final line | `/guides/ceo-delegation-playbook/` (5 links) | **`/guides/how-to-build-sops-to-delegate/`** (0 links) | The sentence is about the delegation system being something somebody else owns. That orphaned guide is exactly that |
| 2 | task capture | broken 404 | `/guides/what-does-an-executive-assistant-do/` | See Part 1 |
| 4 | "structure without rigidity", final line | `/comparison/virtual-assistant-vs-executive-assistant/` (9 links) | **`/ceo-insights/master-the-art-of-working-with-an-assistant/`** (0 links) | The sentence is about who owns the process and who participates. That orphaned article is about precisely that working relationship |

Links 3, 5, 6 and 7 stay as they are.

### Swap 1, exact

**Find:**
```
For ADHD founders, the delegation system itself needs to be something someone else owns [LINK → /guides/ceo-delegation-playbook/ "CEO delegation playbook"].
```
**Replace with:**
```
For ADHD founders, the delegation system itself needs to be something someone else owns, which is closer to [building a documented process](/guides/how-to-build-sops-to-delegate/) than to writing a brief.
```

### Swap 2, exact

**Find:**
```
The EA owns the process. The founder participates in it. That distinction matters [LINK → /comparison/virtual-assistant-vs-executive-assistant/ "how a VA compares to an EA"].
```
**Replace with:**
```
The EA owns the process. The founder participates in it. That distinction is the whole of [working well with an assistant](/ceo-insights/master-the-art-of-working-with-an-assistant/), and it matters more here than anywhere.
```

## Copy correction: the NIMH figure

Two problems in one sentence. The figure is **US** data collected **2001 to 2003**, presented as though current and European. And the clause after it has no source at all.

**Find:**
```
The National Institute of Mental Health puts adult ADHD prevalence at 4.4% among adults aged 18 to 44 (NIMH - https://www.nimh.nih.gov/health/statistics/attention-deficit-hyperactivity-disorder-adhd), but among founders and the self-employed, the concentration is significantly higher.
```
**Replace with:**
```
The National Institute of Mental Health puts adult ADHD prevalence at 4.4% among US adults aged 18 to 44, based on survey data collected between 2001 and 2003 (NIMH - https://www.nimh.nih.gov/health/statistics/attention-deficit-hyperactivity-disorder-adhd). The entrepreneurial skew sits on top of that baseline rather than replacing it: the research above found people with ADHD roughly twice as likely to take entrepreneurial action.
```

This keeps the point and removes the unsourced claim by leaning on the citation already two lines above it.

## One item for Olivia, not for the build

The answer box opens with "nearly twice as likely to start a business" attributed to Lerner, Verheul and Thurik. Springer blocks automated checking, so that wording could not be verified against the abstract. It is the article's opening claim, so it is worth one manual check of the paper's own phrasing before publication.

---

# PART 3: Private equity article

## Link changes

Six links, all to well-linked pages. One swap and one addition.

| # | Section | Current target | Change to | Why |
|---|---|---|---|---|
| 2 | delegation table, travel row | `/guides/ceo-delegation-playbook/` (5 links) | **`/guides/how-to-build-sops-to-delegate/`** (0 links) | Travel handled end to end is a documented process, which is what that orphan covers |
| 3 | scope boundaries | broken 404 | `/guides/what-does-an-executive-assistant-do/` | See Part 1 |
| new | cost section | - | **add `/ceo-insights/white-collar-repricing/`** (0 links) | The cost argument is about what a partner's hour is worth. That orphan is about exactly that repricing |

**Keep link 1 to `/who-we-serve/investment-virtual-assistant/` exactly as it is.** That one is deliberate: the guide feeds the service page rather than competing with it, which is the reason this article was approved. Do not remove or redirect it.

### Swap, exact

**Find:**
```
PE partners travel frequently and often at short notice. The EA manages the logistics end to end [LINK → /guides/ceo-delegation-playbook/ "CEO delegation playbook"].
```
**Replace with:**
```
PE partners travel frequently and often at short notice. The EA manages the logistics end to end, which works because the preferences live in [a documented process](/guides/how-to-build-sops-to-delegate/) rather than in the partner's head.
```

### Addition, exact

**Find:**
```
A managing partner whose time is measured in deal value recovered from 10 to 15 hours of admin per week is not saving money by doing it themselves. They are losing it [LINK → /pricing/ "DonnaPro pricing"].
```
**Replace with:**
```
A managing partner whose time is measured in deal value recovered from 10 to 15 hours of admin per week is not saving money by doing it themselves. They are losing it [LINK → /pricing/ "DonnaPro pricing"]. This is the same arithmetic behind [the repricing of senior professional time](/ceo-insights/white-collar-repricing/) across every advisory industry.
```

## Copy correction 1: the FCA statement

FAQ 3 states a legal interpretation as settled fact, to an audience whose compliance officers will read it closely.

**Find:**
```
The FCA's outsourcing guidance applies proportionately based on the nature and complexity of the arrangement. Administrative support such as scheduling, inbox management, and travel coordination falls outside the definition of material outsourcing.
```
**Replace with:**
```
The FCA's outsourcing guidance applies proportionately based on the nature and complexity of the arrangement, and its own examples of arrangements outside the outsourcing definition include services such as office supplies and cleaning. Whether a particular administrative arrangement counts as material outsourcing is a judgement for your compliance function, not one this article can settle for you.
```

The article keeps its general disclaimer. This makes the individual claim match it.

## Copy correction 2: the London salary figure

**This one needs a decision, not an edit.** The article says:

> "a full-time in-house PA in a London financial services firm costs £45,000 to £85,000 in salary"

That range has no source, and it disagrees with the Robert Walters range of £28,000 to £75,000 used everywhere else on the site.

Two options, Zoran picks:

1. **Source it.** If Olivia has a London financial-services PA benchmark, cite it inline with the date checked, same as every other figure on the site.
2. **Align it.** Replace with the Robert Walters range and note that London sits at the top of it: `"£28,000 to £75,000 in salary depending on seniority and location, with London financial services at the top of that range (Robert Walters, 2026 UK Salary Survey)"`.

**Do not build this section until one of those is chosen.** An unsourced salary figure in a compliance-sensitive article aimed at PE buyers is the weakest sentence in either draft.

## Length note

At 2,072 words the article is below the 2,400 guide minimum, and it reads as a guide. The two sections with room to grow are "Emerging fund or established firm" and "What it costs". This is a judgement call rather than a blocker: if the extra words would be padding, leave it short.

---

# PART 4: after the build

- [ ] `/guides/what-does-executive-assistant-do/` appears **zero** times in either page
- [ ] `/guides/how-to-build-sops-to-delegate/` goes from **0** inbound contextual links to **2**
- [ ] `/ceo-insights/master-the-art-of-working-with-an-assistant/` goes from **0** to **1**
- [ ] `/ceo-insights/white-collar-repricing/` goes from **0** to **1**
- [ ] `/who-we-serve/investment-virtual-assistant/` link still present on the PE article
- [ ] Every new link sits inside a real sentence in the body, not a related-posts list
- [ ] Zero em dashes, zero en dashes, zero contractions in the new copy
- [ ] Both pages 200, self-canonical, `robots` includes `index`
- [ ] Both in `sitemap-0.xml`
- [ ] No `[DONNAPRO PRICE` placeholder left unresolved in the rendered page
- [ ] The London salary decision has been made and applied

---

## Why these three orphans and not others

There are seven pages on the site with zero contextual inbound links. These two articles can plausibly reach three of them, and the other four have no honest home here.

| Orphan | Fed by | Fit |
|---|---|---|
| `/guides/how-to-build-sops-to-delegate/` | both | Documented process is the core argument in both pieces |
| `/ceo-insights/master-the-art-of-working-with-an-assistant/` | ADHD | The working relationship is the article's subject |
| `/ceo-insights/white-collar-repricing/` | PE | Senior time repriced is the cost argument |
| `/guides/executive-assistant-for-law-firms/` | neither | Different vertical. Forcing it would be an unnatural link |
| `/guides/how-to-hire-virtual-assistant-europe/` | neither | Needs its own rework, not a link from here |
| `/ceo-insights/ceo-time-management-strategy/` | neither | Reachable, but the ADHD piece already links two delegation pages. A third would crowd it |
| `/virtual-pa/` | neither | Still `noindex`. Linking to it passes nothing until that changes |

The rule applied throughout: a link goes in because the sentence wants it, and among equally good candidates the page with fewer links wins. Not the reverse.
