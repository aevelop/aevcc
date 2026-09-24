#!/usr/bin/env bash
# Run every install step in order. Each step is standalone: run one with `bash scripts/install/NN-name.sh`.
# DRY_RUN=1 prints commands instead of running them. AEVCC_AGENTS=1 also installs the 101 agency agents.
set -euo pipefail
DIR="$(cd "$(dirname "$0")" && pwd)"

for s in 00-cli 10-claude-md 20-plugins 30-skills 40-gsd 50-settings 60-mcp 70-commands; do
  echo "== $s"
  bash "$DIR/$s.sh"
done
[ "${AEVCC_AGENTS:-0}" = 1 ] && { echo "== 80-agents"; bash "$DIR/80-agents.sh"; }
echo "Done. Restart Claude Code."
