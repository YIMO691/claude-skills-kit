# Extract Reusable Rules From A Project

Use this workflow when a concrete project produced useful Claude rules, skills, commands, templates, or agent roles that should be promoted into this kit.

## Decision Filter

Promote the content when it is:

- useful in at least two projects
- stable enough to avoid frequent project-specific edits
- safe to share publicly
- short enough to live in rules or skill instructions, or separable into a template/reference file

Keep it inside the project when it contains:

- exact local paths that only exist on one machine
- current milestone status
- private account names, URLs, keys, tokens, or secrets
- generated logs, caches, model outputs, or temporary decisions
- highly specific product requirements

## Extraction Steps

1. Read the project's `CLAUDE.md`, `AGENTS.md`, `.claude/`, and relevant `docs/`.
2. Split findings into:
   - universal rules
   - stack-specific rules
   - reusable skills
   - project-only facts
3. Move universal rules into `CLAUDE.md` or `.claude/rules/`.
4. Move stack-specific rules into profile-specific files such as `.claude/rules/unity-csharp.md`.
5. Move repeatable workflows into `.claude/skills/<name>/SKILL.md`.
6. Move long examples and templates into `docs/`.
7. Update `docs/reference/skills-manifest.md`.
8. Run `scripts/install-claude-kit.ps1` against a temporary project.

## Token Check

Before committing, ask:

- Does this rule save future context, or does it add noise?
- Could a smart model infer this without being told?
- Should this be loaded every turn, or only through a skill?
- Can a script replace a long written procedure?
