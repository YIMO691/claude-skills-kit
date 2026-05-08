# Setup A New Project

## Core Profile

```powershell
cd "F:\Claude skills"
powershell -ExecutionPolicy Bypass -File .\scripts\install-claude-kit.ps1 -Target "F:\YourProject" -Profile core
```

This installs:

- `CLAUDE.md`
- `AGENTS.md`
- `.claude/agents/`
- `.claude/commands/`
- core rules
- generic skills

## Unity Profile

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-claude-kit.ps1 -Target "F:\YourUnityProject" -Profile unity
```

This adds Unity C# rules and the `unity6-project` skill.

## After Install

1. Open the target project's `CLAUDE.md`.
2. Add project-specific goal, setup commands, test commands, directory layout, and validation rules.
3. Remove any stack-specific rule that does not apply.
4. Commit the imported baseline.

## Updating Later

Run the install script again without `-Force` to copy new missing files only. Use `-Force` only after checking local customizations.
