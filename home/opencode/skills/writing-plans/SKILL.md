---
name: writing-plans
description: "Use when you have a spec or requirements for a multi-step task, before touching code. Creates bite-sized implementation plans."
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero codebase context and questionable taste. Document everything: which files to touch, code, testing, docs to check, how to verify. Give the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

**Context:** Use a dedicated branch or worktree when the work is large enough to benefit from isolation.

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Bite-Sized Task Granularity

Each step is one action (2-5 minutes):
- "Write the failing test" -- step
- "Run it to make sure it fails" -- step
- "Implement the minimal code to make the test pass" -- step
- "Run the tests and make sure they pass" -- step
- "Commit" -- step

## Plan Document Header

Every plan MUST start with:

```markdown
# [Feature Name] Implementation Plan

**Goal:** [One sentence describing what this builds]
**Architecture:** [2-3 sentences about approach]
**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## Requirements

- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- DRY, YAGNI, TDD, frequent commits

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan saved to `docs/plans/<filename>.md`. Two options:**

**1. Execute sequentially (this session)** -- Work through the tasks in order, verifying each step as you go.

**2. Save plan only** -- Keep the plan for later execution.

**Which approach?"**
