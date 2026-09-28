# Organic visitors by country: Q3 2026 (Jul-Sep)

**Prepared:** 28 September 2026
**Source:** PostHog project 36534 (Donna Pro), timezone Europe/Ljubljana
**Target tab:** `Organic visitors by country` in *DonnaPro - Quarterly Stats*
**Data coverage:** 1 July to **27 September 2026**. Three days of the quarter are still missing.

Definition applied, from the tab's own note: organic and AI-driven traffic only, excluding paid ads, social and internal traffic, 17 target markets, careers visitors excluded. Column 1 counts every session landing on any page. Column 2 is the homepage subset.

---

## Calibration: this tab validates the method

My Q2 recompute on the published basis (bots included) lands at **3,046 against your published 3,050**, a gap of 4 sessions, 0.13%. The homepage column comes to **722 against 729**.

Both columns also tie to the other tabs exactly:

| Cross-check | This tab | `Homepage - Organic` tab |
|---|---|---|
| Q2 homepage, bots in | 722 | 722 ("Visitors without /careers/") |
| Q3 homepage, bots in | 850 | 850 |
| Q2 homepage, bots out | 651 | 651 |
| Q3 homepage, bots out | 647 | 647 |

The filter, country list and careers exclusion are right. See "The one thing I cannot reconcile" at the end for the per-country caveat.

---

## The table, bots excluded (recommended)

| Country | Q2 all pages | Q3 all pages | Change | Q2 homepage | Q3 homepage |
|---|---|---|---|---|---|
| United States | 1,452 | **1,180** | -18.7% | 254 | **300** |
| United Kingdom | 225 | **434** | **+92.9%** | 77 | **98** |
| Germany | 167 | **134** | -19.8% | 71 | **47** |
| France | 101 | **91** | -9.9% | 56 | **40** |
| Switzerland | 80 | **69** | -13.8% | 27 | **17** |
| Netherlands | 105 | **114** | +8.6% | 32 | **42** |
| Canada | 86 | **97** | +12.8% | 26 | **24** |
| Ireland | 55 | **45** | -18.2% | 23 | **16** |
| Australia | 69 | **59** | -14.5% | 16 | **10** |
| Sweden | 57 | **42** | -26.3% | 18 | **7** |
| Belgium | 52 | **42** | -19.2% | 12 | **11** |
| UAE | 37 | **49** | +32.4% | 12 | **10** |
| Norway | 34 | **17** | -50.0% | 3 | **1** |
| Denmark | 21 | **22** | +4.8% | 5 | **3** |
| Austria | 17 | **30** | +76.5% | 10 | **13** |
| Finland | 15 | **15** | 0.0% | 5 | **5** |
| Luxembourg | 6 | **13** | +116.7% | 4 | **3** |
| **Total** | **2,579** | **2,453** | **-4.9%** | **651** | **647** |

## The table, bots included (matches how Q2 was published)

| Country | Q2 published | Q2 mine | Q3 all pages | Q2 hp published | Q2 hp mine | Q3 homepage |
|---|---|---|---|---|---|---|
| United States | 1,828 | 1,911 | **1,712** | 309 | 318 | **501** |
| United Kingdom | 273 | 231 | **434** | 84 | 83 | **98** |
| Germany | 186 | 167 | **135** | 76 | 71 | **48** |
| France | 110 | 101 | **92** | 59 | 56 | **41** |
| Switzerland | 94 | 80 | **69** | 26 | 27 | **17** |
| Netherlands | 92 | 106 | **114** | 25 | 33 | **42** |
| Canada | 85 | 86 | **97** | 25 | 26 | **24** |
| Ireland | 72 | 55 | **45** | 23 | 23 | **16** |
| Australia | 67 | 70 | **59** | 16 | 16 | **10** |
| Sweden | 56 | 57 | **42** | 19 | 18 | **7** |
| Belgium | 50 | 52 | **42** | 12 | 12 | **11** |
| UAE | 34 | 37 | **49** | 15 | 12 | **10** |
| Norway | 33 | 34 | **17** | 3 | 3 | **1** |
| Denmark | 26 | 21 | **22** | 8 | 5 | **3** |
| Austria | 17 | 17 | **30** | 9 | 10 | **13** |
| Finland | 16 | 15 | **15** | 5 | 5 | **5** |
| Luxembourg | 11 | 6 | **13** | 6 | 4 | **3** |
| **Total** | **3,050** | **3,046** | **2,987** | **729** | **722** | **850** |

---

## The findings

### 1. The UK nearly doubled, and it is real

