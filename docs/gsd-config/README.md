# Get Shit Done (GSD)

Spec-driven workflow system (`/gsd:*`). Owns 173 files under `~/.claude`: `commands/gsd/*` (42),
`agents/gsd-*.md` (16, disabled on the reference machine -- see [agents-config](../agents-config/README.md)), `hooks/gsd-*.js` (3), `get-shit-done/` (workflows, templates, bin), plus the statusline
and two hooks in `settings.json`. Tracked by `~/.claude/gsd-file-manifest.json` -- never copy these by hand.

Reference version: [VERSION](VERSION). Latest at time of writing: 1.42.3.

## Install

```bash
npx -y get-shit-done-cc@latest --claude --global --portable-hooks     # or: bash scripts/install/40-gsd.sh
```

- `GSD_VERSION=1.26.0 bash scripts/install/40-gsd.sh` -- pin to the reference version.
- `GSD_FORCE_STATUSLINE=1` -- replace an existing statusline.
- `--portable-hooks` writes `$HOME`-relative hook paths, matching `docs/settings-config/settings.json`.

## Verify

```bash
cat ~/.claude/get-shit-done/VERSION; ls ~/.claude/commands/gsd | wc -l; ls ~/.claude/agents/gsd-* | wc -l
```

## Update / remove

```bash
npx -y get-shit-done-cc@latest --claude --global    # update (or /gsd:update inside Claude Code)
npx -y get-shit-done-cc@latest --uninstall          # remove every GSD file
```
