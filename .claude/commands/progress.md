# /progress

生成当前项目的简短进度摘要。

## 建议流程

1. 读取 `docs/status/PROGRESS.md`、`docs/status/TODO.md`、`docs/status/AI_DEV_LOG.md`，如果存在。
2. 查看 `git status --short --branch`。
3. 如任务涉及测试，读取最近测试输出或日志中的失败摘要。
4. 用中文输出：
   - 当前阶段
   - 已完成
   - 正在处理
   - 阻塞或风险
   - 下一步最小行动

## 约束

- 不修改文件。
- 不执行提交、推送、删除或部署。
- 不输出任何密钥、Token 或密码。
