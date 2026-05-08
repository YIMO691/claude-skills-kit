# Token Efficient Development

## Default Loop

1. Locate files with Glob/Grep/Read in Claude Code/Codex tool environments, or `rg --files` and `rg` when using a shell.
2. Read only the files that define behavior or tests for the task.
3. Make the smallest useful change.
4. Run the narrowest meaningful verification.
5. Summarize changed files, verification, and risks.

## What Belongs Where

- `CLAUDE.md`: stable rules used almost every turn.
- `.claude/rules/`: short technical constraints by path or domain.
- `SKILL.md`: short workflow loaded only when triggered.
- `docs/`: longer references, templates, explanations, and manifests.
- `scripts/`: deterministic repeated operations.

## Prompting Habits

- Ask the agent for a focused change, not a broad rewrite.
- Include acceptance criteria and target files when known.
- Prefer "inspect then patch" over "regenerate this module".
- Ask for a concise verification report instead of full logs.
- When a workflow repeats three times, promote it into a script or skill.
