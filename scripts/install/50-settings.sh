#!/usr/bin/env bash
# Merge docs/settings-config/settings.json into ~/.claude/settings.json (repo wins; arrays replaced).
# See docs/settings-config/README.md.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
command -v jq >/dev/null || { echo "jq is required"; exit 1; }

SRC="$ROOT/docs/settings-config/settings.json"
DST="$HOME/.claude/settings.json"
mkdir -p "$HOME/.claude"
[ -f "$DST" ] || echo '{}' > "$DST"

drop_hooks() { FILTER="$FILTER | .hooks |= map_values(map(select([.hooks[].command | contains(\"$1\")] | any | not)))"; }

FILTER='.[0] * .[1]'

# Drop hooks/statusline whose script is not on this machine (e.g. GSD renamed a file).
for p in $(jq -r '[.hooks[][].hooks[].command, .statusLine.command] | map(select(type == "string"))[]
            | capture("\\$HOME/(?<p>\\.claude/hooks/[^\" ]+)") | .p' "$SRC" | sort -u); do
  [ -e "$HOME/$p" ] && continue
  echo "WARN: $p not found; dropping hooks that use it" >&2
  drop_hooks "$p"
  FILTER="$FILTER | if (.statusLine.command // \"\" | contains(\"$p\")) then del(.statusLine) else . end"
done
FILTER="$FILTER | .hooks |= with_entries(select(.value | length > 0))"

if [ "${DRY_RUN:-0}" = 1 ]; then
  jq -s "$FILTER" "$DST" "$SRC"
else
  cp "$DST" "$DST.bak.$(date +%Y%m%d%H%M%S)"
  jq -s "$FILTER" "$DST" "$SRC" > "$DST.tmp" && mv "$DST.tmp" "$DST"
  echo "wrote $DST"
fi
