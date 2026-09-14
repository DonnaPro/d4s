# `/virtual-pa/` - implementation prompt for Changes 5 and 6

**Prepared:** 14 September 2026
**For:** the Claude session editing the Astro repo
**File:** `src/pages/virtual-pa.astro`
**Changes 1 to 4 are already live on staging.** This covers Changes 5 and 6 only, plus one decision.

---

## The prompt

Paste everything between the rules below.

---

You are editing `src/pages/virtual-pa.astro` in the DonnaPro Astro repo. The page is live on staging at `https://astro.donnapro.com/virtual-pa/`.

**Context.** This is a service page targeting "virtual PA" (720 UK searches a month). DonnaPro sells one service and markets it under two names, virtual PA and virtual executive assistant. An earlier pass already fixed the page so it no longer presents them as two tiers. Two things remain: the task section still describes the market rather than selling the service, and the task list is indistinguishable from a classic PA agency's.

**House style, mandatory.** No em dashes and no en dashes anywhere, use a spaced hyphen. No contractions. British spelling. Do not change any wording outside the edits specified below.

---

### Change A - the task section sub-line and heading

**A1.** Find this line (around line 309):

```
          <p class="jb-sub">These are the eight areas UK buyers most consistently expect a virtual PA to own. Most clients hand over the first three in week one and add the rest as trust builds.</p>
```

Replace with:

```
          <p class="jb-sub">Your DonnaPro assistant takes over the operational layer of your working week. Here are the eight areas that covers, handled at the level you would expect from a senior executive assistant rather than a task-taker. Most clients hand over the first three in week one and add the rest as trust builds.</p>
```

**Then, because Change B below takes the grid from eight cards to ten, change the word `eight` in that new sentence to `ten`.** The final line should read "Here are the ten areas that covers".

**A2.** Find this line (around line 308):

```
          <h2 class="jb-h2">What Your Virtual PA <em>Handles</em></h2>
```

Replace with:

```
          <h2 class="jb-h2">What Your DonnaPro Virtual PA <em>Handles</em></h2>
```

---

### Change B - add two task cards

**B1.** In the `handles` array (starts line 54), the last entry is:

```
  ["Personal and <em>Lifestyle Support</em>", "Appointments, renewals, gifts, restaurant bookings and household logistics. ...
```

Add these two entries **after it**, as the ninth and tenth items, immediately before the closing `];`:

```ts
  ["Investor and <em>Stakeholder Communication</em>", "Board papers assembled before the meeting rather than the night before it. Investor updates going out on the day they are due. The quiet follow-up when someone has not replied for a fortnight. Your assistant holds the thread on the relationships that matter most, so none of them go cold because the month got busy."],
  ["Project and <em>Deliverable Tracking</em>", "Deadlines tracked across everyone who owes you something, the chasing done without you being the one who chases, and a launch kept moving while you are in other meetings. This is where an assistant stops completing tasks and starts owning an outcome. It is also the part most founders delegate last, and usually regret waiting on."],
```

**B2.** In `handleIcons` (starts line 67), the last entry is:

```ts
  svg('<path d="M3 11l9-7 9 7"/><path d="M5 10v10h14V10"/>'), // personal/home
```

Add these two **after it**, in the same order as the handles, immediately before the closing `];`:

```ts
  svg('<path d="M3 3v18h18"/><path d="M7 14l4-4 3 3 4-6"/>'), // investor/chart
  svg('<rect x="3" y="4" width="18" height="16" rx="2"/><path d="M8 9l2 2 4-4M8 15h8"/>'), // project/checklist
```

The arrays must stay the same length and in the same order, because the template indexes icons by handle position.

**B3.** Check the `jb-cards--bento` grid still balances at ten cards. It was laid out for eight. If ten leaves an awkward orphan on desktop, adjust the grid rule in the page's `<style>` block rather than dropping or padding a card.

---

### Change C - a decision, not an edit

The page currently carries `noindex` via the `BaseLayout` prop on line 185, with a comment explaining it is deliberate until sign-off.

**Do not remove it as part of this task.** Report back that it is still set, and note that removing it requires two edits together, per the existing comment:

1. the `noindex` prop on `<BaseLayout>` in `src/pages/virtual-pa.astro`
2. the `SITEMAP_EXCLUDE` entry in `astro.config.mjs`

One without the other either hides the page from Google anyway or submits a noindex URL to Search Console.

---

### Verification before you report back

Run these against the built page, not the source:

- [ ] The phrase "UK buyers most consistently expect" appears nowhere
- [ ] The sub-line says "ten areas", not "eight"
- [ ] The H2 reads "What Your DonnaPro Virtual PA Handles"
- [ ] `handles.length === 10` and `handleIcons.length === 10`
- [ ] Ten cards render, each with an icon, no card missing its icon
- [ ] The grid has no orphaned or stretched card at desktop, tablet and mobile widths
- [ ] Zero em dashes and zero en dashes in the two new card texts
- [ ] Zero contractions in the two new card texts
- [ ] Word count rises by roughly 160 words
- [ ] Nothing else on the page changed: title, description, H1, the other eight cards, the FAQ, the pricing cards, the schema
- [ ] `noindex` still present, and reported as still present

---

## Notes for Zoran, not for the prompt

**On the `noindex` decision.** The comment in the file says the page must stay out of the index until the "virtual PA" cannibalisation with `/guides/how-to-hire-virtual-assistant-uk/` and `/comparison/best-virtual-assistant-companies-uk/` is settled. That caution is partly justified: `/comparison/best-virtual-assistant-companies-uk/` currently ranks position 29 for **virtual personal assistant**, which is a PA term.

But position 29 is weak, and `/virtual-pa/` is purpose-built for the cluster. Holding a dedicated page out of the index to protect a 29th-place ranking on a sibling term is the wrong trade in my view. The counter-argument is that `/comparison/best-virtual-assistant-companies-uk/` is your single most AI-cited page at 15 citations and must not be destabilised.

My recommendation: index it, and watch that one keyword weekly for four weeks. If the comparison page loses ground on `virtual personal assistant` and `/virtual-pa/` has not picked it up, reconsider. That is a reversible experiment; leaving the page unindexed indefinitely is not a decision, it is a deferral.

**On the en dashes.** Five remain on the page. Two are inside verbatim client testimonials, which should stay as quoted. The other three are used as bullet glyphs inside the pricing card component, so that is a component-level fix elsewhere, not in this file.

**On the dropped link.** The link to `/comparison/virtual-assistant-vs-executive-assistant/` disappeared when the tier section was removed. Optional to restore, not required.
