# Task 2 - Morning Brief (GitHub -> Discord)

**File:** `Task2_Workflow_Aryan.json` (import via n8n: Workflows -> Import from file)

**APIs:** GitHub REST API, no key needed for these read-only calls (60 requests/hour per IP). Chosen because it is free, stable and has two related endpoints.
1. `GET /search/repositories?q=topic:react&sort=stars` - list of repos.
2. `GET /repos/{owner}/{repo}/commits?per_page=1` - enrichment: latest commit of the #1 repo (runs once).

**Flow:** Schedule (every 1 h) -> HTTP #1 -> Code "Top 5 Repos" (keep 5, pick name/stars/url/description, sort by stars) -> HTTP #2 -> Code "Build digest" (one Discord message) -> IF `top repo stars > 1000` -> Discord "popular" or "quiet" message.
Threshold 1000 is a sample value from the assignment; on the topic:react search it is always true, so change it (or the topic) to see the false branch.

**Error path:** both HTTP nodes use *On Error -> Continue (using error output)*; HTTP #1 also retries 3 times. Any failure goes to `Discord: ALERT API failed`, so nothing fails silently. Empty results throw an error inside the Code node, which is also surfaced in the n8n execution log.

**Credentials:** none hard-coded. Create a *Discord Webhook* credential in n8n and select it on the 3 Discord nodes (the JSON contains only a placeholder id `REPLACE_ME`).

**Tested:** the Code-node logic was executed with Node.js against live GitHub search data (top-5 output above). I did not import it into a running n8n instance here, so re-select the credential after import and run *Execute workflow* once. If your n8n version shows the Discord node parameters differently, re-select "Webhook" authentication.
