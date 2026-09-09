# Brief: add "PA" to /guides/how-to-hire-virtual-assistant-uk/

**Prepared:** 9 September 2026
**Page:** `https://donnapro.com/guides/how-to-hire-virtual-assistant-uk/`
**Scope:** three body insertions and one new FAQ. Nothing else.
**Source of truth:** live page text, fetched 9 September 2026.

---

## Constraints, read first

**This is a protected page.** It is one of the four DonnaPro pages AI assistants cite most. Adding body prose and an FAQ entry is permitted. The following must not change:

- Title, H1, meta description, URL, canonical
- Any H2 or H3
- The structure of the General VA vs Executive VA table
- Any existing sentence not named in this brief

**Matching the find strings.** The live page uses **en dashes** (`–`, U+2013) and **curly quotes** (`'` `"`). Every find string below is chosen to avoid both, so it can be matched as plain ASCII. Do not normalise the page's existing punctuation as part of this edit: there are 34 en dashes on the page and sweeping them is a separate, approved job.

**New copy follows house style:** spaced hyphen `-` not en dash, no contractions.

---

## Edit 1 of 3 - the answer box

This is the most-quoted passage on the page, so the head term belongs here.

**Find:**

```
An executive virtual assistant handles higher-level support
```

**Replace with:**

```
An executive virtual assistant, also sold as a virtual PA in the UK, handles higher-level support
```

Nothing else in that paragraph changes. The en dashes either side of the task list stay as they are.

---

## Edit 2 of 3 - opening of "Types of Virtual Assistant"

The section is about telling the types apart, so this is where the naming overlap gets explained once, properly.

**Find:**

```
Not all virtual assistants do the same work. The term covers a wide spectrum, and hiring the wrong type is the most common mistake UK businesses make.
```

**Replace with:**

```
Not all virtual assistants do the same work. The term covers a wide spectrum, and hiring the wrong type is the most common mistake UK businesses make. The naming does not help. UK providers use "virtual assistant", "virtual PA" and "executive assistant" loosely and often interchangeably, so two quotes carrying the same job title can describe very different levels of support.
```

Adds 44 words. The table immediately below is untouched.

---

## Edit 3 of 3 - closing line of the same section

**Find:**

```
you need an executive virtual assistant.
```

**Replace with:**

```
you need an executive virtual assistant, which many UK providers market as a virtual PA.
```

This sentence sits directly above the link to the C-level guide. Check the find string matches only once before replacing.

---

## The new FAQ

**Position:** last item, after "What tasks can I delegate to a virtual assistant?". The live FAQ has six items; this becomes the seventh.

**Question:**

```
Is a virtual PA the same as a virtual assistant?
```

**Answer:**

```
In practice, yes: most UK agencies use the two terms to sell the same service. They come from different places - "personal assistant" is the traditional UK title for in-person, one-to-one support, while "virtual assistant" describes the remote delivery model - but the label now tells you little. Judge providers on the level of autonomy you are buying, not the title. That is the difference between £15 to £35 per hour and £35 to £75 per hour support.
```

82 words. Both hourly figures are already on this page, in the VA versus EA table, so the FAQ stays consistent with the body.

### Why this answer, and not the drafted one

The version in Olivia's document reads:

> "A virtual assistant typically handles defined administrative tasks such as diary management, data entry and email handling. A virtual PA or executive assistant operates at a higher level, managing priorities, coordinating stakeholders and making decisions on the leader's behalf."

That is a good paragraph, but it is the same answer as the FAQ already sitting two items above it:

> **What is the difference between a virtual assistant and an executive assistant?**
> "A virtual assistant is a broad term covering anyone who provides remote administrative support. An executive assistant provides higher-level support to senior leaders... The key difference is decision-making authority."

Two FAQ items giving the same capability comparison with one word swapped is duplicate content in the same `FAQPage`, and it wastes the slot. The existing item already owns the capability question. The new one should answer what a reader searching "virtual PA" is actually unsure about, which is whether the two words mean different products. The replacement above does that and defers the capability difference to the item that already covers it.

---

## Schema

The page carries `FAQPage`. Add the matching `Question` and `acceptedAnswer` node for the new item, and make the schema answer text **character-identical** to the on-page answer. A mismatch between the two is what breaks rich-result eligibility, and it is the check that caught problems on the Fix 2 and Fix 3 pages.

Do not add `DefinedTerm` to this page. It belongs on `/virtual-executive-assistant/` and nowhere else for this term.

---

## Optional, needs sign-off

The VA versus EA table has a `Dimension` column and would take an **"Also known as"** row cleanly:

| | General Virtual Assistant | Executive Virtual Assistant |
|---|---|---|
| Also known as | Virtual assistant, admin assistant, VA | Virtual PA, executive assistant, EA |

This is the single clearest place on the page to settle the terminology, and it would be the passage an AI assistant quotes when asked what a virtual PA is. **But it adds a row to a table on a protected page**, which counts as a structural change. Decide before it is built, not after.

---

## Verification

- [ ] `PA` appears 3 times in body prose, plus the FAQ question and twice in the FAQ answer. It was **0** before
- [ ] Title, H1, meta description, canonical and all 24 headings unchanged
- [ ] The VA versus EA table has the same number of rows as before, unless the optional row was approved
- [ ] FAQ has 7 items; the first 6 are unchanged word for word
- [ ] `FAQPage` schema has 7 `Question` nodes and the new answer text matches the page exactly
- [ ] Page returns 200, canonical self-referencing, `robots` includes `index`
- [ ] Zero em dashes in the new copy; no contractions in the new copy
- [ ] Existing en dashes elsewhere on the page left alone
- [ ] Word count rises by roughly 145 words, from about 4,000

---

## What this does not fix

Two problems on this page are out of scope here and still open:

1. The **REC citation returns 404**. It carries the 42-day time-to-hire figure and the £132,000 cost-of-a-bad-hire figure. Both need a working source or both come out.
2. The **£8,449 monthly in-house figure** matches `/countries/uk/` but disagrees with `/guides/executive-assistant-cost-guide/` (£7,266) and `/guides/virtual-executive-assistant-cost-uk/` (£8,280). Pick the canonical number across all three before adding more pages that quote it.
