# Claude Skills Kit

[![Version](https://img.shields.io/badge/version-0.2.1-blue)](VERSION) [![License](https://img.shields.io/badge/license-MIT-green)](LICENSE) [![CI](https://github.com/YIMO691/claude-skills-kit/actions/workflows/validate.yml/badge.svg)](https://github.com/YIMO691/claude-skills-kit/actions/workflows/validate.yml)

可复制、可持续更新的 Claude/Codex 通用配置仓库。提供 engineer(架构师) + coder(码农) 双角色协作体系、自动发现式安装脚本、CI 验证和一行部署能力。适合在新项目中快速搭建 AI 编码协作基线，少做重复配置。

当前版本：`0.2.1`，见 [VERSION](VERSION)。

## 内容

- `CLAUDE.md`: 通用 Claude Code 项目指令，每 turn 自动加载。
- `AGENTS.md`: AI 代理交接说明。
- `.claude/rules/`: 通用开发、安全、Token 节省和 Unity C# 规则。
- `.claude/skills/`: 7 个可复用 skill — engineer、coder、orchestrator、GitHub 规范、学习笔记、Unity 6、配置维护。
- `.claude/agents/`: engineer/coder 角色预设（含 DeepSeek 本地覆盖模板）。
- `.claude/settings.json`: 权限基线，拒绝 push/reset/递归删除等高风险命令。
- `.claude/commands/`: 常用命令模板，例如 `progress` 进度摘要。
- `docs/`: 工作流指南、反模式参考、技能清单、模型路由说明、下游模板。
- `scripts/`: 本地安装（支持 DryRun 预览、Backup 备份）、远程安装（版本固定）、pre-commit hook、validate-kit 自检。
- `.github/workflows/`: CI 自动验证 YAML、安装脚本和密钥扫描。
- `LICENSE`、`SECURITY.md`、`CONTRIBUTING.md`、`CHANGELOG.md`、`MAINTAINERS.md`。

## 快速使用

**一行部署（推荐，无需 clone）：**

```powershell
irm https://raw.githubusercontent.com/YIMO691/claude-skills-kit/main/scripts/install-remote.ps1 | iex
```

在当前目录自动检测项目类型并安装。可指定版本和目标：

```powershell
# 固定版本
irm .../install-remote.ps1 | iex -Ref v0.2.1

# 指定目标
.\install-remote.ps1 -Target "F:\MyProject" -Profile unity
```

**本地安装（已 clone 仓库）：**

```powershell
# 预览（不写入）
.\scripts\install-claude-kit.ps1 -Target "F:\MyProject" -AutoProfile -DryRun

# 安装（覆盖前备份旧文件）
.\scripts\install-claude-kit.ps1 -Target "F:\MyProject" -AutoProfile -Backup -Force
```

**自检：**

```powershell
.\scripts\validate-kit.ps1
```

## 更新策略

1. 先在具体项目中验证规则或 skill 是否真的有用。
2. 回到本仓库，把可复用部分抽象出来，不写入项目私有路径、密钥、账号或临时状态。
3. 更新 `docs/reference/skills-manifest.md`。
4. 提交前运行 `scripts/pre-commit.ps1`；push 后 CI 自动验证安装脚本和密钥扫描。
5. 更新 `CHANGELOG.md` 和 `VERSION`，打 tag 推送。

## Token 节省原则

- 把高频、稳定、短小的规则放进 `CLAUDE.md` 或 `.claude/rules/`。
- 把低频、较长、按需阅读的内容放进 skill 的 `references/` 或 `docs/`。
- `SKILL.md` 只写触发条件、必须流程和关键约束，不塞完整教程。
- 新项目先加载 `core`，只有 Unity 项目才加载 Unity 规则。
- 每次让 AI 先做最小上下文扫描，再读必要文件。

## Skill 与 Agent

- Skill 负责工作流触发和流程约束，适合沉淀可复用做法。
- Agent 负责角色预设，适合手动选择 engineer 或 coder。
- 简单实现、修 bug、配置、小文档：直接使用 `coder` 或当前上下文实现。
- 纯方案、架构、接口、任务拆解：直接使用 `engineer`。
- 复杂且要落地的功能：使用 `engineer-coder-orchestrator`，把设计 brief 和实现任务分开，减少返工。
- Unity 相关任务：叠加 `unity6-project`。
- 维护本 kit：叠加 `claude-config-maintainer`。
- 默认不在 agent JSON 中写死 model；当前环境中主线程运行在 v4-pro（engineer），Agent 工具运行在 v4-flash（coder），自然形成物理分离。详见 `docs/workflows/agent-model-routing.md`。
