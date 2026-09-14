# `/virtual-pa/` - positioning fix

**Prepared:** 14 September 2026
**Page:** `https://astro.donnapro.com/virtual-pa/`
**Problem:** the page sells a two-tier market frame, then offers DonnaPro's single product on the lower tier at the upper tier's price.

---

## What is wrong, in the order a visitor hits it

1. **A comparison table puts "Virtual PA" in the weaker column.** Autonomy: *"Executes reliably against your priorities"* against the EA's *"Sets priorities within an agreed remit and acts on your behalf"*. Business context: *"Enough to run your day well"* against *"Deep understanding of your objectives, stakeholders and commercial pressures"*. Complexity: *"Routine to moderately complex"* against *"Interconnected, sensitive, high-responsibility"*.

2. **Then the page sends the best buyer away.** *"If the thing slowing you down is board packs, investor updates and projects that stall without you, read our virtual executive assistant page instead."* That is DonnaPro's exact ideal client, told to leave a page built to capture a term where DonnaPro currently has no presence at all.

3. **Then it quotes the executive assistant price.** £2,350 part-time and £5,660 full-time. Those are the GBP equivalents of the €2,700 and €6,500 on `/pricing/`. Same product, same money.

4. **And calls it a different thing.** `/virtual-pa/` says **"Managed PA service"**. `/pricing/` is headed **"What Does a DonnaPro Executive Assistant Cost?"** and every bullet under it says "Elite virtual executive assistant" and "Top 1% EA".

5. **The testimonials on the page say "my EA".** *"Working with my EA allowed me to focus on new business opportunities."* A reader who has just been told a PA is the lighter option now reads proof from EA clients.

So the page says: you want the lesser thing, here is the greater thing's price, here is a different name for it, and here are testimonials about the greater thing. A buyer cannot resolve that, and neither could you, which is the correct reaction.

---

## Why it happened

DonnaPro sells **one** service. I took the *market's* PA-versus-EA tier distinction, which is real and which the research documented correctly, and imported it into DonnaPro's own offer, which has no tiers.

The research warned against exactly this. Olivia's pack said the distinction "should **not** imply that a Virtual PA is incapable of proactive or sophisticated work" and is "better understood as a difference in depth and level of executive ownership rather than a rigid task boundary". My own spec said "do not make the PA sound junior. It is a different remit, not a lower grade of person."

I wrote that instruction and then wrote copy that does the opposite. The strategy behind the page is still right. The execution of one section is not.

---

## The fix: one standard, two words for it

The frame should be that **the label is market noise and DonnaPro runs a single standard**, which happens to sit at the executive end. That resolves every contradiction above without touching the keyword targeting, the price, or the rest of the page.

It is also the stronger sales position. Right now a buyer searching "virtual PA" is told they want the cheaper tier and pointed elsewhere. After the fix they are told: yes, that is us, and ours operates well above what that term usually buys. That is the actual reason to pay more.

---

### Change 1 - replace the whole tier section

**Delete:** the H2 "Virtual PA vs Virtual Executive Assistant: Which One You Need", the five-row comparison table, its caption, and the three paragraphs beneath it, ending with "read our virtual executive assistant page instead."

**Replace with:**

**H2:** Virtual PA or Executive Assistant: `<em>`What You Get With Us`</em>`

> You will see both terms used for the same work, and most UK providers use them almost interchangeably. The words came from different places. "Personal assistant" is the traditional British title for one-to-one support. "Executive assistant" arrived from the corporate world and implies working closer to the business itself. Most agencies pick one and price to match.
>
> We do not run two tiers. Every DonnaPro assistant works to the same standard whether you arrived here looking for a virtual PA or a [virtual executive assistant](/virtual-executive-assistant/). That standard sits at the executive end of the market: your assistant does not wait for a task list. They read the week ahead, decide what genuinely needs you, and act inside limits you set.
>
> This is also why our pricing does not look like an hourly PA service. You are not buying blocks of admin time that expire at the end of the month. You are buying one person who owns the running of your working life, with a team behind them managing quality, training and cover.
>
> If what you need is a few hours of clearly defined tasks each week, an hourly service will serve you better and cost less. The comparison further down is honest about that. If you want the whole thing handled by someone who does not need managing, that is what we do.

224 words. The link to `/virtual-executive-assistant/` stays, so the internal link is preserved, but it now reads as "the same service under the other name" rather than "go here instead".

**Keep the pricing comparison table further down.** Hourly PA service, freelance PA, DonnaPro. That is the honest comparison, and it already does the job the tier table was attempting badly: it tells a buyer who only wants cheap hours to go elsewhere, without telling them the DonnaPro product is junior.

---

### Change 2 - name the product the same everywhere

The pricing card on `/virtual-pa/` currently reads **"Managed PA service"**. `/pricing/` calls the identical thing an executive assistant.

This is offer copy, so the wording is yours. The requirement is that a buyer who opens both pages sees one product, not two. The cheapest way to do that is a single line under the price on `/virtual-pa/`:

