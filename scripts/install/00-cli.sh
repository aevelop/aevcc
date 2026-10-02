#!/usr/bin/env bash
# Claude Code CLI + system tools + npm globals. See docs/cli-config/README.md.
set -euo pipefail
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

command -v node >/dev/null || { echo "Node >= 22 required (https://github.com/nvm-sh/nvm). Install it, then re-run."; exit 1; }
command -v claude >/dev/null || run bash -c 'curl -fsSL https://claude.ai/install.sh | bash'
command -v brew >/dev/null && run brew install jq gh tmux ffmpeg
run npm install -g agent-browser intelephense typescript typescript-language-server prettier markdownlint-cli @alibaba-group/open-code-review
command -v uv >/dev/null || run bash -c 'curl -LsSf https://astral.sh/uv/install.sh | sh'
export PATH="$HOME/.local/bin:$PATH"
# serena MCP server (step 60 registers it). init writes ~/.serena/serena_config.yml; keep the dashboard from opening a tab per session.
run uv tool install -p 3.13 serena-agent
[ -f "$HOME/.serena/serena_config.yml" ] || run serena init
run sed -i.bak 's/^web_dashboard_open_on_launch: true/web_dashboard_open_on_launch: false/' "$HOME/.serena/serena_config.yml" && rm -f "$HOME/.serena/serena_config.yml.bak"
