# Reverse Path to /get-started/: Q3 2026 (Jul-Sep)

**Prepared:** 28 September 2026
**Source:** PostHog project 36534 (Donna Pro), timezone Europe/Ljubljana
**Target tab:** `Reverse Path` in *DonnaPro - Quarterly Stats*
**Data coverage:** 1 July to **27 September 2026**. Three days of the quarter are still missing.

The last page seen immediately before the first view of `/get-started/` in a session.

> **The tab's note does not state a source filter**, unlike the other tabs. So both bases are given: all traffic, and the organic target-market subset used elsewhere in this workbook. Tell me which the published column used.

`/get-started/` is matched exactly. The variants `/get-started/call/`, `/hr/`, `/other/`, `/call-usa/`, `/confirmed/` and `/hr-confirmed/` are separate pages and are not counted as the destination.

---

## Table in the existing sheet structure

The published Q2 column includes careers pages and has no "landed directly" row, so the basis is **all traffic, careers included, sessions that had a prior page only**. Sessions landing straight on `/get-started/` are excluded (102 in Q2, 89 in Q3).

**Totals: Q2 595 sessions across 67 pages. Q3 657 sessions across 83 pages.**

### Your existing 33 rows, in your order

| # | Previous page | Q2 | Q3 |
|---|---|---|---|
| 1 | / (homepage) | 346 | **318** |
| 2 | /pricing/ | 31 | **44** |
| 3 | /countries/germany/ | 16 | **11** |
| 4 | /countries/uk/ | 14 | **11** |
| 5 | /countries/italy/ | 13 | **11** |
| 6 | /countries/ | 11 | **33** |
| 7 | /countries/spain/ | 10 | **7** |
| 8 | /services/calendar-management/ | 9 | **4** |
| 9 | /countries/netherlands/ | 11 | **7** |
| 10 | /countries/france/ | 8 | **6** |
| 11 | /countries/belgium/ | 7 | **5** |
| 12 | /services/email-management/ | 7 | **4** |
| 13 | /services/ | 9 | **26** |
| 14 | /virtual-executive-assistant/ | 5 | **25** |
| 15 | /uk-virtual-assistant-agency/ | 7 | **0** |
| 16 | /careers/executive-virtual-assistant-jobs/ | 5 | **4** |
| 17 | /countries/switzerland/ | 7 | **9** |
| 18 | /who-we-serve/healthcare-virtual-assistant/ | 5 | **0** |
| 19 | /countries/ireland/ | 4 | **2** |
| 20 | /services/project-management/ | 4 | **1** |
| 21 | /countries/canada/ | 3 | **1** |
| 22 | /get-started/call/ | 2 | **2** |
| 23 | /testimonials/ | 2 | **4** |
| 24 | /services/travel-planning/ | 2 | **3** |
| 25 | /guides/c-level-executive-assistant/ | 2 | **2** |
| 26 | /guides/ | 2 | **0** |
| 27 | /pricing/full-time-executive-assistant/ | 2 | **0** |
| 28 | /guides/how-to-choose-executive-assistant-agency/ | 2 | **0** |
| 29 | /countries/dubai/ | 2 | **5** |
| 30 | /comparison/virtual-assistant-vs-executive-assistant/ | 2 | **2** |
| 31 | /who-we-serve/startup-virtual-assistant/ | 2 | **0** |
| 32 | /careers/location/ | 2 | **5** |
| 33 | /careers/location/spain/ | 2 | **4** |
| | **Subtotal, your 33 rows** | | **556** |

### New rows to add: pages with 2 or more sessions in Q3 that are not in your list

