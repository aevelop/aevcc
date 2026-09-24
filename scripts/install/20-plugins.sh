#!/usr/bin/env bash
# Marketplaces + plugins from docs/plugins-config/*.txt. See docs/plugins-config/README.md.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

while read -r name repo; do
  [ -z "${name:-}" ] && continue
  run claude plugin marketplace add "$repo" || echo "skip marketplace $name (already added?)"
done < "$ROOT/docs/plugins-config/marketplaces.txt"

# Lines ending in "disabled" are installed, then turned off (matches the reference machine).
while read -r plugin version state; do
  [ -z "${plugin:-}" ] && continue
  run claude plugin install "$plugin" --scope user -y || echo "FAILED $plugin"
  if [ "${state:-}" = disabled ]; then run claude plugin disable "$plugin" --scope user || echo "FAILED disable $plugin"; fi
done < "$ROOT/docs/plugins-config/plugins.txt"
