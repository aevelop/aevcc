#!/usr/bin/env bash
# Snapshot THIS machine's Claude Code setup into the repo.
# Output is machine-agnostic: "$HOME" replaces the literal home path, secrets become ${PLACEHOLDERS}.
# Nothing is written directly: every file is staged, diffed against the repo, and you choose per file:
#   [a]dditive merge (default for lists/JSON: add + update, never remove)  [r]eplace with machine  [k]eep repo
# Prose files (CLAUDE.md, vendored skills/commands) only offer [r]/[k].
# EXPORT_MODE=a|r|k answers every prompt. Without a terminal and without EXPORT_MODE, repo files are kept.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CL="$HOME/.claude"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

# Hand-made (or upstream-less) items that live only in ~/.claude. Add new ones here.
CUSTOM_SKILLS=(ask-me-questions-for-context critical-thinking-partner brand-guidelines)
CUSTOM_COMMANDS=(nasa-code.md)
# learned: empty dir from ecc | synced: claude.ai skill sync | notebooklm: git clone, see docs/skills-config
IGNORE_SKILLS=(learned synced notebooklm)
# Skills installed by the `skills` CLI before it kept a lock file ("source skill"). Add here if export warns.
EXTRA_SKILLS=(
  "vercel-labs/agent-browser agent-browser"
  "vercel-labs/deepsec deepsec"
  "anthropics/skills canvas-design"
  "anthropics/skills skill-creator"
  "coreyhaines31/marketingskills paid-ads"
)

command -v jq >/dev/null || { echo "jq is required"; exit 1; }

# Replace the literal home path with "$HOME" in every JSON string and object key.
dehome() {
  jq --arg h "$HOME" 'def dh: split($h) | join("$HOME");
    walk(if type == "object" then with_entries(.key |= dh) elif type == "string" then dh else . end)'
}

# Secrets -> placeholders. env values become ${KEY}; header values become ${SERVER_HEADER}.
REDACT='
  def ph($s; $k): "${" + (($s + "_" + $k) | ascii_upcase | gsub("[^A-Z0-9]"; "_")) + "}";
  to_entries | map(.key as $s | .value |= (
      (if .env     then .env     |= with_entries(.value = "${" + .key + "}") else . end)
    | (if .headers then .headers |= with_entries(.value = ph($s; .key))     else . end)
  )) | from_entries'

# --- merge strategies: $1 = repo file, $2 = machine file, stdout = merged -------------------------------

# Line lists keyed by field 1 ("key" mode) or by the whole line ("line" mode). Trailing @<digits...> is
# ignored in the key so version bumps update in place. Repo order is kept; new machine lines are appended.
merge_lines() {
  awk -v mode="$3" '
    function k(l,  f) { if (mode == "line") return l; split(l, f, " "); sub(/@[0-9][^@]*$/, "", f[1]); return f[1] }
    NR == FNR { m[k($0)] = $0; order[++n] = k($0); next }
    { key = k($0); print (key in m ? m[key] : $0); seen[key] = 1 }
    END { for (i = 1; i <= n; i++) if (!(order[i] in seen)) { print m[order[i]]; seen[order[i]] = 1 } }
  ' "$2" "$1"
}

# JSON deep merge: machine wins on scalars, objects merge recursively, arrays are unioned (repo items kept).
merge_json() {
  jq -s 'def m($a; $b):
      if ($a|type) == "object" and ($b|type) == "object" then
        reduce ($b|keys_unsorted[]) as $k ($a; .[$k] = (if $a|has($k) then m($a[$k]; $b[$k]) else $b[$k] end))
      elif ($a|type) == "array" and ($b|type) == "array" then $a + [$b[] | select(. as $x | $a | index([$x]) | not)]
      else $b end;
    m(.[0]; .[1])' "$1" "$2"
}

# --- review gate ----------------------------------------------------------------------------------------
# review <repo-relative path> <lines|lines-whole|json|prose>
review() {
  local rel="$1" kind="$2" new="$STAGE/$1" old="$ROOT/$1" ans opts="a/r/K"
  [ -e "$new" ] || return 0
  if [ ! -e "$old" ]; then
    mkdir -p "$(dirname "$old")"; cp -R "$new" "$old"; echo "added    $rel"; return
  fi
  diff -rq "$old" "$new" >/dev/null && return 0
  [ "$kind" = prose ] && opts="r/K"

  echo; echo "=== $rel  ('-' = only in repo, '+' = only on this machine)"
  diff -ru "$old" "$new" | tail -n +3 || true
  ans="${EXPORT_MODE:-}"
  if [ -z "$ans" ] && [ -t 0 ]; then read -r -p "$rel: [a]dditive / [r]eplace / [k]eep? ($opts) " ans; fi
  ans="${ans:-k}"
  [ "$kind" = prose ] && [ "$ans" = a ] && ans=k

  case "$ans" in
    a)
      case "$kind" in
        lines)       merge_lines "$old" "$new" key  > "$STAGE/.m" ;;
        lines-whole) merge_lines "$old" "$new" line > "$STAGE/.m" ;;
        json)        merge_json  "$old" "$new"      > "$STAGE/.m" ;;
      esac
      mv "$STAGE/.m" "$old"; echo "merged   $rel" ;;
    r) rm -rf "$old"; cp -R "$new" "$old"; echo "replaced $rel" ;;
    *) echo "kept     $rel" ;;
  esac
}

