# Homepage - Organic: Q3 2026 (Jul-Sep)

**Prepared:** 28 September 2026
**Source:** PostHog project 36534 (Donna Pro), timezone Europe/Ljubljana
**Target tab:** `Homepage - Organic` in *DonnaPro - Quarterly Stats*
**Data coverage:** 1 July to **27 September 2026**. The last day with pageviews is 27 September, so three days of the quarter are still missing.

---

## The numbers

Two bases, because the bot question changes three of the six rows. See "The bot problem" below for why this is not a detail.

### Base A: excluding bots (recommended)

| KEY NUMBERS | Q2 2026 | Q3 2026 (to 27 Sep) | Change |
|---|---|---|---|
| Total sessions (incl. careers) | 759 | **778** | +2.5% |
| Homepage only (no other pages) | 484 | **506** | +4.5% |
| Went to next page | 275 | **272** | -1.1% |
| Visited a careers page at some point | 110 | **133** | +20.9% |
| Never visited careers - pure buyer/browser | 165 | **139** | -15.8% |
| Visitors without /careers/ | 649 | **645** | -0.6% |

### Base B: including bots (matches how Q2 was published)

| KEY NUMBERS | Q2 2026 | Q3 2026 (to 27 Sep) | Change |
|---|---|---|---|
| Total sessions (incl. careers) | 830 | **978** | +17.8% |
| Homepage only (no other pages) | 555 | **706** | +27.2% |
| Went to next page | 275 | **272** | -1.1% |
| Visited a careers page at some point | 110 | **133** | +20.9% |
| Never visited careers - pure buyer/browser | 165 | **139** | -15.8% |
| Visitors without /careers/ | 720 | **845** | +17.4% |

Both bases are internally consistent: homepage-only plus went-to-next equals the total, careers plus pure buyer equals went-to-next, and total minus careers equals without-careers.

---

## The bot problem

Automated traffic to the homepage roughly tripled between the quarters, and all of it lands in the Direct channel:

| Channel | Q2 bot sessions | Q3 bot sessions |
|---|---|---|
| Direct | 71 (15.9% of Direct) | **200 (34.0% of Direct)** |
| Organic Search | 0 | 0 |
| AI | 0 | 0 |
| Referral | 0 | 0 |

**Every bot session is a single-page homepage hit.** That is why "Went to next page", "Visited careers" and "Pure buyer" are identical on both bases, and only the three volume rows move.

What the bots are, Q3, homepage entry, target markets:

| Bot | Category | Sessions |
|---|---|---|
| Google fetcher | search_crawler | 134 |
| Spoofed Edge UA | headless_browser | 33 |
| Whitespace-padded UA | headless_browser | 15 |
| WebPageTest | seo_crawler | 8 |
| Google special crawler | search_crawler | 4 |
| Google-AdWords-Express | seo_crawler | 3 |
| GTmetrix | monitoring | 2 |
| NotebookLM | ai_assistant | 2 |
| Claude Desktop | ai_assistant | 1 |

This is crawler and scraper noise, not AI search. Only 3 sessions across the whole quarter are AI assistants. Reporting the Base B figure as "+18% growth" would be reporting Googlebot.

---

## What actually happened this quarter

Real human traffic to the homepage is flat: 759 to 778, +2.5%, and the quarter still has three days to run.

The engaged portion did not grow at all. 275 people clicked past the homepage in Q2; 272 did in Q3.

**The composition of that engaged traffic got worse.** Within the flat 272:

- Job seekers rose from 110 to 133, up 21%
- Buyers fell from 165 to 139, down 16%
- Careers now takes 48.9% of everyone who clicks past the homepage, against 40.0% last quarter

Pure buyer sessions as a share of all homepage traffic: 21.7% in Q2, 17.9% in Q3 on the human basis.

By channel, human sessions only:

| Channel | Q2 | Q3 | Q2 pure buyer | Q3 pure buyer |
|---|---|---|---|---|
| Direct | 375 | 388 | 60 | 57 |
| Organic Search | 337 | 329 | 95 | 77 |
| AI | 30 | 35 | 8 | 4 |
| Referral | 17 | 26 | 2 | 1 |

Organic Search is the largest buyer source and it fell hardest: 95 to 77 pure buyer sessions, down 19%, on roughly flat volume. That is a conversion problem on the homepage, not a traffic problem.

The three missing days would add roughly 26 sessions at September's run rate, of which historically about 5 would be pure buyer. That does not change any conclusion above.

---