> The same assistant we place as an executive assistant. One standard, whichever word you use.

If you would rather change the card title instead, anything that does not imply a separate lesser product works. "Managed PA service" is the specific phrase causing the problem, because it reads as a product name that does not appear anywhere else on the site.

---

### Change 3 - rewrite FAQ 3

**Current question, keep it:** "What is the difference between a virtual PA and a virtual executive assistant?"

**New answer:**

> In the UK market the two terms are used almost interchangeably, and most providers simply pick one. Where a real difference exists it is depth: how much the assistant decides on your behalf rather than waiting to be told. DonnaPro does not run two tiers. The same assistant, the same standard and the same price apply whether you arrived looking for a virtual PA or an executive assistant.

68 words, inside the 40 to 90 limit. Copy it into the `FAQPage` schema character for character, as the current answer is.

---

### Change 4 - the testimonials become an asset

No edit needed. Once the page says the PA and the EA are the same person at DonnaPro, the "my EA" testimonials stop reading as a mismatch and start reading as proof. Leave them.

---

### Change 5 - make the task list DonnaPro's offer, not a market survey

Added 14 September 2026, after the first four changes went to staging.

The task section still describes the category rather than the service. Compare the two pages:

| Page | Sub-line under the task heading |
|---|---|
| `/virtual-executive-assistant/` | "**Our executive assistants take over** the operational workload that keeps you stuck in the weeds. Here is what that looks like in practice..." |
| `/virtual-pa/` | "These are the eight areas **UK buyers most consistently expect** a virtual PA to own." |

The first sells a service. The second reports what the market considers standard, which positions DonnaPro as meeting a baseline rather than exceeding one. It is the same defect as the tier table: research register in offer copy.

The gap is measurable across the page. `/virtual-pa/` says "DonnaPro" 14 times against the EA page's 25, and "your PA" or "your assistant" 11 times against 21.

**H2, optional but recommended:**

| From | To |
|---|---|
| What Your Virtual PA `<em>`Handles`</em>` | What Your DonnaPro Virtual PA `<em>`Handles`</em>` |

This diverges from the EA page, which carries no brand in the equivalent heading. The divergence is worth it here, and the EA page could follow later.

**Sub-line, required. Replace:**

> These are the eight areas UK buyers most consistently expect a virtual PA to own. Most clients hand over the first three in week one and add the rest as trust builds.

**With:**

> Your DonnaPro assistant takes over the operational layer of your working week. Here are the eight areas that covers, handled at the level you would expect from a senior executive assistant rather than a task-taker. Most clients hand over the first three in week one and add the rest as trust builds.

52 words. It does three jobs the current line does not: it names DonnaPro as the provider, it signals the service level, which is what justifies the price, and it carries the PA-to-EA merge into the section where a buyer is deciding what they actually get. The final sentence is kept because it is concrete and specific to how DonnaPro onboards.

**What stays as it is.** The eight task cards themselves are already written in DonnaPro voice ("Your PA reads your inbox before you do"). No change needed there.

**Market-register copy that should stay.** Three other passages describe the market, and all three are doing legitimate work:

- The "Virtual PA or Executive Assistant" section explaining that providers use the terms interchangeably. That is the section's entire purpose.
- "Most UK virtual PA services sell you hours" in the cost section. That is competitive contrast, and it sets up why DonnaPro prices differently.
- The FAQ answer on PA versus EA. Same reason.

The task list was the only place where category language displaced offer language.

---

## What does not change

- The keyword targeting. `virtual pa` at 720 a month, the cluster at roughly 1,730, DonnaPro absent from all of it. That opportunity is unaffected.
- The price. £2,350 and £5,660 are correct and match `/countries/uk/`.
- The schema. `Service` with `serviceType: "Virtual PA"` and `DefinedTerm` for "Virtual PA" are both still correct: it is the same service under the name this audience searches for. No `Table` node was emitted, so nothing to remove there.
- The task list, the personas, the process, the cost comparison, the FAQ apart from item 3.
- The separate `/virtual-executive-assistant/` page. Two pages for one product is fine when the search terms are genuinely distinct, and they are: 20 and 21 percent SERP overlap. Virtalent runs exactly this structure and both of its pages rank.

---

## Verification after the change

- [ ] No table on the page compares "Virtual PA" against "Virtual Executive Assistant" as two tiers
- [ ] The phrase "read our virtual executive assistant page instead" is gone
- [ ] Exactly one link to `/virtual-executive-assistant/` remains, in the new section
- [ ] The phrase "Managed PA service" is either gone or accompanied by the one-standard line
- [ ] FAQ 3 answer matches the new copy on the page and in the `FAQPage` schema, character for character
- [ ] Word count stays within 2,400 to 3,000
- [ ] Zero em dashes, zero en dashes, zero contractions in the new copy
- [ ] A reader who lands cold can answer "what am I buying and what does it cost" without opening a second page
