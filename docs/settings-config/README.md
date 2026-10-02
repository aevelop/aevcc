# settings.json

Snapshot: [settings.json](settings.json) = `~/.claude/settings.json` with the home path replaced by `$HOME`.
Contains no machine ids (those live in `~/.claude.json`, which is never exported).

| Key | Value |
| --- | ----- |
| `model` | not set: Claude Code uses its default model (pick one per session with `/model`) |
| `modelSettings` | per-model effort, e.g. `claude-fable-5-1` -> `high` |
| `effortLevel` | `xhigh` |
| `permissions.defaultMode` | `auto` |
| `permissions.allow` | 130 patterns: git read/write, npm/bun/pnpm, python/uv, read-only shell, gh, build tools, ctx tools |
| `permissions.deny` | 24 patterns: sudo, `rm -rf /`, force push, hard reset, `.env`, secrets, `~/.ssh`, `~/.aws` |
| `hooks` | macOS notification, pixel-agents (see [hooks-config](../hooks-config/README.md)) |
| `statusLine` | not set (Claude Code default; GSD's statusline left with GSD on 2026-10-02; `/statusline` to add a custom one) |
| `enabledPlugins` | 40: 22 `true`, 18 `false` = installed but disabled (see [plugins-config](../plugins-config/README.md)) |
| `extraKnownMarketplaces` | 10 non-official marketplaces |
| `skillOverrides` | 44 skills set to `"off"` (see [skills-config](../skills-config/README.md)) |
| `autoMode` | not exported: its rules and environment notes are project-specific (repo names, secret variable names). Let Claude Code generate your own |

## Install

```bash
bash scripts/install/50-settings.sh      # backup, then deep-merge (repo wins, arrays replaced)
```

Manual: `cp docs/settings-config/settings.json ~/.claude/settings.json` (overwrites).

The script drops hooks whose script is missing on the machine
(and the statusline if its script is missing) and drops pixel-agents hooks unless `~/.pixel-agents` exists.
`DRY_RUN=1` prints the merged JSON.

## Verify

```bash
jq '{model, effortLevel, plugins: (.enabledPlugins|length), hooks: (.hooks|keys)}' ~/.claude/settings.json
```

## Not included

- `~/.claude/settings.local.json` -- per-machine overrides (MAMP php paths on the reference machine).
- `~/.claude.json` -- account, machine id, caches. Only its `mcpServers` is exported (see mcp-config).
- `~/.claude/keybindings.json` -- none on the reference machine.
