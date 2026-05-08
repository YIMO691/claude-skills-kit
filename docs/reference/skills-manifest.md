# Skills Manifest

Use this file before adding or renaming a skill.

| Skill | Purpose | Use when |
| --- | --- | --- |
| `engineer` | 架构设计与任务规划 | 需求模糊、需要方案、接口、取舍或任务拆解 |
| `coder` | 代码实现 | 已有清晰需求或设计，需要实现、测试、修 bug |
| `engineer-coder-orchestrator` | 双角色编排 | 需要先设计再实现，或需要 engineer 到 coder 的明确交接 |
| `github-repo-standards` | GitHub 仓库规范 | 准备发布 GitHub、补齐社区健康文件 |
| `learning-blog` | 学习笔记 | 记录一次工具学习、排错、环境配置或开发复盘 |
| `unity6-project` | Unity 6 开发 | Unity 6、C#、NavMesh、Behavior、ML-Agents、Sentis 相关任务 |
| `claude-config-maintainer` | 配置仓库维护 | 更新本仓库规则、skills、commands、安装脚本 |

## Routing Rules

- 简单实现、修 bug、配置、小文档：直接使用 `coder` 或当前上下文实现。
- 纯方案、架构、接口、任务拆解：直接使用 `engineer`。
- 复杂且要落地的功能：使用 `engineer-coder-orchestrator`。
- Unity 相关任务：叠加 `unity6-project`。
- 维护本 kit：叠加 `claude-config-maintainer`。
- 项目进度摘要不是 skill；使用 `.claude/commands/progress.md`。

## Add A New Skill

### 0. 判断：这真的需要是一个 skill 吗？

不是所有重复操作都值得做成 skill。满足 **至少 2 条** 才创建：

- [ ] 跨项目可复用（不绑定特定项目路径、账号或业务逻辑）
- [ ] 有明确的触发场景（用户会说"帮我..."或"我要..."）
- [ ] 流程超过 3 步，且容易遗漏或出错
- [ ] 纯文本指令无法可靠触发（需要加载外部参考文件或有硬约束）

**不需要创建 skill 的情况**：
- 单项目专用流程 → 写到项目 CLAUDE.md Project Overlay
- 简单规则/偏好 → 写到 `.claude/rules/`
- 一次性操作 → 直接用自然语言描述

### 1. 创建文件

```
.claude/skills/<skill-name>/SKILL.md
```

命名规范：
- 小写字母 + 数字 + 连字符（`my-new-skill`）
- 名称体现动作或领域（`github-repo-standards`、`learning-blog`）
- 不要用 `skill-` 前缀（已经在 skills 目录下）

### 2. SKILL.md 结构

```markdown
---
name: <skill-name>
description: <一句话描述用途和触发条件。中英双语，英文用于机器匹配。>
---

# <Skill Title>

## Purpose / 用途

一句话说明这个 skill 解决什么问题。

## When To Use / 何时使用

明确触发场景。如果适用，给出正例和反例：
- 使用：xxx 场景
- 不使用：yyy 场景（用别的方式处理）

## Workflow / 工作流

1. 步骤 1
2. 步骤 2
3. 步骤 3

## Rules / 约束

- 硬约束（MUST/MUST NOT）
- 软约束（PREFER/AVOID）
```

### 3. 内容标准

- `SKILL.md` 控制在 **40 行以内**。长示例和模板放到 `docs/` 或 skill 目录下的 `references/`。
- description 必须中英双语：`中文描述。Use when English trigger conditions.`
- 不引用仅存在于 kit 源仓库的文件路径（如 `scripts/install-claude-kit.ps1`），除非 skill 仅限 kit 维护使用。
- 外部依赖（模板、参考文件）使用存在性检查：`若 xxx 存在，则...；否则直接生成。`

### 4. 更新清单

新增 skill 后按顺序完成：

- [ ] `docs/reference/skills-manifest.md` — 在表格和 Routing Rules 中添加条目
- [ ] `scripts/install-claude-kit.ps1` — 检查：新 skill 应被自动发现（无需修改脚本），除非需要 profile 排除
- [ ] `CHANGELOG.md` — 记录新增
- [ ] 在空目录运行安装脚本验证新 skill 被正确复制
- [ ] 如果是 Unity 限定 skill，确认 `unity` profile 的排除逻辑正确

### 5. Profile 归属

| Skill 类型 | Profile | 说明 |
|------------|---------|------|
| 通用开发流程 | `core`（默认） | 无需额外操作 |
| 特定技术栈 | `unity` 等 | 在 `$skillExclusions` 中按 profile 排除 |
| Kit 维护专用 | 不部署 | 加入 `$skillExclusions` |

### 6. 验证

在临时目录测试：

```powershell
.\scripts\install-claude-kit.ps1 -Target "$env:TEMP\test-skill" -Profile core -Force
# 确认新 skill 目录存在
ls "$env:TEMP\test-skill\.claude\skills\" 
# 清理
Remove-Item -Recurse -Force "$env:TEMP\test-skill"
```
