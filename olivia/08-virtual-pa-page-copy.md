# `/virtual-pa/` - full page copy and Astro build notes

**Prepared:** 10 September 2026
**Target URL:** `/virtual-pa/`
**Template:** `src/pages/virtual-executive-assistant.astro`
**Word count:** 2,477 page-copy words, inside the 2,400 to 3,000 target from the spec
**House style:** no em dashes, no contractions, British spelling, spaced hyphen for asides

> **Build notes are marked `BUILD:` and are not page copy.** Everything else is copy, ready to place.

---

## Page-level setup

```ts
const seo = {
  title: "Virtual PA Services for CEOs & Founders | DonnaPro",
  description:
    "Dedicated virtual PA support for CEOs and founders. EU-based, working your UK hours, fully managed and ready in 9 days. No long-term contract.",
};
const APPLY = "/get-started/";
```

**BUILD:** Copy the wrapper from the template exactly - `<BaseLayout title={seo.title} description={seo.description}>` then `<div class="jobs va">`, `<Header />`, `<main>`, `<Footer />`. Reuse the same `jb-section` / `jb-narrow` / `jb-prose` / `jb-h2` class system throughout. Every CTA uses `<Cta href={APPLY} label="..." class="jb-cta" />` so the smush hover is inherited.

**BUILD - why the H1 is not just "Virtual PA":** position 1 on `virtual pa` is an Indeed jobs page, and five of the six People Also Ask questions on that term are job-seeker questions. The title and H1 have to signal buyer intent immediately or this page competes with our own careers silo. Do not shorten the H1 to the bare keyword.

---

## 1. Hero

**H1:** Virtual PA Services for `<em>`CEOs and Founders`</em>`

**Lead:** A dedicated virtual PA who runs your diary, your inbox and your travel, so your working day stops running you. EU-based, working your UK hours, ready in 9 days.

**CTA:** Book Your Free Strategy Session

**BUILD:** Copy the `va-hero` block from the template verbatim, including the duplicated `va-hero__media-m` image for mobile and the `review-logos` strip. Keep `loading="eager"` on both hero images.

**IMAGE 1 - hero, required.**
- Slot: `va-hero__media` and `va-hero__media-m`
- Path: `/images/wp/2026/09/virtual-pa-diary-inbox.jpg`
- Size: 560 x 520, JPG
- Alt: `A virtual PA reviewing a founder's diary and inbox on a laptop at a bright desk`
- Brief: professional, calm, European, real-looking workspace. No headset, no visible text, no stock-cliché handshake. Must read as a working professional, not a call centre.

**BUILD:** Place `<ProofStrip />` immediately after the hero, as on the template.

---

## 2. What Is a Virtual PA?

**H2:** What Is a `<em>`Virtual PA?`</em>`

**BUILD:** Wrap the first paragraph in `<div class="dp-answer-box">`. This is the passage AI assistants quote, so it must answer completely on its own. 77 words.

> A virtual PA is a personal assistant who works remotely, handling the diary, inbox, travel, meetings and day-to-day administration that would otherwise sit with you. The work is the same as a traditional PA does in an office. The difference is that your PA is not in your office, which means you are not paying for a desk, a commute or a full-time salary to get it. Most founders start with 20 to 30 hours a month.

Then, as normal `jb-prose` paragraphs:

"Virtual PA" and "virtual assistant" are used interchangeably by most UK providers, and in practice they describe the same service. The words came from different places. "Personal assistant" is the traditional British job title for one-to-one support, usually in person. "Virtual assistant" describes the delivery model rather than the role. Today the label tells you very little about what you are actually buying.

What does tell you something is the level of judgement involved. Some providers sell you hours against a task list, where you decide what needs doing and your PA does it. Others give you someone who reads the week ahead, protects the time you need, and handles the things that would otherwise reach you. The hourly rate is broadly similar. The outcome is not.

At DonnaPro, every virtual PA is based in the European Union, works during UK business hours, and supports one client at a time rather than a shared pool. They are real people who are very good at using AI to work faster, not AI tools with a person attached.

**BUILD:** No image in this section. Keep it in `jb-narrow` for the reading measure.

