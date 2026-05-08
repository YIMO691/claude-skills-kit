# Maintainers

本仓库自身是 Claude/Codex 通用配置 kit，目标是把跨项目可复用的规则、skills、agents、commands、模板和安装脚本沉淀为可发布到 GitHub 的基线。

## 维护原则

- 可复制、可更新、低 token 成本、默认安全。
- 新增内容前先判断是否跨项目通用；项目私有事实留在具体项目。
- 新增 skill 后更新 `docs/reference/skills-manifest.md`，并确保安装脚本能自动发现。
- 公开发布前检查 `LICENSE`、`SECURITY.md`、`CONTRIBUTING.md`、`.github/` 和密钥泄露风险。

## 模型路由

本 kit 不在 agent JSON 中写死 model 字段。当前环境验证结果（2026-05-08）：

- 主会话运行在 deepseek-v4-pro
- Agent 工具（sonnet/opus/haiku）统一路由到 deepseek-v4-flash
- 自定义模型名（deepseek-v4-pro/deepseek-v4-flash）被 Agent 工具拒绝
- 因此 engineer 工作留在主线程（pro），coder 工作通过 Agent 工具委派（flash）

详见 `docs/workflows/agent-model-routing.md`。

## 发布检查清单

- [ ] 无 API Key、Token、密码、私钥、私有路径
- [ ] `docs/reference/skills-manifest.md` 与实际 skills 一致
- [ ] 安装脚本在空目录测试通过
- [ ] CHANGELOG.md 已更新
- [ ] VERSION 已更新
