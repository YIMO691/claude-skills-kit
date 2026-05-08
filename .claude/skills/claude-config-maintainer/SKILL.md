---
name: claude-config-maintainer
description: 维护 Claude/Codex 配置仓库。Use when updating reusable CLAUDE.md, AGENTS.md, .claude/rules, .claude/skills, agents, commands, install scripts, or extracting project-specific rules into a reusable GitHub-hosted configuration kit.
---

# Claude Config Maintainer

## Workflow

1. Separate universal rules from project-specific facts.
2. Keep universal instructions in `CLAUDE.md`, `AGENTS.md`, and `.claude/rules/`.
3. Put reusable workflows in `.claude/skills/<skill-name>/SKILL.md`.
4. Keep each `SKILL.md` short; move long examples or templates to `docs/` or skill references.
5. Update `docs/reference/skills-manifest.md` when adding, renaming, or deleting skills.
6. Test `scripts/install-claude-kit.ps1` after structural changes.

## Extraction Rules

- Keep: workflow, safety constraints, validation habits, file placement logic, reusable templates.
- Generalize: project paths, milestone names, private process details, local machine paths.
- Remove: API keys, tokens, account IDs, private URLs, temporary logs, generated caches.
- Mark optional stacks, such as Unity, as profiles instead of forcing them into every project.