---

## 3. Virtual PA vs Virtual Executive Assistant

**H2:** Virtual PA vs Virtual Executive Assistant: `<em>`Which One You Need`</em>`

The two roles overlap heavily. Both own your inbox, your diary, your travel and your meetings. Anyone who tells you they are completely different jobs is selling you something.

The honest distinction is depth, not task list. A virtual PA organises and protects your working day. A virtual executive assistant works further inside the business itself: board preparation, stakeholder relationships, investor reporting, cross-functional projects. The PA keeps your week running. The EA takes on the things that would otherwise need your judgement.

That also means a virtual PA is not a junior version of an executive assistant. It is a different remit, and for most of the people reading this it is the right one. If what you need is for your diary, your inbox and your travel to stop being your problem, a PA does that completely and you would be paying for capability you will not use at the executive tier. We set out the cost difference at equivalent hours in our [virtual assistant vs executive assistant comparison](/comparison/virtual-assistant-vs-executive-assistant/).

**BUILD - TABLE 1.** Use the standard site table markup. Two columns plus a row-label column. Caption underneath in the small-print style used on `/guides/how-to-hire-virtual-assistant-uk/`.

| | Virtual PA | Virtual Executive Assistant |
|---|---|---|
| Core work | Diary, inbox, travel, meetings, documents, expenses, general administration | The same, plus board preparation, stakeholder management, investor reporting, project coordination |
| Autonomy | Executes reliably against your priorities | Sets priorities within an agreed remit and acts on your behalf |
| Business context | Enough to run your day well | Deep understanding of your objectives, stakeholders and commercial pressures |
| Typical client | Founders, directors, professionals and business owners | CEOs, founders and C-suite leaders |
| Complexity | Routine to moderately complex | Interconnected, sensitive, high-responsibility |

**Caption:** Virtual PA and virtual executive assistant support compared on scope, autonomy and typical client.

Closing paragraph:

Most founders start with a virtual PA and move up when the work outgrows it. If you are losing your week to scheduling, email and travel, a virtual PA solves that completely. If the thing slowing you down is board packs, investor updates and projects that stall without you, read our [virtual executive assistant](/virtual-executive-assistant/) page instead.

**BUILD - internal links, exactly these four, all in body prose, no duplicates:**

| Target | Anchor | Section |
|---|---|---|
| `/comparison/virtual-assistant-vs-executive-assistant/` | virtual assistant vs executive assistant comparison | 3, above the table |
| `/virtual-executive-assistant/` | virtual executive assistant | 3, closing paragraph |
| `/guides/executive-assistant-cost-guide/` | executive assistant cost guide | 6, closing paragraph |
| `/pricing/` | see full pricing | 6, closing paragraph |

**BUILD - no link from this page to anything under `/careers/`.** This term is careers-adjacent and the whole point of the page is to hold buyer intent on the client side.

---

## 4. What Your Virtual PA Handles

**H2:** What Your Virtual PA `<em>`Handles`</em>`

**Sub (`jb-sub`):** These are the eight areas UK buyers most consistently expect a virtual PA to own. Most clients hand over the first three in week one and add the rest as trust builds.

**BUILD:** Reuse the `handles` pattern from the template exactly - a typed `const handles: [string, string][]`, rendered into `jb-cards jb-cards--bento` with a line icon per card. Eight cards, so the bento grid stays even. Icons: envelope, calendar, document-with-clock, aeroplane, presentation, receipt, magnifier, house. Follow the `svg()` helper already in the template.

1. **Inbox and `<em>`Email`</em>` Management** - Your PA reads your inbox before you do, answers what does not need you, drafts replies for the things that do, and files the rest. Over the first fortnight they learn which senders always matter, which threads you want to see only when they conclude, and which can be handled without you entirely. You stop starting every morning with two hundred unread messages and start with a shortlist.

2. **Diary and `<em>`Calendar`</em>` Management** - Booking, rebooking, confirming and protecting the blocks you need for actual work. Your PA handles the back and forth with other people's assistants, holds the line on your focus time when someone tries to book over it, and makes sure two commitments never land in the same hour. Time zones, travel buffers and the gap you need between back-to-back calls are all handled without being asked.

