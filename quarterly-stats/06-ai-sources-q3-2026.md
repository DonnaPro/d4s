# AI Sources: Q3 2026 (Jul-Sep)

**Prepared:** 28 September 2026
**Source:** PostHog project 36534 (Donna Pro), timezone Europe/Ljubljana
**Target tab:** `AI Sources` in *DonnaPro - Quarterly Stats*
**Data coverage:** 1 July to **27 September 2026**. Three days of the quarter are still missing.

Basis: sessions whose entry referring domain matches the listed source exactly, careers visitors excluded, **all countries** (this tab does not restrict to the 17 markets).

---

## Calibration

Exact domain matching, with no `www.` normalisation, reproduces the published Q2 column almost exactly:

| Source | Published Q2 | My Q2 | Match |
|---|---|---|---|
| bing.com | 4 | 4 | exact |
| gemini.google.com | 12 | 12 | exact |
| kagi.com | 1 | 1 | exact |
| copilot.microsoft.com | 1 | 1 | exact |
| perplexity.ai | 0 | 0 | exact |
| you.com, grok.com, meta.ai, deepseek.com, mistral.ai, poe.com, phind.com | 0 | 0 | exact |
| chatgpt.com | 93 | 90 | -3 |
| claude.ai | 5 | 4 | -1 |

The `bing.com` row confirms the method: `bing.com` and `www.bing.com` are different referrers, and only the bare one belongs in an AI table. `www.bing.com` is ordinary Bing web search and ran at 110 in Q2, 174 in Q3.

---

## The table, your 14 rows

| Source | Q2 2026 | Q3 2026 (to 27 Sep) |
|---|---|---|
| chatgpt.com | 90 | **87** |
| gemini.google.com | 12 | **22** |
| claude.ai | 4 | **8** |
| bing.com | 4 | **9** |
| kagi.com | 1 | **0** |
| copilot.microsoft.com | 1 | **0** |
| perplexity.ai | 0 | **0** |
| you.com | 0 | **0** |
| grok.com | 0 | **0** |
| meta.ai | 0 | **0** |
| deepseek.com | 0 | **0** |
| mistral.ai | 0 | **0** |
| poe.com | 0 | **0** |
| phind.com | 0 | **0** |
| **Total** | **112** | **126** |

On these rows alone, AI referrals are up 12.5%.

---

## Finding 1: three rows are matching the wrong string

| Source as listed | What it should match | Q2 | Q3 |
|---|---|---|---|
| `perplexity.ai` | **`www.perplexity.ai`** | 9 | **5** |
| `copilot.microsoft.com` | also **`www.copilot.com`** | +1 | 0 |
| not listed | **`notebooklm.google.com`** | 4 | **5** |
| not listed | `cn.bing.com` | 0 | 1 |

**Perplexity is not zero.** It sends its referrer as `www.perplexity.ai`, so the `perplexity.ai` row reads 0 when the real figure is 9 for Q2 and 5 for Q3. That row has been wrong in both quarters.

NotebookLM is a real and growing source at 5 sessions and is not on the list at all.

Adding these back: **Q2 126, Q3 137.**

---

## Finding 2: the hidden traffic your note predicted, measured

Your note says the bulk of AI traffic arrives as direct/unattributed. That is correct, and a large part of it is measurable, because ChatGPT appends `utm_source=chatgpt.com` even when the referrer is stripped.

Sessions with **no referring domain** but an AI `utm_source`:

| utm_source | Referrer | Q2 | Q3 |
|---|---|---|---|
| chatgpt.com | (none) | 44 | **124** |
| copilot.com | (none) | 3 | **1** |
| perplexity | (none) | 3 | **0** |
| gemini | (none) | 0 | **2** |
| **Subtotal invisible to this table** | | **50** | **127** |

These are not double-counted: sessions carrying both the chatgpt.com referrer and the UTM (76 in Q2, 83 in Q3) are already inside the 90 and 87 above.

### What this does to the ChatGPT trend

| | Q2 | Q3 | Change |
|---|---|---|---|
| Referrer visible (what the table shows) | 90 | 87 | **-3%** |
| Referrer stripped, UTM survives | 44 | 124 | **+182%** |
| **True ChatGPT total** | **134** | **212** | **+58%** |

**The table says ChatGPT is flat. It is up 58%.** What actually changed is how ChatGPT opens links: the referrer-visible share fell from 67% of ChatGPT sessions to 41%, while the total grew strongly.

This is the single most misleading number in the workbook, because it reads as "AI is stalling" when AI is the fastest-growing channel on the site.

### The full picture

| | Q2 | Q3 | Change |
|---|---|---|---|
| Your 14 rows as currently matched | 112 | 126 | +12.5% |
| Plus corrected and missing referrer rows | 126 | 137 | +8.7% |
| Plus UTM-attributed with no referrer | **176** | **264** | **+50.0%** |

And 264 is still a floor, not a ceiling. Claude, Perplexity and others strip the referrer without adding a UTM, so they leave no trace at all and sit inside the Direct bucket. There is no way to size that from PostHog alone.

---

## What to change in the tab

1. **Fix the `perplexity.ai` row** to match `www.perplexity.ai`. It has read 0 in both quarters while real traffic existed.
2. **Add `notebooklm.google.com`.** 4 in Q2, 5 in Q3.
3. **Make `copilot.microsoft.com` also catch `www.copilot.com`.**
4. **Add a second column or block for UTM-attributed sessions with no referrer.** Without it the tab cannot see the majority of ChatGPT traffic, and the trend it reports is the opposite of the real one.
5. Consider whether `bing.com` belongs here at all. It is 9 sessions and is Copilot-adjacent at best, while the `Homepage - Organic` tab already counts Bing as search.

---

## Reusable queries

Referrer-based rows:

```sql
SELECT
  src,
  countIf(q = 'Q2') AS q2,
  countIf(q = 'Q3') AS q3
FROM (
  SELECT
    $session_id AS sid,
    coalesce(any(session.$entry_referring_domain), '')     AS src,
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
WHERE src IN ('chatgpt.com','gemini.google.com','claude.ai','bing.com','kagi.com',
              'copilot.microsoft.com','www.perplexity.ai','notebooklm.google.com',
              'www.copilot.com','you.com','grok.com','meta.ai','deepseek.com',
              'mistral.ai','poe.com','phind.com')
GROUP BY src
ORDER BY q3 DESC
```

The hidden block: same query, but replace the final `WHERE` with

```sql
WHERE refdom IN ('', '$direct')
  AND (utm_src ILIKE '%chatgpt%' OR utm_src ILIKE '%openai%' OR utm_src ILIKE '%claude%'
    OR utm_src ILIKE '%perplexity%' OR utm_src ILIKE '%gemini%' OR utm_src ILIKE '%copilot%')
```

selecting `coalesce(any(session.$entry_utm_source), '') AS utm_src` in the inner query. Do not normalise `www.` away in either: it merges Bing web search into Bing Copilot and breaks the table.
