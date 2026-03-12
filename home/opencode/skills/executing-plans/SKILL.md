---
name: executing-plans
description: "Use when you have a written implementation plan to execute with review checkpoints. Batch execution with human feedback loops."
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches.

**Core principle:** Batch execution with checkpoints for user review.

## When to Use

- You have a written implementation plan (from the writing-plans skill)
- Executing in the current session (not dispatching subagents)
- Want human checkpoints between batches

## The Process

### Step 1: Load and Review Plan

1. Read the plan file
2. Review critically -- identify any questions or concerns
3. If concerns: Raise them with the user before starting
4. If no concerns: Create task tracker and proceed

### Step 2: Execute Batch

**Default: First 3 tasks**

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified in the plan
4. Mark as completed

### Step 3: Report

When batch complete:
- Show what was implemented
- Show verification output
- Say: "Ready for feedback."
- Wait for user response

### Step 4: Continue

Based on feedback:
- Apply changes if needed
- Execute next batch of 3 tasks
- Repeat until complete

### Step 5: Complete Development

After all tasks complete and verified:
- Load the git-workflow skill for branch finishing
- Follow that skill to verify tests, present finish options

## When to Stop and Ask

**STOP executing immediately when:**
- Hit a blocker mid-batch (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- User updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** -- stop and ask.

## Rules

- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Between batches: just report and wait
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent
