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

## What a statement is, and how to add one

### The concept

A statement is one fact, written as a **property** and a **value**.

> DonnaPro — *country* — Slovenia

In Wikidata's own shorthand that is `Q141450469 — P17 — Q215`. The item is a Q-number, the property is a P-number, and the value is often another Q-number. That is the entire model. Eight statements means eight facts like that one.

### The five kinds of value box you will meet

This is the part that trips people up. What you type depends on the property's data type, and the box does not always make it obvious.

| Data type | What the box wants | Example |
|---|---|---|
| **item** | Start typing a name, then pick from the dropdown. Never type a Q-number by hand | `instance of` → type "business", pick the one described as "organization undertaking commercial activity" |
| **url** | A full address including `https://` | `official website` → `https://donnapro.com` |
| **external-id** | Just the identifier, **not** the full URL | `LinkedIn company or organization ID` → `thedonnapro`, **not** `linkedin.com/company/thedonnapro` |
| **time** | A date picker. Year alone is fine if that is all you know | `inception` → `2019` |
| **quantity** | A plain number | `employees` → `40` |

The external-id one causes the most errors. Pasting the whole URL into an identifier field creates a broken link on the item.

### Adding your first statement, click by click

1. Open `https://www.wikidata.org/wiki/Q141450469` while logged in.
2. Scroll past the label and description box to the **Statements** heading.
3. Click **+ Add statement**. Two empty fields appear, property on the left, value on the right.
4. In the property field, type `instance of`. A dropdown appears. **Check the P-number reads P31** before clicking it, because several properties have similar names.
5. Move to the value field and type `business`. Pick the entry described as "organization undertaking commercial, industrial or professional activity". That is Q4830453.
6. Click **publish**.

That is one statement. The next seven work identically.

### Adding a reference, which is the part that matters

A statement with no reference is the thing that gets items deleted. Add one to every statement.

1. Under a published statement, click the small **0 references** link, or **add reference**.
2. A property field appears. Type `reference URL` and pick **P854**.
3. Paste the URL that supports the fact.
4. Optionally click **add** underneath to add a second line, type `retrieved` (**P813**), and set today's date. This is good practice and reviewers like to see it.
5. Click **publish**.

**Which URL to use as the reference:**

| For these statements | Use this reference |
|---|---|
| official website, LinkedIn, Facebook, Instagram | `https://donnapro.com` — these are self-evident facts about your own properties |
| country, headquarters, inception, official name, legal form, employees | Your **AJPES** business register entry. Search your company at `https://www.ajpes.si` and use the URL of your own record |

The AJPES reference is the important one. A national company register is exactly the "serious and publicly available reference" the notability rule asks for, and it is the single strongest thing you can attach to this item.

### One note on speed

There is a bulk tool called QuickStatements that can load many statements at once. For eight statements it is not worth learning the syntax. Do them by hand, it takes about twenty minutes including references.

---

## What to fill in

Work down this list. Each row is one statement.

### Core, add these first

| # | Property to type | P-number | What to type in the value box | Type |
|---|---|---|---|---|
| 1 | instance of | `P31` | `business`, pick "organization undertaking commercial, industrial or professional activity" (Q4830453) | item |
| 2 | country | `P17` | `Slovenia` (Q215) | item |
| 3 | headquarters location | `P159` | `Ljubljana`, pick the capital city (Q437), not the municipality | item |
| 4 | official website | `P856` | `https://donnapro.com` | url |
| 5 | industry | `P452` | `business service` (Q25351891) | item |

Statement 1 is the most important. Without `instance of`, the item is not formally "about" anything and reviewers treat it as incomplete.

### Identifiers, strong for machine linking

| # | Property to type | P-number | What to type in the value box | Type |
|---|---|---|---|---|
| 6 | LinkedIn company or organization ID | `P4264` | `thedonnapro` | external-id |
| 7 | Facebook username | `P2013` | `thedonnapro` | external-id |
| 8 | Instagram username | `P2003` | `thedonnapro` | external-id |

**Just the username on these three. No `https://`, no `linkedin.com/company/`.** They are verified from the `sameAs` array in the live Organization schema on donnapro.com, and Wikidata builds the full link itself.

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
