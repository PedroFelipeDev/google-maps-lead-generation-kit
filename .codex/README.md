# Codex integration

Open this repository in Codex. Root `AGENTS.md` supplies project instructions.
The automatically discovered skill lives in
`.agents/skills/google-maps-scraper/SKILL.md`. The entry point under
`.codex/skills/google-maps-scraper/SKILL.md` links to those same instructions.

Examples to ask Codex:

- "Start the local scraper and check that it is healthy."
- "Use $google-maps-scraper to find dentists in Recife, PE, with emails."
- "Run examples/queries.example.txt for Denver, CO."
- "List scraper jobs and download the completed results."

The skill covers setup, single searches, batches, and job management. Claude's
`.claude/commands/` slash commands and `.claude/settings.json` permissions are
specific to Claude Code. Codex uses its available tools and the user's existing
sandbox and approval settings. No personal settings or credentials are included.

Official references:

- [Skill discovery](https://learn.chatgpt.com/docs/build-skills)
- [Codex configuration](https://learn.chatgpt.com/docs/config-file/config-reference)
