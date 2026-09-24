#!/usr/bin/env bash
# Global ~/.claude/CLAUDE.md. See docs/CLAUDE.md-config/README.md.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

DST="$HOME/.claude/CLAUDE.md"
run mkdir -p "$HOME/.claude"
[ -f "$DST" ] && run cp "$DST" "$DST.bak.$(date +%Y%m%d%H%M%S)"
run cp "$ROOT/docs/CLAUDE.md-config/CLAUDE.md" "$DST"
