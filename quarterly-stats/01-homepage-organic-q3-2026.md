# Homepage - Organic: Q3 2026 (Jul-Sep)

**Prepared:** 28 September 2026
**Source:** PostHog project 36534 (Donna Pro), timezone Europe/Ljubljana
**Target tab:** `Homepage - Organic` in *DonnaPro - Quarterly Stats*
**Data coverage:** 1 July to **27 September 2026**. The last day with pageviews is 27 September, so three days of the quarter are still missing.

> **Revision note.** The first version of this file used a hand-picked channel inclusion list instead of the tab's stated exclusion rule, and lost two sessions to a null-handling bug. Both are fixed here. The corrected figures are 2 to 5 sessions higher. No conclusion changed.

---

## The numbers

### Base A: excluding bots (recommended)

| KEY NUMBERS | Q2 2026 | Q3 2026 (to 27 Sep) | Change |
|---|---|---|---|
| Total sessions (incl. careers) | 761 | **780** | +2.5% |
| Homepage only (no other pages) | 484 | **508** | +5.0% |
| Went to next page | 277 | **272** | -1.8% |
| Visited a careers page at some point | 110 | **133** | +20.9% |
| Never visited careers - pure buyer/browser | 167 | **139** | -16.8% |
| Visitors without /careers/ | 651 | **647** | -0.6% |

### Base B: including bots (matches how Q2 was published)

| KEY NUMBERS | Q2 2026 | Q3 2026 (to 27 Sep) | Change |
|---|---|---|---|
| Total sessions (incl. careers) | 832 | **983** | +18.1% |
| Homepage only (no other pages) | 555 | **711** | +28.1% |
| Went to next page | 277 | **272** | -1.8% |
| Visited a careers page at some point | 110 | **133** | +20.9% |
| Never visited careers - pure buyer/browser | 167 | **139** | -16.8% |
| Visitors without /careers/ | 722 | **850** | +17.7% |

Both bases are internally consistent: homepage-only plus went-to-next equals the total, careers plus pure buyer equals went-to-next, and total minus careers equals without-careers.

---

## Compliance with the tab's stated rules

| Rule as written | Followed? |
|---|---|
| Source: ALL traffic EXCEPT social (FB / IG / LinkedIn / YouTube) + internal (donnapro.com) + paid ads (Google Ads) | Yes, now. Applied as an exclusion of `Organic Social`, `Paid Social`, `Organic Video`, `Paid Search`, plus any entry referrer containing `donnapro` |
| Target countries only, 17 listed | Yes. UK maps to `GB`, UAE to `AE`. Verified no `UK` or `UAE` literals exist in the data |
| Total sessions - landed on the homepage, regardless of where they went next | Yes. Session's first pageview path is `/` |
| Homepage only - left without clicking to any other page | Yes. One distinct path in the session |
| Went to next page - clicked at least one more page | Yes. More than one distinct path |
| Visited careers - of those who clicked further, browsed at least one careers page | Yes. Equivalent here, because a single-path homepage session cannot contain a careers page |
| Never visited careers - clicked further, never touched careers | Yes |
| Visitors without /careers/ | Total minus anyone who touched careers. Matches the published Q2 arithmetic (849 - 120 = 729) |

### Where I deviated

**1. Bot filtering is not in the rules.** Base A is my addition. The rules say nothing about automated traffic, so Base B is the literal reading. I recommend Base A anyway, for the reason in the next section, but the choice is yours and it is not something the tab currently specifies.

**2. Referral is genuinely ambiguous.** The source rule says "ALL traffic EXCEPT" three things, which includes Referral. The line underneath says "This captures: Google Organic + all AI tools + Bing + DuckDuckGo + direct/unattributed", which omits it. I followed the rule and included it. To drop it instead, subtract 17 from Q2 and 26 from Q3, giving 744 and 754 on Base A.

---

## The bot problem

Automated traffic to the homepage roughly tripled, and all of it sits in Direct:

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

Crawler and scraper noise, not AI search. Three AI-assistant sessions across the whole quarter. Reporting Base B as "+18% growth" would be reporting Googlebot.

---

## What actually happened this quarter

Human traffic to the homepage is close to flat: 761 to 780, up 2.5%, with three days still to come.

The engaged portion did not grow. 277 people clicked past the homepage in Q2; 272 did in Q3.

