# Bonus - Uptime Monitor

**File:** `Bonus_UptimeMonitor_Aryan.json`

- Every 5 minutes: `Config` (target URL) -> `Mark start` -> `Ping app` (HTTP, full response, *never error*, 8 s timeout, 3 retries) -> `Evaluate` (status code, response time in ms, counters) -> `IF status == 200`.
- Not 200 (including no response at all, status 0) -> Discord alert with URL, status, time, error text.
- Daily 09:00 -> summary of checks, failures, average and slowest response time (counters live in workflow static data, which only persist when the workflow is **active**).
- Default target is `http://localhost:8000/api/tags` (the Django app tested in Task 1). If n8n runs in Docker use `http://host.docker.internal:8000/api/tags`; or point it at any public URL.
- Select the same Discord Webhook credential as in Task 2.
