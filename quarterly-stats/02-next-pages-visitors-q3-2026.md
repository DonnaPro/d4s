# Next pages visitors: Q3 2026 (Jul-Sep)

**Prepared:** 28 September 2026
**Source:** PostHog project 36534 (Donna Pro), timezone Europe/Ljubljana
**Target tab:** `Next pages visitors` in *DonnaPro - Quarterly Stats*
**Data coverage:** 1 July to **27 September 2026**. Three days of the quarter are still missing.

Definition applied, from the tab's own note: the first page visited directly after the homepage, organic and AI-driven traffic from the 17 target markets, careers visitors excluded, one row per session, no intermediate steps.

> **Validation.** The Q2 column sums to **167** and the Q3 column to **139**. Those are exactly the "Never visited careers - pure buyer" figures from the `Homepage - Organic` tab for the same two quarters. The two tables reconcile.

> **Bots are not a factor here.** Every bot session on the homepage is a single-page hit, so none of them ever reach a second page. This table is bot-free by construction, unlike the previous tab.

---

## The table

| First page after homepage | Q2 2026 | Q3 2026 (to 27 Sep) |
|---|---|---|
| /pricing/ | 60 | **31** |
| /services/ | 12 | **26** |
| /get-started/ | 39 | **25** |
| /testimonials/ | 2 | **6** |
| /our-story/ | 1 | **4** |
| /who-we-serve/ | 0 | **4** |
| /guides/ | 0 | **4** |
| /services/email-management/ | 5 | **3** |
| /ea-tasks/ | 5 | **3** |
| /faq/ | 4 | **3** |
| /services/travel-planning/ | 2 | **3** |
| /blog/ | 1 | **2** |
| /countries/italy/ | 0 | **2** |
| /countries/usa/ | 0 | **2** |
| /countries/ | 0 | **2** |
| /who-we-serve/saas-virtual-assistant/ | 0 | **2** |
| /countries/germany/ | 5 | **1** |
| /guides/executive-assistant-cost-guide/ | 4 | **1** |
| /countries/france/ | 2 | **1** |
| /affiliate/ | 1 | **1** |
| /countries/norway/ | 1 | **1** |
| /services/research-services/ | 1 | **1** |
| /guides/when-to-hire-executive-assistant/ | 0 | **1** |
| /guides/how-to-hire-virtual-assistant-uk/ | 0 | **1** |
| /services/personal-tasks/ | 0 | **1** |
| /countries/dubai/ | 0 | **1** |
| /services/marketing/ | 0 | **1** |
| /virtual-executive-assistant/ | 0 | **1** |
| /countries/spain/ | 0 | **1** |
| /services/standard-operating-procedures-sops/ | 0 | **1** |
| /who-we-serve/real-estate-virtual-assistant/ | 0 | **1** |
| /who-we-serve/marketing-agency-virtual-assistant/ | 0 | **1** |
| /press/ | 0 | **1** |
| /countries/netherlands/ | 3 | 0 |
| /terms-and-conditions/ | 3 | 0 |
| /countries/uk/ | 3 | 0 |
| /who-we-serve/investment-virtual-assistant/ | 2 | 0 |
| /guides/c-level-executive-assistant/ | 2 | 0 |
| /comparison/virtual-assistant-vs-executive-assistant/ | 2 | 0 |
| /services/project-management/ | 1 | 0 |
| /free-breakdown/ | 1 | 0 |
| /who-we-serve/startup-virtual-assistant/ | 1 | 0 |
| /get-started/confirmed/ | 1 | 0 |
| /services/hr-tasks/ | 1 | 0 |
| /who-we-serve/ai-virtual-assistant/ | 1 | 0 |
| /guides/working-with-executive-assistant/ | 1 | 0 |
| **Total** | **167** | **139** |

---

## Grouped by intent

| Bucket | Q2 | Q3 | Q2 share | Q3 share |
|---|---|---|---|---|
| Commercial (pricing, get-started, free-breakdown) | 101 | **56** | 60.5% | **40.3%** |
| Services | 22 | **36** | 13.2% | **25.9%** |
| Trust (testimonials, our story, FAQ, press) | 7 | **14** | 4.2% | **10.1%** |
| Countries | 14 | **11** | 8.4% | 7.9% |
| Content and guides | 15 | **12** | 9.0% | 8.6% |
| Who we serve | 4 | **8** | 2.4% | 5.8% |
| Other | 4 | **2** | 2.4% | 1.4% |

---

## The finding

**Commercial first-clicks fell 45%, from 101 to 56.** People landing on the homepage and clicking straight to pricing or get-started went from three in five, to two in five. `/pricing/` alone nearly halved, 60 to 31.

