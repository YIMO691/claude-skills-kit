# Agent Model Routing

## 验证结论 (2026-05-08)

在当前 DeepSeek relay 环境中实测：

| 测试 | model 参数 | 实际路由 |
|------|-----------|----------|
| Agent tool | `sonnet` | deepseek-v4-flash |
| Agent tool | `opus` | deepseek-v4-flash |
| Agent tool | `haiku` | deepseek-v4-flash |
| Agent tool | `deepseek-v4-pro` | **拒绝**（只接受 sonnet/opus/haiku） |
| 主会话 | N/A | deepseek-v4-pro |

**结论：**
- Agent 工具只接受 `sonnet` / `opus` / `haiku` 三个值，全部路由到 **deepseek-v4-flash**
- 主会话运行在 **deepseek-v4-pro**
- 为 engineer/coder 提供了天然的物理分离：主线程 = pro（engineer），子 agent = flash（coder）

## 推荐策略

1. **不在 agent JSON 中写 model 字段** — 写了也被忽略（全部路由到 flash）
2. **Engineer 工作留在主线程** — 利用 v4-pro 的深度推理能力做需求分析和架构设计
3. **Coder 工作通过 Agent 工具委派** — 利用 v4-flash 的速度做 scoped 代码实现
4. **Orchestrator 负责协调** — 在主线程完成 engineer brief，然后启动 agent 做 coder 实现

## 未来环境适配

如切换到其他 relay/环境，重新按上表验证。若环境支持自定义 model 名或不同路由映射，在私有分支或本地文件中覆盖 agent JSON，不提交到公共 kit。
