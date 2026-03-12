---
name: systematic-debugging
description: "Use when encountering any bug, test failure, or unexpected behavior. Root cause investigation before proposing any fix."
---

# Systematic Debugging

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

ANY technical issue: test failures, bugs, unexpected behavior, performance problems, build failures, integration issues.

**Especially when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work

## The Four Phases

Complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read error messages carefully** -- don't skip past errors. Read stack traces completely. Note line numbers, file paths, error codes.

2. **Reproduce consistently** -- can you trigger it reliably? What are the exact steps? If not reproducible, gather more data. Don't guess.

3. **Check recent changes** -- what changed? Git diff, recent commits, new dependencies, config changes, environmental differences.

4. **Gather evidence in multi-component systems** -- before proposing fixes, add diagnostic instrumentation at each component boundary. Log what enters and exits each layer. Run once to see WHERE it breaks.

5. **Trace data flow** -- where does the bad value originate? What called this with the bad value? Keep tracing up until you find the source. Fix at source, not at symptom.

### Phase 2: Pattern Analysis

1. **Find working examples** -- locate similar working code in same codebase
2. **Compare against references** -- read reference implementations COMPLETELY, don't skim
3. **Identify differences** -- list every difference between working and broken, however small
4. **Understand dependencies** -- what other components, settings, config, environment does this need?

### Phase 3: Hypothesis and Testing

1. **Form single hypothesis** -- state clearly: "I think X is the root cause because Y"
2. **Test minimally** -- SMALLEST possible change. One variable at a time. Don't fix multiple things at once.
3. **Verify** -- did it work? Yes: Phase 4. No: form NEW hypothesis. DON'T layer more fixes on top.
4. **When you don't know** -- say "I don't understand X." Don't pretend.

### Phase 4: Implementation

1. **Create failing test case** -- simplest reproduction. Automated if possible. MUST have before fixing. Use the tdd skill.
2. **Implement single fix** -- address root cause. ONE change. No "while I'm here" improvements.
3. **Verify fix** -- test passes? No other tests broken? Issue resolved?
4. **If fix doesn't work** -- STOP. Count fixes attempted. If < 3: return to Phase 1. If >= 3: question the architecture.

**If 3+ fixes failed:** This is likely an architectural problem, not a bug. Each fix revealing new problems in different places = wrong architecture. Discuss with the user before attempting more fixes.

## Red Flags -- STOP and Follow Process

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Here are the main problems: [lists fixes without investigation]"
- Proposing solutions before tracing data flow
- "One more fix attempt" (when already tried 2+)

**ALL mean: STOP. Return to Phase 1.**

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple" | Simple issues have root causes too. Process is fast for simple bugs. |
| "Emergency, no time" | Systematic debugging is FASTER than guess-and-check. |
| "Just try this first" | First fix sets the pattern. Do it right from the start. |
| "I see the problem" | Seeing symptoms != understanding root cause. |
| "One more fix attempt" | 3+ failures = architectural problem. Question the pattern. |

## User Signals You're Doing It Wrong

If the user says something like:
- **"Is that not happening?"** -- You assumed without verifying
- **"Will it show us...?"** -- You should have added evidence gathering
- **"Stop guessing"** -- You're proposing fixes without understanding
- **"We're stuck"** (frustrated) -- Your approach isn't working, change strategy

## When Process Reveals No Root Cause

If investigation yields no clear root cause:
- Check environmental factors (different OS, different versions, CI vs local)
- Check timing/race conditions
- Check external dependencies (APIs, services, network)

**95% of "no root cause" cases are incomplete investigation.** Go back to Phase 1.

## Supporting References

For detailed techniques, see the reference files in this skill directory:
- **root-cause-tracing.md** -- Backward tracing through call chains with real examples
- **defense-in-depth.md** -- Four-layer validation pattern to make bugs structurally impossible
- **condition-based-waiting.md** -- Replace arbitrary timeouts with condition-based polling

## Quick Reference

| Phase | Key Activities | Done When |
|-------|---------------|-----------|
| **1. Root Cause** | Read errors, reproduce, check changes, trace data | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identified differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |
