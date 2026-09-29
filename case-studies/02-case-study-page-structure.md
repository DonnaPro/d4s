# Single case study page: structure spec

**Prepared:** 29 September 2026
**URL pattern:** `/case-studies/{client-slug}/`
**Purpose of this document:** the section-by-section template for one case study. Structure only, no copy.

---

## What this page has to do

A founder is deciding whether to spend a monthly fee on something they have never bought before. They are not looking for information. They are looking for **permission to believe it will work for them**.

They arrive with six questions, in this order:

1. Is this someone like me?
2. What was actually going wrong?
3. What did the assistant actually do? ← **credibility is won or lost here**
4. Did it work?
5. Would it work for me?
6. What do I do now?

The page is built to answer those six in that sequence. Every section below maps to one of them.

---

## Two constraints that shape the whole layout

**1. Most people will not scroll.** Measured on your own homepage this quarter: 65% of desktop views never scroll past 5%, and only 11% pass 75%. There is no reason to expect a case study to do better.

**2. Your homepage is 25,680px on desktop and 36,409px on mobile.** That is far too long for this page type.

So:

| | Target |
|---|---|
| Total word count | **1,200 to 1,500** |
| Total page height, desktop | **around 8,000px**, roughly one third of the homepage |
| Everything decisive | **above 3,000px**, which is the first two or three screens |
| Mobile | the At a Glance box must be fully readable without scrolling past the second screen |

If a section cannot justify its pixels, cut it. A tight 1,200-word case study converts better than a thorough 3,000-word one that nobody reaches the end of.

---

## Section by section

### 1. Hero and identity — answers "is this someone like me?"

**Height: 800 to 1,200px. Word count: 40 to 60.**

| Element | Notes |
|---|---|
| Client logo | Large enough to be the first thing seen |
| Tags | Industry · Country · Company size. Small, muted, on one line |
| **H1** | **Result-led, not name-led.** Pattern: `How [Client] [achieved outcome] with [mechanism]` |
| Sub-line | One sentence describing the business, for a reader who has never heard of them |
| Assistant credit | "Supported by [EA first name]" with a photo if they consent |

**Why a result-led H1.** A name-led heading ("WUKA Case Study") tells the reader nothing and forces them to read on to find out whether it is relevant. A result-led one does the qualification work in the heading itself, which is the only line most visitors will read.

No hero image of a generic person at a laptop. Either the client's logo and a real photo, or nothing. Stock imagery on a trust page actively costs trust.

### 2. At a glance — the workhorse

**Height: 1,200 to 1,600px. Word count: 120 to 180.**

This is the single most important block on the page. Assume half your readers will read this and nothing else, then decide. Build it so that is enough.

A bordered box or contrasting panel, sitting immediately under the hero, containing:

| Row | Content |
|---|---|
| **The situation** | One sentence. What was breaking before |
| **What the assistant took on** | Three to five bullets, concrete and named |
| **The outcome** | One to three hard results. Numbers, named third parties, named wins |
| **Time to first value** | "First week", "within a month". Answers the unspoken "how long until this pays off" |
| **Still working together** | Yes or no, and how long. Duration is a trust signal in itself |

Everything in this box must be checkable against reality. It is also the block a language model will quote when asked about your results, so keep it factual and self-contained, with no pronouns referring back to earlier text.

### 3. Where they were — answers "what was going wrong?"

**Word count: 150 to 200.**

The before state. What the founder's week actually looked like, what was slipping, what it was costing them.

Write it so the reader recognises their own week. Specific beats dramatic: "invoices were reconciled whenever someone remembered" lands harder than "operations were in chaos".

Include **why they had not solved it another way**: why not a full-time hire, why not a freelancer, why not software. This pre-empts the objection rather than leaving it live.

### 4. Why this assistant — answers "how do you get the right person?"

**Word count: 80 to 120.**

Short. How the match was made, what was looked for, what made this assistant right for this founder.

This section sells the **agency model** rather than the individual. A reader who believes the outcome but thinks it depended on getting lucky with one exceptional person has not been converted. This is where you show the matching was deliberate.

### 5. What the assistant actually does — answers "what will I get?"

**Word count: 250 to 350. The longest section on the page.**

The most carefully read section, and the one where credibility is won or lost.

- **Name the tools.** Airtable, Dropbox, Motion, Xero, whatever it genuinely is. Named software is the fastest credibility signal available, because it cannot be faked convincingly.
- **Itemise.** A two-column list or grouped sub-headings beat prose here, because readers scan for their own pain.
- **Group by area**, not chronology. Inbox and calendar / finance / reporting / suppliers / compliance.
- **Include the unglamorous.** Chasing suppliers and reconciling invoices are more believable, and more reassuring, than "strategic support".

Avoid every abstraction: "streamlined operations", "improved efficiency", "transformed the business". If a sentence would be true of any assistant at any company, cut it.

### 6. The turning point — the memorable bit

**Word count: 120 to 180.**

One specific project or incident, told as a small story with a beginning and an end.

This is what a reader repeats to a co-founder later. Nobody remembers a bullet list; they remember "they replaced an Evernote process with a deal-intake workflow that pipes straight into Airtable".

