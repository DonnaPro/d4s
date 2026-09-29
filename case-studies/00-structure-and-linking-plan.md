# Case studies: structure, URLs and internal linking

**Prepared:** 29 September 2026
**Question:** should case studies live under `/testimonials/`, and how should the URLs and linking work?

---

## Short answer

**Your instinct is right about not building a big archive, and wrong about the URL.**

Use **`/case-studies/{client-slug}/`**, not `/testimonials/{slug}/`. Keep `/testimonials/` as a promotion surface. And the thing that will actually decide whether this works is not the URL at all, it is **what links to the case studies**, because `/testimonials/` cannot carry them.

---

## The evidence this rests on

### 1. Nobody searches for case studies

Google Ads search volume, UK:

| Keyword | Monthly volume |
|---|---|
| virtual assistant case study | **no data** |
| virtual assistant case studies | **no data** |
| executive assistant case study | 10 |
| virtual assistant success stories | 10 |
| virtual assistant testimonials | 10 |
| virtual assistant reviews | 10 |
| outsourcing case study | 10 |
| executive assistant success story | **no data** |

There is no search market here. Any plan that justifies case studies by ranking for "case study" terms is justifying them with nothing. **Do not build a hub page designed to rank.** That settles your archive-page question: you are right, do not build one for SEO reasons.

### 2. `/testimonials/` has no authority to pass down

| Signal | Value |
|---|---|
| Unique organic visitors landing there, Q3 | **18** |
| First click from the homepage, Q3 | 6 |
| Sessions that went from it to `/get-started/`, Q3 | 4 |
| Keywords it ranks for in the site's top 25 | **none** |
| Word count | 3,746 |

Nesting case studies under `/testimonials/` inherits nothing, because there is nothing to inherit. The usual argument for nesting (the parent has authority) does not apply.

### 3. `/testimonials/` is a reviews page, structurally

It carries `Review`, `Rating` and `ItemList` schema and is titled "DonnaPro Reviews: What CEOs Say About Our Executive Assistants". That schema is correct for reviews and wrong for case studies, which want `Article`. Putting case studies on the same URL path muddles both content types.

---

## So what are case studies actually for?

Since it is not search, be clear about the four real jobs. They change what you build.

1. **AI citation.** When someone asks ChatGPT "is DonnaPro any good" or "what results do DonnaPro clients get", the model needs a page with named outcomes to quote. This is the biggest one, given AI is now 266 sessions a quarter and growing 51%.
2. **Sales enablement.** A link to send in a proposal or a follow-up email.
3. **Conversion.** The proof a hesitant buyer reads before `/get-started/`.
4. **Internal linking.** Somewhere credible to link *from*, feeding the pages that do rank and the orphans that get nothing.

Every structural decision below follows from those four, not from rankings.

---

## URL recommendation

```
/case-studies/wuka/
/case-studies/zenith-land/
/case-studies/home-transformers/
/case-studies/mana-warrior/
/case-studies/ali-healthcare-group/     ← needs a company name, see open questions
```

**Not** `/testimonials/case-study-home-transformers/`. Three reasons:

- **The URL is read as a label**, by people who receive it in a proposal and by models retrieving it. A URL containing `case-study` matches the intent "DonnaPro case study" far better than one containing `testimonials`.
- **Your own convention is one flat segment per silo**: `/guides/`, `/comparison/`, `/who-we-serve/`, `/countries/`, `/ceo-insights/`, `/services/`. Nothing on the site nests two levels except `/careers/location/` and `/careers/guides/`. `/case-studies/` fits the pattern; `/testimonials/case-study-x/` does not.
- **It scales.** Five now, thirty in two years. Thirty children under a reviews page is wrong; thirty under `/case-studies/` is a normal silo.

Avoid `study-case` as in your example. It reads as a typo. `case-studies` is the standard.

### What to put at `/case-studies/`

You still need *something* there, or the parent URL 404s when someone truncates the path. Make it **thin and cheap**: a one-paragraph intro and a card per case study. Do not write a 2,000-word hub, because there is no query for it to answer. Twenty minutes of work, `index, follow`, in the sitemap, linked from the footer.

---

## The part that actually matters: linking

This is where the plan lives or dies. `/testimonials/` receives 18 organic visitors a quarter. **If the case studies are only linked from there, roughly nobody will read them.**

### Link them from the pages that have traffic

Matched by subject, not scattered:

