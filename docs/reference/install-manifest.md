# Install Manifest

This file defines what a downstream project should receive from Claude Skills Kit.

## Core Profile

Core profile is the default for non-Unity projects.

### Must Exist

- `CLAUDE.md`
- `AGENTS.md`
- `VERSION`
- `.claude-kit-version`
- `scripts/install-claude-kit.ps1`
- `scripts/validate-kit.ps1`
- `.claude/settings.json`
- `.claude/agents/coder.json`
- `.claude/agents/engineer.json`
- `.claude/commands/progress.md`
- `.claude/rules/core-development.md`
- `.claude/rules/safe-remote-commands.md`
- `.claude/rules/token-efficiency.md`
- `.claude/skills/coder/SKILL.md`
- `.claude/skills/engineer/SKILL.md`
- `.claude/skills/engineer-coder-orchestrator/SKILL.md`
- `.claude/skills/github-repo-standards/SKILL.md`
- `.claude/skills/learning-blog/SKILL.md`

### Must Not Exist

- `.claude/rules/unity-csharp.md`
- `.claude/skills/unity6-project/`
- `.claude/skills/claude-config-maintainer/`
- `.claude/agents/*.local.json.example`
- `docs/`
- `.github/`
- `.gitleaks.toml`
- `MAINTAINERS.md`
- `CHANGELOG.md`
- `LICENSE`
- `SECURITY.md`
- `CONTRIBUTING.md`

## Unity Profile

Unity profile includes everything in core plus Unity-specific files.

### Additional Must Exist

- `.claude/rules/unity-csharp.md`
- `.claude/skills/unity6-project/SKILL.md`

### Must Not Exist

- `.claude/skills/claude-config-maintainer/`
- `.claude/agents/*.local.json.example`
- `docs/`
- `.github/`
- `.gitleaks.toml`
- `MAINTAINERS.md`
- `CHANGELOG.md`
- `LICENSE`
- `SECURITY.md`
- `CONTRIBUTING.md`

## IncludeDocs

When `-IncludeDocs` is used, the installer may additionally copy:

- `docs/templates/`
- `docs/reference/`

This option is intended for projects that want local templates or the skills manifest.

## Backup Output

When `-Backup` is used with overwrites, the installer may create:

- `.claude-kit-backup/<timestamp>/`

This directory is local safety output and should normally stay uncommitted.
