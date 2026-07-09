# Rate Limits & Credits

Everything the `seo-api` skill needs to forecast cost and pace requests against the DataForSEO API.

## Rate limits

DataForSEO does not publish a single universal rate limit — it varies by endpoint category and subscription plan. Safe conservative defaults:

| Endpoint category | Safe default (req/min) | Notes |
|---|---|---|
| DataForSEO Labs | ~60 req/min | Historical/aggregated data; lower throughput |
| SERP (live) | ~100 req/min | Real-time scraping; plan-dependent |
| Backlinks | ~60 req/min | Index queries |
| On-Page (Lighthouse) | ~20 req/min | Lighthouse is resource-intensive |
| On-Page (instant_pages) | ~60 req/min | Faster than Lighthouse |
| AI Optimization (ChatGPT scraper) | ~20 req/min | Slow due to LLM calls |
| Keyword Data | ~60 req/min | |
| Content Analysis | ~60 req/min | |

**These are safe conservative estimates, not published SLAs.** If you're running large batch jobs, start low and ramp up — a `429` response will tell you when you've hit the actual limit.

**Rate limits are per account**, not per IP. All concurrent workers sharing the same `DATAFORSEO_USERNAME` share the same budget.

## Handling 429 — exponential backoff with jitter

```python
import random, time, requests, base64, os

USERNAME = os.environ["DATAFORSEO_USERNAME"]
PASSWORD = os.environ["DATAFORSEO_PASSWORD"]
CREDS = base64.b64encode(f"{USERNAME}:{PASSWORD}".encode()).decode()
HEADERS = {"Authorization": f"Basic {CREDS}", "Content-Type": "application/json"}

def call(url, payload, max_attempts=5):
    delay = 1.0
    for attempt in range(max_attempts):
        r = requests.post(url, json=payload, headers=HEADERS)
        if r.status_code != 429:
            r.raise_for_status()
            return r.json()
        jitter = random.uniform(-0.2, 0.2) * delay
        time.sleep(delay + jitter)
        delay *= 2
    raise RuntimeError(f"Rate-limited after {max_attempts} attempts on {url}")
```

```typescript
async function call(url: string, payload: unknown, maxAttempts = 5): Promise<unknown> {
  const credentials = btoa(`${process.env.DATAFORSEO_USERNAME}:${process.env.DATAFORSEO_PASSWORD}`);
  const headers = { Authorization: `Basic ${credentials}`, "Content-Type": "application/json" };
  let delay = 1000;
  for (let attempt = 0; attempt < maxAttempts; attempt++) {
    const r = await fetch(url, { method: "POST", headers, body: JSON.stringify(payload) });
    if (r.status !== 429) {
      if (!r.ok) throw new Error(`HTTP ${r.status}: ${await r.text()}`);
      return r.json();
    }
    const jitter = (Math.random() * 0.4 - 0.2) * delay;
    await new Promise((resolve) => setTimeout(resolve, delay + jitter));
    delay *= 2;
  }
  throw new Error(`Rate-limited after ${maxAttempts} attempts`);
}
```

**Why jitter matters.** Without it, multiple workers hitting the limit simultaneously synchronise their retries and re-hit the limit at the next interval. A ±20% randomisation spreads them out.

## Client-side throttling (proactive)

Better than reacting to 429s: pace requests to stay under the limit.

```python
import time
from collections import deque

class RateLimiter:
    def __init__(self, rpm: int):
        self.rpm = rpm
        self.calls = deque()

    def acquire(self):
        now = time.monotonic()
        window = 60.0
        while self.calls and self.calls[0] < now - window:
            self.calls.popleft()
        if len(self.calls) >= self.rpm:
            wait = window - (now - self.calls[0])
            time.sleep(wait + 0.1)
        self.calls.append(time.monotonic())

# Example: pace DataForSEO Labs at 60 req/min
limiter = RateLimiter(rpm=60)
for payload in payloads:
    limiter.acquire()
    result = call(url, payload)
```

## Credit system

DataForSEO charges credits per API call. Credits are pre-purchased — requests are rejected with `402` when balance runs out.

### Billing model

Most endpoints charge a flat fee per task (one item in the request array). Some endpoints charge per record returned.

- **Per task (flat):** most Labs, SERP, and summary endpoints — charged once per item in the POST array, regardless of how many results are returned.
- **Per record:** list endpoints where the charge scales with result count — e.g., `backlinks_backlinks` charges per backlink record returned.

**Failed requests (4xx, 5xx) are not billed** unless the task was successfully created and the failure is in processing.

### Checking credit balance

```bash
curl -u 'your@email.com:your_api_password' \
  'https://api.dataforseo.com/v3/appendix/user_data'
```

Response includes:

```json
{
  "money": {
    "balance": 150.00,
    "currency": "USD"
  }
}
```

