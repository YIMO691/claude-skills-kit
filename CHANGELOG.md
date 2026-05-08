# Changelog

All notable changes to this kit are documented here.

## [0.2.0] - 2026-05-08

### Added
- Remote installer: one-liner deployment via `irm ... | iex` (no clone needed)
- `-AutoProfile` switch: auto-detect Unity vs core profile from project structure
- `-Target` now defaults to current directory
- GitHub Actions CI: validates YAML frontmatter, tests install script, scans for secrets
- Pre-commit hooks (PowerShell + Bash): check frontmatter validity and secret patterns
- `engineer.local.json.example` and `coder.local.json.example` for DeepSeek model override
- README badges: version, license, CI status

### Changed
- Skills reduced from 8 to 7: removed `project-progress-reporter` (duplicate of `/progress` command)
- `claude-config-maintainer` excluded from `core` profile (kit-maintainer only, not deployed to projects)
- Orchestrator: removed dependency-check step (skills always co-deployed)
- `github-repo-standards`: graceful fallback when template directory is missing
- README and skills-manifest: added skill routing rules (when to use which)
- Skills-manifest: comprehensive "Add A New Skill" guide with checklist

## [0.1.1] - 2026-05-08

### Changed
- CLAUDE.md: removed kit-specific "Claude Skills Kit" section to prevent content leak to downstream projects; added trim hint comment
- Engineer SKILL.md: added "何时使用" decision heuristics for task sizing
- Coder SKILL.md: added hard-stop rule for design flaws (stop and report, don't blindly implement)
- Agent model routing doc: updated with verified DeepSeek relay behavior (main session = v4-pro, sub-agents = v4-flash)

### Added
- MAINTAINERS.md: kit maintenance guide with verified model routing notes
- `docs/reference/anti-patterns.md`: common failure modes for engineer, coder, and orchestrator

### Verified
- Model switching: Agent tool model param only accepts sonnet/opus/haiku, all route to v4-flash; custom model names rejected; main session runs v4-pro
- Install script: VERSION copied as `.claude-kit-version`; auto-discovery works for all skills/rules/agents/commands

## [0.1.0] - 2026-05-08

### Added

- Initial reusable Claude/Codex configuration kit.
- Core and Unity install profiles.
- Reusable rules for development safety, token efficiency, remote command safety, and Unity C#.
- Skills for engineer, coder, engineer-coder orchestration, GitHub repository standards, learning blog generation, project progress reporting, Unity 6 projects, and kit maintenance.
- Thin engineer/coder agent presets that reference skills as the source of truth.
- GitHub publication baseline: MIT license, security policy, contributing guide, CODEOWNERS, PR template, and issue template config.
- PowerShell installer with automatic discovery for agents, commands, rules, and skills.
