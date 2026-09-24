#!/usr/bin/env bash
# Repo slash commands (./commands/*.md) -> ~/.claude/commands. See docs/commands-config/README.md.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

run mkdir -p "$HOME/.claude/commands"
for f in "$ROOT"/commands/*.md; do run cp "$f" "$HOME/.claude/commands/"; done
