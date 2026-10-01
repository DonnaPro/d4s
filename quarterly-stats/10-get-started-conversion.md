# Get Started conversion

**Prepared:** 1 October 2026
**Source:** PostHog project 36534 (Donna Pro), timezone Europe/Ljubljana
**Status:** new table, monthly series

Conversion from reaching the sign-up form to taking the next step. Organic and AI traffic only, 17 target markets, careers visitors excluded, paid and social excluded, bots and non-production hosts excluded.

---

## The table

| Month | Reached /get-started/ | → Call | Call % | → Confirmed | Confirmed % |
|---|---|---|---|---|---|
| April 2026 | 38 | 7 | **18.4%** | 5 | 13.2% |
| May 2026 | 28 | 5 | **17.9%** | 3 | 10.7% |
| June 2026 | 37 | 6 | **16.2%** | 5 | 13.5% |
| July 2026 | 25 | 2 | **8.0%** | 2 | 8.0% |
| August 2026 | 21 | 4 | **19.0%** | 1 | 4.8% |
| September 2026 | 48 | 8 | **16.7%** | 7 | 14.6% |
| **Q2 2026** | **103** | **18** | **17.5%** | **13** | **12.6%** |
| **Q3 2026** | **94** | **14** | **14.9%** | **10** | **10.6%** |

**Markets:** AT, BE, DK, FI, FR, DE, IE, LU, NL, NO, SE, CH, GB, AU, CA, AE, US. Confirmed as correct for this table.

---

## Definitions

- **Reached /get-started/**: the session viewed `/get-started/` at any point
- **→ Call**: the same session also viewed `/get-started/call/` or `/get-started/call-usa/`
- **→ Confirmed**: the same session also viewed `/get-started/confirmed/`, the post-submission page

Both conversion measures are given because they answer different questions. Call is the Calendly step and matches the existing "→ Call" column in the sales analysis. Confirmed is the closest page-level proxy for a submitted form.

**Neither is the lead count.** The actual lead number comes from Gravity Forms and EngageBay, which PostHog cannot see. Where a lead figure is needed it stays a manual entry.

---

## The benchmark

The proposed internal benchmark of **17% on the call step** holds. Q2 came in at 17.5%, and four of the six months fall between 16.2% and 19.0%.

The proposed operating band of 12% to 25% is reasonable, with one note: **July fell below it at 8.0%**, which is the only month outside the range in this period. August's 19.0% sits on a denominator of 21 sessions, so it is within noise either way.

September is the strongest month on both volume (48) and absolute conversions (8).

Monthly denominators here run between 21 and 48 sessions. At that size a single conversion moves the rate by three to five points, so month-to-month movement should not be read as signal unless it persists across two or three months.

---

## Open item

The earlier January to April series recorded 37, 42, 47 and 47 sessions reaching `/get-started/`. This method gives 38 for April on the same 17 markets.

A 13-market filter should produce a *lower* number than a 17-market one, not higher, so the two series are measuring different things. The likely causes are unique people rather than sessions, or the inclusion of some paid traffic. Worth reconciling before the series is extended, so the benchmark is not built across two denominators.

---

## Reusable query

```sql
SELECT
  toStartOfMonth(ds)                          AS month,
  count()                                     AS reached_get_started,
  countIf(has(paths, '/get-started/call/')
       OR has(paths, '/get-started/call-usa/')) AS reached_call,
  countIf(has(paths, '/get-started/confirmed/')) AS reached_confirmed,
  round(100.0 * countIf(has(paths, '/get-started/call/')
                     OR has(paths, '/get-started/call-usa/')) / count(), 1) AS call_pct,
  round(100.0 * countIf(has(paths, '/get-started/confirmed/')) / count(), 1) AS confirmed_pct
FROM (
  SELECT
    $session_id AS sid,
    arrayMap(t -> t.2,
      arraySort(x -> x.1,
        groupArray((timestamp, if(properties.$pathname = '', '/', properties.$pathname))))) AS paths,
    argMin(properties.$geoip_country_code, timestamp) AS country,
    argMin(properties.$host, timestamp)               AS entry_host,
    coalesce(any(session.$channel_type), '')          AS channel,
    coalesce(any(session.$entry_referring_domain), '') AS refdom,
    max(coalesce(properties.$virt_is_bot, false))     AS is_bot,
    countIf(properties.$pathname LIKE '/careers%'
         OR properties.$pathname LIKE '/bravo/careers%') AS careers,
    toDate(toTimeZone(min(timestamp), 'Europe/Ljubljana')) AS ds
  FROM events
  WHERE event = '$pageview'
    AND timestamp >= toDateTime('2026-03-31 00:00:00')
    AND timestamp <  toDateTime('2026-10-01 00:00:00')
    AND $session_id != ''
  GROUP BY sid
  HAVING ds >= toDate('2026-04-01') AND ds <= toDate('2026-09-30')
    AND entry_host = 'donnapro.com'
    AND NOT is_bot
    AND careers = 0
    AND channel NOT IN ('Organic Social','Paid Social','Organic Video','Paid Search')
    AND refdom NOT ILIKE '%donnapro%'
    AND country IN ('AT','BE','DK','FI','FR','DE','IE','LU','NL','NO','SE','CH','GB','AU','CA','AE','US')
    AND has(paths, '/get-started/')
)
GROUP BY month
ORDER BY month
```
