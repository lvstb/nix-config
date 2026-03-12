---
name: code-review
description: "Use between tasks or before merging. Reviews code against the plan, reports issues by severity."
---

# Code Review

## Overview

Review code against the implementation plan and quality standards. Classify issues by severity. Critical issues block progress.

## When to Use

- After a substantial implementation step
- Before merging a branch
- When explicitly requested by the user

## Review Process

### 1. Spec Compliance Review

Check against the plan/spec:

- [ ] All requirements from the spec are implemented
- [ ] Nothing extra added beyond the spec (YAGNI)
- [ ] Behavior matches the spec exactly
- [ ] File paths match the plan
- [ ] Test coverage matches the plan

### 2. Code Quality Review

Check for quality:

- [ ] Code is readable and well-named
- [ ] No unnecessary complexity
- [ ] No duplication (DRY)
- [ ] Error handling is present and correct
- [ ] No hardcoded values that should be configurable
- [ ] No leftover debug code or TODOs
- [ ] Tests are meaningful (test behavior, not implementation)
- [ ] No test anti-patterns (testing mocks, not real code)

### 3. Security Review

Quick security check:

- [ ] No secrets, API keys, or credentials in code
- [ ] Input validation present where needed
- [ ] No obvious injection vulnerabilities
- [ ] Authentication/authorization checked where appropriate

## Severity Classification

| Severity | Meaning | Action |
|----------|---------|--------|
| **Critical** | Spec violation, security issue, data loss risk | **Blocks progress.** Must fix before continuing. |
| **Important** | Code quality issue, missing error handling | Should fix before merging. |
| **Minor** | Style issue, naming improvement, optional optimization | Fix if convenient, note for later. |

## Reporting Format

```markdown
## Code Review: [Task/Branch Name]

### Spec Compliance: [PASS/FAIL]
- [List of issues if any]

### Code Quality
- **Critical:** [issues]
- **Important:** [issues]
- **Minor:** [issues]

### Summary
[Overall assessment: Approved / Needs Changes]
```

## When to Request Review

**Mandatory:**
- After completing a major feature
- Before merging any branch

**Optional (but recommended):**
- When stuck on a design decision
- Before refactoring complex code
- After a complex bug fix

## Acting on Feedback

Fix issues in priority order:
1. **Critical** -- fix immediately, re-review
2. **Important** -- fix before proceeding
3. **Minor** -- note for later
4. **Push back** -- if feedback is wrong, explain why with technical reasoning

## Rules

- Critical issues ALWAYS block. No exceptions.
- Review the actual code, not just the test results.
- Compare against the plan, not against what "seems right."
- If the plan is wrong, flag it -- don't silently deviate.
- Use file:line references for all issues.
