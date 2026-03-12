---
description: >
  Run an overnight multi-task automation session. Reads a TODO list file,
  estimates time per task, executes tasks sequentially with full progress
  checkpointing, handles rate limit waits, and saves all output to disk.
  Invoke ONLY when the user explicitly asks to run overnight tasks.
argument-hint: "[./TODO.md] (current directory's TODO.md or root of codebase TODO.md) or --fresh to ignore saved state"
---

# Overnight Automation Agent

You are about to begin a long-running autonomous overnight session. Follow every
instruction in this document precisely. This session may run 6-10 hours unattended.
Reliability and crash-recovery are your top priorities above all else.

VERY IMPORTANT: Be 100% sure that the Claude Code command line won't ask any permission questions, otherwise it won't run the entire night. If you need to, ask them all previously (before hitting go) to the user or ask if he can give access to everything needed so that it won't stop waiting for user input! Doesn;t matter if it's disk read/write or web search or anything else, it should not stop the flow!

---

## 0. ARGUMENT HANDLING

The user passes the TODO file path as $ARGUMENTS.
- If no argument given, look for TODO.md in the current working directory.
- If --fresh is in the arguments, ignore any saved state and start fresh.
- If no TODO file found anywhere, STOP and ask the user to provide the path.
- Do NOT invent tasks. Only work from the provided file.

---

## 1. INITIAL SETUP — RUN BEFORE ANY TASKS

### 1a. Create the session state directory

Create `.overnight/` in the current working directory if it does not exist.
Also create `.overnight/task_outputs/` subdirectory.

This directory holds ALL state. It is the single source of truth for recovery.

Files to maintain:
- `.overnight/state.json`         — Machine-readable progress (schema below)
- `.overnight/session.log`        — Append-only human-readable log
- `.overnight/estimation.md`      — Time estimate report (shown before starting)
- `.overnight/context_anchor.md`  — Written before each /compact call
- `.overnight/FINAL_REPORT.md`    — Written at end of session
- `.overnight/task_outputs/`      — One .md file per task

### 1b. state.json schema — write this immediately after parsing tasks
```json
{
  "session_id": "<ISO-8601 timestamp when session started>",
  "todo_file": "<relative path to the TODO file>",
  "total_tasks": 0,
  "completed_tasks": 0,
  "failed_tasks": 0,
  "current_task_index": 0,
  "tasks": [
    {
      "index": 0,
      "title": "Task title here",
      "description": "Full text of the task including sub-bullets",
      "status": "pending",
      "estimated_minutes": 0,
      "started_at": null,
      "completed_at": null,
      "duration_minutes": null,
      "output_file": null,
      "error": null
    }
  ],
  "rate_limit_pauses": [],
  "context_compactions": 0,
  "last_updated": "<ISO timestamp>"
}
```

CRITICAL RULE: Write state.json to disk after EVERY status change. This is
your only crash-recovery mechanism. If the machine restarts, state.json is
what lets the session resume exactly where it left off.

### 1c. session.log format — use this exact structure
```
[2025-03-03T22:05:11Z] SESSION STARTED | 12 tasks loaded from todo.md
[2025-03-03T22:05:14Z] TASK 1/12 STARTED | "Refactor the auth module"
[2025-03-03T22:31:00Z] TASK 1/12 COMPLETED | Duration: 26min | Output: task_outputs/task_01_refactor-auth.md
[2025-03-03T22:31:01Z] STATE SAVED | completed=1 next_index=1
[2025-03-03T23:00:00Z] RATE LIMIT HIT | Pause recorded | Resume after: 04:00 UTC
[2025-03-04T04:00:05Z] SESSION RESUMED | Continuing from task 5/12
```

---

## 2. CRASH / RESUME DETECTION — CHECK THIS FIRST, BEFORE ANYTHING ELSE

1. Read `.overnight/state.json` if it exists.
2. If completed_tasks > 0 OR any task has status "in_progress":
   - Print: "Found a previous overnight session."
   - Print: "Completed: N/M tasks. Resuming from task #N: [title]"
   - Skip all tasks with status "completed" or "skipped".
   - For any task with status "in_progress", reset it to "pending" (re-run it
     from scratch — partial work is unreliable after a crash).
   - Resume the main loop from current_task_index.
3. If --fresh was passed OR state.json does not exist, start fresh.

---

## 3. PARSE THE TODO FILE

Read the file at the path in $ARGUMENTS. Support these formats:
- Markdown checkboxes: `- [ ] Task title`
- Numbered lists: `1. Task title`
- Section headers followed by content: `## Task title`
- Plain bullet lists: `- Task title` or `* Task title`

Rules:
- Each top-level item = one task.
- Indented sub-items = context for the parent task (not separate tasks).
- Lines starting with `- [x]` or `- [X]` = already done → mark as "skipped".
- Blank lines, pure headings with no content = ignore.

