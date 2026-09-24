#!/usr/bin/env bash
# Get Shit Done (commands/gsd, gsd-* agents, hooks, statusline). See docs/gsd-config/README.md.
# GSD_VERSION=1.26.0 to pin (captured version is in docs/gsd-config/VERSION). GSD_FORCE_STATUSLINE=1 to replace an existing statusline.
set -euo pipefail
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

run npx -y "get-shit-done-cc@${GSD_VERSION:-latest}" --claude --global --portable-hooks \
  ${GSD_FORCE_STATUSLINE:+--force-statusline}
