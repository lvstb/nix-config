---
name: git-workflow
description: "Use for branch management: creating worktrees, setting up branches, and finishing development branches (merge/PR/keep/discard)."
---

# Git Workflow

## Overview

Manage git branches and worktrees when the work is large enough to benefit from isolation. Use this for larger features, risky refactors, or branch-finishing tasks.

For small local edits, staying on the current branch may be fine if the user has not asked for branch management.

## Starting a Development Branch

### Option A: Git Worktree (Recommended for larger work)

```bash
# Create worktree on new branch
git worktree add ../project-feature-name -b feature/feature-name

# Move into worktree
cd ../project-feature-name

# Verify clean state
git status
```

### Option B: Regular Branch (Simpler, for medium work)

```bash
# Create and switch to new branch
git checkout -b feature/feature-name

# Verify clean state
git status
```

### After Branch Setup

1. Detect project type and install dependencies:
   ```bash
   # Auto-detect and install
   [ -f package.json ] && npm install
   [ -f Cargo.toml ] && cargo build
   [ -f requirements.txt ] && pip install -r requirements.txt
   [ -f pyproject.toml ] && poetry install || pip install -e .
   [ -f go.mod ] && go mod download
   ```
2. Run existing tests to verify a clean baseline when practical
3. Understand any pre-existing failures before starting work

**If tests don't pass on a clean branch:** Fix them first or document known failures.

## During Development

- Commit frequently (after each task or logical unit)
- Use conventional commit messages:
  - `feat: add user authentication`
  - `fix: handle empty email validation`
  - `test: add retry operation tests`
  - `refactor: extract validation helpers`
  - `docs: add API documentation`
- Keep commits small and focused
- Don't mix feature work with unrelated changes

## Finishing a Development Branch

When all tasks are complete and verified:

### 1. Final Checks

```bash
# Run full test suite
npm test  # or project-specific test command

# Check for uncommitted changes
git status

# Review all changes
git diff main...HEAD
```

### 2. Present Options to User

**"All tasks complete. Options:"**

| Option | When to Use |
|--------|------------|
| **Merge to main** | Small changes, high confidence, you're the sole developer |
| **Create PR** | Team review needed, CI checks required |
| **Keep branch** | Not ready to merge, more work planned |
| **Discard** | Experiment didn't work out |

### 3. Execute Chosen Option

**Merge:**
```bash
git checkout main
git merge --no-ff feature/feature-name
git branch -d feature/feature-name
```

**PR:**
```bash
git push -u origin feature/feature-name
gh pr create --title "feat: description" --body "Summary of changes"
```

**Keep:** No action needed.

**Discard:**
```bash
# Show what will be lost
git log --oneline main..feature/feature-name

# Confirm with user before proceeding
git checkout main
git branch -D feature/feature-name
# If worktree:
git worktree remove ../project-feature-name
```

### 4. Cleanup Worktree (if used)

```bash
cd ..
git worktree remove ../project-feature-name
```

## Rules

- Prefer a clean baseline before larger work
- Never commit directly to main without explicit user consent
- Always present finishing options to the user -- don't assume
- Clean up worktrees after merging or discarding
