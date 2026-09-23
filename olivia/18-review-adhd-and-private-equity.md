# Review: ADHD founders and Private Equity drafts

**Reviewed:** 23 September 2026
**Drafts:** "How ADHD Founders Can Make Delegation Actually Work" (2,320 words) and "Executive Assistant for Private Equity" (2,072 words)
**Purpose stated:** AI citation first, SEO partly, internal link building
**Method:** every internal link probed, every external source fetched and searched for the claimed figure, full 131-page crawl to count inbound contextual links on every link target, lengths measured.

---

## Verdict

**Publish both, after two fixes. The sourcing is the best work in this programme so far.**

For the first time I have checked a load-bearing statistic cluster and found every figure accurate and correctly attributed. That is a genuine change from the last three batches.

But on the **third stated purpose, internal link building, these two articles currently achieve nothing.** Every link points at a page that already has plenty. That is the main thing to fix, and it is twenty minutes of work.

---

## Accuracy: verified, and this is the headline

### Private equity, EY 2023 Global Private Equity Survey

I downloaded the 30-page PDF and searched it. All four figures are correct:

| Claim in the draft | Source says | Verdict |
|---|---|---|
| "only 27% consider their operations highly automated" | "only 27% of the largest firms considered their overall platform to be highly automated" | **Exact** |
| "67% of large firms and 74% of smaller firms" in the manual-and-automated category | Chart reads 67% / 74% / 74% across the three fund-size bands | **Correct** |
| "62% of the largest PE firms have increased outsourcing to address margin erosion" | "72% and 62% of the largest organizations, respectively, said that technology deployment and increased use of outsourcing has enabled them to address margin erosion" | **Correct** |

### ADHD, NIMH

> "The National Institute of Mental Health puts adult ADHD prevalence at 4.4% among adults aged 18 to 44"

Source, verbatim: "the estimated prevalence of adults aged 18 to 44 years with a current diagnosis of ADHD... The overall prevalence of current adult ADHD is 4.4%." **Exact.**

### Could not verify

Springer (Lerner, Verheul and Thurik) and SAGE (Tran, Wiklund et al.) both block automated fetching. Both are real papers with real DOIs at real journals, so this is a tooling limit rather than a red flag. Worth Olivia confirming the "twice as likely" wording against the abstract once, since it is the answer box's opening claim.

---

## The two fixes

### 1. The same broken link, for the third time

Both drafts link to `/guides/what-does-executive-assistant-do/`. It returns **404**. The real page is `/guides/what-does-an-executive-assistant-do/`, with "an".

This is the third article carrying it, after the Q4 draft. It is clearly saved in a link list somewhere, so correcting it once at the source will stop it recurring.

### 2. Neither article does any internal link building

This is the one that matters, because it was a stated purpose.

I crawled all 131 pages and counted contextual inbound links for every target these two drafts point at:

| ADHD article links to | Existing inbound links |
|---|---|
| `/virtual-executive-assistant/` | 31 |
| `/pricing/` | 14 |
| `/guides/how-to-hire-virtual-assistant-uk/` | 10 |
| `/comparison/virtual-assistant-vs-executive-assistant/` | 9 |
| `/services/` | 9 |
| `/guides/ceo-delegation-playbook/` | 5 |
| `/guides/what-does-an-executive-assistant-do/` | 4 |

| PE article links to | Existing inbound links |
|---|---|
| `/who-we-serve/investment-virtual-assistant/` | 26 |
| `/pricing/` | 14 |
| `/comparison/outsourced-executive-assistant/` | 11 |
| `/services/` | 9 |
| `/guides/ceo-delegation-playbook/` | 5 |
| `/guides/what-does-an-executive-assistant-do/` | 4 |

**Thirteen links, and every single one goes to a page that already has between 4 and 31.** Not one reaches any of the eight orphaned pages with zero inbound links.

The orphans these two were meant to feed, all still at **zero**:

