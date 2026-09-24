#!/usr/bin/env bash
# Claude Code CLI + system tools + npm globals. See docs/cli-config/README.md.
set -euo pipefail
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

command -v node >/dev/null || { echo "Node >= 22 required (https://github.com/nvm-sh/nvm). Install it, then re-run."; exit 1; }
command -v claude >/dev/null || run bash -c 'curl -fsSL https://claude.ai/install.sh | bash'
command -v brew >/dev/null && run brew install jq gh tmux ffmpeg
run npm install -g agent-browser intelephense typescript typescript-language-server prettier markdownlint-cli @alibaba-group/open-code-review
