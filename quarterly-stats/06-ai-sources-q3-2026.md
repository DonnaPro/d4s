# AI Sources: Q3 2026 (Jul-Sep)

**Prepared:** 28 September 2026
**Source:** PostHog project 36534 (Donna Pro), timezone Europe/Ljubljana
**Target tab:** `AI Sources` in *DonnaPro - Quarterly Stats*
**Data coverage:** 1 July to **27 September 2026**. Three days of the quarter are still missing.

Basis: all countries (this tab does not restrict to the 17 markets), careers visitors excluded, one row per session.

---

# THE ACCURATE TABLE

Each session is attributed to one AI source, using the referring domain where the browser passed one and the `utm_source` where it did not. No session is counted twice.

| Source | Q2 2026 | Q3 2026 (to 27 Sep) | Change |
|---|---|---|---|
| **ChatGPT** | 134 | **213** | **+59%** |
| Gemini | 12 | **24** | +100% |
| Bing (bare domain) | 4 | **10** | +150% |
| Claude | 4 | **8** | +100% |
| Perplexity | 12 | **5** | -58% |
| NotebookLM | 4 | **5** | +25% |
| Copilot | 5 | **1** | -80% |
| Kagi | 1 | **0** | - |
| You.com | 0 | **0** | - |
| Grok | 0 | **0** | - |
| Meta AI | 0 | **0** | - |
| DeepSeek | 0 | **0** | - |
| Mistral | 0 | **0** | - |
| Poe | 0 | **0** | - |
| Phind | 0 | **0** | - |
| **Total** | **176** | **266** | **+51%** |

**AI traffic grew 51% this quarter, and ChatGPT is 80% of it.**

## How each source was seen

| Source | Q2 by referrer | Q2 by UTM only | Q3 by referrer | Q3 by UTM only |
|---|---|---|---|---|
| ChatGPT | 90 | 44 | **87** | **126** |
| Gemini | 12 | 0 | 22 | 2 |
| Bing (bare domain) | 4 | 0 | 10 | 0 |
| Claude | 4 | 0 | 8 | 0 |
| Perplexity | 9 | 3 | 5 | 0 |
| NotebookLM | 4 | 0 | 5 | 0 |
| Copilot | 2 | 3 | 0 | 1 |
| Kagi | 1 | 0 | 0 | 0 |

---

## Why this differs from the current tab

The current tab reads **112 in Q2 and 126 in Q3**, up 12.5%. The accurate figures are 176 and 266, up 51%. Three separate causes, worth 140 sessions in Q3:

### 1. ChatGPT increasingly strips its referrer

ChatGPT appends `utm_source=chatgpt.com` even when the browser passes no referring domain. A referrer-only table cannot see those sessions.

| | Q2 | Q3 | Change |
|---|---|---|---|
| Referrer visible (what the tab counts) | 90 | 87 | **-3%** |
| Referrer stripped, UTM survives | 44 | **126** | **+186%** |
| **True ChatGPT total** | **134** | **213** | **+59%** |

The referrer-visible share of ChatGPT sessions fell from 67% to 41%. **The tab reports ChatGPT as flat. It grew 59%.** That is the single most misleading number in the workbook, because it reads as "AI is stalling" when AI is the fastest-growing channel on the site.

### 2. The `perplexity.ai` row matches the wrong string

Perplexity passes its referrer as **`www.perplexity.ai`**, so a literal `perplexity.ai` match returns 0. It has read 0 in both quarters while real traffic existed: 12 in Q2, 5 in Q3.

Note that once corrected, Perplexity is the one source that **fell**, down 58%.

### 3. Missing and mismatched rows

| Issue | Effect |
|---|---|
| `notebooklm.google.com` is not on the list at all | 4 in Q2, 5 in Q3 uncounted |
| `copilot.microsoft.com` does not catch `www.copilot.com` or the `copilot.com` UTM | 3 in Q2, 1 in Q3 uncounted |
| `cn.bing.com` not caught by the `bing.com` row | 1 in Q3 |

---

## Calibration, so you can trust the above

Exact domain matching with **no `www.` normalisation** reproduces your published Q2 column:

| Source | Published Q2 | My referrer-only Q2 |
|---|---|---|
| bing.com | 4 | **4** |
| gemini.google.com | 12 | **12** |
| kagi.com | 1 | **1** |
| copilot.microsoft.com | 1 | **1** |
| perplexity.ai | 0 | **0** |
| you.com, grok.com, meta.ai, deepseek.com, mistral.ai, poe.com, phind.com | 0 | **0** |
| chatgpt.com | 93 | 90 |
| claude.ai | 5 | 4 |

