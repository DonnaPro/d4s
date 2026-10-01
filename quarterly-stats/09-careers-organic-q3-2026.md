# Careers pages: organic traffic, Q3 2026

**Prepared:** 1 October 2026
**Source:** PostHog project 36534 (Donna Pro), timezone Europe/Ljubljana
**Data coverage:** Q3 2026 is **complete**. Data runs to 1 October, so 1 July to 30 September is a full quarter.

> **Note for the other files in this folder.** Files 01 to 08 were built when data stopped at 27 September, so their Q3 figures are three days short. They should be re-run before the final report.

---

## Definitions used

- **Organic**: the workbook's rule. All traffic except social, paid ads and internal. Bots excluded. Host restricted to `donnapro.com`
- **Careers page**: `/careers*`, `/bravo/careers*`, or any path containing `virtual-assistant-careers`
- **Campaign exclusion**: any session whose entry campaign contains `hr`, case-insensitive. This removes `hr`, `hr-sales`, `hr-v2`, `hrDonnaPro` and `Donna - HR - ABO - Conversion`
- **Recruitment markets**: ES, PT, SI, HR, PL, CZ, GR, RO, IT, HU

---

# The numbers

## All organic careers traffic, any country

| | Q2 2026 | Q3 2026 | Change |
|---|---|---|---|
| Sessions that visited a careers page | 9,930 | **13,619** | +37.1% |
| **Unique visitors who visited a careers page** | 8,419 | **11,345** | **+34.8%** |
| Sessions that landed directly on a careers page | 9,111 | **12,633** | +38.7% |
| Unique visitors who landed directly | 7,803 | **10,625** | +36.2% |

## The ten recruitment markets

| | Q2 2026 | Q3 2026 | Change |
|---|---|---|---|
| Sessions that visited a careers page | 4,429 | **6,271** | +41.6% |
| **Unique visitors who visited a careers page** | 3,521 | **5,027** | **+42.8%** |
| Sessions that landed directly on a careers page | 4,082 | **5,873** | +43.9% |
| Unique visitors who landed directly | 3,296 | **4,767** | +44.6% |

## By market

| Country | Q2 sessions | Q2 visitors | Q3 sessions | Q3 visitors | Visitor change |
|---|---|---|---|---|---|
| Spain | 1,056 | 816 | **1,497** | **1,161** | +42.3% |
| Italy | 829 | 647 | **1,217** | **964** | +49.0% |
| Portugal | 822 | 615 | **904** | **746** | +21.3% |
| Greece | 439 | 380 | **802** | **650** | +71.1% |
| Romania | 431 | 379 | **655** | **559** | +47.5% |
| Croatia | 198 | 169 | **397** | **327** | +93.5% |
| Poland | 247 | 203 | **351** | **270** | +33.0% |
| Hungary | 120 | 108 | **141** | **129** | +19.4% |
| Czech Republic | 131 | 107 | **148** | **122** | +14.0% |
| Slovenia | 156 | 102 | **159** | **108** | +5.9% |
| **Total** | **4,429** | **3,521** | **6,271** | **5,027** | **+42.8%** |

Sessions sum exactly to the totals. Visitor columns sum to 3,526 and 5,036, slightly above the deduplicated totals of 3,521 and 5,027, because a handful of people appear in two countries across different sessions. Use the deduplicated figure as the headline.

---

## What stands out

### Careers is growing while the buyer side is not

| | Q2 | Q3 | Change |
|---|---|---|---|
| Careers, organic sessions, all countries | 9,930 | 13,619 | **+37.1%** |
| Buyer side, organic sessions, 17 target markets | 2,579 | 2,453 | **-4.9%** |

The recruitment funnel grew by more than a third in a quarter while the client funnel went backwards. Careers organic traffic is now **5.5 times** the size of buyer organic traffic.

That is not necessarily a problem, since you need the supply side, but it is a notable imbalance and it explains why careers visitors have to be excluded from every buyer-facing number in this workbook.

### 93% land directly on a careers page

