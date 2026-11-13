#!/usr/bin/env bash
# Check this machine against the repo lists. One "MISSING" line per gap, each with the step that fixes it.
# Exit 1 if anything is missing. Read-only; honours KEEP_MINE=1 and whatever you deleted from the lists.
set -uo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CL="$HOME/.claude"
export PATH="$HOME/.local/bin:$PATH"
n=0
miss() { printf 'MISSING %-58s fix: %s\n' "$1" "$2"; n=$((n + 1)); }
has() { jq -e --arg k "$2" "$1 | has(\$k)" "$3" >/dev/null 2>&1; }

for t in claude jq gh tmux ffmpeg uv agent-browser intelephense tsc typescript-language-server prettier markdownlint ocr; do
  command -v "$t" >/dev/null || miss "tool $t" "00-cli.sh"
done

[ -f "$CL/CLAUDE.md" ] || miss "~/.claude/CLAUDE.md" "10-claude-md.sh"
for r in no-inline-imports typescript-exhaustive-switch; do
  [ -f "$CL/rules/$r.md" ] || miss "rule $r" "15-cursor-plugins.sh"
done

while read -r name _; do
  [ -z "${name:-}" ] && continue
  has . "$name" "$CL/plugins/known_marketplaces.json" || miss "marketplace $name" "20-plugins.sh (15-cursor-plugins.sh for aevcc-local)"
done < "$ROOT/docs/plugins-config/marketplaces.txt"
while read -r plugin _ state; do
  [ -z "${plugin:-}" ] && continue
  [ "${KEEP_MINE:-0}" = 1 ] && [ "${state:-}" = disabled ] && continue
  has .plugins "$plugin" "$CL/plugins/installed_plugins.json" || miss "plugin $plugin" "20-plugins.sh"
done < "$ROOT/docs/plugins-config/plugins.txt"

while read -r _ skill; do
  [ -z "${skill:-}" ] && continue
  [ -d "$CL/skills/$skill" ] || [ -d "$HOME/.agents/skills/$skill" ] || miss "skill $skill" "30-skills.sh"
done < "$ROOT/docs/skills-config/skills.txt"
for d in "$ROOT"/skills/*/ "$CL/skills/notebooklm/"; do
  [ -d "$CL/skills/$(basename "$d")" ] || miss "skill $(basename "$d")" "30-skills.sh"
done

[ -f "$CL/settings.json" ] || miss "~/.claude/settings.json" "50-settings.sh"
for s in $(jq -r '.mcpServers | keys[]' "$ROOT/docs/mcp-config/mcp-servers.json"); do
  has .mcpServers "$s" "$HOME/.claude.json" || miss "MCP server $s" "60-mcp.sh"
done
for f in "$ROOT"/commands/*.md; do
  [ -f "$CL/commands/$(basename "$f")" ] || miss "command /$(basename "$f" .md)" "70-commands.sh"
done
for f in "$ROOT"/bin/*; do
  [ -x "$CL/bin/$(basename "$f")" ] || miss "~/.claude/bin/$(basename "$f")" "75-bin.sh"
done
if command -v security >/dev/null; then
  security find-generic-password -s ollama-cloud-api-key >/dev/null 2>&1 \
    || miss "Keychain item ollama-cloud-api-key" "docs/bin-config/README.md"
fi

if [ "$n" = 0 ]; then echo "OK: everything in the repo lists is installed."; exit 0; fi
echo "$n missing. Run the step on each line (bash scripts/install/<step>), then this script again."
exit 1
