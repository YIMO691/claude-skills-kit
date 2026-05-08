# File Organization Convention

## Root

Keep only files that a new contributor or AI agent should discover immediately:

- `README.md`
- `CLAUDE.md`
- `AGENTS.md`
- `LICENSE`
- `.gitignore`
- `.gitattributes`
- `.editorconfig`

## `.claude/`

- `.claude/rules/`: short rules that should apply automatically or nearly automatically.
- `.claude/skills/<name>/SKILL.md`: reusable workflows.
- `.claude/agents/`: role presets.
- `.claude/commands/`: reusable command prompts.

## `docs/`

- `docs/workflows/`: procedural guides.
- `docs/reference/`: stable reference material and manifests.
- `docs/templates/`: templates copied into projects.
- `docs/status/`: project-specific status files, only in actual projects.

## `scripts/`

Put deterministic, repeatable operations here, especially setup, validation, migration, or sync scripts.

Scripts should default to non-destructive behavior and require explicit flags for overwrite.
