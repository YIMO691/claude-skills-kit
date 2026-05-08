---
name: engineer-coder-orchestrator
description: 编排 engineer 到 coder 的协作流程。Use when a task is complex enough to benefit from separate design and implementation phases, when the user asks for engineer/coder collaboration, or when Codex should first produce an implementation brief and then execute it.
---

# Engineer Coder Orchestrator

## Purpose

Use `engineer` for design clarity, then `coder` for scoped implementation. Keep the handoff explicit so decisions do not disappear between phases. If the user asks you to execute the task, continue from the brief into implementation in the same turn; do not require the user to copy the brief manually.

## Workflow

1. Define the user goal and acceptance checks.
2. Run an engineer pass:
   - inspect current project context
   - identify constraints and risks
   - choose the smallest viable design
   - write a coder-ready implementation brief
3. Run a coder pass:
   - follow the brief
   - make scoped changes
   - add or update tests when behavior changes
   - verify with the narrowest meaningful commands
4. Integrate:
   - compare implementation against acceptance checks
   - note any engineer assumptions that changed
   - update docs only if the workflow or public behavior changed

## Execution Mode

- If the user asks for a plan only, stop after the engineer brief.
- If the user asks to implement or fix, create the brief internally and continue into coder execution.
- If the environment supports explicit subagents, pass the handoff template to coder. Otherwise, keep the brief in working context and implement directly.

## Handoff Template

```markdown
## Goal

## Acceptance Checks

## Files / Areas To Inspect

## Implementation Tasks

## Constraints

## Verification
```

## Rules

- Do not split tiny tasks; direct implementation is cheaper.
- Do not let coder invent new architecture when the brief is incomplete.
- If implementation reveals a design flaw, pause and revise the brief before continuing.
