# Agents

| Set | Location | Installed by |
| --- | -------- | ------------ |
| `gsd-*` (16) | `~/.claude/agents/gsd-*.md` (disabled on the reference machine: moved to `~/.claude/agents-disabled/`) | GSD, step 40. Never copy by hand. |
| Plugin agents (`ecc:*`, `feature-dev:*`, `pr-review-toolkit:*`, `superpowers:code-reviewer`, `understand-anything:*`, `hookify:*`, `code-simplifier`) | plugin cache | step 20 |
| Agency agents (101) | [/agents](../../agents) = [msitarzewski-agency-agents](msitarzewski-agency-agents) (+ [GUIDELINES.md](msitarzewski-agency-agents/GUIDELINES.md)) | opt-in, step 80 |
| Legacy ECC-era agents (139) | [legacy/](legacy) | reference only |

The reference machine has `~/.claude/agents` empty: the `gsd-*` set was moved to `~/.claude/agents-disabled/`
(Claude Code only loads `~/.claude/agents`), and every active agent comes from plugins. To match it after step 40:

```bash
mkdir -p ~/.claude/agents-disabled && mv ~/.claude/agents/gsd-*.md ~/.claude/agents-disabled/   # undo: mv back
```

GSD's `/gsd:*` commands that spawn these agents will not find them while disabled.

## Install the agency agents (optional)

```bash
cp agents/*.md ~/.claude/agents/          # or: bash scripts/install/80-agents.sh  /  AEVCC_AGENTS=1 bash scripts/install/all.sh
```

Or as this repo's plugin: `/plugin marketplace add aevelop/aev-cc` then `/plugin install aevcc@aevcc`.

## Verify

```bash
ls ~/.claude/agents | wc -l       # 0 on the reference machine; 16 with GSD agents enabled; 117 with agency agents too
```