# --- produce everything into $STAGE (same layout as the repo) ------------------------------------------
D="$STAGE/docs"
mkdir -p "$D"/{settings-config,CLAUDE.md-config,plugins-config,skills-config,gsd-config,mcp-config,cli-config} \
         "$STAGE/skills" "$STAGE/commands"

# 1. settings.json. autoMode is dropped: its rules and notes describe private projects, repos and secret names.
dehome < "$CL/settings.json" | jq 'del(.autoMode)' > "$D/settings-config/settings.json"

# 2. global CLAUDE.md (+ the plugin-injected home-level one, for reference)
cp "$CL/CLAUDE.md" "$D/CLAUDE.md-config/CLAUDE.md"
[ -f "$HOME/CLAUDE.md" ] && cp "$HOME/CLAUDE.md" "$D/CLAUDE.md-config/home-CLAUDE.md"

# 3. marketplaces + plugins (version installed here; "disabled" when installed but turned off)
jq -r 'to_entries[] | "\(.key) \(.value.source.repo // .value.source.url // .value.source.path // "?")"' \
  "$CL/plugins/known_marketplaces.json" | sort > "$D/plugins-config/marketplaces.txt"
jq -r --slurpfile inst "$CL/plugins/installed_plugins.json" '
  .enabledPlugins | to_entries[] | .key as $k
  | "\($k) \($inst[0].plugins[$k][0].version // "latest" | if . == "unknown" then "latest" else . end)"
    + (if .value then "" else " disabled" end)' \
  "$CL/settings.json" > "$D/plugins-config/plugins.txt"

# 4. skills installed by the `skills` CLI (source repo + skill name)
{ jq -r '.skills | to_entries[] | "\(.value.source) \(.key)"' "$HOME/.agents/.skill-lock.json"
  printf '%s\n' "${EXTRA_SKILLS[@]}"; } | sort -u > "$D/skills-config/skills.txt"
for d in "$HOME"/.agents/skills/*/; do
  n=$(basename "$d")
  grep -q " $n\$" "$D/skills-config/skills.txt" && continue
  printf '%s\n' "${CUSTOM_SKILLS[@]}" | grep -qx "$n" && continue
  echo "WARN: ~/.agents/skills/$n has no source (add to EXTRA_SKILLS or CUSTOM_SKILLS)"
done

# 5. hand-made skills/commands (-L follows symlinks into ~/.agents/skills)
for s in "${CUSTOM_SKILLS[@]}"; do cp -RL "$CL/skills/$s" "$STAGE/skills/$s"; done
for c in "${CUSTOM_COMMANDS[@]}"; do cp "$CL/commands/$c" "$STAGE/commands/$c"; done
for d in "$CL"/skills/*/; do
  n=$(basename "$d")
  [ -L "${d%/}" ] && continue
  grep -q " $n\$" "$D/skills-config/skills.txt" && continue
  printf '%s\n' "${CUSTOM_SKILLS[@]}" "${IGNORE_SKILLS[@]}" | grep -qx "$n" && continue
  echo "WARN: ~/.claude/skills/$n is not tracked (add to CUSTOM_SKILLS or document its installer)"
done

# 6. GSD version
cp "$CL/get-shit-done/VERSION" "$D/gsd-config/VERSION"

# 7. MCP servers: user scope + project scope. Only .mcpServers is read from ~/.claude.json.
jq ".mcpServers // {} | $REDACT | {mcpServers: .}" "$HOME/.claude.json" | dehome \
  > "$D/mcp-config/mcp-servers.json"
jq ".projects // {} | to_entries
    | map(select((.value.mcpServers // {}) | length > 0) | {key, value: (.value.mcpServers | $REDACT)})
    | from_entries" "$HOME/.claude.json" | dehome > "$D/mcp-config/mcp-servers-project.json"

# 8. CLI + global tool versions
{
  echo "claude $(claude --version 2>/dev/null | awk '{print $1}')"
  echo "node $(node -v 2>/dev/null || echo -)"
  echo "bun $(bun -v 2>/dev/null || echo -)"
  echo "npm-global:"
  npm ls -g --depth=0 2>/dev/null | tail -n +2 | sed -E 's/^[^@A-Za-z]*/  /' | grep -v '^ *$'
} > "$D/cli-config/versions.txt"

# --- review each staged file against the repo -----------------------------------------------------------
review docs/settings-config/settings.json      json
review docs/CLAUDE.md-config/CLAUDE.md         prose
review docs/CLAUDE.md-config/home-CLAUDE.md    prose
review docs/plugins-config/marketplaces.txt    lines
review docs/plugins-config/plugins.txt         lines
review docs/skills-config/skills.txt           lines-whole
review docs/gsd-config/VERSION                 prose
review docs/mcp-config/mcp-servers.json        json
review docs/mcp-config/mcp-servers-project.json json
review docs/cli-config/versions.txt            lines
for s in "${CUSTOM_SKILLS[@]}";   do review "skills/$s"   prose; done
for c in "${CUSTOM_COMMANDS[@]}"; do review "commands/$c" prose; done

echo; echo "Export done. Review with: git diff"
