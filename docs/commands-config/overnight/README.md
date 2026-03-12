# 🌙 Overnight Automation for Claude Code

A slash command system for Claude Code that lets you run a long list of tasks autonomously while you sleep — with full crash recovery, progress checkpointing, time estimation, and automatic rate limit handling.

---

## Table of Contents

- [What This Is](#what-this-is)
- [How It Works](#how-it-works)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Writing Your TODO File](#writing-your-todo-file)
- [Running an Overnight Session](#running-an-overnight-session)
- [Time Estimation](#time-estimation)
- [Crash Recovery & Resuming](#crash-recovery--resuming)
- [Rate Limit Handling](#rate-limit-handling)
- [Session Output Files](#session-output-files)
- [Context Management](#context-management)
- [Tips & Best Practices](#tips--best-practices)
- [Limitations](#limitations)

---

## What This Is

This project adds a single slash command — `/overnight` — to Claude Code. When invoked, it:

1. Reads a `TODO.md` file containing a list of tasks you want done
2. Estimates how many hours the full list will take and asks for your confirmation
3. Executes every task sequentially, saving progress to disk after each one
4. Handles interruptions (crashes, power outages, restarts) by resuming from the last checkpoint
5. Handles Claude Code rate limit pauses by saving state and resuming automatically when you re-run it
6. Produces a final report of everything completed, failed, or skipped

You trigger it only when you explicitly want to — it does nothing passively.

---

## How It Works

### Why a Slash Command (Not a Skill or Agent)

Claude Code offers several extension mechanisms:

| Mechanism | When it triggers | Best for |
|-----------|-----------------|----------|
| **Skill** | Automatically, when Claude detects the context matches | Behaviors you always want active |
| **Slash Command** | Only when you explicitly type the command | On-demand workflows you control |
| **CLAUDE.md instructions** | Every session, as background context | Project-wide conventions |

This system uses a **slash command** because you want full control over when the overnight run starts. You never want it activating automatically.

### The Execution Loop

```
/overnight TODO.md
       │
       ▼
  Load state.json ──► Previous session found? ──► Resume from checkpoint
       │ (no prior session)
       ▼
  Parse TODO.md → Build task list → Write state.json
       │
       ▼
  Show time estimate → Wait for "go"
       │
       ▼
  ┌─── For each task: ────────────────────────────────────┐
  │  1. Set status = in_progress → save state.json        │
  │  2. Append to session.log                             │
  │  3. Execute the task                                  │
  │  4. Write output to task_outputs/task_NN_<slug>.md    │
  │  5. Set status = completed → save state.json          │
  │  6. Every 3 tasks: write context_anchor.md → /compact │
  └───────────────────────────────────────────────────────┘
       │
       ▼
  Write FINAL_REPORT.md → Print summary
```

If a **rate limit** is hit at any point, the current task is reset to `pending`, state is saved, and the session stops cleanly. Re-running `/overnight TODO.md` resumes from exactly that task.

If the **computer restarts or Claude Code crashes**, the same recovery applies — re-run the command and it picks up from the last successfully saved checkpoint.

---

## Project Structure

```
your-project/
│
├── .claude/
│   └── commands/
│       └── overnight.md          ← The slash command definition
│
├── CLAUDE.md                     ← Project context for Claude (includes overnight notes)
├── TODO.md                       ← Your task list (you create and edit this)
│
└── .overnight/                   ← Created automatically during a session
    ├── state.json                ← Live progress checkpoint (crash recovery)
    ├── session.log               ← Append-only human-readable log
    ├── estimation.md             ← Time estimate from the last run
    ├── context_anchor.md         ← Written before each /compact call
    ├── FINAL_REPORT.md           ← Summary written at end of session
    └── task_outputs/
        ├── task_01_refactor-auth-module.md
        ├── task_02_write-tests-user-api.md
        ├── task_03_fix-login-redirect_FAILED.md
        └── ...
```

> **Note:** Add `.overnight/` to your `.gitignore` unless you want session logs committed to version control.

---

## Installation

### 1. Create the commands directory

```bash
mkdir -p .claude/commands
```

To make the command available **globally across all projects** instead, use:

```bash
mkdir -p ~/.claude/commands
```

### 2. Save the slash command

Copy the contents of `overnight.md` (the slash command definition) into:

```
.claude/commands/overnight.md       ← project-local
# or
~/.claude/commands/overnight.md     ← global (all projects)
```

### 3. Update your CLAUDE.md

Add the following section to your project's `CLAUDE.md` file:

```markdown
## Overnight Automation

This project uses an overnight automation slash command for long unattended runs.

- Slash command: `/overnight <path/to/TODO.md>`
- State is saved to `.overnight/` — never delete this during a session
- To resume after interruption: run `/overnight <same-TODO-file>` again
- To start fresh: run `/overnight --fresh <TODO-file>`
- Rate limit pauses are handled automatically; just re-run after the reset time
```

### 4. Add .overnight/ to .gitignore

```bash
echo ".overnight/" >> .gitignore
```

### 5. Verify the command is available

Open Claude Code in your project directory and type `/`. You should see `overnight` listed in the slash command menu.

---

## Writing Your TODO File

The TODO file is a plain Markdown file. You can name it anything (e.g., `TODO.md`, `tasks-tonight.md`).

### Supported formats

```markdown
# Section headers are ignored (used for organization only)

## Task as a heading
(followed by content — the whole block is one task)

- [ ] Task as an unchecked checkbox
  - Sub-bullet for extra context (part of the same task)
  - Another sub-bullet

1. Task as a numbered list item
2. Another numbered task

- [ ] Already completed tasks are marked like this
- [x] This is already done — it will be SKIPPED automatically

* Plain bullets also work
```

### Rules

- **One top-level item = one task.** Indented sub-items are context for the parent task, not separate tasks.
- **Already-checked items** (`- [x]`) are automatically detected and skipped.
- **Sub-bullets** give Claude useful context — include file paths, issue numbers, acceptance criteria, etc.
- **Keep task titles descriptive.** The title becomes the filename for the task's output. "Fix bug" is worse than "Fix login redirect bug on mobile".

### Example TODO.md

```markdown
# Overnight Tasks — March 3

- [ ] Refactor the authentication module to use JWT tokens
  - Replace session-based auth in src/auth/
  - Update all API routes that check req.session
  - Write migration notes to docs/auth-migration.md

- [ ] Write unit tests for the user API endpoints
  - Cover GET /users, POST /users, DELETE /users/:id
  - Use existing test patterns from tests/api/

- [ ] Fix the login redirect bug on mobile
  - Reported in issue #142
  - Reproduces at viewport width < 480px

- [x] Update README with installation steps
  (already done — will be auto-skipped)

- [ ] Audit all console.log statements and replace with structured logging
- [ ] Generate API documentation from JSDoc comments
- [ ] Review and clean up unused dependencies in package.json
```

---

## Running an Overnight Session

### Basic usage

```
/overnight TODO.md
```

Or with a custom path:

```
/overnight tasks/tonight.md
```

### What happens next

1. Claude reads the TODO file and parses all tasks.
2. It shows you a **time estimate table** (see below).
3. It waits for you to type one of:
   - `go` — start the session
   - `go anyway` — start even if the estimate exceeds 8 hours
   - `cancel` — exit without doing anything
4. Once you type `go`, the session runs autonomously until all tasks are complete or a rate limit/crash occurs.

### Starting fresh (ignore saved state)

```
/overnight --fresh TODO.md
```

This overwrites any existing `.overnight/state.json` and starts the session from scratch.

---

## Time Estimation

Before any work begins, Claude analyzes your task list and produces an estimate like this:

```
OVERNIGHT SESSION — TIME ESTIMATE
══════════════════════════════════

 #   Task                                    Est.
─────────────────────────────────────────────────
 1   Refactor auth module                    35 min
 2   Write tests for user API                20 min
 3   Fix login redirect bug                  12 min
 4   Audit console.log statements            18 min
 5   Generate API documentation              15 min
 6   Clean up unused dependencies            10 min
─────────────────────────────────────────────────
 Subtotal (6 tasks):                         1h 50m
 Overhead buffer (15%):                      +17m
 Possible rate limit wait (0-1 pauses):      +0h to +5h

 TOTAL ESTIMATED RANGE:  2h 07m  to  7h 07m

RECOMMENDATION:
  ✅  Fits in 8 hours. Good to go.
```

### Estimation heuristics used

| Keywords in task | Estimated range |
|-----------------|----------------|
| "refactor", "rewrite", "migrate", "overhaul" | 25–60 min |
| "implement", "create", "build", "add feature" | 15–35 min |
| "fix", "debug", "patch", "resolve" | 10–25 min |
| "write tests", "add tests", "test coverage" | 15–30 min |
| "document", "write docs", "add comments" | 10–20 min |
| "research", "analyze", "audit", "review" | 20–45 min |
| "configure", "set up", "install" | 10–20 min |
| Simple 1-sentence task | 5–10 min |
| Task with 3+ sub-bullets | base × 1.5 |

These are rough heuristics. Actual time depends on codebase complexity, file sizes, and task specifics. Use the estimate as a planning tool, not a guarantee.

---

## Crash Recovery & Resuming

Every state change is written to `.overnight/state.json` **before** the next action is taken. This means:

- If Claude Code crashes mid-task → re-run the command, the in-progress task restarts from scratch
- If the computer restarts → re-run the command, all completed tasks are skipped
- If you close the terminal accidentally → re-run the command, session resumes

### To resume

Simply run the same command again:

```
/overnight TODO.md
```

Claude will detect the saved state and print:

```
Found a previous overnight session.
Completed: 4/12 tasks. Resuming from task #5: "Generate API documentation"
```

### How state is maintained

The `state.json` file records:
- Which tasks are `pending`, `in_progress`, `completed`, `failed`, or `skipped`
- When each task started and finished
- The output file path for each completed task
- Any rate limit pauses that occurred
- The current task index

In addition, `session.log` provides a timestamped human-readable audit trail of everything that happened.

---

## Rate Limit Handling

Claude Code uses a **5-hour rolling usage window**. If you hit the limit during an overnight session:

1. The current task is reset to `pending` (not lost — it will re-run on resume).
2. State is saved to disk immediately.
3. Claude prints a clear message:

```
╔══════════════════════════════════════════════════════════╗
║  ⏸  RATE LIMIT REACHED — SESSION PAUSED                  ║
╠══════════════════════════════════════════════════════════╣
║  Progress saved:  .overnight/state.json                  ║
║  Tasks done:      4 / 12                                 ║
║  Paused at:       "Generate API documentation"           ║
║  Reset time:      04:00 UTC                              ║
╠══════════════════════════════════════════════════════════╣
║  TO RESUME: Run  /overnight TODO.md  after the reset.    ║
║  Your progress is fully saved.                           ║
╚══════════════════════════════════════════════════════════╝
```

4. The session stops. You do nothing.
5. After the reset time, run `/overnight TODO.md` again — it resumes automatically.

### Checking your rate limit reset time

Run `/usage` inside Claude Code to see your current usage and when the 5-hour window resets. The reset time is also recorded in `.overnight/session.log`.

### Planning around rate limits

For very large task lists (8+ hours of work), you may hit the limit once or twice overnight. The estimation report accounts for this by showing you a range: "2h without pauses to 12h with 2 full pauses." Plan accordingly — if the upper bound is too long for your morning deadline, trim the list.

---

## Session Output Files

### `.overnight/state.json`
The live checkpoint file. Written after every status change. Used for crash recovery and resume. Do not edit manually unless recovering from a corrupted session.

### `.overnight/session.log`
An append-only timestamped log of everything that happened:
```
[2025-03-03T22:05:11Z] SESSION STARTED | 12 tasks loaded from todo.md
[2025-03-03T22:05:14Z] TASK 1/12 STARTED | "Refactor auth module"
[2025-03-03T22:31:00Z] TASK 1/12 COMPLETED | Duration: 26min
[2025-03-03T22:31:01Z] STATE SAVED | completed=1 next_index=1
```

### `.overnight/estimation.md`
The time estimate report generated before the session starts. Useful for future planning.

### `.overnight/task_outputs/task_NN_<slug>.md`
One file per task. Contains the full output of what Claude did for that task — code written, files modified, analysis performed, decisions made. This is your permanent record of the session's work.

Failed tasks produce a `_FAILED.md` file with the error, what was attempted, and a suggested manual fix.

### `.overnight/context_anchor.md`
Written automatically before each `/compact` call (every 3 tasks). Contains a summary of completed work, modified files, and what comes next. Used to restore Claude's awareness after context compression.

### `.overnight/FINAL_REPORT.md`
Written at the end of a complete session. Includes:
- Full summary table (completed / failed / skipped counts)
- Per-task duration and output file
- List of all files modified or created
- Recommendations for follow-up on failed tasks

---

## Context Management

Long sessions accumulate a lot of context. Without management, Claude Code's context window fills up and the session becomes unreliable or stops.

This system handles it automatically: after every 3 completed tasks, it:
1. Writes `context_anchor.md` — a durable summary of everything done so far
2. Runs `/compact` — compresses the conversation history
3. Reads back `context_anchor.md` — restores situational awareness

This allows the session to run indefinitely without context overflow.

---

## Tips & Best Practices

**Writing better TODO files:**
- Be specific. "Fix the user pagination bug in `src/api/users.js` (issue #88)" is far better than "Fix pagination bug."
- Include acceptance criteria in sub-bullets. Claude will use them to know when it's done.
- Reference file paths. "Refactor `src/auth/session.js`" is more actionable than "Refactor auth."
- Group related tasks together so file context can be reused between them.

**Planning overnight sessions:**
- Check the estimate carefully before typing `go`. If the upper bound (with rate limit pauses) runs past your morning, trim the list.
- Put your highest-priority tasks first. If a rate limit hits at 4 AM, the most important work is already done.
- Put risky or exploratory tasks last. If they fail or take longer than expected, they don't block everything else.

**During the session:**
- Don't close the terminal unless you want to pause. Closing Claude Code mid-task is fine — just re-run to resume.
- Don't edit `state.json` manually unless you know what you're doing.
- You can monitor progress by watching `session.log` in another terminal: `tail -f .overnight/session.log`

**After the session:**
- Read `FINAL_REPORT.md` first for the big picture.
- Check `_FAILED.md` files for any tasks that need manual attention.
- Review individual `task_outputs/` files if you want to understand what Claude did for a specific task.

---

## Limitations

- **Sequential only.** Tasks run one at a time. This is intentional — parallel execution makes crash recovery unreliable.
- **Time estimates are heuristic.** They are based on keyword analysis of task titles, not actual code analysis. Treat them as rough planning guides.
- **Resume restarts interrupted tasks.** If a crash happens mid-task, the task reruns from scratch on resume. Partial work is discarded. This is the safe choice — partial writes to files can cause worse problems.
- **Rate limit waits require a manual re-run.** Claude Code cannot wake itself up after a rate limit. You (or a cron job) must run `/overnight TODO.md` again after the reset time. The progress is fully saved — nothing is lost.
- **Context anchor summaries are imperfect.** After `/compact`, Claude reconstructs its awareness from a written summary. Very nuanced context (e.g., subtle architectural decisions made earlier) may not fully survive the compression. Mitigate this by writing detailed sub-bullets in your TODO tasks rather than relying on implicit session context.