---
name: auto-commit
description: Use when executing any multi-step task, implementing features, fixing bugs, or running plans. Commits after each completed todo item so the git history tracks every discrete unit of work.
---

# Auto-Commit

## Overview

Commit to git after every completed task so the user can follow the agent's work step-by-step in git history. This mirrors how Aider works: each unit of change gets its own commit with a meaningful message — no batching, no "big bang" commits at the end.

## The Rule

**HARD GATE: Every time you mark a todo as `completed`, you MUST commit before moving to the next task.**

```
complete task → stage relevant files → commit with message → continue
```

No exceptions. Not "I'll commit at the end." Not "this is too small." Every. Task.

## Commit Workflow

After finishing each task:

### 1. Check what changed

```bash
git status
git diff --stat
```

### 2. Stage only files relevant to the completed task

```bash
# Stage specific files (preferred — keep commits focused)
git add path/to/changed/file

# Or stage all if the task touched everything changed so far
git add -A
```

### 3. Commit with a descriptive message

Use conventional commit format reflecting what was just done:

```bash
git commit -m "feat: add user authentication module"
git commit -m "fix: resolve podman socket permission issue"
git commit -m "refactor: extract validation helpers from core module"
git commit -m "chore: enable docker compat layer in podman config"
```

Message format: `<type>: <what was done>` — imperative, specific.

| Type | When |
|------|------|
| `feat` | New capability added |
| `fix` | Bug or broken behavior fixed |
| `refactor` | Code reorganized, no behavior change |
| `chore` | Config, tooling, formatting changes |
| `docs` | Documentation only |
| `test` | Tests added or fixed |

### 4. Verify the commit landed

```bash
git log --oneline -3
```

Confirm your commit appears at the top.

## Nothing to Commit?

If `git status` shows no changes after completing a task (e.g. the task was research or planning), skip the commit and note it. Never create empty commits.

## No Push

Never push. Commits stay local. The user manages push and PR creation.

## What NOT to Do

| Bad | Good |
|-----|------|
| Commit everything at the very end | Commit after each task |
| `git add -A` when only one file changed | Stage only files for this task |
| `fix: various fixes` | `fix: handle empty podman socket path` |
| Skip commit for "trivial" tasks | Every task gets a commit |
| Batch multiple tasks into one commit | One task = one commit |

## Red Flags

| Thought | Reality |
|---------|---------|
| "I'll commit at the end, it's cleaner" | The user wants to see each step. Commit now. |
| "This change is too small to commit" | Small commits are better. Commit now. |
| "Let me finish the next task first" | No. Commit now. Then start next task. |
| "The message doesn't matter much" | The message IS the history. Make it descriptive. |
| "I'll do a WIP commit later" | No WIP commits. Real message, right now. |

## Iron Law

```
MARK TASK COMPLETE → COMMIT → ONLY THEN START NEXT TASK
```

Skipping any step breaks the audit trail the user depends on.
