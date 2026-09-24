# CLAUDE.md

| File | Goes to | Install |
| ---- | ------- | ------- |
| [CLAUDE.md](CLAUDE.md) | `~/.claude/CLAUDE.md` (global, every project) | `bash scripts/install/10-claude-md.sh` |
| [home-CLAUDE.md](home-CLAUDE.md) | `~/CLAUDE.md` -- reference only | nothing: plugins regenerate it (below) |
| [CLAUDE-guidelines.md](CLAUDE-guidelines.md) | per-project `CLAUDE.md` template | copy into a project and fill in |
| [AGENTS.md](AGENTS.md) | per-project `AGENTS.md` template | copy into a project |
| [overnight/CLAUDE.md](overnight/CLAUDE.md) | project snippet for `/overnight` | append to a project `CLAUDE.md` |

Manual: `cp docs/CLAUDE.md-config/CLAUDE.md ~/.claude/CLAUDE.md`

## Plugin-injected blocks

Project `CLAUDE.md` files on the reference machine carry two blocks written automatically on SessionStart.
Do not hand-copy them; install the plugins (step 20) and they appear on the next session:

- `# context-mode -- MANDATORY routing rules` <- `context-mode@context-mode`
- `# Behavioral Guidelines` <- `karpathy-automatic-claude-md@karpathy-automatic-claude-md`

## Verify

```bash
head -3 ~/.claude/CLAUDE.md
```
