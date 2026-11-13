# Hooks

Nothing to install separately -- every hook arrives with another step. This maps each one to its owner.

## In `~/.claude/settings.json` (step 50)

| Event | Command | Owner | Needs |
| ----- | ------- | ----- | ----- |
| Notification | `osascript -e 'display notification ...'` | hand-added | macOS |
| SessionStart | `"$HOME/.claude/hooks/context-mode-cache-heal.mjs"` | context-mode (auto-deployed) | the script, which context-mode writes on first run; `50-settings.sh` drops the hook while it is missing. Re-links a missing plugin cache dir; it does not repair a half-populated one (reinstall the plugin) |
| SessionStart, UserPromptSubmit, PreToolUse, PermissionRequest, PostToolUse, PostToolUseFailure, Notification, Stop, StopFailure, SubagentStart, SubagentStop, SessionEnd | `/bin/zsh '<home>/.claude/hooks/claude-monitor-report.zsh'` (absolute path, written by the app) (shell form on purpose: exec form is unsafe on Claude Code versions without `args`; `async: true`; posts over the Unix socket `~/.claude/claude-monitor/monitor.sock` in a 0700 folder) | Claude Monitor app (added 2026-11-06) | the app (`~/Documents/claude-monitor`, local git repo on `main`, no remote yet; built with `npm run package` to `dist/Claude-Monitor-macOS.zip`). The app writes the script and these entries itself on first launch (consent sheet, settings.json backup) and keeps the script in sync on every launch; menu has Connect/Disconnect. Clicking a VS Code card also installs the `claude-monitor.claude-monitor-helper` VS Code extension (with consent; Disconnect removes it). Needs only zsh, ps, curl. Without the app running the hook fails silently in the background and never blocks Claude |

Standalone snippet for the notification hook:

```json
{ "hooks": { "Notification": [ { "matcher": "", "hooks": [ { "type": "command",
  "command": "osascript -e 'display notification \"Claude Code needs your attention\" with title \"Claude Code\"'" } ] } ] } }
```

## From plugins (step 20, nothing to configure)

| Plugin | Events | Does |
| ------ | ------ | ---- |
| context-mode | PreToolUse, PostToolUse, PreCompact, UserPromptSubmit, SessionStart, Stop | blocks curl/wget/WebFetch, routes large output to sandbox, injects routing block into CLAUDE.md, captures session history. Never pin copies of these in `settings.json`: the paths go stale on the next plugin update |
| impeccable | SessionStart, PostToolUse (Edit/Write), Stop | runs the impeccable engine binary: design-detector reminders after UI file edits, a "design deep pass" at Stop; never blocks. `/impeccable hooks off` per project |
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