3. **Meeting `<em>`Support`</em>`** - Agendas circulated in advance, background on who you are meeting and what was last agreed, notes taken during, and actions chased afterwards until they are done. You arrive knowing what the meeting is for and leave without a list of things to remember. For recurring meetings, your PA keeps the running record so nothing gets relitigated three weeks later.

4. **Travel and `<em>`Itineraries`</em>`** - Flights, hotels, transfers, visas and a single confirmed itinerary in your calendar rather than eleven confirmation emails. Preferences are remembered, so you stop restating that you want an aisle seat and a hotel near the venue. When a flight is cancelled at short notice, your PA rebooks it while you are still in the meeting.

5. **Documents and `<em>`Presentations`</em>`** - Formatting decks, tidying proposals, building a report from your rough outline, and keeping version control sane so the right file goes to the client. This is the work that takes you an hour on a Sunday and takes a competent PA fifteen minutes on a Tuesday.

6. **Expenses and `<em>`Invoicing Admin`</em>`** - Receipts collected and categorised, expenses submitted on time, invoices raised and politely chased until they are paid. Nobody should be reconciling a month of receipts at ten at night, and late invoices should not be a cash flow problem you discover in arrears.

7. **Research and `<em>`Information Gathering`</em>`** - Background on a prospect before a pitch, three suppliers compared on the criteria you care about, a long document summarised to the part that affects your decision, or the answer to a question you do not have time to look up. Delivered in a form you can act on rather than a folder of links.

8. **Personal and `<em>`Lifestyle Support`</em>`** - Appointments, renewals, gifts, restaurant bookings and household logistics. The admin that follows you home is still admin, it still takes real hours, and it is still delegatable. Most clients hold this back for a month and then wonder why they waited.

**BUILD:** `<div class="jb-ctarow"><Cta href={APPLY} label="Book Your Free Strategy Session" class="jb-cta" /></div>` at the end of the section, as on the template.

**BUILD:** Section takes `jb-band` for the alternating background, matching the template's `va-handles` section.

---

## 5. Who It Is For

**H2:** Who Our `<em>`Virtual PAs`</em>` Work With

**BUILD:** Reuse `<LeadershipAudienceBlock />` if the three personas can be passed as props. If not, use three `jb-card` items. Do not write a fourth persona to fill the grid.

**The Founder Running Everything** - Fifteen people, no operations hire yet, and every scheduling decision still routes through you. You are the bottleneck for your own calendar, and the work that only you can do keeps getting pushed to the evening because the day filled up with coordination. A virtual PA is usually the first support hire that pays for itself immediately, because it returns hours you are currently spending on work nobody needs you specifically to do. Most founders at this stage start with twenty to thirty hours a month and add from there.

**The Director With No Assistant** - You had a PA at your last company and you have been managing without one since you moved. You already know what good support looks like, which makes this an easier decision than it is for a first-time buyer, and it also makes you harder to impress. You are not looking for someone to work through a task list. You want the person who notices the clash before you do and has already moved the meeting.

**The Leader Running Two Things** - Two businesses, or a business and a board seat, or a company and a portfolio. The problem here is rarely volume. It is context switching, and the cost of it is invisible until something is dropped. A dedicated PA holds both diaries, keeps the two sets of commitments from quietly eating each other, and gives you one person who can see the whole week rather than half of it.

**BUILD:** No new imagery needed here if `LeadershipAudienceBlock` is reused, since it carries its own.

---

## 6. What It Costs

**H2:** What a Virtual PA `<em>`Actually Costs`</em>`

Most UK virtual PA services sell you hours. Rates run from about £27 to £50 an hour depending on the provider and whether you buy a block or pay ad hoc, and the cheaper tiers usually mean a PA shared across several clients.

We price differently, because buying an assistant by the hour makes you the person managing the clock. Counting minutes is a poor use of the time you are trying to buy back, and it quietly discourages you from delegating the very things worth delegating. You get a dedicated PA on a monthly retainer, matched to how you work, with the agency handling quality, cover and continuity behind them.

