#!/usr/bin/env bash
# Repo helper scripts (./bin/*) -> ~/.claude/bin. See docs/bin-config/README.md.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }
run mkdir -p "$HOME/.claude/bin"
for f in "$ROOT"/bin/*; do run install -m 700 "$f" "$HOME/.claude/bin/"; done
