# Global Claude Code Configuration

This is the global CLAUDE.md for all projects. It configures plugins, hooks, agents, skills, rules, and behavioral guidelines.

---

## Behavioral Guidelines

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

**Tradeoff:** These guidelines bias toward caution over speed. For trivial tasks, use judgment.

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, and clarifying questions come before implementation rather than after mistakes.

---

## Critical Rules

### 1. Code Organization

- Many small files over few large files
- High cohesion, low coupling
- 200-400 lines typical, 800 max per file
- Organize by feature/domain, not by type

### 2. Code Style

- No emojis in code, comments, or documentation
- Immutability always - never mutate objects or arrays
- No console.log in production code
- Proper error handling with try/catch
- Input validation with Zod or similar

### 3. Testing

- TDD: Write tests first
- 80% minimum coverage
- Unit tests for utilities
- Integration tests for APIs
- E2E tests for critical flows

### 4. Security

- No hardcoded secrets
- Environment variables for sensitive data
- Validate all user inputs
- Parameterized queries only
- CSRF protection enabled

---

## Rules & Guidelines

### Coding Style (from ECC rules)
- **Immutability**: ALWAYS create new objects, NEVER mutate existing ones
- **File size**: 200-400 lines typical, 800 max; many small files > few large files
- **Functions**: Keep under 50 lines, focused on a single responsibility
- **Nesting**: Max 4 levels deep
- **Error handling**: Handle errors explicitly at every level; never silently swallow errors
- **Input validation**: Validate at system boundaries; never trust external data
- **Organization**: By feature/domain, not by type
- **No hardcoded values**: Use constants or config

### Security (from ECC rules)
Before ANY commit:
- No hardcoded secrets (API keys, passwords, tokens)
- All user inputs validated
- SQL injection prevention (parameterized queries)
- XSS prevention (sanitized HTML)
- CSRF protection enabled
- Authentication/authorization verified
- Rate limiting on endpoints
- Error messages don't leak sensitive data

If security issue found: STOP immediately, use security-reviewer agent, fix before continuing.

### Git Workflow (from ECC rules)
- **Commit format**: `<type>: <description>` (types: feat, fix, refactor, docs, test, chore, perf, ci)
- **PR workflow**: Analyze full commit history, use `git diff [base-branch]...HEAD`, include test plan
- **Feature workflow**: Plan first → TDD approach → Code review → Commit & Push

### Testing (from ECC rules)
- **Minimum coverage**: 80%
- **Required test types**: Unit, Integration, E2E
- **TDD workflow**: Write test (RED) → Run and fail → Implement (GREEN) → Run and pass → Refactor (IMPROVE) → Verify coverage

### Performance (from ECC rules)
- **Model routing**: Use haiku for lightweight tasks, sonnet for standard work, opus for deep analysis
- **Context window**: Avoid last 20% for large refactors and multi-file features
- **Build failures**: Use build-error-resolver agent, fix incrementally

### Patterns (from ECC rules)
- **Repository pattern**: Encapsulate data access behind consistent interfaces
- **API response format**: Consistent envelope with success indicator, data, error message, pagination metadata
- **Skeleton projects**: Search for battle-tested starter projects before building from scratch

---

## Behavioral Guidelines

### Delegation Strategy
- **Delegate** multi-file implementations, refactors, debugging, reviews, and planning to specialized agents
- **Work directly** on small clarifications, quick status checks, simple single-file edits
- **Use Context7 MCP** before implementing with unfamiliar SDKs/frameworks/APIs
- **Parallelize** independent tasks that each take >30 seconds

### Verification
- Verify before claiming completion with evidence-based confidence
- For small changes (<5 files): lightweight verification
- For standard changes: run tests, check types
- For large/security changes: comprehensive agent-driven review

### Proactive Agent Usage
These agents/skills should be used proactively (without user asking):
- **code-reviewer**: After writing or modifying code
- **security-reviewer**: After code handling user input, auth, API endpoints, sensitive data
- **tdd-guide**: When writing new features or fixing bugs
- **build-error-resolver**: When build fails
- **silent-failure-hunter**: After code with error handling, catch blocks, fallback logic
- **verification-before-completion**: Before claiming work is done

### Ralph Loop
When active (triggered by `/ralph-loop:ralph-loop`), Claude continues working autonomously through a self-referential loop until all tasks are complete and verified. The stop hook keeps the loop going.

---

# My Custom Instructions to Every Prompt in Every Codebase
**Ask questions whenever in doubt instead of providing formulaic response: Do it when you think the go-to response is vague and you could use some clarification to create a better response. Always use an interactive (clickable) interface for questions instead of numbering them.**

## Claude in Chrome: use a separate window, never my working window