| Previous page | Q2 | Q3 |
|---|---|---|
| /bravo/careers/ | 0 | **7** |
| /who-we-serve/investment-virtual-assistant/ | 1 | **6** |
| /careers/location/italy/ | 0 | **6** |
| /careers/ | 1 | **5** |
| /countries/norway/ | 1 | **5** |
| /careers/location/portugal/ | 0 | **5** |
| /countries/australia/ | 1 | **4** |
| /guides/working-with-executive-assistant/ | 0 | **3** |
| /countries/usa/ | 2 | **2** |
| /countries/denmark/ | 1 | **2** |
| /services/reports/ | 1 | **2** |
| /our-story/ | 1 | **2** |
| /ceo-insights/buy-back-your-time/ | 1 | **2** |
| /careers/location/romania/ | 0 | **2** |
| /who-we-serve/ | 0 | **2** |
| /guides/inbox-calendar-travel-management-executive-assistant/ | 0 | **2** |
| /category/virtual-assistant-careers/ | 0 | **2** |
| /comparison/best-virtual-assistant-companies-uk/ | 0 | **2** |
| /careers/location/bulgaria/ | 0 | **2** |
| /countries/luxembourg/ | 0 | **2** |
| **Subtotal, new rows** | | **65** |

### Tail row

`(36 more pages with 1 session each)` = **36**

Your Q2 tail read "(33 more pages with 1 session each)". Q3 has 38 single-session pages in total, but two of them (`/services/project-management/` and `/countries/canada/`) already appear in your named rows above, so the tail row is 36 to avoid double-counting.

**Reconciliation: 556 + 65 + 36 = 657.** Matches the checksum exactly.

### Two rows worth acting on

**`/uk-virtual-assistant-agency/` returns 404.** It fed 7 sessions into the sign-up form in Q2 and zero in Q3, because the page no longer exists and there is no redirect. This looks like a migration casualty. It should redirect to `/countries/uk/`, which is live and already feeds 11 sessions.

The other zeros are not broken. `/who-we-serve/healthcare-virtual-assistant/`, `/pricing/full-time-executive-assistant/`, `/guides/how-to-choose-executive-assistant-agency/`, `/who-we-serve/startup-virtual-assistant/` and `/guides/` all return 200 and are indexable. They simply stopped feeding the form.

`/services/project-management/` returns 200 but carries `noindex`, same as the rest of the services sub-pages.

### A note on the Q2 column

My Q2 recompute differs slightly from your published ordering: I have `/countries/netherlands/` at 11 where your row order implies it sits below `/countries/spain/` at 10. This is the same few-percent per-country variance flagged on the `Organic visitors by country` tab. The totals and the trends are sound; individual small rows may differ by 1 or 2.

---

## Full distribution, both bases

| Previous page | Q2 all traffic | Q3 all traffic | Q2 organic TAM | Q3 organic TAM |
|---|---|---|---|---|
| / (homepage) | 346 | **318** | 40 | **28** |
| (landed directly on /get-started/) | 102 | **89** | 13 | **13** |
| /pricing/ | 31 | **44** | 4 | **6** |
| /countries/ | 11 | **33** | 0 | **1** |
| /services/ | 9 | **26** | 6 | **2** |
| /virtual-executive-assistant/ | 5 | **25** | 0 | **2** |
| /countries/germany/ | 16 | **11** | 7 | **6** |
| /countries/uk/ | 14 | **11** | 1 | **2** |
| /countries/italy/ | 13 | **11** | 0 | **1** |
| /countries/switzerland/ | 7 | **9** | 7 | **1** |
| /countries/netherlands/ | 11 | **7** | 0 | **2** |
| /countries/spain/ | 10 | **7** | 0 | **1** |
| /bravo/careers/ | 0 | **7** | 0 | **1** |
| /countries/france/ | 8 | **6** | 1 | **2** |
| /who-we-serve/investment-virtual-assistant/ | 1 | **6** | 1 | **0** |
| /careers/location/italy/ | 0 | **6** | 0 | **0** |
| /countries/belgium/ | 7 | **5** | 2 | **2** |
| /countries/dubai/ | 2 | **5** | 1 | **1** |
| /careers/location/ | 2 | **5** | 0 | **0** |
| /countries/norway/ | 1 | **5** | 1 | **1** |
| /careers/ | 1 | **5** | 0 | **0** |
| /careers/location/portugal/ | 0 | **5** | 0 | **0** |
| /services/calendar-management/ | 9 | **4** | 3 | **0** |
| /services/email-management/ | 7 | **4** | 0 | **0** |
| /careers/executive-virtual-assistant-jobs/ | 5 | **4** | 0 | **0** |
| /careers/location/spain/ | 2 | **4** | 0 | **0** |
| /testimonials/ | 2 | **4** | 0 | **1** |
| /countries/australia/ | 1 | **4** | 0 | **0** |
| /services/travel-planning/ | 2 | **3** | 0 | **2** |
| /guides/working-with-executive-assistant/ | 0 | **3** | 0 | **0** |
| Everything else (2 or fewer each) | 76 | **60** | 16 | **15** |
| **Total** | **697** | **746** | **103** | **90** |