**The composition of that engaged traffic got worse.** Within the flat 272:

- Job seekers rose from 110 to 133, up 21%
- Buyers fell from 167 to 139, down 17%
- Careers now takes 48.9% of everyone who clicks past the homepage, against 39.7% last quarter

Pure buyer sessions as a share of all human homepage traffic: 21.9% in Q2, 17.8% in Q3.

By channel, human sessions only:

| Channel | Q2 | Q3 | Q2 pure buyer | Q3 pure buyer |
|---|---|---|---|---|
| Direct | 375 | 388 | 60 | 57 |
| Organic Search | 337 | 329 | 95 | 77 |
| AI | 30 | 35 | 8 | 4 |
| Referral | 17 | 26 | 2 | 1 |

Organic Search is the largest buyer source and it fell hardest: 95 to 77 pure buyer sessions, down 19%, on roughly flat volume. That is a homepage conversion problem, not a traffic problem.

The three missing days would add roughly 26 sessions at September's run rate, of which about 5 would be pure buyer. That does not change any conclusion above.

---

## Q2 calibration: why my Q2 differs from the sheet

The sheet publishes **849** total sessions for Q2. On the comparable basis (Base B, bots included) I get **832**, a gap of 17 sessions, 2.0%.

There is no saved PostHog insight holding the original definition, so I rebuilt it from the tab's notes and tested the variants:

| Definition tested | Q2 total |
|---|---|
| Entry page from the first pageview event (used here) | 832 |
| Entry page from the session record | 837 |
| Direct + Organic Search + AI only, no Referral | 813 |
| Homepage seen anywhere in the session, not just entry | 886 |
| Unique people rather than sessions | 769 |
| **Published** | **849** |

No combination lands on 849. The rest of the row is close: published homepage-only is 560 against my 555, published careers is 120 against my 110.

I use the first-pageview definition because it is the only one where the parts add up. The session-record definition produces 3 sessions whose entry is recorded as the homepage but whose only pageview is a careers page, which breaks the arithmetic.

**This matters for the sheet.** Q3 against the published Q2 is not like-for-like. Either restate Q2 on this basis, or tell me where 849 came from and I will match it.

---

## Method notes

Careers content also exists at `/bravo/careers/` and `/virtual-assistant-careers/`. I tested the wider pattern and it changes nothing: no homepage-entry session in the target markets touched those without also touching `/careers/`. The narrow `/careers` prefix is safe.

`/ceo-insights/executive-assistant-career-growth/` is deliberately **not** counted as careers. It sits in the buyer silo despite the word "career" in the slug.

### Reusable query

Swap the two dates and the quarter labels each time. `NOT is_bot` gives Base A; drop that line for Base B. The `coalesce` calls matter: without them, sessions with a null channel or referrer are silently dropped.

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
    argMin(properties.$geoip_country_code, timestamp)                          AS country,
    argMin(if(properties.$pathname = '', '/', properties.$pathname), timestamp) AS entry_path,
    coalesce(any(session.$channel_type), '')                                   AS channel,
    coalesce(any(session.$entry_referring_domain), '')                         AS refdom,
    toDate(toTimeZone(min(timestamp), 'Europe/Ljubljana'))                     AS ds,
    uniq(if(properties.$pathname = '', '/', properties.$pathname))             AS n_paths,
    countIf(properties.$pathname LIKE '/careers%')                             AS careers,
    max(coalesce(properties.$virt_is_bot, false))                              AS is_bot,
    if(ds <= toDate('2026-06-30'), 'Q2 2026', 'Q3 2026')                       AS q
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
  AND NOT is_bot
  AND ds >= toDate('2026-04-01') AND ds <= toDate('2026-09-30')
GROUP BY q
ORDER BY q
```

---

## Decisions needed before this goes in the sheet

1. **Bots in or out.** Not covered by the current rules. Recommendation: out, and restate Q2 the same way. Two thirds of this quarter's apparent growth is Googlebot and headless scrapers.
2. **Referral in or out.** The rule includes it, the explanatory note omits it. Currently in. Worth 17 sessions in Q2 and 26 in Q3.
3. **The 849.** Restate Q2 on this method, or point me at the original PostHog view so I can match it.
4. **When to finalise.** These figures stop at 27 September. Say the word on 1 October and I will re-run for the complete quarter.