The retainer covers the assistant, the matching process, structured onboarding, ongoing quality management, and cover when your PA is ill or on leave. There is no recruitment fee, no employer National Insurance, no pension contribution, no equipment to buy and no notice period to work through if your needs change. If the match is wrong, we rematch you rather than leaving you to start again.

**BUILD - TABLE 2.** Three rows only. Do not add an in-house row: we do not have a sourced UK in-house PA salary, and inventing one would put a number on the page we cannot defend. Point to the cost guide instead, as in the closing paragraph.

| | Typical hourly PA service | Freelance PA | DonnaPro |
|---|---|---|---|
| Monthly cost | £270 to £2,000 depending on hours bought | £15 to £35 per hour | [DONNAPRO PRICE GBP] |
| Dedicated to you | Often shared across clients | Yes, until they take another client | Yes, one client at a time |
| Who manages quality | You | You | We do |
| Cover during absence | Varies | None | Included |
| Contract | Frequently a three-month minimum | None | No long-term contract |
| Unused hours | Often expire monthly | Not applicable | Not applicable, we do not bill by the hour |

**Caption:** Virtual PA pricing models compared. Hourly rates checked against published UK provider pricing, September 2026.

Closing paragraph:

If you are weighing this against hiring someone in-house, we set out the full salary, employer contribution and overhead comparison in our [executive assistant cost guide](/guides/executive-assistant-cost-guide/), and you can [see full pricing](/pricing/) for our own plans.

**BUILD:** `[DONNAPRO PRICE GBP]` is a placeholder. Current live value on `/countries/uk/` is £2,350 per month part-time and £5,660 full-time. Swap at build, do not hardcode into the copy source.

---

## 7. How It Works

**H2:** How It Works: `<em>`From First Call to Full Delegation in 9 Days`</em>`

**BUILD:** Reuse `<ProcessTimeline />` with the same five-step shape as the template. The steps below are rewritten for PA rather than EA. Do not reuse the EA wording verbatim, or the two pages will read as duplicates to a crawler.

1. **The PA Is Already Hired** - We recruit and train across the European Union continuously, which is why this takes nine days rather than three months. Every candidate goes through a multi-stage assessment and roughly one in a hundred makes it through. By the time you call, the person who will support you is already trained and already working.
2. **A 30-Minute Call** - We work out what is actually eating your week, how you prefer to communicate, which tools you already use, and whether we are the right answer at all. There is no pitch and no obligation. If a cheaper hourly service would serve you better, we will tell you that on the call rather than after you have signed.
3. **Matching** - We pick a PA who fits your sector, your tools and your temperament, not simply whoever has capacity. Industry familiarity, communication style and working hours all factor in. You meet them before anything is signed, and if the fit is wrong we match you again.
4. **Onboarding** - We map your tools, preferences and priorities, set up access properly, and brief your PA on your business and your key relationships before day one. You will spend more time in the first fortnight than you save. That is normal, and it is the only part of this that asks anything of you.
5. **The Part That Matters** - Your diary makes sense, your inbox is under control, your travel is booked, and your follow-ups happen without you chasing them. The measure is not hours logged. It is whether you have stopped thinking about the admin at all.

---

## 8. Proof

**BUILD:** Reuse `<TestimonialsBlock headingBefore="What Founders Say About Working With a" headingAccent="Virtual PA" headingAfter="From DonnaPro" />`.

**BUILD - imagery:** Olivia's research recommends real assistant photography and video testimonials over stock, and I agree. If real photography is not ready, ship without it rather than dropping in stock. A stock image here undercuts the "real people" claim made in section 2.

---

## 9. FAQ

**H2:** Frequently Asked `<em>`Questions`</em>`

**BUILD:** Five items. Every answer is between 40 and 90 words and must stand alone, because these are quoted in isolation. Emit `FAQPage` schema with the answer text **character-identical** to the on-page text.

**BUILD - deliberately excluded, do not add later:** "How much do virtual PAs earn", "How to become a virtual PA", "What is the average salary for a virtual assistant". All three appear in People Also Ask for this term, and all three are job-seeker questions. Answering them here is exactly what pulled buyer queries onto our careers pages. They belong on the careers side, which already owns them.

