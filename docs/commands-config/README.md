# Slash Commands

| Command | File | Installed by | On reference machine |
| ------- | ---- | ------------ | -------------------- |
| `/gsd:*` (42) | `~/.claude/commands/gsd/*.md` | GSD, step 40 | yes |
| `/nasa-code` | [commands/nasa-code.md](../../commands/nasa-code.md) | step 70 | yes |
| `/autopush` | [commands/autopush.md](../../commands/autopush.md) | step 70 | repo only |
| `/overnight` | [commands/overnight.md](../../commands/overnight.md), guide: [overnight/README.md](overnight/README.md) | step 70 | repo only |
| plugin commands (`/commit`, `/code-review`, `/ecc:*`, `/hookify`, `/impeccable:*`, ...) | plugin cache | step 20 | yes |

## Install

```bash
cp commands/*.md ~/.claude/commands/      # or: bash scripts/install/70-commands.sh
```

## Verify

```bash
ls ~/.claude/commands
```
