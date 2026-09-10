# Virtual PA service page: go/no-go and writing spec

**Prepared:** 10 September 2026
**For:** Zoran, who writes this page
**Inputs:** Olivia's `RESEARCH for 'virtual PA' service page`, plus UK SERP, People Also Ask and volume data pulled 10 September 2026
**Target URL:** `/virtual-pa/`

---

## Verdict: build it

The case is stronger than the brief assumed, and the one risk is bigger.

**"Virtual PA" is 4.2 times the size of the term your money page targets.**

| Keyword | UK volume | CPC |
|---|---|---|
| **virtual pa** | **720** | £23.19 |
| virtual personal assistant | 390 | £18.39 |
| virtual pa services | 210 | £11.17 |
| remote pa | 210 | £7.17 |
| online pa | 140 | £8.43 |
| virtual pa uk | 50 | £10.44 |
| hire a virtual pa | 10 | £19.46 |
| **virtual executive assistant** *(what `/virtual-executive-assistant/` targets)* | **170** | £23.88 |

About 1,730 searches a month across the PA cluster. **DonnaPro appears nowhere in any of these SERPs.**

### It will not cannibalise the money page

Tested rather than assumed:

| Query pair | Domain overlap | Verdict |
|---|---|---|
| `virtual pa` vs `virtual executive assistant` | **20%** | Distinct. Separate page justified |
| `virtual pa services` vs `virtual executive assistant` | **21%** | Distinct |
| `hire a virtual pa` vs `virtual executive assistant` | 33% | Grey, leaning distinct |

The only domains appearing in both are Indeed, Virtalent and Oriel Partners.

**Virtalent is the proof.** It runs `/how-we-help/virtual-pa/` and `/how-we-help/virtual-executive-assistant/` as two separate pages. The PA page ranks on four of the five queries tested; the EA page ranks second on `virtual executive assistant`. Two pages, both ranking, no cannibalisation. That is the model.

### One page, not several

| Query pair | Overlap | Meaning |
|---|---|---|
| `virtual pa` vs `virtual personal assistant` | 60% | Same intent. One page covers both |
| `virtual pa` vs `hire a virtual pa` | **67%** | Same intent. Do not build a second page |

So `/virtual-pa/` targets `virtual pa`, `virtual personal assistant`, `virtual pa services` and `hire a virtual pa` together. Roughly 1,330 a month on one URL.

---

## The risk the brief did not catch

The brief warned Olivia off "part time virtual assistant" because "those results are dominated by job listings, and careers content already outranks our client content across the site."

**That warning applies to "virtual PA" too, and nobody applied it.**

- `virtual pa` position **1** is `uk.indeed.com/q-virtual-pa-jobs.html`
- Position 7 is Tiger Recruitment, "Virtual Assistant Jobs | Remote & Online PA Roles"
- Position 10 is Oriel Partners, "Best Virtual Assistant (VA) Jobs in London"
- `virtual personal assistant` position 1 is also an Indeed jobs page

And the People Also Ask on the head term is overwhelmingly candidate-side. Five of six:

> How much do virtual PA's earn? · How to become a virtual PA in the UK? · Can you make 10k a month as a virtual assistant? · How to start VA as a beginner? · What is the average salary for a virtual assistant in the UK?

Olivia called this correctly in her research: "mixed intent, with a noticeable career focus". She simply left the list out of the document.

**This does not stop the page.** There is no Google Jobs pack on any of these queries, and six of the ten organic results on `virtual pa` are vendor or service pages. But it changes how the page must be written, because DonnaPro's careers content already wins buyer queries and this term is the most careers-adjacent one you would deliberately target.

**Three rules follow:**

1. **The H1 and title must carry buyer framing.** Not "Virtual PA" alone. Something closer to "Virtual PA Services for CEOs and Founders". Virtalent gets away with a neutral title because it has no careers silo competing with it. You do.
2. **Do not answer any candidate question on this page.** No earnings, no "how to become one", no salary, no "getting started as a VA". Those five PAA questions are exactly the bridge that pulled buyer queries onto your careers pages in the first place. Leave them to the careers side, which already owns them.
3. **Keep every internal link buyer-side.** No link from this page to anything under `/careers/`.

For contrast, the PAA on `hire a virtual pa` is **six out of six buyer questions**, which is where the FAQ should come from.

---

## The missing People Also Ask, now filled

Olivia's research pack has two empty "Questions included:" lists. Here they are.

**"virtual pa"** - mixed, mostly candidate:

- How much do virtual PA's earn? *(candidate - do not answer)*
- How to become a virtual PA in the UK? *(candidate - do not answer)*
- **What does a virtual PA do?** *(buyer - use this)*
- Can you make 10k a month as a virtual assistant? *(candidate - do not answer)*
- How to start VA as a beginner? *(candidate - do not answer)*
- What is the average salary for a virtual assistant in the UK? *(candidate - do not answer)*

**"hire a virtual pa"** - entirely buyer:

- How much is a virtual PA per hour?
- How much should you pay for a virtual assistant?
- How much does it cost to hire a PA?
- What is the average cost of a virtual assistant?
- How much does a virtual assistant charge in the UK?
- Is there a free virtual assistant?