Exactly one of these per case study. Two dilutes.

### 7. What changed — answers "did it work?"

**Word count: 120 to 180.**

The results, stated plainly. Hard numbers first, then named external outcomes, then qualitative change.

**If there are no numbers, say what there is instead and do not inflate.** "Three award submissions shortlisted" is a real result. "Significantly improved visibility" is not, and a buyer reads the difference instantly.

### 8. In their words — the pull quote

**Height: 400 to 600px.**

One large quote from the client. Full attribution: name, role, company, and a photo if they consent.

One quote, not three. A wall of quotes reads as a testimonials page and this is not one. Choose the line that a sceptic would find hardest to dismiss.

### 9. Would this work for you? — answers "would it work for me?"

**Word count: 150 to 200.**

The transfer section, and the one most case studies skip. It is what turns a nice story into a decision.

Three parts:

1. **Who this applies to.** "If you are running more than one business and your finance admin is the thing that slips, this is the closest match on the site."
2. **What it took from the client.** Onboarding time, how much briefing was needed in the first weeks. **Be honest here.** A case study with no friction in it reads as marketing. One truthful line about the ramp-up makes every other claim on the page more believable.
3. **Where it would not fit.** One sentence. Naming who this is not for is the strongest trust signal on the page and costs you nothing, because those people were never going to buy.

### 10. CTA

`Cta.astro`, smush convention. Single primary action to `/get-started/`.

One CTA block. Not a sticky bar, not a mid-page interruption. The story is the persuasion.

### 11. Related stories

Two or three other case study cards, plus a link to the matching `/who-we-serve/` page.

Pick related studies by **similar situation**, not by industry. A founder running multiple businesses wants another multi-business story more than another story from their sector.

---

## Credibility rules

These apply to every case study and matter more than the layout.

1. **Name everything you are allowed to name.** Client, assistant, tools, third parties, awards, councils. Every anonymised element costs credibility, so anonymise only where consent requires it.
2. **Never round a number up.** If it is 9 months, say 9 months, not "nearly a year".
3. **Include at least one honest limitation.** Slow first month, a task that did not work out, something still in progress. This is the highest-leverage trust move available and almost nobody does it.
4. **Activities are not outcomes.** "Helped create visibility around project profitability" describes work. "Cut month-end close from three days to one" describes a result. Every case study needs at least one of the second kind.
5. **No superlatives about yourselves.** Let the client's quote carry the praise.
6. **Date it.** "Working together since January 2026." Undated stories feel stale and unverifiable.

---

## Intake checklist

Gather before writing. Most of these are missing from the current five.

**From the client:**
- [ ] Written consent to be named, plus consent for any third parties named (councils, awards, NHS, suppliers)
- [ ] One quotable sentence, approved
- [ ] Permission to use the logo
- [ ] At least one hard number: hours returned per week, a cost saved, a contract won, a cycle time cut
- [ ] What their week looked like before
- [ ] Why they did not hire in-house or use a freelancer
- [ ] What onboarding actually took

**From the assistant:**
- [ ] Consent to be named and photographed
- [ ] The full task list, grouped by area
- [ ] Every tool by name
- [ ] The single project they are proudest of, with enough detail to tell as a story
- [ ] What was hardest in the first month

**From the account manager:**
- [ ] Start date and current status
- [ ] Why this assistant was matched to this client
- [ ] Anything that cannot be published

---

## Build notes

| Item | Spec |
|---|---|
| URL | `/case-studies/{client-slug}/`, lowercase, hyphens, no dates |
| Robots | `index, follow` |
| Sitemap | include |
| Schema | `Article`. Not `Review`, which stays on `/testimonials/` |
| Breadcrumb | Home / Case Studies / [Client] |
| Body copy | `--text-size` token |
| Section rhythm | hero 72 / section 76, per the design system |
| CTA | `Cta.astro` |
| Images | client logo, assistant photo, client photo. No stock |
| Copy style | no em dashes, no en dashes, British spelling, prices as `[DONNAPRO PRICE EUR]` placeholders |

---

## Section summary

| # | Section | Words | Answers |
|---|---|---|---|
| 1 | Hero and identity | 40-60 | Is this someone like me? |
| 2 | **At a glance** | 120-180 | All six, in 60 seconds |
| 3 | Where they were | 150-200 | What was going wrong? |
| 4 | Why this assistant | 80-120 | How do you get the right person? |
| 5 | **What the assistant does** | 250-350 | What will I actually get? |
| 6 | The turning point | 120-180 | (memorability) |
| 7 | What changed | 120-180 | Did it work? |
| 8 | In their words | quote | (trust) |
| 9 | Would this work for you? | 150-200 | Would it work for me? |
| 10 | CTA | - | What do I do now? |
| 11 | Related stories | - | (routing) |
| | **Total** | **1,230-1,470** | |

---

## Next

Once one of these is live, the linking pass is a separate job: go through the blog, guides, comparison and service pages and place links **to** the case study where a claim needs proof, and add links **from** the case study out to the pages that support it. That pass is worth doing properly once there is a real page to point at, rather than guessing now.
