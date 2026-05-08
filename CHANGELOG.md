# Changelog

All notable changes to this kit are documented here.

## [0.2.1] - 2026-05-08

### Added
- `-DryRun` switch on install script: preview what would be copied/skipped without writing
- `-Backup` switch on install script: backup existing files to `.claude-kit-backup/` before overwriting
- `-Ref` parameter on remote install: pin to specific version tag or branch
- `scripts/validate-kit.ps1`: shared validation (YAML, manifest, install test) for local and CI use
- `docs/reference/install-manifest.md`: explicit downstream install file policy

### Fixed
- Remote install: use `curl.exe` explicitly to avoid PowerShell alias conflict
- Remote install: download label now correctly shows `-Ref` value when set
- Installer now copies `scripts/install-claude-kit.ps1` and `scripts/validate-kit.ps1` to downstream projects so README validation commands work after one-line install.
- Installer now copies `VERSION` as well as `.claude-kit-version` so downstream local reinstall and validation can run from the installed copy.
- `validate-kit.ps1` skips manifest consistency checks when docs were not installed.
- `validate-kit.ps1` now checks downstream must-exist and must-not-exist install rules by profile.
- Unity profile no longer installs the kit-only `claude-config-maintainer` skill.
- `validate-kit.ps1` now uses a unique temporary install test directory to avoid parallel validation races.

### Changed
- CI: replaced inline YAML validation with `validate-kit.ps1` call
- CI: added remote install unity profile test step

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

### Fixed
- Remote installer avoids `Invoke-Expression` when launching the downloaded local installer, preventing ExecutionPolicy failures.
- Auto profile detection now checks `Packages/manifest.json` as a file.

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
