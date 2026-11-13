# Aevelop Claude Code Configuration

One repo that rebuilds a full Claude Code setup on any machine: CLI tools, global `CLAUDE.md`, plugins, skills,
settings, MCP servers, slash commands and helper scripts.

Needs macOS, Node 22+ and `git`. Every install script can be previewed with `DRY_RUN=1`.

## New machine

```bash
git clone https://github.com/aevelop/aev-cc.git aevcc && cd aevcc
bash scripts/install/all.sh
```

## Machine that already has a Claude Code setup

`KEEP_MINE=1` only adds: your `CLAUDE.md`, settings, permissions, hooks and enabled plugins are kept.

```bash
# 1. Back up
cp -R ~/.claude ~/.claude.backup-$(date +%Y%m%d)
cp ~/.claude.json ~/.claude.json.backup-$(date +%Y%m%d)

# 2. Get the repo
git clone https://github.com/aevelop/aev-cc.git aevcc && cd aevcc

# 3. Delete the lines you do not want from these lists (optional)
#    docs/plugins-config/plugins.txt   docs/skills-config/skills.txt   docs/mcp-config/mcp-servers.json

# 4. Preview, then install
KEEP_MINE=1 DRY_RUN=1 bash scripts/install/all.sh
KEEP_MINE=1 bash scripts/install/all.sh
```

Details, what can still be replaced, and how to undo: [docs/existing-setup.md](docs/existing-setup.md).

## Did everything install?

`all.sh` ends with a check and you can run it again any time. It prints one line per missing item with the step
that fixes it, or `OK`.

```bash
bash scripts/install/90-verify.sh      # add KEEP_MINE=1 if you installed with it
```

```text
MISSING plugin ponytail@ponytail          fix: 20-plugins.sh
```

Then restart Claude Code.

## What gets installed

Each step runs alone: `bash scripts/install/20-plugins.sh`. Full reference per step: [docs/README.md](docs/README.md).

| Step | Installs |
| ---- | -------- |
| `00-cli` | Claude Code CLI, brew tools, npm globals, uv |
| `10-claude-md` | Global `~/.claude/CLAUDE.md` |
| `15-cursor-plugins` | Two Cursor plugins as local plugins, plus two rules |
| `20-plugins` | 19 marketplaces, 45 plugins |
| `30-skills` | 61 skills from the `skills` CLI, 4 from this repo, notebooklm |
| `50-settings` | `settings.json`: model, permissions, hooks |
| `60-mcp` | 22 MCP servers |
| `70-commands` | `/nasa-code`, `/autopush`, `/overnight` |
| `75-bin` | `~/.claude/bin/ollama-cloud` |
| `80-agents` | Agency agents, only with `AEVCC_AGENTS=1` |
| `90-verify` | The check above |

Not scripted (logins, API keys, Keychain, desktop apps): see
[Not covered by scripts](docs/README.md#not-covered-by-scripts) and [MCP keys](docs/mcp-config/README.md).

## Keep the repo in sync with your machine

```bash
./scripts/export.sh      # shows a diff per file, then asks: add / replace / keep
```

Home paths become `$HOME`; secrets in MCP env vars and headers become `${PLACEHOLDERS}`. Read `git diff` before committing.

## License

MIT
