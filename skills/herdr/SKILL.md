---
name: herdr
description: Use when the user mentions Herdr, herdr-app, hc / herdr-core, or wants to change the Herdr window (spaces, tabs, panes, layouts, mods, settings, keybinds, themes) or start, read, message, or wait on terminals and agents running in Herdr.
---

# Herdr

Herdr ships its own agent manuals through its CLIs. They match the installed version, so read them instead of guessing. The binaries live in `~/.local/bin`, which may not be on PATH in agent shells: prefix commands with `export PATH="$HOME/.local/bin:$PATH";`.

1. Read the manual for the part you need, before acting:
   - `herdr-app --skill`: the window (spaces, tabs, panes, layouts, mods, settings.json, keys.json).
   - `hc --skill`: terminals and agents (run, read, send, wait, kill).
2. Inspect first: `herdr-app status` (layout, focus, errors), `herdr-app ls`, `herdr-app commands`.
3. Config lives in `~/.config/herdr-app` (its `AGENTS.md` is the full reference). Shipped layouts and mods are overwritten on every start: clone with `layout.clone` / `mod.clone` and edit the clone.
4. After editing a mod, run `herdr-app check <mod folder>`, then confirm `herdr-app status` shows `"errors": []`.

## Every change goes into the TMD layout

The person keeps ONE layout, `tmd`, holding all their Herdr changes. Never create another layout or a separately named mod, and never leave a change outside TMD.

- Repo: `~/Documents/herdr-tmd` (public, github.com/thiagomontezuma/herdr-tmd, topic `herdr-layout`, listed at herdr.dev/layouts/thiagomontezuma/herdr-tmd). It is a gallery-format layout folder: `layouts/tmd.json`, `mods/tmd-*`, `settings.json`, `RECIPE.md`, `README.md`, `preview.png`, `LICENSE` (Apache-2.0, Herdr's), `NOTICE`, `sync.sh`, `install.sh`.
- TMD today: theme `themes/tmd.json` (Darker Modern), `tmd-files` (VSCode-style explorer: editing, previews, Material icons) and `tmd-changes` (VSCode diff + code colors). Read the repo's `RECIPE.md` (its "Watch out" lists Herdr API traps, e.g. no `on_click` inside virtual list rows) before changing them.
- Real clicks and keys (end-to-end): compile `input.swift` (next to this file) with `swiftc -O input.swift -o input`, set `HERDR_PID=$(pgrep -x Herdr)`. Keys go to Herdr's process only (`postToPid`), so they never reach the app the person is using; clicks need Herdr active: `osascript -e 'tell application "Herdr" to activate'`, click, then reactivate the app that was frontmost. Coordinates: window position from System Events + screenshot px / 2. Never press keys while a person's agent terminal has focus (Esc interrupts it): work in a temporary space with a plain shell (`space.new {name, folder}`, `space.close {id, confirmed: true}` after), ask the person to leave Herdr alone first, and assert state with a temporary probe file the mod writes, not screenshots alone.
- Verify UI without clicks: Herdr can't click inside mods, so for panel logic add a temporary `selftest.js` driven by `cx.timer.every`, write results to scratch, screenshot with `herdr-app shot`, then delete it. Each mod file edit hot-reloads and restarts such a test.
- Structure or look: edit `~/.config/herdr-app/layouts/tmd.json` or `themes/tmd.json`. Panel code: clone the shipped mod as `tmd-<name>` (`mod.clone`), mark the change with a `// TMD:` comment, point `tmd.json`'s `content.mod` at it, and add it to `NOTICE`. Personal settings: `settings.json`. Keys or programs: also `cp` `keys.json` / `programs.json` into the repo once; `sync.sh` keeps them after that.
- After each change: `herdr-app check` each changed mod, `herdr-app status` shows `"errors": []`, then in the repo run `./sync.sh`, update `RECIPE.md` (Herdr's 6-section brief, from the real files) and `README.md`'s feature list, and commit + push (Conventional Commit, with the Co-Authored-By line).
- `preview.png`: only when the look changes. Never shoot the person's real window for it (their folders, clients and sessions show). Use a neutral demo folder in a temporary space, read the PNG before committing, then close the space and delete the folder. The Files/Changes panel can only be opened by a click, so ask the person to click it.