Of 11,345 unique careers visitors, 10,625 arrived straight onto a careers page rather than reaching one through the site. This is almost entirely search-driven, not browsing. The careers content is doing its own acquisition.

### More than half of careers traffic is outside the ten target markets

11,345 unique visitors in total, 5,027 from the ten recruitment markets. That leaves **6,318 unique visitors, 56%, from outside them**.

From the country analysis in file 04, the largest non-target sources are the Philippines, India, Nigeria, Pakistan and Kenya. Worth a decision: either those markets become part of the recruitment strategy, or a meaningful share of the careers content is attracting applicants you will not hire.

### Croatia and Greece are the fastest growing

Croatia nearly doubled (+93.5%) and Greece is up 71.1%. Both from small bases, but both outpacing Spain and Italy, which are the established markets.

Slovenia is flat at +5.9% and the smallest of the ten. It is also your home market, and PostHog's own test-account filter normally excludes `SI` as internal traffic. These figures do not apply that filter, since you asked for SI explicitly, so some of the 108 is likely local or internal rather than genuine applicants.

---

## One judgement call worth confirming

`google_jobs_apply` appears as a campaign on 113 Organic Search sessions plus a few others. That is Google for Jobs traffic, which is organic by any reasonable definition, so it is **included** in these figures. It does not contain `hr`, so the campaign exclusion leaves it in.

If you consider Google for Jobs a separate acquisition channel rather than organic, say so and I will split it out.

---

## Reusable query

```sql
SELECT
  q,
  count()                                   AS sessions_visited_careers,
  uniq(pid)                                 AS unique_visitors_visited,
  countIf(entry_careers)                    AS sessions_landed_on_careers,
  uniqIf(pid, entry_careers)                AS unique_visitors_landed
FROM (
  SELECT
    $session_id AS sid,
    any(person_id)                                                              AS pid,
    argMin(properties.$geoip_country_code, timestamp)                           AS country,
    argMin(if(properties.$pathname = '', '/', properties.$pathname), timestamp) AS entry_path,
    coalesce(any(session.$channel_type), '')                                    AS channel,
    coalesce(any(session.$entry_referring_domain), '')                          AS refdom,
    coalesce(any(session.$entry_utm_campaign), '')                              AS campaign,
    toDate(toTimeZone(min(timestamp), 'Europe/Ljubljana'))                      AS ds,
    max(coalesce(properties.$virt_is_bot, false))                               AS is_bot,
    countIf(properties.$pathname LIKE '/careers%'
         OR properties.$pathname LIKE '/bravo/careers%'
         OR properties.$pathname LIKE '%virtual-assistant-careers%')            AS careers_views,
    (entry_path LIKE '/careers%'
     OR entry_path LIKE '/bravo/careers%'
     OR entry_path LIKE '%virtual-assistant-careers%')                          AS entry_careers,
    if(ds <= toDate('2026-06-30'), 'Q2 2026', 'Q3 2026')                        AS q
  FROM events
  WHERE event = '$pageview'
    AND timestamp >= toDateTime('2026-03-31 00:00:00')
    AND timestamp <  toDateTime('2026-10-01 00:00:00')
    AND properties.$host = 'donnapro.com'
    AND $session_id != ''
  GROUP BY sid
  HAVING ds >= toDate('2026-04-01') AND ds <= toDate('2026-09-30')
    AND careers_views > 0
    AND NOT is_bot
    AND channel NOT IN ('Organic Social','Paid Social','Organic Video','Paid Search','Paid Unknown')
    AND refdom NOT ILIKE '%donnapro%'
    AND NOT (campaign ILIKE '%hr%')
)
GROUP BY q
ORDER BY q
```

Add `AND country IN ('ES','PT','SI','HR','PL','CZ','GR','RO','IT','HU')` to the `HAVING` clause for the recruitment-market figures, or `GROUP BY country` for the per-market table.

Note `Paid Unknown` is excluded here. The buyer-side files keep it, because the workbook's stated rule only excludes Google Ads. On careers traffic it is 104 sessions and all of it looks like paid recruitment placement, so excluding it is the more honest reading. Say if you want it back in for consistency.