Totals verified two ways: the bucket sums and the monthly sums both give 697 and 746.

## Grouped

| Route | Q2 all | Q3 all | Q2 TAM | Q3 TAM |
|---|---|---|---|---|
| Homepage | 346 | 318 | 40 | 28 |
| Countries pages | 111 | 125 | 22 | 23 |
| Landed directly on /get-started/ | 102 | 89 | 13 | 13 |
| **Careers pages (job seekers)** | **15** | **48** | 0 | 2 |
| Services pages | 37 | 43 | 12 | 5 |
| Service and audience pages | 23 | 40 | 4 | 5 |
| Pricing | 31 | 44 | 4 | 6 |
| Content, guides, comparison, other | 32 | 39 | 8 | 8 |

---

## Finding 1: job seekers are reaching the client sign-up form, and it tripled

Sessions arriving at `/get-started/` directly from a careers page went **15 to 48**. That is now 6.4% of everyone who reaches the client sign-up form.

Monthly, it is a July spike that is partly self-correcting:

| Month | From a careers page | Total reaching /get-started/ |
|---|---|---|
| April | 3 | 224 |
| May | 6 | 218 |
| June | 6 | 255 |
| **July** | **24** | 246 |
| August | 15 | 226 |
| September | 7 | 274 |

**The route is the site-wide header, not in-content links.** I checked five careers pages on the live site: `/careers/`, `/bravo/careers/`, `/careers/location/`, `/careers/location/italy/` and `/careers/executive-virtual-assistant-jobs/`. None has a single `/get-started/` link in its `<main>` content. Every one carries exactly one in the header navigation, anchor text "GET STARTED".

So a job seeker reading a careers page sees the global "GET STARTED" button and clicks it, landing on the client enquiry form. There is a separate `/get-started/hr/` page (68 sessions this quarter) that would be the right destination for them.

**Worth fixing**, because these are job-seeker leads entering the sales pipeline. Options: suppress or relabel the header CTA on `/careers/*`, or point it at `/get-started/hr/` within the careers section.

## Finding 2: the homepage is still the main route, and it is shrinking

The homepage feeds 318 of 746 arrivals, 43%, down from 346 of 697, 50%. In the organic target-market subset it fell harder, 40 to 28.

That is consistent with the `Next pages visitors` tab, where commercial first-clicks from the homepage fell 45%.

## Finding 3: the country pages are the quiet second funnel

Country pages feed 125 arrivals, second only to the homepage, and they are the most stable route across both quarters (111 to 125). In the organic target-market subset they are the largest single source after the homepage, 22 to 23, and unlike everything else they did not decline.

`/countries/germany/` alone feeds 6 organic target-market sessions into `/get-started/`, more than `/pricing/` does.

## Finding 4: /virtual-executive-assistant/ and /countries/ hub jumped

`/virtual-executive-assistant/` went 5 to 25 and `/countries/` hub went 11 to 33. Both are new routes that barely existed in Q2. Worth knowing what changed in their internal linking, because they are now meaningful funnel entries.