- `/guides/how-to-build-sops-to-delegate/`
- `/ceo-insights/ceo-time-management-strategy/`
- `/ceo-insights/white-collar-repricing/`
- `/ceo-insights/master-the-art-of-working-with-an-assistant/`
- `/guides/executive-assistant-for-law-firms/`
- `/guides/how-to-hire-virtual-assistant-europe/`
- `/virtual-pa/`

**The fix is to swap, not add.** Two or three links per article, keeping the total at six:

**ADHD article**
- The delegation-system passage currently links to `/guides/ceo-delegation-playbook/`. Point it at **`/guides/how-to-build-sops-to-delegate/`** instead. Building a system somebody else owns is literally what that orphaned guide covers.
- The "structure without rigidity" daily-rhythm passage should link to **`/ceo-insights/master-the-art-of-working-with-an-assistant/`**, which is about exactly that relationship and currently unreachable.
- Keep `/virtual-executive-assistant/` and `/pricing/`. Drop one of `/services/` or `/guides/how-to-hire-virtual-assistant-uk/`, both of which are well linked already.

**Private equity article**
- Keep `/who-we-serve/investment-virtual-assistant/`. That one is correct and deliberate: the guide feeds the service page rather than competing with it, which was the whole point of approving this article.
- The travel and logistics row links to `/guides/ceo-delegation-playbook/`. Point it at **`/guides/how-to-build-sops-to-delegate/`** instead.
- The cost section, which talks about a partner's hours, should link to **`/ceo-insights/white-collar-repricing/`**, which is about exactly that and has no route in.

---

## Smaller things

### ADHD article

**The NIMH figure is US data from 2001-2003.** The National Comorbidity Survey Replication sampled US adults over twenty years ago. That is fine to cite, but an article aimed at European founders should say so: "US data" and a date. As written it reads as a current European figure.

**One unsourced assertion sits right after it:** "but among founders and the self-employed, the concentration is significantly higher." No source. Either attach one, or soften to something the research does support, which is the "twice as likely to initiate entrepreneurial action" finding already cited two lines above.

**The health boundary is handled well.** This was my main concern when approving the idea. There is an explicit disclaimer in the introduction, another in the methodology, and a dedicated FAQ. That is more than enough, and the piece never strays into symptoms or treatment.

### Private equity article

**It is thin at 2,072 words** for a vertical that needs to establish authority with compliance-sensitive buyers. It sits inside the article band but below the guide band, and this reads as a guide. The two sections that would benefit from more depth are "Emerging fund or established firm" and "What it costs".

**One regulatory statement is firmer than it should be.** FAQ 3 says: "Administrative support such as scheduling, inbox management, and travel coordination falls outside the definition of material outsourcing." That is a legal interpretation stated as fact, to an audience whose compliance officers will read it closely. The article does carry a disclaimer, but I would soften that specific sentence to describe what the FCA guidance says rather than what it means for a given firm.

**The £45,000 to £85,000 London PA salary** is unsourced. Every other cost figure across the site traces to Robert Walters. Either source it or align it.

---

## Strategic fit

**No cannibalisation in either.** The ADHD article opens genuinely new territory: nothing on the site touches it.

The PE article does what I recommended when flipping that idea to approved. It is an editorial guide that links **down** to `/who-we-serve/investment-virtual-assistant/` rather than competing with it, which preserves the guide-versus-service-page separation. Since no `/who-we-serve/` page has ever earned a ranking or a citation while guides have, this is the right shape.

**Lengths are all correct.** Both answer boxes are 86 words, and every FAQ answer sampled falls between 66 and 82. That discipline has now held across two consecutive batches.

---

## What to tell Olivia

Two things, and the first one is praise she has earned.

**The sourcing is now right.** Every EY figure and the NIMH figure check out exactly against the source documents. After three batches where statistics turned out not to be on the pages they cited, this is the standard, and it held across a compliance-sensitive article where getting it wrong would have been expensive.

**Links should go where they are needed, not where they are obvious.** Thirteen links across two articles, all to pages that already have 4 to 31 inbound links, while seven finished articles sit at zero and cannot be reached from anywhere. When choosing an internal link, the question is not only "is this relevant" but "does this page need it".
