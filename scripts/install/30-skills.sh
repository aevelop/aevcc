#!/usr/bin/env bash
# Skills via the `skills` CLI (docs/skills-config/skills.txt) + hand-made skills vendored in ./skills.
# See docs/skills-config/README.md.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

while read -r source skill; do
  [ -z "${source:-}" ] && continue
  run npx -y skills add "$source" --skill "$skill" -g -a claude-code -y || echo "FAILED $source/$skill"
done < "$ROOT/docs/skills-config/skills.txt"

run mkdir -p "$HOME/.claude/skills"
for d in "$ROOT"/skills/*/; do run cp -R "$d" "$HOME/.claude/skills/"; done

# notebooklm: plain git clone (not tracked by the skills CLI). Needs python3; the skill sets up its own venv.
[ -d "$HOME/.claude/skills/notebooklm" ] || \
  run git clone https://github.com/PleasePrompto/notebooklm-skill "$HOME/.claude/skills/notebooklm"