My working Chrome windows are usually tiled (Split View), so they cannot be resized and I do not want automation tabs mixed into them. The extension currently opens its MCP tab group as tabs in my active window (it used to open a separate window).

Rules for every session that uses browser automation:
- Browser automation must run in its own Chrome window, separate from the windows I am working in.
- The tab-vs-window choice belongs to the Claude in Chrome extension and cannot be changed via tool calls (verified: window.open popups are blocked even from automation clicks). So: right after creating the first MCP tab, if window-level operations (resize_window, mobile-viewport testing) will be needed, pause and ask me to drag the MCP tab group out into its own window before continuing. The group keeps working after the move.
- After any resize_window call, verify it took effect (screenshot dimensions). If the window did not resize, it is one of my tiled working windows: STOP, do not retry, and ask me to move the MCP tab group to its own window.
- Never resize, move, or close a window that contains my own tabs.

## Ollama Cloud: outsource heavy non-coding work

Goal: save Claude tokens for coding. Applies to every session and every agent/subagent, in any folder.

**What qualifies:** non-coding tasks that would cost many tokens: long-form text creation or rewriting, bulk/repetitive text transformations, translation, summarizing large documents, reformatting, data-to-prose. Rough threshold: more than ~1,500 words of output, or a large input file Claude would otherwise have to read. Never outsource code writing, code review, debugging, or anything needing tool access. Small tasks are not worth the overhead; do them directly.

**Ask first:** before every outsourced task, ask me for approval (interactive question) naming the task and the model you picked. Do not outsource silently.

**Never send:** secrets, credentials, API keys, .env contents, or personal data of customers/students/patients (PII/PHI). If the input contains any, do the task yourself or strip it first.

**How:** use the helper `~/.claude/bin/ollama-cloud` (reads the API key from macOS Keychain service `ollama-cloud-api-key`; never print, log, or copy the key anywhere).

```
~/.claude/bin/ollama-cloud --list-models
~/.claude/bin/ollama-cloud --model MODEL --prompt-file PROMPT.md [--system TEXT] [--input-file FILE ...] --out RESULT.md
```

- Pass large inputs with `--input-file` so they go straight to Ollama; do not read them into context first.
- Write the prompt to a file with full context: purpose, audience, tone, format, length, constraints. The remote model knows nothing about this conversation.
- For batches, run one call per item (parallel in background is fine) rather than one giant prompt.

**Model choice:** pick the best model for the task. I reviewed the prices and all of them are far cheaper than Claude, so do not over-optimize for cost; use it only as a tiebreaker when quality is comparable. Starting points (prices per 1M tokens in/out as of 2026-09; check https://ollama.com/pricing and `--list-models` if a model is missing or retired):
- Simple bulk/repetitive transforms: `gpt-oss:20b` ($0.07/$0.30), `nemotron-3-nano:30b` ($0.06/$0.24)
- Most tasks: `deepseek-v4.1-flash` ($0.15/$0.60), `gpt-oss:120b` ($0.15/$0.60), `glm-5.3-flash` ($0.15/$0.50)
- Quality-critical writing: `deepseek-v4-pro:0813` ($0.66/$1.98), `glm-5.3` ($1.40/$4.40), `kimi-k2.6` ($0.95/$4.00), `mistral-large-3:675b` ($0.50/$1.50)
- Top tier, only when the task really needs it: `kimi-k3` ($3.00/$15.00)

**Verify (mandatory):** after the result is back, you (Claude, active model) must read the output file and check it is well written, accurate to the source, complete (not truncated), in the requested format/language, and fits the purpose it was created for. Fix small issues yourself. If it fails, retry once with a sharper prompt or a better-tier model; if it still fails, do the task yourself and tell me. Report which model was used and the token counts from the helper's summary line.

## Engineering workflow: mattpocock-skills is the spine

Planning, design, and ticket breakdown go through the `mattpocock-skills` plugin, not through superpowers' brainstorming or ecc's PRP/epic/orchestration flows (those remain installed for their specialist agents only).

- New feature or non-trivial change: `/grill-with-docs` (or `/grill-me` for a quick decision) until we have shared understanding, then `/to-spec`, then `/to-tickets`, then `/implement` (which drives `/tdd` and closes with `/code-review`).
- Big efforts with many open decisions: `/wayfinder` first.
- Bugs: `/diagnosing-bugs`. Codebase health: `/improve-codebase-architecture`. Not sure which skill: `/ask-matt`.
- Keep using superpowers for `test-driven-development`, `systematic-debugging`, `verification-before-completion`, and `using-git-worktrees`. Do not invoke `superpowers:brainstorming`; grilling replaces it.
- Run `/setup-matt-pocock-skills` once per repo before the first use (GitHub Issues as the tracker, docs under `docs/agents/`).
- GSD (`/gsd:*`) is uninstalled. Never suggest it.
