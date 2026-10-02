# Hooks

Nothing to install separately -- every hook arrives with another step. This maps each one to its owner.

## In `~/.claude/settings.json` (step 50)

| Event | Command | Owner | Needs |
| ----- | ------- | ----- | ----- |
| Notification | `osascript -e 'display notification ...'` | hand-added | macOS |
| 12 events: Notification, SessionStart, PostToolUse, SessionEnd, Stop, PermissionRequest, PreToolUse, PostToolUseFailure, SubagentStart, SubagentStop, TeammateIdle, TaskCompleted | `node "$HOME/.pixel-agents/hooks/claude-hook.js"` | Pixel Agents VS Code extension | `~/.pixel-agents` -- the extension registers these itself; `50-settings.sh` drops them when the dir is absent |

Standalone snippet for the notification hook:

```json
{ "hooks": { "Notification": [ { "matcher": "", "hooks": [ { "type": "command",
  "command": "osascript -e 'display notification \"Claude Code needs your attention\" with title \"Claude Code\"'" } ] } ] } }
```

## From plugins (step 20, nothing to configure)

| Plugin | Events | Does |
| ------ | ------ | ---- |
| context-mode | PreToolUse, PostToolUse, PreCompact, UserPromptSubmit, SessionStart | blocks curl/wget/WebFetch, routes large output to sandbox, injects routing block into CLAUDE.md |
| karpathy-automatic-claude-md | SessionStart | appends Behavioral Guidelines block to CLAUDE.md |
| ecc | PreToolUse, PostToolUse, PreCompact, SessionStart, SessionEnd, Stop | tmux reminders, block dev servers outside tmux, block non-README `.md` writes, git push reminder, prettier + tsc after edits, console.log checks, session persistence |
| security-guidance | PostToolUse, SessionStart, Stop, UserPromptSubmit | security warnings on Edit/Write |
| hookify | PreToolUse, PostToolUse, Stop, UserPromptSubmit | runs user rules from `.claude/hookify.*.local.md` |
| understand-anything | PostToolUse, SessionStart | knowledge-graph bookkeeping |
| superpowers | SessionStart | skill system bootstrap |
| explanatory-output-style | SessionStart | output style |
| double-shot-latte | Stop | judges whether Claude stopped prematurely and continues |

Definitions: `~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/hooks/hooks.json`.

## Not real hooks

`~/.claude.json` has a top-level `"hooks"` key holding descriptive strings (`"prettier --write"`, `"tmux reminder"`).
Claude Code ignores it; leftover notes, not exported.
