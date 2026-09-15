# Wikidata: DonnaPro (Q141450469)

**Prepared:** 15 September 2026
**Item:** `https://www.wikidata.org/wiki/Q141450469`
**Current state, checked live:** label "DonnaPro", description "premium executive assistant agency", English only. No aliases, no sitelinks, **zero statements**.

---

## What Wikidata is, in one paragraph

Wikidata is a structured database of facts about things, run by the Wikimedia Foundation. It is not an article, it is a list of machine-readable statements: this thing is a business, it is in Slovenia, its website is X. Google, Bing and the large language models all ingest it. It is one of the few places where you can state what your company *is* in a format machines treat as fact rather than marketing. That is why it matters for AI visibility, and it is the only reason to bother with it.

Every statement is a **property** (a `P` number, the field) plus a **value** (often a `Q` number, another Wikidata item). So "headquarters location = Ljubljana" is written `P159 = Q437`.

---

## Two things to fix before adding anything

### 1. The item is empty, and empty company items get deleted

Wikidata's notability rule requires an item to describe something "that can be described using serious and publicly available references". An item with zero statements and zero references fails that on its face. Empty items about companies are nominated for deletion routinely, and yours has been sitting empty.

**This is the actual urgency.** Not the SEO upside, the survival of the item.

### 2. The description is promotional

> "premium executive assistant agency"

**"Premium" is a marketing word and does not belong in a Wikidata description.** Descriptions are meant to be neutral and to disambiguate, nothing more. That single word is enough to attract a conflict-of-interest flag on an item that is already empty.

**Change it to:** `executive assistant agency` or `virtual executive assistant agency based in Slovenia`.

### 3. Declare the conflict of interest

You are editing an item about your own company. Wikidata tolerates this far better than Wikipedia does, but the expectation is that you say so. Put one line on your user page:

> I am the founder of DonnaPro and may edit the item about it (Q141450469). I will keep edits factual and sourced.

That single sentence is most of the difference between "company owner maintaining accurate data" and "undisclosed promotion".

---

## What to fill in

Work down this list. Each row is one statement.

### Core, add these first

| Property | Field name | Value | Notes |
|---|---|---|---|
| `P31` | instance of | `Q4830453` (business) | The single most important statement. Without it the item is not "about" anything |
| `P17` | country | `Q215` (Slovenia) | |
| `P159` | headquarters location | `Q437` (Ljubljana) | |
| `P856` | official website | `https://donnapro.com` | |
| `P452` | industry | `Q25351891` (business service) | |

### Identifiers, strong for machine linking

| Property | Field name | Value |
|---|---|---|
| `P4264` | LinkedIn organization ID | `thedonnapro` |
| `P2013` | Facebook username | `thedonnapro` |
| `P2003` | Instagram username | `thedonnapro` |

Those three are verified from the `sameAs` array in the live Organization schema on donnapro.com.

### You need to supply these, I will not guess them

I have deliberately left these blank rather than infer them. Getting a founding date or a legal name wrong on Wikidata is worse than omitting it.

| Property | Field name | What I need from you |
|---|---|---|
| `P571` | inception | The year DonnaPro was founded. The site says "7+ years of agency experience", which implies around 2019, but I am not stating a founding year on that basis |
| `P1448` | official name | The registered legal name, for example "DonnaPro d.o.o." if that is correct |
| `P1454` | legal form | The Slovenian legal form item. Search Wikidata for "družba z omejeno odgovornostjo" and use the Q number that comes back |
| `P1128` | number of employees | Current headcount, with the year as a qualifier |
| `P169` | chief executive officer | Filip Pesek, but this needs a Person item to point at, and a person item has its own notability test. Skip unless he already has one |

### Optional

- `P2088` Crunchbase organization ID, if DonnaPro has a Crunchbase profile
- `P973` described at URL, pointing at the AJPES business register entry

---

## The part that actually keeps the item alive: references

Statements without references are what get items deleted. **Every statement should carry a reference**, added through "add reference" underneath it.

The strongest reference available to you is the **Slovenian business register (AJPES)** entry. A national company register is exactly the "serious and publicly available reference" the notability rule asks for. Use it as the reference for inception, legal name, legal form and headquarters.

For the website and social identifiers, `P854` (reference URL) pointing at donnapro.com is acceptable, because those are self-evident facts about your own properties.

If the PR work has produced any independent press coverage, add one of those as a reference too. Independent coverage is worth more than anything self-published, and it is the difference between an item that survives a deletion discussion and one that does not.

---

## What not to add

- Anything with a marketing adjective: premium, elite, leading, top-rated, best
- Client names, testimonials, awards you gave yourself
- Prices
- Anything you cannot point to a published source for

Wikidata is not a listing site. Treat it as a registry entry, not a profile.

---

## Honest assessment of the upside

I checked every competitor in your comparison set. **None of them has a Wikidata item:**

Virtalent, Time Etc, Boldly, Prialto, BELAY, Pink Spaghetti, Worxbee, Athena. All absent. The one hit for "The Online PA" is an unrelated 1996 scientific article.

Two ways to read that:

**In your favour.** You would be the only entity in the category with a structured, machine-readable identity. For a programme whose entire objective is AI citation, that is a real and cheap differentiator.

**The caution.** Nobody in this category has established Wikidata notability, which may be because the category does not clear the bar. A company item with no independent coverage and an obvious COI editor can be deleted, and a deletion is recorded.

**My recommendation:** fill it in properly with the core statements and real references, neutralise the description, declare the COI. That is perhaps an hour of work. If it survives three months, it is a permanent asset nobody else in your market has. If it gets nominated, you will have lost an hour, and the nomination itself is not damaging to the site.

What would be damaging is leaving it exactly as it is now: an empty, promotionally-worded item created by someone connected to the company. That is the version most likely to be deleted, and it is the current state.