DataForSEO bills in USD, not a named "credit" unit — the balance is dollar-denominated. Top up at: <https://app.dataforseo.com/billing>

### Forecasting cost

Before running a large workflow:

1. List every tool call.
2. Check the per-endpoint pricing at: <https://docs.dataforseo.com/v3/> (each endpoint's docs page lists its price).
3. Multiply by call count.
4. Compare against account balance.

**Approximate pricing reference (verify against docs before large runs — prices change):**

| Tool | Approx. cost |
|---|---|
| `serp_organic_live_advanced` | ~$0.0015 per task |
| `dataforseo_labs_google_domain_rank_overview` | ~$0.0025 per task |
| `dataforseo_labs_google_ranked_keywords` | ~$0.0025 per task |
| `dataforseo_labs_google_keyword_ideas` | ~$0.0025 per task |
| `dataforseo_labs_bulk_keyword_difficulty` | ~$0.0025 per task (up to 1000 KWs) |
| `backlinks_summary` | ~$0.002 per task |
| `backlinks_backlinks` | ~$0.00001 per record returned |
| `on_page_instant_pages` | ~$0.0025 per task |
| `on_page_lighthouse` | ~$0.0075 per task |
| `ai_optimization_chat_gpt_scraper` | ~$0.01–$0.03 per task |

**Always verify pricing in the DataForSEO docs before a large run.** Prices vary by plan tier and are updated periodically.

### Insufficient balance — 402

```json
{
  "status_code": 402,
  "status_message": "PaymentRequired",
  "tasks": null
}
```

No partial billing — the entire request batch is rejected. Top up at <https://app.dataforseo.com/billing>.

## Combined rate-limit + error safety pattern

The end-to-end shape for any production DataForSEO integration:

```python
import time, random, requests, base64, os
from collections import deque

USERNAME = os.environ["DATAFORSEO_USERNAME"]
PASSWORD = os.environ["DATAFORSEO_PASSWORD"]
BASE = "https://api.dataforseo.com/v3"

class DataForSEOClient:
    def __init__(self, rpm=60):
        creds = base64.b64encode(f"{USERNAME}:{PASSWORD}".encode()).decode()
        self.headers = {"Authorization": f"Basic {creds}", "Content-Type": "application/json"}
        self.rpm = rpm
        self.calls = deque()

    def _throttle(self):
        now = time.monotonic()
        while self.calls and self.calls[0] < now - 60.0:
            self.calls.popleft()
        if len(self.calls) >= self.rpm:
            wait = 60.0 - (now - self.calls[0])
            time.sleep(wait + 0.1)
        self.calls.append(time.monotonic())

    def post(self, path, payload, max_attempts=5):
        delay = 1.0
        for attempt in range(max_attempts):
            self._throttle()
            r = requests.post(f"{BASE}{path}", json=payload, headers=self.headers)
            if r.status_code == 429:
                time.sleep(delay + random.uniform(-0.2, 0.2) * delay)
                delay *= 2
                continue
            if r.status_code == 402:
                raise RuntimeError("Insufficient DataForSEO balance — top up before retrying.")
            r.raise_for_status()
            data = r.json()
            # DataForSEO wraps results in tasks[0].result
            tasks = data.get("tasks", [])
            if tasks and tasks[0].get("status_code") == 20000:
                return tasks[0].get("result", [])
            # Surface API-level errors
            if tasks:
                raise RuntimeError(f"DataForSEO task error: {tasks[0].get('status_message')}")
            return data
        raise RuntimeError(f"Rate-limited after {max_attempts} attempts on {path}")

# Usage
client = DataForSEOClient(rpm=60)
result = client.post("/dataforseo_labs/google/domain_rank_overview/live", [
    {"target": "acme.com", "location_code": 2826, "language_code": "en"}
])
```

This handles: proactive rate pacing, exponential backoff with jitter, terminal 402 (no balance), and DataForSEO's task-level error codes. Tune `rpm` per endpoint category — use 20 for Lighthouse, 60 for Labs, 100 for SERP.

## DataForSEO response envelope

Every DataForSEO response wraps results in a consistent envelope. Always check `tasks[0].status_code`:

```json
{
  "version": "0.1.20231114",
  "status_code": 20000,
  "status_message": "Ok.",
  "time": "0.2345 sec.",
  "tasks": [
    {
      "id": "...",
      "status_code": 20000,
      "status_message": "Ok.",
      "result": [ ... ]
    }
  ]
}
```

| `status_code` | Meaning |
|---|---|
| `20000` | Success |
| `20100` | Task created (async — poll for result) |
| `40000` | Bad request (check parameters) |
| `40101` | Auth error |
| `40200` | Insufficient balance |
| `50000` | Internal server error (retry) |