---

## The thing that connects four tabs

Every page on donnapro.com now serves Astro markup. I checked the homepage, `/careers/`, `/bravo/careers/`, `/careers/location/italy/`, `/services/`, `/pricing/` and `/countries/germany/`: all Astro, no WordPress assets on any of them.

Three separate findings across these tabs all step at the same July boundary:

| Tab | Finding | When |
|---|---|---|
| `Next pages visitors` | Commercial first-clicks from the homepage fell from a steady 58-65% to 38% | July |
| `Services visitors` | All `/services/` sub-pages carry `noindex` and vanished from the sitemap; organic landings fell 159 to 34 | Q3 |
| `Reverse Path` | Careers pages became a route into the client form, 6 per month to 24 | July |

Each of these is the kind of thing a site rebuild introduces: a changed homepage CTA layout, pages missing from the new sitemap with `noindex` left on, and a global header CTA applied to a section that previously did not have it.

**I have verified that production is Astro today. I have not verified when it went live**, so this is a hypothesis rather than a conclusion. You will know the cutover date. If it was late June or early July, these three findings have one cause and one owner, and the `/services/` noindex is the most expensive of them at roughly 125 organic sessions a quarter.

---

## Small bug

`/get-started/confirmed/)/` received 3 pageviews this quarter. That is a stray closing bracket inside a link somewhere, producing a 404-ish URL. Worth grepping the Astro source for `confirmed/)`.

---

## Reusable query

```sql
SELECT
  prior_page,
  countIf(q = 'Q2') AS q2_all_traffic,
  countIf(q = 'Q3') AS q3_all_traffic,
  countIf(q = 'Q2' AND organic_tam) AS q2_organic_tam,
  countIf(q = 'Q3' AND organic_tam) AS q3_organic_tam
FROM (
  SELECT
    q, organic_tam,
    if(idx > 1, paths[idx - 1], '(landed directly on /get-started/)') AS prior_page
  FROM (
    SELECT
      $session_id AS sid,
      arrayMap(t -> t.2,
        arraySort(x -> x.1,
          groupArray((timestamp, if(properties.$pathname = '', '/', properties.$pathname))))) AS paths,
      indexOf(paths, '/get-started/')                        AS idx,
      argMin(properties.$geoip_country_code, timestamp)      AS country,
      coalesce(any(session.$channel_type), '')               AS channel,
      coalesce(any(session.$entry_referring_domain), '')     AS refdom,
      toDate(toTimeZone(min(timestamp), 'Europe/Ljubljana')) AS ds,
      max(coalesce(properties.$virt_is_bot, false))          AS is_bot,
      countIf(properties.$pathname LIKE '/careers%')         AS careers,
      if(ds <= toDate('2026-06-30'), 'Q2', 'Q3')             AS q,
      (country IN ('AT','BE','DK','FI','FR','DE','IE','LU','NL','NO','SE','CH','GB','AU','CA','AE','US')
        AND channel NOT IN ('Organic Social','Paid Social','Organic Video','Paid Search')
        AND refdom NOT ILIKE '%donnapro%'
        AND careers = 0
        AND NOT is_bot)                                      AS organic_tam
    FROM events
    WHERE event = '$pageview'
      AND timestamp >= toDateTime('2026-03-31 00:00:00')
      AND timestamp <  toDateTime('2026-10-01 00:00:00')
      AND $session_id != ''
    GROUP BY sid
    HAVING ds >= toDate('2026-04-01') AND ds <= toDate('2026-09-30') AND idx > 0
  )
)
GROUP BY prior_page
ORDER BY q3_all_traffic DESC, q2_all_traffic DESC
```

The `arraySort` on `(timestamp, path)` tuples is what guarantees the pageviews are in real order. `groupArray` alone does not promise ordering, so a simpler version of this query can silently return the wrong previous page.