| Case study | Link it from | Q3 unique visitors on that page |
|---|---|---|
| WUKA (tenders, awards, Ceredigion win) | `/comparison/best-virtual-assistant-companies-uk/` | **95** |
| WUKA | `/who-we-serve/ecommerce-virtual-assistant/` | 4 |
| WUKA | `/countries/uk/` | 32 |
| Zenith Land (deal flow, Airtable, automation) | `/who-we-serve/investment-virtual-assistant/` | 2 |
| Zenith Land | `/who-we-serve/real-estate-virtual-assistant/` | 3 |
| Zenith Land | `/services/standard-operating-procedures-sops/` | - |
| HomeTransformers (finance visibility, project reporting) | `/services/reports/` and `/services/managing-investors/` | - |
| Mana Warrior (SOPs, inbox, Drive, clinic ops) | `/who-we-serve/healthcare-virtual-assistant/` | 2 |
| Mana Warrior | `/guides/how-to-build-sops-to-delegate/` | orphan, 0 inbound |
| Ali (multi-business, finance, NHS, compliance) | `/who-we-serve/healthcare-virtual-assistant/` | 2 |
| Ali | `/ceo-insights/executive-assistant-multiple-ventures/` | 0 |
| All five | `/testimonials/`, `/pricing/`, homepage | - |

The single highest-value link on that list is **WUKA from `/comparison/best-virtual-assistant-companies-uk/`**. That page went from nothing to 95 unique visitors in one quarter and is the biggest new entry point on the site. A UK client with a named tender win is exactly the proof a reader of that page wants.

### Link them *out* to the pages that need it

Each case study should carry three to five outbound internal links, and they should go where link value is scarce, not to the homepage:

- `/pricing/` and `/get-started/` — one each, in the closing section
- The matching `/who-we-serve/` page
- One orphan per case study. Current zero-inbound pages that fit: `/guides/how-to-build-sops-to-delegate/` (Mana Warrior, Zenith Land), `/ceo-insights/white-collar-repricing/` (HomeTransformers), `/ceo-insights/master-the-art-of-working-with-an-assistant/` (Ali), `/guides/executive-assistant-for-law-firms/` (none of these five, leave it)

### How `/testimonials/` should change

Your instinct here is good. Rather than a separate archive:

1. Promote the five clients on `/testimonials/` from quote-sized to a **short story block each**: two or three sentences of context, one named outcome, a photo or logo, and a "Read the full story" link to `/case-studies/{slug}/`.
2. Keep the existing 50+ short quotes below them. That volume is the page's real asset and it is what the `Review` schema describes.
3. Leave the `Review` / `Rating` schema exactly as it is. Put `Article` schema on the case study pages instead.

So `/testimonials/` becomes the showcase, `/case-studies/*` holds the substance, and the traffic-carrying pages do the work of getting people there.

---

## Which five to build, and in what order

Based on the strength of the evidence in each, not on client size:

| Order | Client | Why it is strongest | Risk |
|---|---|---|---|
| **1** | **WUKA (Ruby / Saga)** | Only one with a hard, externally verifiable outcome: a won Ceredigion Council tender and three shortlisted award submissions. Named third parties make it citable | Needs Ruby's sign-off on naming the council and the awards |
| **2** | **Zenith Land (Chris & Kenny / Annabelle)** | Best systems story. A named before-and-after (Evernote to an Airtable and Claude deal-intake workflow) is concrete and technical | Check they are happy to name the tooling |
| **3** | **Mana Warrior (Tina / Guta)** | Cleanest narrative arc: chaos to structure. Emergency SOP, nurse onboarding manual, medication SOPs, four properties | Healthcare and medication SOPs need care in how they are described |
| **4** | **HomeTransformers (Walid / Tish)** | "Very strategic" is a strong quotable line, and finance visibility is a differentiated claim | The work is ongoing, so the outcome is a direction rather than a result |
| **5** | **Ali** | Broadest scope, genuinely impressive range | Weakest as a story: a long list of duties with no stated outcome, and no company name given |

Do WUKA first. If only one gets built, that is the one, because it is the only one where a stranger can verify part of the claim.

---

## Open questions before writing anything

1. **Client consent.** All five name a client and an assistant. Written permission is needed for each, and separately for naming third parties such as Ceredigion Council, the NHS and the awards. WUKA's value depends entirely on being allowed to name the tender.
2. **Ali has no company name.** A case study needs a subject. Either get the business name or the study becomes anonymised, which costs most of its credibility.
3. **Numbers.** Every one of these five is described in activities, not results. "Helped create more visibility around project profitability" is not an outcome. Before writing, each needs at least one of: hours returned per week, a cost saved, a revenue or contract won, a cycle time cut. WUKA already has one. The other four do not yet.
4. **Do the EAs get named?** Tish, Gaby, Annabelle, Guta and Saga are named throughout. Naming them is stronger and more human, and it is also a recruitment signal. But it is a decision, and it needs their consent too.

---

## What I would do next

1. Get consent for WUKA and confirm what can be named.
2. Get one hard number for each of the other four.
3. Build `/case-studies/wuka/` plus the thin `/case-studies/` index.
4. Add the WUKA link to `/comparison/best-virtual-assistant-companies-uk/` and `/countries/uk/`, and the story block on `/testimonials/`.
5. Measure: unique visitors to the case study, and sessions that go from it to `/get-started/`. If WUKA earns nothing in six weeks from the highest-traffic page on the site, do not build the other four as pages. Turn them into PDF one-pagers for sales instead.

That last step matters. There is no search demand here, so the whole bet is that case studies convert and get cited. Test it once before paying for it five times.
