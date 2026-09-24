**Aevelop Claude Code Configuration**

Production-ready agents, skills, hooks, commands, rules, plugins, and MCP configurations.

---

## Reproduce the full machine setup

Everything installed on the reference machine (CLI, plugins, skills, GSD, settings, MCP servers, commands) is
documented per concern in [docs/README.md](docs/README.md), each with its own install script:

```bash
git clone https://github.com/aevelop/aev-cc.git aevcc && cd aevcc
bash scripts/install/all.sh          # everything, or one step: bash scripts/install/20-plugins.sh
./scripts/export.sh                  # refresh the snapshot from the current machine
```

---

## 🚀 Quick Start

Get up and running in under 2 minutes:

### Step 1: Install the Plugin

```bash
# Add marketplace
/plugin marketplace add aevelop/aev-cc

# Install plugin
/plugin install aevcc@aevcc
```

### Step 2: Install Rules (Required)
> ⚠️ **Important:** Claude Code plugins cannot distribute `rules` automatically. Install them manually:

```bash
# Clone the repo first
git clone https://github.com/aevelop/aev-cc.git

# Copy rules (applies to all projects)
cp -r aevcc/rules/* ~/.claude/rules/

# # With Installer
# cd aevcc

# # Recommended: use the installer (handles common + language rules safely)
# ./install.sh typescript    # or python or golang
# # You can pass multiple languages:
# # ./install.sh typescript python golang
# # or target cursor:
# # ./install.sh --target cursor typescript

# # Manually
# # Install common rules (required)
# cp -r aevcc/rules/common/* ~/.claude/rules/

# # Install language-specific rules (pick your stack)
# cp -r aevcc/rules/typescript/* ~/.claude/rules/
# cp -r aevcc/rules/python/* ~/.claude/rules/
```

### Step 3: Start Using

```bash
# Try a command
/plan "Add user authentication"

# Check available commands
/plugin list aevcc@aevcc
```

✨ **That's it!** You now have full access to it.

## 🔧 Option 2: Manual Installation

If you prefer manual control over what's installed:

```bash
# Clone the repo

git clone https://github.com/aevelop/aev-cc.git

# Copy agents to your Claude config
cp aevcc/agents/*.md ~/.claude/agents/

# # Copy rules
# cp aevcc/rules/*.md ~/.claude/rules/

# # Copy rules (common + language-specific)
# cp -r aevcc/rules/common/* ~/.claude/rules/
# cp -r aevcc/rules/typescript/* ~/.claude/rules/   # pick your stack
# cp -r aevcc/rules/python/* ~/.claude/rules/

# Copy commands
cp aevcc/commands/*.md ~/.claude/commands/

# Copy skills
cp -r aevcc/skills/* ~/.claude/skills/
```

<!-- #### Add hooks to settings.json

Copy the hooks from `hooks/hooks.json` to your `~/.claude/settings.json`. -->

#### Configure MCPs

Copy desired MCP servers from `docs/mcp-configs/mcp-servers.json` to your `~/.claude.json`.

**Important:** Replace `YOUR_*_HERE` placeholders with your actual API keys.

---

## 🌐 Cross-Platform Support

This plugin fully supports **Windows, macOS, and Linux**. All hooks and scripts have been rewritten in Node.js for maximum compatibility.

### Package Manager Detection

The plugin automatically detects your preferred package manager (npm, pnpm, yarn, or bun) with the following priority:

1. **Environment variable**: `CLAUDE_PACKAGE_MANAGER`
2. **Project config**: `.claude/package-manager.json`
3. **package.json**: `packageManager` field
4. **Lock file**: Detection from package-lock.json, yarn.lock, pnpm-lock.yaml, or bun.lockb
5. **Global config**: `~/.claude/package-manager.json`
6. **Fallback**: First available package manager

To set your preferred package manager:

```bash
# Via environment variable
export CLAUDE_PACKAGE_MANAGER=pnpm

# Via global config
node scripts/setup-package-manager.js --global pnpm

# Via project config
node scripts/setup-package-manager.js --project bun

# Detect current setting
node scripts/setup-package-manager.js --detect
````

Or use the `/setup-pm` command in Claude Code.

---

## 📦 What's Inside

This repo is a **Claude Code plugin** - install it directly or copy components manually.

---

## 📋 Requirements

### Claude Code CLI Version

**Minimum version: v2.1.0 or later**

This plugin requires Claude Code CLI v2.1.0+ due to changes in how the plugin system handles hooks.

Check your version:

```bash
claude --version
```

### Important: Hooks Auto-Loading Behavior

> ⚠️ **For Contributors:** Do NOT add a `"hooks"` field to `.claude-plugin/plugin.json`. This is enforced by a regression test.

Claude Code v2.1+ **automatically loads** `hooks/hooks.json` from any installed plugin by convention. Explicitly declaring it in `plugin.json` causes a duplicate detection error:

```
Duplicate hooks file detected: ./hooks/hooks.json resolves to already-loaded file
```

---

## 🎯 Key Concepts

### Agents

Subagents handle delegated tasks with limited scope. Example:

```markdown
---
name: code-reviewer
description: Reviews code for quality, security, and maintainability
tools: ["Read", "Grep", "Glob", "Bash"]
model: opus
---

You are a senior code reviewer...
```

### Skills

Skills are workflow definitions invoked by commands or agents:

```markdown
# TDD Workflow

1. Define interfaces first
2. Write failing tests (RED)
3. Implement minimal code (GREEN)
4. Refactor (IMPROVE)
5. Verify 80%+ coverage
```

---

## ❓ FAQ

<details>
<summary><b>How do I check which agents/commands are installed?</b></summary>

```bash
/plugin list aevcc@aevcc
```

This shows all available agents, commands, and skills from the plugin.
</details>

<details>
<summary><b>My hooks aren't working / I see "Duplicate hooks file" errors</b></summary>

This is the most common issue. **Do NOT add a `"hooks"` field to `.claude-plugin/plugin.json`.** Claude Code v2.1+ automatically loads `hooks/hooks.json` from installed plugins. Explicitly declaring it causes duplicate detection errors.
</details>

<details>
<summary><b>My context window is shrinking / Claude is running out of context</b></summary>

Too many MCP servers eat your context. Each MCP tool description consumes tokens from your 200k window, potentially reducing it to ~70k.

**Fix:** Disable unused MCPs per project:
```json
// In your project's .claude/settings.json
{
  "disabledMcpServers": ["supabase", "railway", "vercel"]
}
```

Keep under 10 MCPs enabled and under 80 tools active.
</details>

<details>
<summary><b>Can I use only some components (e.g., just agents)?</b></summary>

Yes. Use Option 2 (manual installation) and copy only what you need:

```bash
# Just agents
cp aevcc/agents/*.md ~/.claude/agents/

# Just rules
cp -r aevcc/rules/common/* ~/.claude/rules/
```

Each component is fully independent.
</details>

---

## 📄 License

MIT - Use freely, modify as needed, contribute back if you can.

---

**Star this repo if it helps. Read guides. Build something great.**
