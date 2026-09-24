#!/usr/bin/env bash
# OPTIONAL: the 101 agency agents in ./agents -> ~/.claude/agents. Not part of the default machine setup.
# See docs/agents-config/README.md.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

run mkdir -p "$HOME/.claude/agents"
for f in "$ROOT"/agents/*.md; do run cp "$f" "$HOME/.claude/agents/"; done
