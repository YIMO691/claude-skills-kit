# Contributing

## Workflow

1. Keep reusable kit changes separate from project-specific edits.
2. Update `docs/reference/skills-manifest.md` when adding, renaming, or deleting skills.
3. Run `scripts/install-claude-kit.ps1` against a temporary project after structural changes.
4. Keep `SKILL.md` files short; move long examples to `docs/` or references.

## Pull Request Checklist

- [ ] The change is reusable across projects.
- [ ] Secrets, private paths, logs, and caches are not included.
- [ ] New skills are included by the installer automatically or explicitly excluded by profile.
- [ ] Documentation is updated when workflows change.