**What does a virtual PA do?**
A virtual PA handles the administration that would otherwise sit with you: diary and calendar management, inbox triage and replies, travel booking and itineraries, meeting agendas and follow-ups, document formatting, expenses, research and personal admin. The work is the same as an in-office PA does. The difference is that it is delivered remotely, which is why it costs less and can start in days rather than months.

**How much does a virtual PA cost in the UK?**
UK virtual PA services typically charge £27 to £50 per hour, or £270 to £2,000 per month depending on how many hours you buy. Freelance PAs run £15 to £35 per hour but you manage them yourself. DonnaPro charges a flat monthly retainer of [DONNAPRO PRICE GBP] for a dedicated PA, with quality management, absence cover and no long-term contract included.

**What is the difference between a virtual PA and a virtual executive assistant?**
They overlap heavily and both cover diary, inbox, travel and meetings. The difference is depth. A virtual PA organises and protects your working day. A virtual executive assistant works inside the business itself, taking on board preparation, stakeholder relationships and projects that would otherwise need your own judgement. Most founders start with a PA and move up when the work outgrows it.

**How does hiring a virtual PA work?**
It starts with a 30-minute call to work out what is taking your time and how you prefer to work. We then match you with a PA from our existing EU-based team, and you meet them before committing. Onboarding maps your tools, preferences and priorities. Most clients are delegating meaningful work within two weeks, and fully handed over within nine days of starting.

**Can I hire a virtual PA without a long-term contract?**
Yes. Many UK providers ask for a three-month minimum and expire your unused hours each month. We do not. Our virtual PA service runs monthly with no long-term commitment, and we do not bill by the hour, so there is no clock to manage and nothing to lose at the end of the month if your workload was lighter than usual.

---

## 10. Final CTA

**H2:** Ready to Get Your `<em>`Week Back?`</em>`

Book a free 30-minute call. We will work out what is actually taking your time, and whether a virtual PA is the right answer. If it is not, we will say so.

**CTA:** Book Your Free Strategy Session

**BUILD:** Use the template's closing CTA section pattern with `<Cta href={APPLY} ... />`.

---

## Schema

**BUILD - emit three nodes:**

1. **`Service`** - `serviceType: "Virtual PA"`, provider DonnaPro, same `areaServed` array as `/virtual-executive-assistant/` uses.
2. **`FAQPage`** - the five questions above, answer text matching the page exactly.
3. **`DefinedTerm`** - for the term **Virtual PA** only:

```json
{
  "@type": "DefinedTerm",
  "name": "Virtual PA",
  "description": "A personal assistant who works remotely, handling diary management, inbox triage, travel booking, meeting support and day-to-day administration for a business leader.",
  "inDefinedTermSet": "https://donnapro.com/virtual-pa/"
}
```

**BUILD - do not add** a `DefinedTerm` for "Virtual Executive Assistant". That term belongs to `/virtual-executive-assistant/` and to no other page. A `DefinedTerm` for "Virtual PA" is a different term, so it is correct here.

**BUILD - do not add** `JobPosting`, and do not add an `Offer` with a typed price.

---

## Post-build verification

- [ ] Title and H1 both carry buyer framing, not the bare keyword
- [ ] `PA` appears throughout; `virtual PA` in H1, answer box, and at least one H2
- [ ] Answer box is 60 to 90 words and sits in `dp-answer-box`
- [ ] Both tables render and scroll horizontally on mobile
- [ ] Five FAQ items, each answer 40 to 90 words
- [ ] `FAQPage` answer text is character-identical to the page
- [ ] `DefinedTerm` present for "Virtual PA" and for no other term
- [ ] Zero em dashes, zero contractions, zero literal `\uXXXX` sequences in the JSON-LD
- [ ] No internal link to any `/careers/*` page
- [ ] Exactly four internal links as specified in section 3, all resolving, no duplicate targets
- [ ] `[DONNAPRO PRICE GBP]` replaced everywhere, and the two instances match
- [ ] Page in `sitemap-0.xml`, count rises 128 to 129
- [ ] Canonical self-referencing, `robots` includes `index`
- [ ] Word count between 2,400 and 3,000