**"virtual pa services"** adds one more buyer question: **What are the top 5 virtual assistants?**

Note that five of the six buyer questions are the same pricing question asked five ways. Olivia's recommendation to consolidate them into one clear pricing answer rather than five near-duplicate FAQ entries is right, and it also avoids the duplicate-`Question`-node problem that had to be cleaned up on the careers pages.

---

## Page spec

**Shape:** a service page, not a guide. The brief is right that a long explainer is the wrong shape - the SERP is vendor offer pages. But the site's own evidence is that thin pages never get cited, so do not go too short either.

**Target: 2,400 to 3,000 words.** The `/virtual-executive-assistant/` template is 4,985, which is longer than this page needs. Trim the sections marked optional below rather than thinning every section.

**Structure**, adapted from `/virtual-executive-assistant/`:

| # | Section | Notes |
|---|---|---|
| H1 | Virtual PA Services for CEOs and Founders | Buyer framing is mandatory, see rule 1 above |
| 1 | Answer box, 60-90 words | What a virtual PA is and what you get. This is what AI assistants quote |
| 2 | What Is a Virtual PA? | Lead with the buyer's definition. Do not define the job role |
| 3 | Virtual PA vs Virtual Executive Assistant | **The important one.** Use Olivia's recommended distinction below. Links to `/virtual-executive-assistant/` |
| 4 | What Your Virtual PA Handles | The task list. Lead with inbox, diary, meetings, travel, follow-ups, documents, expenses |
| 5 | Who It Is For | Keep to CEOs, founders and senior leaders. This is your differentiator against Pink Spaghetti and The Online PA |
| 6 | How It Works, 9 Days | Reuse the template's process section |
| 7 | What It Costs | Against the competitor pricing in Olivia's pack |
| 8 | Proof | Testimonials. Olivia suggests video plus real assistant photography rather than stock, which I would take |
| 9 | FAQ | See below |
| 10 | Booking CTA | |

**Optional, cut if length runs over:** the 110+ industries block and the "not based in the UK" block. Both exist on the EA page and neither is load-bearing for this term.

### The PA versus EA distinction

Olivia's research landed on the right answer and it is worth using close to as written:

> Virtual PA and Virtual Executive Assistant responsibilities overlap significantly, particularly around inbox, diary, travel, meeting and administrative support. The main distinction in current market positioning is the level of seniority, autonomy and business judgement expected.

Her one-line version:

> **Virtual PA:** Dedicated support that organises and manages the executive's working day.
> **Virtual Executive Assistant:** Dedicated support that operates more deeply within the executive's business priorities and leadership environment.

Her caution is also right: do not make the PA sound junior. It is a different depth of ownership, not a lower grade of person. Half the point of this page is to catch buyers who use the word "PA" and would otherwise never find you.

### FAQ, from the buyer PAA

1. What does a virtual PA do?
2. How much does a virtual PA cost? *(consolidates the five pricing variants - include an hourly comparison, since three of the five ask per-hour)*
3. What is the difference between a virtual PA and a virtual executive assistant? *(links to `/virtual-executive-assistant/`)*
4. How does hiring a virtual PA work?
5. Can I hire a virtual PA without a long-term contract?

Five to eight items, answers 40 to 90 words, each self-contained.

**Do not include** "Is a virtual PA the same as a virtual assistant?" here. That question is being added to `/guides/how-to-hire-virtual-assistant-uk/`, and Olivia correctly flagged it as an editorial suggestion rather than a search-supported one.

---

## Competitor pricing, for the cost section

From Olivia's research pack, verified against Boldly's live page:

| Provider | Model | Price |
|---|---|---|
| The Online PA | Monthly retainer, flat rate | £400 / £800 / £1,200 / £1,600 for 10 / 20 / 30 / 40 hours. £40 per hour at every tier. 3-month minimum, no rollover |
| Virtalent | Tiered subscription | £310 / £600 / £1,160 / £1,680 / £2,700 for 10 / 20 / 40 / 60 / 100 hours. £31 down to £27 per hour. Monthly, 7 days notice, hours roll over |
| Pink Spaghetti | Ad hoc or retainer | £35-40 per hour standard, £50+ technical. Billed by the minute |

Every one of them sells time. Olivia's observation that this leaves room to sell continuity, matching and ownership instead of units of assistant time is the strongest strategic point in her pack, and it is the same argument the EA page already makes.

---

## One thing worth picking up separately

`teambuildconsultancy.co.uk/virtual-personal-assistant-companies/` - "Best Virtual PA Companies UK, Top 10 Compared (2026)" - ranks on **three** of the five queries tested. `levelupvirtualservices.com/the-definitive-guide-to-virtual-pa-services-in-the-uk` ranks on a fourth.

Both are listicles DonnaPro is not in. They belong on the outreach list with the other listicle targets.

---

## A baseline reading

On `virtual executive assistant` (170/mo), the DonnaPro result at position 10 is **`/careers/executive-virtual-assistant-jobs/`**, not `/virtual-executive-assistant/`.

That is the second query where a careers URL is the only DonnaPro result, alongside `virtual assistant vs executive assistant`. The fixes went live on 8 September, so this is expected lag, but both belong on the weekly tracking list as the clearest before-and-after measure you have.
