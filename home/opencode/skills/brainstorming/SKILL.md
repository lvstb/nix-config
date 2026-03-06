---
name: brainstorming
description: "Use before any creative work - creating features, building components, adding functionality. Explores intent, requirements, and design before implementation."
---

# Brainstorming Ideas Into Designs

## Overview

Turn ideas into fully formed designs through collaborative dialogue. Understand the project context, ask questions one at a time, then present a design for approval.

**HARD GATE:** Do NOT write any code, scaffold any project, or take any implementation action until a design is presented and the user approves it. This applies to EVERY project regardless of perceived simplicity.

## Anti-Pattern: "Too Simple To Need A Design"

Every project goes through this process. A todo list, a single-function utility, a config change -- all of them. "Simple" projects are where unexamined assumptions cause the most wasted work. The design can be short (a few sentences for truly simple things), but you MUST present it and get approval.

## Checklist

Complete these in order:

1. **Explore project context** -- check files, docs, recent commits
2. **Ask clarifying questions** -- one at a time, understand purpose/constraints/success criteria
3. **Propose 2-3 approaches** -- with trade-offs and your recommendation
4. **Present design** -- in sections scaled to complexity, get user approval after each section
5. **Write design doc** -- save to `docs/plans/YYYY-MM-DD-<topic>-design.md` and commit
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
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify

## After the Design

**Documentation:**
- Write the validated design to `docs/plans/YYYY-MM-DD-<topic>-design.md`
- Commit the design document

**Implementation:**
- Load the writing-plans skill to create a detailed implementation plan
- Do NOT start coding. writing-plans is the next step.

## Key Principles

- **One question at a time** -- don't overwhelm with multiple questions
- **Multiple choice preferred** -- easier than open-ended when possible
- **YAGNI ruthlessly** -- remove unnecessary features from all designs
- **Explore alternatives** -- always propose 2-3 approaches before settling
- **Incremental validation** -- present design, get approval before moving on