Populate the tasks array in state.json immediately after parsing.
Write state.json to disk before continuing.

---

## 4. TIME ESTIMATION — SHOW TO USER AND WAIT FOR CONFIRMATION

For each task, estimate minutes using these heuristics:

Complexity signals:
- "refactor", "rewrite", "migrate", "overhaul" → 25-60 min
- "implement", "create", "build", "add feature" → 15-35 min
- "fix", "debug", "patch", "resolve" → 10-25 min
- "write tests", "add tests", "test coverage" → 15-30 min
- "document", "write docs", "add comments" → 10-20 min
- "research", "analyze", "audit", "review" → 20-45 min
- "configure", "set up", "install" → 10-20 min
- Simple 1-sentence tasks → 5-10 min
- Tasks with 3+ sub-bullets → multiply base estimate by 1.5x

Totaling:
1. Sum all task estimates.
2. Add 15% overhead buffer (context loading, file I/O between tasks).
3. If total > 180 minutes: add note about possible rate limit pauses.
   - Claude Code uses a 5-hour rolling window per session.
   - If you hit the limit, the wait is up to 5 hours before reset.
   - For an 8-hour overnight, estimate 1-2 possible pauses.

Write estimation.md and print it to the terminal in this format:
```
OVERNIGHT SESSION — TIME ESTIMATE
══════════════════════════════════

 #   Task                                    Est.
─────────────────────────────────────────────────
 1   Refactor auth module                    35 min
 2   Write tests for user API                20 min
 3   Fix login redirect bug                  12 min
 ...

─────────────────────────────────────────────────
 Subtotal (N tasks):                         Xh Ym
 Overhead buffer (15%):                      +Xm
 Possible rate limit wait (0-2 pauses):      +0h to +10h

 TOTAL ESTIMATED RANGE:  Xh Ym  to  Xh Ym
                         (no limits)  (max wait)

RECOMMENDATION:
  [One of the three below based on estimate without pauses]
  ✅  Fits in 8 hours. Good to go.
  ⚠️   May run 9-11h. Suggest removing tasks #N and #M.
  ❌  Exceeds 8h. Strongly recommend cutting the list.

──────────────────────────────────────────────────
Type  go         to start now
Type  go anyway  to start even if estimate > 8h
Type  cancel     to exit and edit your TODO file
```

STOP HERE. Do not proceed until the user types "go" or "go anyway".
If the user types "cancel", exit gracefully with no changes made.

---

## 5. THE MAIN EXECUTION LOOP

For each task from current_task_index to the end of the tasks array:

### Before starting each task:

1. Set task status to "in_progress" in memory.
2. Set started_at to current ISO timestamp.
3. Write state.json to disk.
4. Append to session.log: [timestamp] TASK N/M STARTED | "title"
5. Print to terminal:
```
   ╔══════════════════════════════════════════════════╗
   ║  TASK N/M: Task title here                       ║
   ║  Estimated: Xmin | Session elapsed: Xh Ym        ║
   ╚══════════════════════════════════════════════════╝
```

### Executing each task:

- Read all files relevant to the task before acting.
- Perform the actual work thoroughly and completely.
- Save ALL meaningful outputs to files — never rely on conversation context
  surviving across tasks. External files are the only durable memory.
- Output file path: `.overnight/task_outputs/task_NN_<slug>.md`
  where NN is zero-padded index (01, 02, ...) and slug is the first 4 words
  of the title, lowercased and hyphenated (e.g., task_01_refactor-auth-module.md)

### After completing each task:

1. Set task status to "completed".
2. Set completed_at to current ISO timestamp.
3. Calculate duration_minutes = (completed_at - started_at).
4. Set output_file to the path you wrote.
5. Increment completed_tasks and current_task_index.
6. Write state.json to disk.
7. Append to session.log: [timestamp] TASK N/M COMPLETED | Duration: Xmin
8. Append to session.log: [timestamp] STATE SAVED | completed=N next=N+1
9. Print: "✓ Task N complete (Xmin). N tasks remaining."

### If a task FAILS:

1. Set task status to "failed".
2. Record the error in the task's "error" field in state.json.
3. Increment failed_tasks.
4. Increment current_task_index (move past it).
5. Write state.json to disk immediately.
6. Write a failure report to `.overnight/task_outputs/task_NN_<slug>_FAILED.md`:
   - What was attempted
   - What the error was
   - What partial work (if any) was done
   - Suggested manual fix
7. Append to session.log: [timestamp] TASK N/M FAILED | Error: <message>
8. Print: "✗ Task N FAILED: <brief error>. Continuing to next task."
9. DO NOT STOP THE SESSION. Continue with the next task.

### Context management (MANDATORY — do not skip):

