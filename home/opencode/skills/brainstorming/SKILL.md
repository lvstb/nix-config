---
name: brainstorming
description: "Use before any creative work - creating features, building components, adding functionality. Explores intent, requirements, and design before implementation."
---

# Brainstorming Ideas Into Designs

## Overview

Turn ideas into clear designs through collaborative dialogue. Use this when the work is creative, ambiguous, or large enough that a quick implementation would likely drift.

**HARD GATE:** Do NOT write any code until the problem, constraints, and recommended approach are clear enough to execute confidently.

## When to Use

Use this skill when:
- Building a new feature or workflow
- The user wants a rigorous plan before implementation
- There are multiple reasonable approaches
- Requirements or constraints are still fuzzy

Skip this skill for tiny, low-ambiguity edits where a short implementation plan or direct change is enough.

## Checklist

Complete these in order:

1. **Explore project context** -- check files, docs, recent commits
2. **Ask clarifying questions** -- one at a time, understand purpose/constraints/success criteria
3. **Propose 2-3 approaches** -- with trade-offs and your recommendation
4. **Present design** -- in sections scaled to complexity, confirm it matches the user's intent
5. **Write design doc** -- save to `docs/plans/YYYY-MM-DD-<topic>-design.md` when the design is substantial
6. **Transition to implementation** -- load the writing-plans skill

## The Process

**Understanding the idea:**
- Check the current project state first (files, docs, recent commits)
- Ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible
- Only one question per message
- Focus on: purpose, constraints, success criteria

**Exploring approaches:**
- Propose 2-3 different approaches with trade-offs
- Lead with your recommended option and explain why

**Presenting the design:**
- Present the design in sections, scaled to complexity
- A few sentences if straightforward, up to 200-300 words if nuanced
- Confirm the proposed direction before moving into implementation planning
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify

## After the Design

**Documentation:**
- Write the validated design to `docs/plans/YYYY-MM-DD-<topic>-design.md` when useful for future execution
- Commit the design document only when the user wants the design preserved in git

**Implementation:**
- Load the writing-plans skill to create a detailed implementation plan
- Do NOT start coding. writing-plans is the next step.

## Key Principles

- **One question at a time** -- don't overwhelm with multiple questions
- **Multiple choice preferred** -- easier than open-ended when possible
- **YAGNI ruthlessly** -- remove unnecessary features from all designs
- **Explore alternatives** -- present alternatives when there is a real decision to make
- **Scale the process** -- a small task may only need a brief design, a complex task may need a full document
