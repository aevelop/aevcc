# Agents

| Set | Location | Installed by |
| --- | -------- | ------------ |
| Plugin agents (`ecc:*`, `feature-dev:*`, `pr-review-toolkit:*`, `superpowers:code-reviewer`, `understand-anything:*`, `hookify:*`, `code-simplifier`) | plugin cache | step 20 |
| Agency agents (101) | [/agents](../../agents) = [msitarzewski-agency-agents](msitarzewski-agency-agents) (+ [GUIDELINES.md](msitarzewski-agency-agents/GUIDELINES.md)) | opt-in, step 80 |
| Legacy ECC-era agents (139) | [legacy/](legacy) | reference only |

The reference machine has `~/.claude/agents` empty; every active agent comes from plugins. (The 16 `gsd-*` agents
that used to be parked in `~/.claude/agents-disabled/` were deleted with GSD on 2026-10-02.)

## Install the agency agents (optional)

```bash
cp agents/*.md ~/.claude/agents/          # or: bash scripts/install/80-agents.sh  /  AEVCC_AGENTS=1 bash scripts/install/all.sh
```

Or as this repo's plugin: `/plugin marketplace add aevelop/aev-cc` then `/plugin install aevcc@aevcc`.

## Verify

```bash
ls ~/.claude/agents | wc -l       # 0 on the reference machine; 101 with the agency agents
```
