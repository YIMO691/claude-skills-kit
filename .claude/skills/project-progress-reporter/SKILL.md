---
name: project-progress-reporter
description: 生成项目进度摘要。Use when the user asks for current progress, mobile-readable status, Git status, recent development summary, blockers, logs, test failures, or a concise report for Feishu/Slack/chat.
---

# Project Progress Reporter

## Allowed Reads

- `docs/status/PROGRESS.md`
- `docs/status/TODO.md`
- `docs/status/AI_DEV_LOG.md`
- `README.md`
- `CLAUDE.md`
- Git branch/status/log
- project-local logs and test outputs

## Do Not

- Do not modify business code.
- Do not delete files.
- Do not commit, push, deploy, or publish.
- Do not output secrets.

## Report Shape

Use Chinese and keep the report compact:

- 当前阶段
- 已完成
- 正在处理
- 阻塞/风险
- 下一步最小行动

If logs contain compile or test errors, list file, line, error type, and likely owner first.
