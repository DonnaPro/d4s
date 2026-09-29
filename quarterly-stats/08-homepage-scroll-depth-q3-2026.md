# Homepage scroll depth: Q3 2026 (Jul-Sep)

**Prepared:** 29 September 2026
**Source:** PostHog project 36534 (Donna Pro)
**Data coverage:** 1 July to **27 September 2026**
**Scope:** homepage only (`donnapro.com/`), all traffic, bots excluded, one observation per homepage view

PostHog does record scroll depth. It lives on the `$pageleave` event as `$prev_pageview_max_scroll_percentage`, stored as a fraction from 0 to 1. This is a real measurement across every session, not a sample, and it is more reliable than reading a heatmap by eye.

---

# THE TABLE

Percentage of homepage views that scrolled **at least** this far down the page.

| Checkpoint | Desktop | Mobile |
|---|---|---|
| 5% | **35.0%** | **43.1%** |
| 10% | **27.8%** | **30.2%** |
| 25% | **17.2%** | **15.1%** |
| 50% | **12.9%** | **8.5%** |
| 75% | **10.2%** | **6.4%** |
| | | |
| Average scroll depth | **15.7%** | **13.3%** |
| Homepage views measured | 3,860 | 1,675 |

Tablet is included in the data but only 19 views, too small to report: 52.6 / 36.8 / 21.1 / 15.8 / 10.5.

---

## Read this alongside the numbers: the homepage is very long

Measured from the data itself, median scrollable height:

| Device | Scrollable height | Roughly |
|---|---|---|
| Desktop | **25,680 px** | about 28 screens |
| Mobile | **36,409 px** | about 55 screens |

That changes how the percentages should be read:

| Checkpoint | Desktop distance | Mobile distance |
|---|---|---|
| 5% | 1,284 px | 1,820 px (about 2.7 screens) |
| 10% | 2,568 px | 3,641 px |
| 25% | 6,420 px | 9,102 px |
| 50% | 12,840 px | 18,205 px |
| 75% | 19,260 px | 27,307 px |

So the 10.2% of desktop visitors who pass the 75% mark have scrolled roughly 19,000 pixels. That is committed reading, not idle scrolling. Conversely, a visitor who does not scroll at all sees only about 3.5% of the desktop page and 1.8% of the mobile page.

---

## What the shape says

**Two thirds of desktop visitors never scroll at all.** 65% do not reach even the 5% mark. On mobile it is 57%. This is consistent with the `Homepage - Organic` tab, where 506 of 780 Q3 sessions (65%) left without clicking to another page.

**Mobile starts better and finishes worse.** More mobile visitors begin scrolling (43.1% against 35.0% at the 5% mark), but they drop away faster:

| Checkpoint | Desktop | Mobile | Gap |
|---|---|---|---|
| 5% | 35.0% | 43.1% | mobile +8.1 |
| 10% | 27.8% | 30.2% | mobile +2.4 |
| 25% | 17.2% | 15.1% | desktop +2.1 |
| 50% | 12.9% | 8.5% | desktop +4.4 |
| 75% | 10.2% | 6.4% | desktop +3.8 |

The crossover sits between 10% and 25%. Mobile visitors give the page a scroll, then abandon it at roughly 3,600 to 9,000 pixels. Desktop visitors are slower to start but far more likely to go the distance.

**The drop between 5% and 10% is where most people leave.** Desktop loses 7.2 points there, mobile loses 12.9. Whatever sits between roughly 1,300 and 2,600 pixels on desktop, and 1,800 to 3,600 on mobile, is where the page loses its audience.

---

## Second metric: content actually seen

`$prev_pageview_max_content_percentage` measures how much of the page's content entered the viewport, so it credits the first screen even when nobody scrolls. Closer to what Clarity reports.

| Checkpoint | Desktop | Mobile |
|---|---|---|
| 5% | 57.8% | 56.1% |
| 10% | 34.7% | 40.1% |
| 25% | 21.1% | 22.1% |
| 50% | 15.3% | 8.9% |
| 75% | 10.5% | 6.4% |
| Average content seen | 20.2% | 17.7% |

Use the first table for "how far did they scroll" and this one for "how much of the page did they see". They converge at the deeper checkpoints, as they should.

---

## Reliability

| Device | Homepage views | Views that fired a page-exit event | Coverage |
|---|---|---|---|
| Desktop | 3,923 | 3,865 | **98.5%** |
| Mobile | 2,039 | 1,682 | **82.5%** |
| Tablet | 21 | 19 | 90.5% |

Desktop is effectively complete. **Mobile is missing 17.5%**, because `$pageleave` does not always fire when a mobile browser is closed or backgrounded abruptly. Those missing views are disproportionately the fastest exits, so the true mobile figures are probably slightly *worse* than the table shows, not better.

---

## On heatmaps and session recordings

Both are enabled on the project, but neither is the right tool for these numbers:

- **Heatmaps** (`heatmaps_opt_in: true`) render as a visual overlay in the PostHog UI. There is no export that gives checkpoint percentages, which is why reading numbers off them is imprecise.
- **Session recordings** (`session_recording_opt_in: true`) have a **90-day retention**. Today is 29 September, so the window reaches back to about 1 July. Q3 recordings are inside it but only just, and July recordings are expiring now. Anything from Q2 is already gone.

The `$pageleave` scroll properties are the accurate source and they are retained with the event data, so this table can be rebuilt for any past quarter.

---

## Reusable query

```sql
SELECT
  device,
  count() AS homepage_views,
  round(100.0 * countIf(scroll >= 0.05) / count(), 1) AS pct_5,
  round(100.0 * countIf(scroll >= 0.10) / count(), 1) AS pct_10,
  round(100.0 * countIf(scroll >= 0.25) / count(), 1) AS pct_25,
  round(100.0 * countIf(scroll >= 0.50) / count(), 1) AS pct_50,
  round(100.0 * countIf(scroll >= 0.75) / count(), 1) AS pct_75,
  round(100.0 * avg(scroll), 1)                       AS avg_scroll_pct
FROM (
  SELECT
    properties.$device_type                                        AS device,
    toFloat(properties.$prev_pageview_max_scroll_percentage)       AS scroll
  FROM events
  WHERE event = '$pageleave'
    AND timestamp >= toDateTime('2026-07-01 00:00:00')
    AND timestamp <  toDateTime('2026-09-28 00:00:00')
    AND properties.$host = 'donnapro.com'
    AND properties.$prev_pageview_pathname = '/'
    AND NOT coalesce(properties.$virt_is_bot, false)
    AND properties.$prev_pageview_max_scroll_percentage IS NOT NULL
)
GROUP BY device
ORDER BY homepage_views DESC
```

Change `$prev_pageview_pathname` to run it for any other page. Swap `max_scroll_percentage` for `max_content_percentage` to get the content-seen view. The value is a 0-1 fraction, so the checkpoints are 0.05, 0.10, 0.25, 0.50, 0.75.

Page height is derived as `median(max_scroll / max_scroll_percentage)` over rows where the percentage exceeds 0.02, which avoids dividing by near-zero.
