# Already have Claude Code set up? Add aevcc without losing yours

`all.sh` reproduces the reference machine and overwrites things. On a machine that already has a setup, use
`KEEP_MINE=1`: it only adds. Five steps.

## 1. Back up

```bash
cp -R ~/.claude ~/.claude.backup-$(date +%Y%m%d)
cp ~/.claude.json ~/.claude.json.backup-$(date +%Y%m%d)
```

## 2. Get the repo

```bash
git clone https://github.com/aevelop/aev-cc.git aevcc && cd aevcc
```

## 3. Remove what you do not want

Each file is a plain list. Delete lines (or JSON entries) you do not want before installing.

| File | Delete |
| ---- | ------ |
| `docs/plugins-config/plugins.txt` | plugins you do not want |
| `docs/skills-config/skills.txt` | skills you do not want |
| `docs/mcp-config/mcp-servers.json` | `filesystem`, `obsidian`, `design-library`, `supabase`, `figcraft` (paths and ids from the reference machine), plus any server you do not want |

API keys for the MCP servers you keep: see [mcp-config](mcp-config/README.md).

## 4. Preview, then install

```bash
KEEP_MINE=1 DRY_RUN=1 bash scripts/install/all.sh    # prints every command, changes nothing
KEEP_MINE=1 bash scripts/install/all.sh              # installs
```

One step only: `KEEP_MINE=1 bash scripts/install/20-plugins.sh` (any `NN-name.sh`).

What `KEEP_MINE=1` does:

| Step | With `KEEP_MINE=1` |
| ---- | ------------------ |
| 10 `CLAUDE.md` | your file is kept untouched |
| 20 plugins | installs the enabled plugins only; never disables one of yours |
| 50 `settings.json` | your values win; permissions and hooks get the repo entries added; no skill is hidden; plugins are left to step 20 |
| 60 MCP servers | (always) a server name you already have is skipped |

Still replaced when the name is the same, in every mode:

| Step | Files |
| ---- | ----- |
| 15 | `~/.claude/rules/no-inline-imports.md`, `typescript-exhaustive-switch.md` |
| 30 | a skill with the same name as one in `skills.txt` or [`/skills`](../skills) |
| 70 | `~/.claude/commands/nasa-code.md`, `autopush.md`, `overnight.md` |
| 75 | `~/.claude/bin/ollama-cloud` |

## 5. Optional: take parts of the global CLAUDE.md

Step 10 kept your file. Open [CLAUDE.md-config/CLAUDE.md](CLAUDE.md-config/CLAUDE.md) and paste the sections you
want into `~/.claude/CLAUDE.md`. Restart Claude Code.

## Undo

```bash
rm -rf ~/.claude && mv ~/.claude.backup-<date> ~/.claude
mv ~/.claude.json.backup-<date> ~/.claude.json
```

One item only: `claude plugin uninstall <plugin>@<marketplace>`, `claude mcp remove -s user <name>`,
`rm -rf ~/.claude/skills/<name>`. Step 50 also leaves `~/.claude/settings.json.bak.<timestamp>`.
