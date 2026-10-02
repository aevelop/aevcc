# Machine Setup Index

Everything installed on the reference machine, one folder per concern. Each folder has a README with
copy-paste commands and a matching script in `scripts/install/`. Run one step or all of them.

## Reproduce on a new machine

```bash
git clone https://github.com/aevelop/aev-cc.git aevcc && cd aevcc
export GITHUB_PERSONAL_ACCESS_TOKEN=... FIRECRAWL_API_KEY=... STITCH_X_GOOG_API_KEY=...   # optional, see mcp-config
export GEMINI_API_KEY=...                                                                # optional, watch plugin (plugins-config)
bash scripts/install/all.sh        # everything, in order
bash scripts/install/20-plugins.sh # or any single step
```

`DRY_RUN=1` prints the commands instead of running them.

| Step | Concern | Doc | Script |
| ---- | ------- | --- | ------ |
| 00 | Claude Code CLI, brew tools, npm globals, uv + serena-agent | [cli-config](cli-config/README.md) | `00-cli.sh` |
| 10 | Global `~/.claude/CLAUDE.md` | [CLAUDE.md-config](CLAUDE.md-config/README.md) | `10-claude-md.sh` |
| 20 | 15 marketplaces, 38 plugins (19 enabled, 19 installed-but-disabled) | [plugins-config](plugins-config/README.md) | `20-plugins.sh` |
| 30 | 50 `skills` CLI skills + 3 vendored + notebooklm | [skills-config](skills-config/README.md) | `30-skills.sh` |
| 40 | Get Shit Done (commands, agents, hooks, statusline) | [gsd-config](gsd-config/README.md) | `40-gsd.sh` |
| 50 | `settings.json` (model, effort, permissions, hooks) | [settings-config](settings-config/README.md) | `50-settings.sh` |
| 60 | 19 user-scope MCP servers | [mcp-config](mcp-config/README.md) | `60-mcp.sh` |
| 70 | Slash commands (`/nasa-code`, `/autopush`, `/overnight`) | [commands-config](commands-config/README.md) | `70-commands.sh` |
| 80 | Agents (GSD-owned, disabled on reference machine; agency agents opt-in) | [agents-config](agents-config/README.md) | `80-agents.sh` (opt-in) |
| -- | Hooks: where each one comes from | [hooks-config](hooks-config/README.md) | covered by 20, 40, 50 |

Order matters once: `40-gsd` before `50-settings` (the settings snapshot already contains GSD's hooks with
`$HOME` paths, so GSD's own edits are overwritten instead of duplicated). Everything else is independent.

## Refresh the snapshot from this machine

```bash
./scripts/export.sh          # shows a diff per changed file, then asks: [a]dditive / [r]eplace / [k]eep
git diff && git add -A && git commit -m "chore: refresh machine snapshot"
```

The export never overwrites the repo on its own. `a` adds and updates entries but never removes one (lists merge by
name, JSON merges recursively with arrays unioned); `r` takes the machine version; `k` (default) leaves the repo file.
Hand-written files (`CLAUDE.md`, vendored skills/commands) only offer `r`/`k`. `EXPORT_MODE=a|r|k` answers every
prompt at once; with no terminal and no `EXPORT_MODE`, everything is kept.

Exports are machine-agnostic: home path -> `$HOME`, secrets -> `${PLACEHOLDER}`. Only `mcpServers` is read from
`~/.claude.json` (machine id, account, caches never leave the machine). The script warns about anything in
`~/.claude/skills` it cannot trace to an installer.

## Not covered by scripts

- Login: run `claude` once; `gh auth login`; OAuth MCPs via `/mcp`; claude.ai connectors (Gmail, Drive, Calendar) at claude.ai.
- [Pixel Agents](https://marketplace.visualstudio.com/items?itemName=pablodelucca.pixel-agents) VS Code extension (registers its own hooks).
- Claude in Chrome browser extension.
- `watch` plugin key: `~/.config/watch/.env` with `GEMINI_API_KEY=...` if `GEMINI_API_KEY` was not exported for step 20.
