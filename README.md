# Claude Skills Kit

这是一个可复制、可持续更新的 Claude/Codex 通用配置仓库。它从 `F:\Unity6_AI` 中提炼了通用工作规则、开发流程、仓库规范、学习笔记、进度汇报和 Unity 6 项目经验，方便新项目少做重复配置。

当前版本：`0.1.0`，见 [VERSION](VERSION)。

## 内容

- `CLAUDE.md`: 新项目的通用 Claude Code 项目指令。
- `AGENTS.md`: 给不同 AI 代理阅读的交接说明。
- `.claude/rules/`: 通用开发、安全、token 节省和 Unity C# 规则。
- `.claude/skills/`: 可复用 skill，包括架构设计、代码实现、仓库规范、学习笔记、进度汇报、Unity 6 项目和配置维护。
- `.claude/agents/`: engineer/coder 两个角色配置。
- `.claude/settings.json`: 项目级权限基线，默认允许只读检查并拒绝 push、强制 reset 和递归删除等高风险命令。
- `.claude/commands/`: 常用命令模板。
- `docs/`: 新项目安装、GitHub 发布、token 节省和文件组织说明。
- `scripts/install-claude-kit.ps1`: 将本仓库配置同步到新项目。
- `LICENSE`、`SECURITY.md`、`CONTRIBUTING.md`、`.github/`: GitHub 发布基线。

## 快速使用

在新项目中安装通用配置：

```powershell
cd "F:\Claude skills"
powershell -ExecutionPolicy Bypass -File .\scripts\install-claude-kit.ps1 -Target "F:\YourProject" -Profile core
```

Unity 项目使用：

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\install-claude-kit.ps1 -Target "F:\YourUnityProject" -Profile unity
```

如果目标项目已有 `CLAUDE.md`、`AGENTS.md` 或 `.claude` 文件，脚本默认不覆盖。确认要更新时加 `-Force`。

## 更新策略

1. 先在具体项目中验证规则或 skill 是否真的有用。
2. 回到本仓库，把可复用部分抽象出来，不写入项目私有路径、密钥、账号或临时状态。
3. 更新 `docs/reference/skills-manifest.md`。
4. 在一个空目录或测试项目中运行安装脚本验证。
5. 提交并推送到 GitHub。

## Token 节省原则

- 把高频、稳定、短小的规则放进 `CLAUDE.md` 或 `.claude/rules/`。
- 把低频、较长、按需阅读的内容放进 skill 的 `references/` 或 `docs/`。
- `SKILL.md` 只写触发条件、必须流程和关键约束，不塞完整教程。
- 新项目先加载 `core`，只有 Unity 项目才加载 Unity 规则。
- 每次让 AI 先做最小上下文扫描，再读必要文件。

## Skill 与 Agent

- Skill 负责工作流触发和流程约束，适合沉淀可复用做法。
- Agent 负责角色预设，适合手动选择 engineer 或 coder。
- 复杂任务使用 `engineer-coder-orchestrator`，把设计 brief 和实现任务分开，减少返工。
- 默认不在 agent JSON 中写死 model；DeepSeek 等本地路由见 `docs/workflows/agent-model-routing.md`。