The `bing.com` row is the proof that the original method used literal domains: `bing.com` and `www.bing.com` are different referrers, and only the bare one is in your table. `www.bing.com` is ordinary Bing web search, which ran 110 in Q2 and 174 in Q3 and correctly does not belong in an AI table.

---

## What 266 still does not include

266 is a floor, not a ceiling. Claude, Perplexity and others open links in ways that strip the referrer **without** adding a UTM, so they leave no trace at all and sit inside the Direct bucket. Nothing in PostHog can size that.

For context, Direct human sessions landing on the homepage alone were 375 in Q2 and 388 in Q3. An unknown but material share of that is AI.

Worth considering whether `bing.com` belongs on this tab at all. It is 10 sessions, Copilot-adjacent at best, and the `Homepage - Organic` tab already counts Bing as search.

---

## Reusable query

One row per session, referrer first, UTM as fallback, no double counting.

```sql
SELECT
  source,
  countIf(q = 'Q2') AS q2_total,
  countIf(q = 'Q3') AS q3_total,
  countIf(q = 'Q3' AND by_referrer)       AS q3_via_referrer,
  countIf(q = 'Q3' AND NOT by_referrer)   AS q3_via_utm_only
FROM (
  SELECT
    q,
    refdom IN ('chatgpt.com','gemini.google.com','claude.ai','notebooklm.google.com',
               'www.perplexity.ai','perplexity.ai','copilot.microsoft.com','www.copilot.com',
               'copilot.com','bing.com','cn.bing.com','kagi.com','you.com','grok.com','x.ai',
               'meta.ai','deepseek.com','chat.deepseek.com','mistral.ai','chat.mistral.ai',
               'poe.com','phind.com') AS by_referrer,
    multiIf(
      refdom = 'chatgpt.com',                                              'ChatGPT',
      refdom = 'gemini.google.com',                                        'Gemini',
      refdom = 'claude.ai',                                                'Claude',
      refdom = 'notebooklm.google.com',                                    'NotebookLM',
      refdom IN ('www.perplexity.ai','perplexity.ai'),                     'Perplexity',
      refdom IN ('copilot.microsoft.com','www.copilot.com','copilot.com'), 'Copilot',
      refdom IN ('bing.com','cn.bing.com'),                                'Bing (bare domain)',
      refdom = 'kagi.com',                                                 'Kagi',
      refdom = 'you.com',                                                  'You.com',
      refdom IN ('grok.com','x.ai'),                                       'Grok',
      refdom = 'meta.ai',                                                  'Meta AI',
      refdom IN ('deepseek.com','chat.deepseek.com'),                      'DeepSeek',
      refdom IN ('mistral.ai','chat.mistral.ai'),                          'Mistral',
      refdom = 'poe.com',                                                  'Poe',
      refdom = 'phind.com',                                                'Phind',
      utm ILIKE '%chatgpt%' OR utm ILIKE '%openai%',                       'ChatGPT',
      utm ILIKE '%notebooklm%',                                            'NotebookLM',
      utm ILIKE '%gemini%',                                                'Gemini',
      utm ILIKE '%claude%' OR utm ILIKE '%anthropic%',                     'Claude',
      utm ILIKE '%perplexity%',                                            'Perplexity',
      utm ILIKE '%copilot%',                                               'Copilot',
      utm ILIKE '%grok%',                                                  'Grok',
      utm ILIKE '%deepseek%',                                              'DeepSeek',
      utm ILIKE '%mistral%',                                               'Mistral',
      ''
    ) AS source
  FROM (
    SELECT
      $session_id AS sid,
      coalesce(any(session.$entry_referring_domain), '')     AS refdom,
      coalesce(any(session.$entry_utm_source), '')           AS utm,
      toDate(toTimeZone(min(timestamp), 'Europe/Ljubljana')) AS ds,
      countIf(properties.$pathname LIKE '/careers%'
           OR properties.$pathname LIKE '/bravo/careers%')   AS careers,
      if(ds <= toDate('2026-06-30'), 'Q2', 'Q3')             AS q
    FROM events
    WHERE event = '$pageview'
      AND timestamp >= toDateTime('2026-03-31 00:00:00')
      AND timestamp <  toDateTime('2026-10-01 00:00:00')
      AND $session_id != ''
    GROUP BY sid
    HAVING ds >= toDate('2026-04-01') AND ds <= toDate('2026-09-30') AND careers = 0
  )
)
WHERE source != ''
GROUP BY source
ORDER BY q3_total DESC, q2_total DESC
```

Do not normalise `www.` away: it merges Bing web search into Bing Copilot and breaks the table. The referrer test must come before the UTM fallback in the `multiIf`, or sessions with both signals get attributed twice.