## Q2 calibration: why my Q2 differs from the sheet

The sheet publishes **849** total sessions for Q2. My reconstruction gives **830** on the same inclusive basis, a gap of 19 sessions (2.2%).

I could not find a saved PostHog insight holding the original definition, so I rebuilt it from the tab's own notes and tested the variants:

| Definition tested | Q2 total |
|---|---|
| Entry page from the first pageview event (used here) | 830 |
| Entry page from the session record | 837 |
| Direct + Organic Search + AI only | 813 |
| Including Paid Unknown | 834 |
| Homepage seen anywhere in the session, not just entry | 886 |
| Unique people rather than sessions | 769 |
| **Published** | **849** |

No combination lands on 849. The rest of the row matches closely, though: published homepage-only is 560 against my 555, and published careers is 120 against my 110.

I used the first-pageview definition because it is the only one where the parts add up. The session-record definition produces 3 sessions whose entry is recorded as the homepage but whose only pageview is a careers page, which breaks the arithmetic.

**This matters for the sheet.** Q3 against the published Q2 is not a like-for-like comparison. Either restate Q2 on this basis, or tell me where the original 849 came from and I will match it.

---

## Method

Included, per the tab's own note:

- Channels: Direct, Organic Search, AI, Referral
- Excluded channels: Paid Search, Paid Social, Paid Unknown, Organic Social, Organic Video
- Excluded any session whose entry referrer contains `donnapro`, which removes internal and self-referral traffic
- Countries: AT, BE, DK, FI, FR, DE, IE, LU, NL, NO, SE, CH, GB, AU, CA, AE, US
- Session's first pageview path is `/`
- Careers means a pathname starting `/careers`

Careers content also exists at `/bravo/careers/` and `/virtual-assistant-careers/`. I tested the wider pattern and it changes nothing: no homepage-entry session in the target markets touched those without also touching `/careers/`. The narrow prefix is safe.

`/ceo-insights/executive-assistant-career-growth/` is deliberately **not** counted as careers. It sits in the buyer silo despite the word "career" in the slug.

### Reusable query

Swap the two dates and the quarter labels each time. `NOT is_bot` gives Base A; drop that line for Base B.

```sql
SELECT
  q,
  count()                                      AS total_sessions,
  countIf(n_paths = 1)                         AS homepage_only,
  countIf(n_paths > 1)                         AS went_to_next_page,
  countIf(careers > 0)                         AS visited_careers,
  countIf(n_paths > 1 AND careers = 0)         AS pure_buyer,
  countIf(careers = 0)                         AS without_careers
FROM (
  SELECT
    $session_id AS sid,
    argMin(properties.$geoip_country_code, timestamp)                        AS country,
    argMin(if(properties.$pathname = '', '/', properties.$pathname), timestamp) AS entry_path,
    any(session.$channel_type)                                              AS channel,
    any(session.$entry_referring_domain)                                    AS refdom,
    toDate(toTimeZone(min(timestamp), 'Europe/Ljubljana'))                  AS ds,
    uniq(if(properties.$pathname = '', '/', properties.$pathname))          AS n_paths,
    countIf(properties.$pathname LIKE '/careers%')                          AS careers,
    max(coalesce(properties.$virt_is_bot, false))                           AS is_bot,
    if(ds <= toDate('2026-06-30'), 'Q2 2026', 'Q3 2026')                    AS q
  FROM events
  WHERE event = '$pageview'
    AND timestamp >= toDateTime('2026-03-31 00:00:00')
    AND timestamp <  toDateTime('2026-10-01 00:00:00')
    AND $session_id != ''
  GROUP BY sid
)
WHERE country IN ('AT','BE','DK','FI','FR','DE','IE','LU','NL','NO','SE','CH','GB','AU','CA','AE','US')
  AND entry_path = '/'
  AND channel IN ('Direct','Organic Search','AI','Referral')
  AND refdom NOT ILIKE '%donnapro%'
  AND NOT is_bot
  AND ds >= toDate('2026-04-01') AND ds <= toDate('2026-09-30')
GROUP BY q
ORDER BY q
```

---

## Decisions needed before this goes in the sheet

1. **Bots in or out.** Recommendation: out, and restate Q2 the same way. Two thirds of this quarter's apparent growth is Googlebot and headless scrapers.
2. **The 849.** Restate Q2 on this method, or point me at the original PostHog view so I can match it.
3. **When to finalise.** These figures stop at 27 September. Say the word on 1 October and I will re-run for the complete quarter.
