# Services visitors: Q3 2026 (Jul-Sep)

**Prepared:** 28 September 2026
**Source:** PostHog project 36534 (Donna Pro), timezone Europe/Ljubljana
**Target tab:** `Services visitors` in *DonnaPro - Quarterly Stats*
**Data coverage:** 1 July to **27 September 2026**. Three days of the quarter are still missing.

Definition applied, from the tab's own note: organic and AI-driven sessions from the 17 target markets that visited at least one `/services/` page, careers visitors excluded, one count per session per page visited.

> **Different population from the previous two tabs.** This one is not restricted to homepage entries. It counts any qualifying session that touched a services page, whatever page it landed on.

---

## The table

| Service page | Q2 2026 | Q3 2026 (to 27 Sep) |
|---|---|---|
| /services/ | 54 | **84** |
| /services/travel-planning/ | 70 | **11** |
| /services/email-management/ | 46 | **6** |
| /services/offers-and-proposals/ | 2 | **5** |
| /services/research-services/ | 7 | **4** |
| /services/calendar-management/ | 23 | **2** |
| /services/project-management/ | 15 | **2** |
| /services/managing-investors/ | 7 | **2** |
| /services/standard-operating-procedures-sops/ | 6 | **2** |
| /services/hr-tasks/ | 5 | **2** |
| /services/marketing/ | 3 | **2** |
| /services/reports/ | 15 | **1** |
| /services/personal-tasks/ | 9 | **1** |
| /services/client-relationship-management/ | 1 | **1** |
| /services/organizing-notes-and-files/ | 1 | **1** |
| /services/brief-preparation/ | 4 | 0 |
| /services-new/ | 1 | 0 |
| /services/event-organisation/ | 1 | 0 |
| **Sum of all rows** | **270** | **126** |
| **Unique sessions touching any service page** | **228** | **104** |

The two totals differ because a session visiting three service pages appears in three rows. Both are given because the tab's note defines rows per page, but the headline number people will quote is the deduplicated session count.

---

## The finding: the service sub-pages are set to noindex

Unique sessions reaching a services page fell **228 to 104, down 54%**. That collapse has a single cause, and it is verifiable on the live site right now.

**Split by how visitors arrived:**

| | Q2 | Q3 | Change |
|---|---|---|---|
| Landed directly on a service page (search entry) | **159** | **34** | **-79%** |
| Arrived by internal navigation | 69 | 70 | flat |
| ...of which entered on the homepage | 30 | 48 | +60% |

Internal navigation did not move. Only search entries collapsed.

**Organic landings, page by page:**

| Landing page | Q2 | Q3 |
|---|---|---|
| /services/travel-planning/ | 62 | **6** |
| /services/email-management/ | 27 | **1** |
| **/services/ (hub)** | 19 | **25** |
| /services/reports/ | 13 | **0** |
| /services/project-management/ | 10 | **0** |
| /services/calendar-management/ | 8 | **0** |
| /services/personal-tasks/ | 4 | **0** |
| /services/standard-operating-procedures-sops/ | 4 | **0** |
| /services/managing-investors/ | 3 | **0** |
| /services/marketing/ | 2 | **0** |
| /services/hr-tasks/ | 2 | **0** |
| /services/research-services/ | 2 | **0** |
| /services/brief-preparation/ | 1 | **0** |

Every sub-page went to zero or near-zero. The hub went up. That is the signature of the children being removed from the index while the parent stays in it.

**Verified on donnapro.com, 28 September 2026:**

| Page | HTTP | robots meta | In sitemap |
|---|---|---|---|
| /services/ | 200 | `index, max-image-preview:large` | **yes** |
| /services/travel-planning/ | 200 | **`noindex`** | no |
| /services/email-management/ | 200 | **`noindex`** | no |
| /services/reports/ | 200 | **`noindex`** | no |
| /services/project-management/ | 200 | **`noindex`** | no |
| /services/calendar-management/ | 200 | **`noindex`** | no |
| /services/managing-investors/ | 200 | **`noindex`** | no |
| /services/personal-tasks/ | 200 | **`noindex`** | no |

`sitemap-0.xml` holds 135 URLs. Exactly **one** contains `/services`, and it is the hub.

Every sub-page returns 200, serves its content, self-canonicalises to itself, and carries `noindex`. They are live, reachable, linked internally, and invisible to search.

### What it costs

**Roughly 125 organic sessions per quarter**, that being the 159 to 34 fall in direct landings.

`/services/travel-planning/` alone was worth 62 organic sessions in Q2 and is now worth 6. `/services/email-management/` went 27 to 1. `/services/managing-investors/` carries about 2,800 words and now receives zero organic entries.

### The question

This was on the open list from an earlier session as the "`/services/*` noindex decision", so it may well be deliberate. The data now prices it:

- **If it was deliberate**, the cost is about 125 organic sessions a quarter, and the hub absorbing some of it (+6 entries) does not come close to covering the loss.
- **If it was not deliberate**, this is a live SEO fault on a dozen commercial pages and it is the single highest-value fix on the site right now.

Either way it is worth a decision rather than drift. Note that `/services/` as a first click after the homepage also doubled this quarter, 12 to 26 on the `Next pages visitors` tab, so demand for this content has not fallen. Only its search visibility has.

---

## Smaller things

`/services-new/` appears with 1 session in Q2. That looks like a leftover staging or draft page sitting on production. Worth confirming it should exist at all.

`/services/event-organisation/` and `/services/brief-preparation/` both fell to zero across the board, entries and navigation alike.

---

## Reusable query

```sql
SELECT
  service_page,
  countIf(q = 'Q2') AS q2_2026,
  countIf(q = 'Q3') AS q3_2026
FROM (
  SELECT q, arrayJoin(services_paths) AS service_page
  FROM (
    SELECT
      $session_id AS sid,
      argMin(properties.$geoip_country_code, timestamp)      AS country,
      coalesce(any(session.$channel_type), '')               AS channel,
      coalesce(any(session.$entry_referring_domain), '')     AS refdom,
      toDate(toTimeZone(min(timestamp), 'Europe/Ljubljana')) AS ds,
      max(coalesce(properties.$virt_is_bot, false))          AS is_bot,
      countIf(properties.$pathname LIKE '/careers%')         AS careers,
      groupUniqArrayIf(
        if(properties.$pathname = '', '/', properties.$pathname),
        properties.$pathname LIKE '/services%'
      )                                                      AS services_paths,
      if(ds <= toDate('2026-06-30'), 'Q2', 'Q3')             AS q
    FROM events
    WHERE event = '$pageview'
      AND timestamp >= toDateTime('2026-03-31 00:00:00')
      AND timestamp <  toDateTime('2026-10-01 00:00:00')
      AND $session_id != ''
    GROUP BY sid
  )
  WHERE country IN ('AT','BE','DK','FI','FR','DE','IE','LU','NL','NO','SE','CH','GB','AU','CA','AE','US')
    AND channel NOT IN ('Organic Social','Paid Social','Organic Video','Paid Search')
    AND refdom NOT ILIKE '%donnapro%'
    AND NOT is_bot
    AND careers = 0
    AND ds >= toDate('2026-04-01') AND ds <= toDate('2026-09-30')
    AND length(services_paths) > 0
)
GROUP BY service_page
ORDER BY q3_2026 DESC, q2_2026 DESC
```

Swap `arrayJoin(services_paths)` for `count()` on the inner query to get the deduplicated session total instead of the per-page rows.
