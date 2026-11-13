#!/usr/bin/env bash
# Marketplaces + plugins from docs/plugins-config/*.txt. See docs/plugins-config/README.md.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

while read -r name repo; do
  [ -z "${name:-}" ] && continue
  run claude plugin marketplace add "$repo" || echo "skip marketplace $name (already added?)"
done < "$ROOT/docs/plugins-config/marketplaces.txt"

# chrome-devtools-mcp 1.13.0 ships a `commands` array of objects that Claude Code rejects; drop it so the
# install below passes. Remove this block once upstream fixes the manifest (see docs/plugins-config Notes).
CDT="$HOME/.claude/plugins/marketplaces/chrome-devtools-plugins/.claude-plugin/plugin.json"
if [ -f "$CDT" ] && jq -e '.commands' "$CDT" >/dev/null; then
  if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ patch $CDT (del .commands)"; else
    jq 'del(.commands)' "$CDT" > "$CDT.tmp" && mv "$CDT.tmp" "$CDT"
  fi
fi

# Lines ending in "disabled" are installed, then turned off (matches the reference machine).
while read -r plugin version state; do
  [ -z "${plugin:-}" ] && continue
  run claude plugin install "$plugin" --scope user -y || echo "FAILED $plugin"
  if [ "${state:-}" = disabled ]; then run claude plugin disable "$plugin" --scope user || echo "FAILED disable $plugin"; fi
done < "$ROOT/docs/plugins-config/plugins.txt"

# watch@claude-video reads its Gemini key from ~/.config/watch/.env, never from the shell.
if [ -n "${GEMINI_API_KEY:-}" ]; then
  if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ write ~/.config/watch/.env"; else
    mkdir -p "$HOME/.config/watch"
    printf 'GEMINI_API_KEY=%s\n' "$GEMINI_API_KEY" > "$HOME/.config/watch/.env"
    chmod 600 "$HOME/.config/watch/.env"
  fi
else
  echo "note: GEMINI_API_KEY not set; put it in ~/.config/watch/.env for the watch plugin (see docs/plugins-config)"
fi
