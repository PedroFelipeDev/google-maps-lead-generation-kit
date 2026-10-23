# Google Maps Lead Generation Kit

This repository runs the `gosom/google-maps-scraper` Docker engine, a Python CLI,
and a Portuguese prospecting dashboard. Keep `LICENSE` and `CREDITS.md` intact.

For lead lists, business searches, engine setup, or scrape job management, read
`.agents/skills/google-maps-scraper/SKILL.md`. Reuse the existing CLI for geocoding,
scraping, deduplication, and enrichment. See `.codex/README.md` for Codex usage.

## Development

- Engine: `docker compose up -d` (localhost:8080 by default).
- Dashboard: `python painel/server.py` (localhost:8090).
- Windows launcher: `Iniciar-Prospecao.cmd`.
- CLI options: `python scripts/scrape.py --help`.
- Regression tests: `python -m unittest discover -s scripts -p "test_*.py"`.
- Python uses only the standard library. Use `python3` if required by the system.

Use available terminal/session tools for long-running commands; do not assume
Claude-specific Bash arguments work in Codex. Consult `SETUP.md` for Docker errors.

## Data and configuration

The CLI reads `SCRAPER_PORT`, `SCRAPER_BASE_URL`, and `SCRAPER_API_KEY` from `.env`
or the environment. Reuse its configuration and HTTP helpers for API requests.
Keep the engine bound to localhost. Never print credentials or commit `.env`,
logs, generated lead files, or `painel/dados/`.
