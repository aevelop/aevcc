#!/usr/bin/env bash
# Register user-scope MCP servers from docs/mcp-config/mcp-servers.json via `claude mcp add`.
# ${PLACEHOLDERS} are filled from your environment; unset ones are passed empty with a warning.
# See docs/mcp-config/README.md.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
command -v jq >/dev/null || { echo "jq is required"; exit 1; }
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

SRC="$ROOT/docs/mcp-config/mcp-servers.json"

expand() {
  local v="$1" n
  v="${v//\$HOME/$HOME}"
  while [[ "$v" =~ \$\{([A-Z0-9_]+)\} ]]; do
    n="${BASH_REMATCH[1]}"
    [ -n "${!n:-}" ] || echo "WARN: $n is unset" >&2
    v="${v/\$\{$n\}/${!n:-}}"
  done
  printf '%s' "$v"
}

jq -r '.mcpServers | keys[]' "$SRC" | while read -r name; do
  s=$(jq -c --arg n "$name" '.mcpServers[$n]' "$SRC")
  type=$(jq -r '.type // "stdio"' <<<"$s")
  # -e and -H are variadic: they must come after <name>/<url> and (for stdio) before "--".
  cmd=(claude mcp add --scope user --transport "$type" "$name")
  if [ "$type" = stdio ]; then
    while IFS='=' read -r k v; do [ -n "$k" ] && cmd+=(-e "$k=$(expand "$v")"); done \
      < <(jq -r '(.env // {}) | to_entries[] | "\(.key)=\(.value)"' <<<"$s")
    cmd+=(-- "$(jq -r .command <<<"$s")")
    while read -r a; do cmd+=("$(expand "$a")"); done < <(jq -r '.args[]?' <<<"$s")
  else
    cmd+=("$(jq -r .url <<<"$s")")
    while IFS='=' read -r k v; do [ -n "$k" ] && cmd+=(-H "$k: $(expand "$v")"); done \
      < <(jq -r '(.headers // {}) | to_entries[] | "\(.key)=\(.value)"' <<<"$s")
  fi
  run "${cmd[@]}" || echo "FAILED $name (already registered?)"
done
