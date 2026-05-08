<!-- 精简提示：如需减少 token 开销，可保留"沟通方式""Skill 与 Agent 边界""Git 与安全""Project Overlay"四节，其余内容可用 .claude/rules/ 代替。 -->

# CLAUDE.md

This file provides reusable guidance for Claude Code or other coding agents working in a project that imports this kit.

## 沟通方式

- 默认使用中文沟通，代码标识符、文件名、API 名称保持英文。
- 先理解项目现状，再做改动。不要凭记忆锁定版本、命令或外部服务细节。
- 对不确定信息给出验证方式；高风险或会花钱的选择先说明取舍。

## 工作流

1. 读取项目根目录说明：`README.md`、`CLAUDE.md`、`AGENTS.md`。
2. 找到当前任务的最小上下文：相关源码、测试、配置和文档。
3. 先写清验收标准或完成条件，再实施。
4. 小步提交式工作：一次推进一个明确目标，避免顺手重构。
5. 改完后运行能覆盖风险的最小验证，并说明验证结果。

## Skill 与 Agent 边界

- `.claude/skills/` 是可触发工作流：描述何时使用、读什么、怎么做、如何验证。
- `.claude/agents/` 是角色预设：用于手动选择 engineer 或 coder 的语气、职责和默认模型。
- 复杂任务优先用 `engineer-coder-orchestrator`：先产出 engineer brief，再由 coder scoped implementation。
- 简单任务不需要编排，直接按当前上下文实现即可。

## 代码原则

- 优先沿用项目现有框架、目录结构、命名和测试方式。
- 只改必要文件；无关重构、格式化和依赖升级单独处理。
- 结构化数据使用结构化 API 或解析器，不用脆弱的字符串拼接。
- 处理边界条件、错误路径、超时、空值和权限失败。
- 不提交 API Key、Token、密码、缓存、构建产物、用户本地设置或大型训练输出。

## Token 节省

- 优先用 Glob/Grep/Read 等可用工具定位上下文；在 shell 中可用时再用 `rg --files` 和 `rg`。
- 长文档只读取相关小节；需要完整背景时再扩大范围。
- 让 skill 保持短小：`SKILL.md` 放流程，详细材料放 `docs/` 或 `references/` 按需读取。
- 对重复操作使用脚本，避免每次让模型重写同一段流程。
- 汇报时只讲决策、变更、验证和下一步，不复述大段日志。

## Git 与安全

- 允许查看状态、diff、log。不要在用户不知情时推送到远端。
- 不使用 `git reset --hard`、批量删除或覆盖用户改动，除非用户明确要求。
- 遇到工作区已有改动，先判断是否相关；无关则保留，相关则兼容。
- 发布 GitHub 前检查 `.gitignore`、`.gitattributes`、`SECURITY.md`、`CONTRIBUTING.md`、PR 模板和 CODEOWNERS。

## Project Overlay

新项目可以在本文件下方追加项目专属内容，例如：

- 项目目标和当前阶段。
- 启动、测试、构建命令。
- 目录结构和文件放置规则。
- 技术栈版本、包管理方式、部署方式。
- 项目专属验收标准。

不要把项目私有密钥、个人账号、临时机器路径写入公共模板。