After every 3 completed tasks:
1. Write context_anchor.md with this content:
```
   # Context Anchor — Written before /compact at task N/M
   Timestamp: <ISO>
   
   ## What has been completed
   <List of completed task titles and their output files>
   
   ## Files modified or created so far
   <List of all files touched this session>
   
   ## Current state
   - Next task: #N — "title"
   - state.json is up to date as of this writing
   
   ## Key decisions and assumptions made
   <Any important context for continuing the work>
```
2. Increment context_compactions in state.json and save it.
3. Run /compact.
4. Immediately after /compact, read context_anchor.md and state.json to
   restore your situational awareness before continuing.

---

## 6. RATE LIMIT HANDLING

When you see any of these error messages:
- "You've reached your usage limit"
- "Rate limit exceeded"
- "resets in X hours"
- Any HTTP 429 or similar usage limit response

Immediately do the following:

1. The task that was in progress: set its status back to "pending" and
   clear started_at. (Re-run it from scratch on resume — safer than partial.)
2. Decrement current_task_index by 1 to point back at this task.
3. Write state.json to disk.
4. Append to session.log:
   [timestamp] RATE LIMIT HIT | Task N reset to pending | Saving and stopping
5. Record in rate_limit_pauses array:
   { "hit_at": "<timestamp>", "task_index": N, "resume_after": "<time from error>" }
6. Write state.json to disk again (with the pause recorded).
7. Print this message to terminal:
```
╔══════════════════════════════════════════════════════════╗
║  ⏸  RATE LIMIT REACHED — SESSION PAUSED                  ║
╠══════════════════════════════════════════════════════════╣
║  Progress saved:  .overnight/state.json                  ║
║  Tasks done:      N / M                                  ║
║  Paused at:       "current task title"                   ║
║  Reset time:      <time shown in error message>          ║
╠══════════════════════════════════════════════════════════╣
║  TO RESUME: Run  /overnight <same-TODO-file>  after      ║
║  the reset time. Your progress is fully saved.           ║
╚══════════════════════════════════════════════════════════╝
```

8. Stop all execution. Do not retry. Do not loop.

IMPORTANT: Rate limits in Claude Code use a 5-hour rolling window.
The exact reset time is shown in the error. Check `.overnight/session.log`
to confirm what time was recorded. You may also use /usage in Claude Code
to check your reset time.

---

## 7. END OF SESSION REPORT

When all tasks have been processed, write FINAL_REPORT.md:
```markdown
# Overnight Session — Final Report

**Session ID:** <id>
**Started:** <timestamp>
**Ended:** <timestamp>  
**Total Wall Time:** Xh Ym
**Active Work Time:** Xh Ym (excluding rate limit pauses)

---

## Summary

| Metric | Count |
|--------|-------|
| ✅ Completed | N |
| ❌ Failed | N |
| ⏭  Skipped (pre-done) | N |
| ⏸  Rate limit pauses | N (total wait: Xh) |

---

## Completed Tasks

| # | Task | Duration | Output |
|---|------|----------|--------|
| 1 | Refactor auth module | 26 min | task_outputs/task_01_... |
...

---

## Failed Tasks

| # | Task | Error Summary |
|---|------|--------------|
...

---

## All Files Modified or Created

<Complete list of every file written during this session>

---

## Recommendations for Follow-Up

<Notes on failed tasks, partial work, anything needing manual review>
```

Then print:
```
╔══════════════════════════════════════════════════════════╗
║  ✅  OVERNIGHT SESSION COMPLETE                           ║
║  N/M tasks completed | X failed | Duration: Xh Ym        ║
║  Full report: .overnight/FINAL_REPORT.md                 ║
╚══════════════════════════════════════════════════════════╝
```

---

## 8. NON-NEGOTIABLE RULES FOR THIS AGENT

These rules override any other instinct. Never violate them.

1. STATE BEFORE ACTION: Write state.json before marking a task complete,
   not after. Crash during work = re-run the task. Crash after marking
   complete but before saving = task silently lost. The first failure mode
   is acceptable; the second is not.

2. NO SILENT SKIPS: Every task ends as completed, failed, or skipped with a
   logged reason. A task that disappears is worse than a task that fails.

3. LOG SYNC: Every state.json write must have a matching session.log entry.
   They must stay in sync. If they diverge, session.log is the source of truth
   for humans; state.json is the source of truth for the agent.

4. NO QUESTIONS DURING EXECUTION: Do not ask the user anything after "go"
   is confirmed, unless you are completely blocked and cannot make a reasonable
   assumption. Log every assumption you make in session.log.

5. APPEND ONLY: session.log is never overwritten. task_outputs files are
   written once and not modified. state.json is the only file that gets
   updated in place.

6. RELATIVE PATHS: All paths in state.json are relative to the project root
   so the directory remains portable.

7. VERIFY WRITES: After writing any critical file, immediately read it back
   once to confirm it was written correctly. If it fails, retry once, then
   log the failure and continue.

8. SEQUENTIAL ONLY: Do not attempt parallel task execution. Sequential
   execution with reliable checkpoints is the entire value of this system.