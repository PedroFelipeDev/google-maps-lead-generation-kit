---
name: google-maps-scraper
description: Generate business lead CSVs with the local Google Maps Docker engine. Use for business searches by city, batch keywords, email or social enrichment, engine setup, and scrape job management. Excludes direct scraping of social platforms.
---

# Google Maps Scraper

Work from the repository root. Prefer `scripts/scrape.py`: it handles geocoding,
job creation, polling, downloads, deduplication, and enrichment using only the
Python standard library. Use `python` on Windows or `python3` where appropriate.

## Setup and health

Check `docker info`. If Docker is unavailable, explain the error and refer to
`SETUP.md`. Otherwise start the engine with `docker compose up -d`. Check its API
using the CLI's configuration, including custom ports and authentication:

```sh
python -c "import sys; sys.path.insert(0, 'scripts'); import scrape; status, body = scrape.req('GET', '/api/v1/jobs'); print(status); print(body.decode())"
```

The default URL is `http://localhost:8080`. The CLI honors `.env` and environment
variables `SCRAPER_BASE_URL`, `SCRAPER_PORT`, and `SCRAPER_API_KEY`. Never print
the key. Retry startup health checks for a bounded period, then inspect
`docker compose logs --tail 50` if the engine remains unavailable.

The optional dashboard starts with `python painel/server.py` on localhost:8090;
`--sem-navegador` suppresses browser opening. On Windows, `Iniciar-Prospecao.cmd`
starts Docker and the dashboard. Report readiness only after a successful check.

## Single search

Use the requested business type, city, and depth (default `5`). Include the city
in the keyword. Emails and deeper contact-page email extraction are enabled by
default; add `--no-email` only when requested.

```sh
python scripts/scrape.py "dentists in Recife PE" --city "Recife, PE, Brazil" --depth 5
```

Honor any existing yes/no choice about social profiles. Otherwise ask once,
before launching, whether Instagram, Facebook, and LinkedIn enrichment is wanted.
Add `--socials` when accepted. The script extracts links from business websites,
not the social platforms themselves. Contact information coverage is partial.

For whole-city requests or Google's roughly 120-listing per-search cap, use
`--grid 3`. Tiles run sequentially and results are deduplicated. Explain the extra
time and rate-limit risk and follow the user's requested scope.

## Batch search

Read the keyword file (one term per line, ignoring blanks and `#` comments) and
resolve the intended city. Use one batch job, applying the same enrichment choices:

```sh
python scripts/scrape.py --keywords-file examples/queries.example.txt --city "Denver, CO" --max-time 900
```

Run one Google Maps job at a time. Consult `--help` for additional CLI options.

## Execution and output

Use available terminal/session tools for long commands and resume the returned
session. Do not assume a Claude-specific `run_in_background` argument exists.
Report meaningful progress. Stop polling on success, failure, or the job's time
limit. Submitting a job does not establish that a scrape completed.

Save the CSV locally (default: `results-<job-id>.csv`). Present the row count, file
path, and a small sample of the eight lead fields: `title`, `phone`, `emails`,
`website`, `category`, `address`, `review_rating`, and `review_count`. Include
requested social columns. Use `--full` only when asked for raw fields. Keep large
lead files out of the conversation.

## Jobs and custom API requests

Reuse `scrape.req(method, path, body=None)` from `scripts/scrape.py` for API access.

- List: `GET /api/v1/jobs`; summarize `ID`, `Name`, `Status`, and `Date`.
- Download: `GET /api/v1/jobs/<id>/download`; save the CSV, count rows using `csv`,
  and keep the eight lead fields unless asked for more.
- Delete: `DELETE /api/v1/jobs/<id>` only for jobs selected by the user for deletion.
  Verify the response. Do not delete Docker volumes as a substitute.

Custom `POST /api/v1/jobs` requires `keywords` (array), `lat` and `lon` (strings),
and `max_time` (integer seconds). Prefer `depth: 5`, `email: true`. Creation
returns lowercase `id`; poll `GET /api/v1/jobs/<id>` using capitalized `Status`
(`working`, `ok`, `failed`). HTTP 422 usually means missing required fields.
Only add proxies supplied or authorized by the user; do not print credentials.

Keep the API bound to localhost. For large or repeated searches, briefly explain
temporary IP rate limits and suggest proxies, then proceed within the requested
scope. Back off when jobs fail or return unusually few results. Contact details
are personal data: keep outputs out of Git and do not assist spam, harassment, or
surveillance. Preserve existing authorization and approval settings.