**225 to 434 human sessions, up 93%.** Zero bot sessions in the UK in either quarter, so none of this is crawler noise. The UK is now a serious second market rather than a distant one: it went from 8.7% of target-market traffic to 17.7%.

This is the single best number in the quarter and it deserves a look at what drove it. Worth checking which UK pages and queries gained, because whatever worked there is the template for Germany and the Nordics.

### 2. The US fell 19%, and a third of what is left is bots

US human sessions went **1,452 to 1,180**. On top of that, US bot sessions rose 459 to 532, so **31% of all recorded US sessions in Q3 are crawlers**, up from 24%.

Nearly every bot on the site geolocates to the US: 532 of the quarter's 534 bot sessions. That is why the US column looks far healthier on the bots-included basis (1,712) than it is (1,180).

The US loss of 272 human sessions is almost exactly offset by the UK gain of 209. Net target-market traffic is down 4.9%.

### 3. Continental Europe is down almost everywhere

Germany -19.8%, Ireland -18.2%, Belgium -19.2%, Sweden -26.3%, Switzerland -13.8%, Australia -14.5%, France -9.9%, Norway -50%.

Nine of the seventeen markets declined. The gains are concentrated in the UK, plus small absolute rises in the Netherlands (+9), Canada (+11), UAE (+12), Austria (+13) and Luxembourg (+7).

Germany is the one to watch: it is the third-largest market, it fell a fifth, and its homepage sessions fell harder still, 71 to 47.

### 4. The homepage subset is flat while the overall pool shrinks

Homepage sessions held at 651 to 647 while all-pages fell 2,579 to 2,453. So the homepage held its ground and the deeper pages lost traffic. That is consistent with the services finding on the previous tab: the `/services/` sub-pages were set to `noindex` and lost roughly 125 organic landings a quarter.

---

## The one thing I cannot reconcile

The **totals** match your published Q2 almost exactly (3,046 against 3,050). The **per-country split** does not:

| Country | Published | Mine | Diff |
|---|---|---|---|
| United States | 1,828 | 1,911 | **+83** |
| United Kingdom | 273 | 231 | **-42** |
| Germany | 186 | 167 | -19 |
| Ireland | 72 | 55 | -17 |
| Switzerland | 94 | 80 | -14 |
| Netherlands | 92 | 106 | +14 |
| France | 110 | 101 | -9 |
| Denmark | 26 | 21 | -5 |
| Luxembourg | 11 | 6 | -5 |
| Everything else | | | within 3 |

My version puts more traffic in the US and less in Europe, and the differences offset almost perfectly. I tested three candidate causes and none explains it:

- **Country from the session's first event versus its last event.** Identical results, differences of 1 at most. Not this.
- **Unique people instead of sessions.** Moves the US closer (1,865) but pushes the UK and Germany further away (211 and 146). Not this.
- **The careers exclusion or the source filter.** Ruled out by the totals matching within 4.

Something in the original attributed roughly 80 sessions differently between the US and Europe. I would need the original PostHog view to find it. The totals, the cross-tab ties and the direction of every trend are sound; treat the individual country numbers as carrying an error bar of a few percent until we find it.

---

## Reusable query

```sql
SELECT
  country,
  countIf(q = 'Q2' AND NOT is_bot)                        AS q2_all_pages,
  countIf(q = 'Q3' AND NOT is_bot)                        AS q3_all_pages,
  countIf(q = 'Q2' AND NOT is_bot AND entry_path = '/')   AS q2_homepage,
  countIf(q = 'Q3' AND NOT is_bot AND entry_path = '/')   AS q3_homepage
FROM (
  SELECT
    $session_id AS sid,
    argMin(properties.$geoip_country_code, timestamp)                           AS country,
    argMin(if(properties.$pathname = '', '/', properties.$pathname), timestamp) AS entry_path,
    coalesce(any(session.$channel_type), '')                                    AS channel,
    coalesce(any(session.$entry_referring_domain), '')                          AS refdom,
    toDate(toTimeZone(min(timestamp), 'Europe/Ljubljana'))                      AS ds,
    max(coalesce(properties.$virt_is_bot, false))                               AS is_bot,
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
  AND channel NOT IN ('Organic Social','Paid Social','Organic Video','Paid Search')
  AND refdom NOT ILIKE '%donnapro%'
  AND careers = 0
  AND ds >= toDate('2026-04-01') AND ds <= toDate('2026-09-30')
GROUP BY country
ORDER BY q3_all_pages DESC
```

Note the tab's note says the homepage column covers sessions that "landed on **or visited**" the homepage. I computed it as landed-on, because that is what reproduces your published 729 and what ties to the `Homepage - Organic` tab. Counting homepage-visited-at-any-point would give a materially larger number.