That is a much steeper fall than the 17% decline in the buyer population itself, so it is not simply a traffic story. A smaller audience is also behaving differently.

**It is a step change at the quarter boundary, not a drift:**

| Month | Engaged buyer sessions | Commercial first click | Share | Reached /get-started/ at any point |
|---|---|---|---|---|
| April | 57 | 37 | 64.9% | 17 |
| May | 62 | 36 | 58.1% | 19 |
| June | 48 | 28 | 58.3% | 20 |
| **July** | 56 | **21** | **37.5%** | 16 |
| August | 41 | 19 | 46.3% | 9 |
| September | 42 | 16 | 38.1% | 9 |

The share sits in a tight 58 to 65% band for all three months of Q2, then drops to 38% in July and never recovers. July had *more* engaged buyer sessions than June (56 against 48) and still produced fewer commercial clicks.

**This is not people taking a longer route.** Sessions that reached `/get-started/` at any point, not just as a first click, went 17 / 19 / 20 in Q2 to 16 / 9 / 9 in Q3. The destination is being reached less in absolute terms, not later.

**Where the traffic went instead.** `/services/` more than doubled as a first click, 12 to 26, and is now the second most common destination. Trust pages doubled, 7 to 14. The pattern is consistent with visitors browsing rather than buying.

### What to check

Something changed in the homepage's onward routing at the end of June. The data shows the effect clearly but cannot name the cause. Worth checking, in this order:

1. What shipped on the homepage in late June. A CTA, hero, or navigation change is the obvious candidate.
2. Whether `/pricing/` lost prominence on the homepage, moved down, or lost a button.
3. Whether the `Get Started Conversion` tab shows a matching fall in form submissions from July. If it does, this is costing leads, not just clicks.

I have not assumed any of these. They are the hypotheses the data points at.

---

## One definitional check

"Careers visitors are excluded" has two readings, and they give different totals:

| Reading | Q2 | Q3 |
|---|---|---|
| **A. Drop the whole session if it touched careers at any point** (used here) | **167** | **139** |
| B. Drop only sessions whose first click was a careers page | 197 | 168 |

I used A, because it reconciles exactly with the "pure buyer" row on the `Homepage - Organic` tab. If your published Q2 column sums to 197 rather than 167, say so and I will switch.

I could not read this tab's existing values through the Drive connector, which only returns the first sheet of the workbook. So both columns here are computed fresh from PostHog rather than checked against what is already in the sheet. If your Q2 column differs from mine, the same calibration question applies as on the previous tab.

---

## Reusable query

```sql
SELECT
  next_page,
  countIf(q = 'Q2') AS q2_2026,
  countIf(q = 'Q3') AS q3_2026
FROM (
  SELECT
    $session_id AS sid,
    argMin(properties.$geoip_country_code, timestamp)                           AS country,
    argMin(if(properties.$pathname = '', '/', properties.$pathname), timestamp) AS entry_path,
    argMinIf(
      if(properties.$pathname = '', '/', properties.$pathname),
      timestamp,
      if(properties.$pathname = '', '/', properties.$pathname) != '/'
    )                                                                           AS next_page,
    coalesce(any(session.$channel_type), '')                                    AS channel,
    coalesce(any(session.$entry_referring_domain), '')                          AS refdom,
    toDate(toTimeZone(min(timestamp), 'Europe/Ljubljana'))                      AS ds,
    uniq(if(properties.$pathname = '', '/', properties.$pathname))              AS n_paths,
    countIf(properties.$pathname LIKE '/careers%')                              AS careers,
    if(ds <= toDate('2026-06-30'), 'Q2', 'Q3')                                  AS q
  FROM events
  WHERE event = '$pageview'
    AND timestamp >= toDateTime('2026-03-31 00:00:00')
    AND timestamp <  toDateTime('2026-10-01 00:00:00')
    AND $session_id != ''
  GROUP BY sid
)
WHERE country IN ('AT','BE','DK','FI','FR','DE','IE','LU','NL','NO','SE','CH','GB','AU','CA','AE','US')
  AND entry_path = '/'
  AND channel NOT IN ('Organic Social','Paid Social','Organic Video','Paid Search')
  AND refdom NOT ILIKE '%donnapro%'
  AND ds >= toDate('2026-04-01') AND ds <= toDate('2026-09-30')
  AND n_paths > 1
  AND careers = 0
GROUP BY next_page
ORDER BY q3_2026 DESC, q2_2026 DESC
```

`argMinIf` is what enforces "nothing in between": it takes the earliest pageview in the session whose path is not the homepage, so a homepage reload does not count as a step and an intermediate page wins over anything later.
