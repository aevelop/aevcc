#!/usr/bin/env bash
# Cursor plugins (github.com/cursor/plugins) as local Claude Code plugins, plus cursor-team-kit's 2 rules in ~/.claude/rules.
# Upstream ships only Cursor manifests, so this builds Claude ones in ~/.claude/local-marketplace.
# Runs before 20-plugins so the "aevcc-local" marketplace exists. Re-run to update. See docs/plugins-config/README.md.
set -euo pipefail
run() { if [ "${DRY_RUN:-0}" = 1 ]; then echo "+ $*"; else "$@"; fi; }

PLUGINS="cursor-team-kit thermos"
MP="$HOME/.claude/local-marketplace"
RULES="$HOME/.claude/rules"

if [ "${DRY_RUN:-0}" = 1 ]; then
    echo "+ build $PLUGINS in $MP and rules in $RULES from cursor/plugins"
else
    TMP="$(mktemp -d)"
    trap 'rm -rf "$TMP"' EXIT
    git clone -q --depth 1 --filter=blob:none --sparse https://github.com/cursor/plugins "$TMP/src"
    git -C "$TMP/src" sparse-checkout set $PLUGINS
    SHA="$(git -C "$TMP/src" rev-parse --short HEAD)"
    mkdir -p "$MP/.claude-plugin" "$RULES"
    echo '[]' > "$TMP/entries.json"

    for p in $PLUGINS; do
        SRC="$TMP/src/$p"
        KIT="$MP/$p"
        # Upstream sha in the version records which commit is installed (the plugin is read live from $KIT).
        VERSION="$(jq -r .version "$SRC/.cursor-plugin/plugin.json")+$SHA"

        rm -rf "$KIT"
        mkdir -p "$KIT/.claude-plugin"
        cp -R "$SRC/skills" "$SRC/agents" "$SRC/LICENSE" "$SRC/README.md" "$KIT/"
        # Cursor-only agent frontmatter: "model: fast" -> haiku; is_background has no Claude Code equivalent.
        sed -i '' -e 's/^model: fast$/model: haiku/' -e '/^is_background:/d' "$KIT"/agents/*.md
        # Cursor's built-in subagent types -> Claude Code's; plugin agents are namespaced "<plugin>:<agent>".
        FILES=$(find "$KIT/skills" "$KIT/agents" -name '*.md')
        sed -i '' -e 's/subagent_type: "shell"/subagent_type: "general-purpose"/g' \
            -e 's/subagent_type: "explore"/subagent_type: "Explore"/g' $FILES
        for a in "$KIT"/agents/*.md; do
            n="$(basename "$a" .md)"
            sed -i '' "s/subagent_type: \"$n\"/subagent_type: \"$p:$n\"/g" $FILES
        done

        jq --arg v "$VERSION" '{name, version: $v, description, author, homepage, repository, license, keywords}' \
            "$SRC/.cursor-plugin/plugin.json" > "$KIT/.claude-plugin/plugin.json"
        jq --arg p "$p" --slurpfile m "$KIT/.claude-plugin/plugin.json" \
            '. + [{name: $p, source: "./\($p)", version: $m[0].version, description: $m[0].description}]' \
            "$TMP/entries.json" > "$TMP/entries.next" && mv "$TMP/entries.next" "$TMP/entries.json"
    done

    jq '{name: "aevcc-local", owner: {name: "aevcc"}, plugins: .}' "$TMP/entries.json" > "$MP/.claude-plugin/marketplace.json"

    # cursor-team-kit .mdc rules -> Claude Code rules: drop the Cursor frontmatter; scope the TypeScript rule to TS files.
    R="$TMP/src/cursor-team-kit/rules"
    awk 'f >= 2; /^---$/ { f++ }' "$R/no-inline-imports.mdc" > "$RULES/no-inline-imports.md"
    { printf -- '---\npaths:\n    - "**/*.{ts,tsx,mts,cts}"\n---\n'; awk 'f >= 2; /^---$/ { f++ }' "$R/typescript-exhaustive-switch.mdc"; } \
        > "$RULES/typescript-exhaustive-switch.md"

    claude plugin validate "$MP"
fi

claude plugin marketplace list 2>/dev/null | grep -q aevcc-local \
    && run claude plugin marketplace update aevcc-local \
    || run claude plugin marketplace add "$MP"
for p in $PLUGINS; do
    if claude plugin list 2>/dev/null | grep -q "$p@aevcc-local"; then
        run claude plugin update "$p@aevcc-local" --scope user
    else
        run claude plugin install "$p@aevcc-local" --scope user -y
    fi
done
