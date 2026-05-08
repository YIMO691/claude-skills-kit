---
name: unity6-project
description: Unity 6 项目开发规则。Use when working on Unity 6 projects, Unity C# scripts, AI gameplay prototypes, NavMesh, Behavior/behavior trees, ML-Agents, Sentis/ONNX inference, Unity package setup, scenes, prefabs, tests, or Unity validation instructions.
---

# Unity 6 Project

## First Reads

Read only what is needed:

- `CLAUDE.md` for project rules.
- `README.md` for setup and current scope.
- `ProjectSettings/ProjectVersion.txt` for Unity version.
- `Packages/manifest.json` when packages are involved.
- project planning docs when milestones or learning goals matter.

## Workflow

1. Identify the active milestone or gameplay goal.
2. State the smallest useful next step and acceptance check.
3. Make scoped changes under the existing Unity project root.
4. For scripts, prefer `Assets/_Project/Scripts/` or the local project convention.
5. For tests, prefer `Assets/_Project/Tests/` or the local project convention.
6. Explain Unity validation steps: scene, GameObject, components, Inspector values, Play/Test Runner checks.

## Rules

- Communicate in Chinese; keep C# identifiers in English.
- Use `[SerializeField] private` for Inspector parameters.
- Cache component references; avoid expensive lookup in `Update()`.
- Put AI tuning values such as radius, speed, cooldown, and layer masks in Inspector.
- Verify package names and versions from Package Manager, local manifest, or official docs.
- Do not commit `Library/`, `Temp/`, `Logs/`, training outputs, large generated assets, or user local settings.
- Use Git LFS before committing large binary assets that must be versioned.
