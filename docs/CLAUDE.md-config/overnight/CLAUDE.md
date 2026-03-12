@AGENTS.md

## Overnight Automation

This project uses an overnight automation slash command for long unattended runs.

- Slash command: `/overnight <path/to/TODO.md>`
- State is saved to `.overnight/` — never delete this during a session
- To resume after interruption: run `/overnight <same-TODO-file>` again
- To start fresh: run `/overnight --fresh <TODO-file>`
- Rate limit pauses are handled automatically; just re-run after the reset time

The `.overnight/` directory should be in `.gitignore` unless you want to
commit session logs.